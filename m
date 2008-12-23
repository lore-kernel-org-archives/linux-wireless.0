Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:47333 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbYLWPBH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 10:01:07 -0500
Received: from smtp06.web.de (fmsmtp06.dlan.cinetic.de [172.20.5.172])
	by fmmailgate02.web.de (Postfix) with ESMTP id 80E4FF80B6CF
	for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2008 16:01:05 +0100 (CET)
Received: from [91.22.242.46] (helo=debian64.daheim)
	by smtp06.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #273)
	id 1LF8kr-0006id-00
	for linux-wireless@vger.kernel.org; Tue, 23 Dec 2008 16:01:05 +0100
Received: from debian64.daheim
	([192.168.0.4] helo=debian64.localnet ident=chuck)
	by debian64.daheim with esmtpa (Exim 4.69)
	(envelope-from <chunkeey@web.de>)
	id 1LF8kq-0005ZE-A7
	for linux-wireless@vger.kernel.org; Tue, 23 Dec 2008 16:01:04 +0100
From: Christian Lamparter <chunkeey@web.de>
To: wireless <linux-wireless@vger.kernel.org>
Subject: [RFC][RFT][PATCH] p54: implement power save management
Date: Tue, 23 Dec 2008 16:01:03 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812231601.03392.chunkeey@web.de> (sfid-20081223_160111_283110_8D7842B4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since Vivek's power save patches are ready and waiting. I can finally add the
power save management for p54 as well.

---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-12-21 22:42:04.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-12-23 15:53:47.000000000 +0100
@@ -1747,6 +1747,41 @@ static int p54_set_edcf(struct ieee80211
 	return 0;
 }
 
+static int p54_powersave(struct ieee80211_hw *dev)
+{
+	struct p54_common *priv = dev->priv;
+	struct sk_buff *skb;
+	struct p54_psm *psm;
+	u16 mode = P54_PSM_OFF;
+	int i;
+
+	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*psm) +
+			sizeof(struct p54_hdr), P54_CONTROL_TYPE_PSM,
+			GFP_ATOMIC);
+	if (!skb)
+		return -ENOMEM;
+
+	if (dev->conf.flags & IEEE80211_CONF_PS)
+		mode = cpu_to_le16(P54_PSM | P54_PSM_DTIM | P54_PSM_MCBC);
+
+	psm = (struct p54_psm *)skb_put(skb, sizeof(*psm));
+	psm->aid = cpu_to_le16(priv->aid);
+	psm->mode = cpu_to_le16(mode);
+	for (i = 0; i < ARRAY_SIZE(psm->intervals); i++) {
+		psm->intervals[i].interval =
+			cpu_to_le16(dev->conf.listen_interval);
+		psm->intervals[i].periods = 1;
+	}
+
+	psm->beacon_rssi_skip_max = 60;
+	psm->rssi_delta_threshold = 0;
+	psm->nr = 0;
+
+	priv->tx(dev, skb);
+
+	return 0;
+}
+
 static int p54_beacon_tim(struct sk_buff *skb)
 {
 	/*
@@ -1939,6 +1974,11 @@ static int p54_config(struct ieee80211_h
 		if (ret)
 			goto out;
 	}
+	if (changed & IEEE80211_CONF_CHANGE_PS) {
+		ret = p54_powersave(dev);
+		if (ret)
+			goto out;
+	}
 
 out:
 	mutex_unlock(&priv->conf_mutex);
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2008-12-21 22:14:44.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.h	2008-12-22 17:22:16.000000000 +0100
@@ -545,6 +545,7 @@ struct p54_psm_interval {
 	__le16 periods;
 } __attribute__ ((packed));
 
+#define P54_PSM_OFF			0
 #define P54_PSM				BIT(0)
 #define P54_PSM_DTIM			BIT(1)
 #define P54_PSM_MCBC			BIT(2)
