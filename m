Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:56892 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613AbZHGRjH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 13:39:07 -0400
From: Christian Lamparter <chunkeey@web.de>
To: wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] p54: implement rfkill
Date: Fri, 7 Aug 2009 19:39:05 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908071939.05779.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch implements a basic rfkill support for p54 hardware and
removes a rfkill related WARNING:

fwio.c: In function ‘p54_setup_mac’:
fwio.c:323: warning: ‘radio_enabled’ is deprecated.

by abandoning radio_enable in flavour for IEEE80211_CONF_CHANGE_IDLE. 

Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/p54/fwio.c b/drivers/net/wireless/p54/fwio.c
index 21f1901..e7b9e9c 100644
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
index bcab4c6..c3c00a1 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -288,6 +288,11 @@ static int p54_config(struct ieee80211_hw *dev, u32 changed)
 		if (ret)
 			goto out;
 	}
+	if (changed & IEEE80211_CONF_CHANGE_IDLE) {
+		ret = p54_setup_mac(priv);
+		if (ret)
+			goto out;
+	}
 
 out:
 	mutex_unlock(&priv->conf_mutex);
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 704685f..6fc0b61 100644
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
