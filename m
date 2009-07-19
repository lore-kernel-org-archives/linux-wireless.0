Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:46826 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbZGSVyS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jul 2009 17:54:18 -0400
Received: from smtp08.web.de (fmsmtp08.dlan.cinetic.de [172.20.5.216])
	by fmmailgate03.web.de (Postfix) with ESMTP id 85652106B3CC0
	for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2009 23:54:17 +0200 (CEST)
Received: from [129.13.72.197] (helo=blech.mobile)
	by smtp08.web.de with esmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #277)
	id 1MSeKn-0001Eg-00
	for linux-wireless@vger.kernel.org; Sun, 19 Jul 2009 23:54:17 +0200
Received: from localhost (localhost [127.0.0.1])
	by blech.mobile (Postfix) with ESMTP id BF4163663D8
	for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2009 23:54:16 +0200 (CEST)
Received: from blech.mobile ([127.0.0.1])
	by localhost (localhost [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id esWw097zKdrx for <linux-wireless@vger.kernel.org>;
	Sun, 19 Jul 2009 23:54:16 +0200 (CEST)
Received: from blech.mobile (localhost [127.0.0.1])
	by blech.mobile (Postfix) with ESMTP id BDEDC361E64
	for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2009 23:54:15 +0200 (CEST)
From: Christian Lamparter <chunkeey@web.de>
To: wireless <linux-wireless@vger.kernel.org>
Subject: [RFT] p54: implement rfkill
Date: Sun, 19 Jul 2009 23:54:15 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200907192354.15349.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch gets rid of the deprecated radio_enabled

fwio.c: In function ‘p54_setup_mac’:
fwio.c:323: warning: ‘radio_enabled’ is deprecated (declared at include/net/mac80211.h:607)
---
diff --git a/drivers/net/wireless/p54/fwio.c b/drivers/net/wireless/p54/fwio.c
index efe47ec..9f5ebab 100644
--- a/drivers/net/wireless/p54/fwio.c
+++ b/drivers/net/wireless/p54/fwio.c
@@ -320,7 +320,7 @@ int p54_setup_mac(struct p54_common *priv)
 		return -ENOMEM;
 
 	setup = (struct p54_setup_mac *) skb_put(skb, sizeof(*setup));
-	if (priv->hw->conf.radio_enabled) {
+	if (!(priv->hw->conf.flags & IEEE80211_CONF_IDLE)) {
 		switch (priv->mode) {
 		case NL80211_IFTYPE_STATION:
 			mode = P54_FILTER_TYPE_STATION;
@@ -348,8 +348,9 @@ int p54_setup_mac(struct p54_common *priv)
 		     (priv->filter_flags & FIF_OTHER_BSS)) &&
 		    (mode != P54_FILTER_TYPE_PROMISCUOUS))
 			mode |= P54_FILTER_TYPE_TRANSPARENT;
-	} else
+	} else {
 		mode = P54_FILTER_TYPE_HIBERNATE;
+	}
 
 	setup->mac_mode = cpu_to_le16(mode);
 	memcpy(setup->mac_addr, priv->mac_addr, ETH_ALEN);
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 955f6d7..fe36983 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -288,7 +288,11 @@ static int p54_config(struct ieee80211_hw *dev, u32 changed)
 		if (ret)
 			goto out;
 	}
-
+	if (changed & IEEE80211_CONF_CHANGE_IDLE) {
+		ret = p54_setup_mac(priv);
+		if (ret)
+			goto out;
+	}
 out:
 	mutex_unlock(&priv->conf_mutex);
 	return ret;
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 0d589d6..d38f10a 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -552,6 +552,12 @@ static void p54_rx_trap(struct p54_common *priv, struct sk_buff *skb)
 		break;
 	case P54_TRAP_TIMER:
 		break;
+	case P54_TRAP_FAA_RADIO_OFF:
+		wiphy_rfkill_set_hw_state(priv->hw->wiphy, true);
+		break;
+	case P54_TRAP_FAA_RADIO_ON:
+		wiphy_rfkill_set_hw_state(priv->hw->wiphy, false);
+		break;
 	default:
 		printk(KERN_INFO "%s: received event:%x freq:%d\n",
 		       wiphy_name(priv->hw->wiphy), event, freq);
