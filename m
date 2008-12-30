Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:43915 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbYL3MuP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2008 07:50:15 -0500
From: Christian Lamparter <chunkeey@web.de>
To: wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] p54: power save management
Date: Tue, 30 Dec 2008 13:48:41 +0100
Cc: John W Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812301348.41201.chunkeey@web.de> (sfid-20081230_135033_432901_2CFF90BD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch implements dynamic power save feature for p54.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-12-30 13:21:07.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-12-30 13:29:59.000000000 +0100
@@ -1741,6 +1741,43 @@ static int p54_set_edcf(struct ieee80211
 	return 0;
 }
 
+static int p54_set_ps(struct ieee80211_hw *dev)
+{
+	struct p54_common *priv = dev->priv;
+	struct sk_buff *skb;
+	struct p54_psm *psm;
+	u16 mode;
+	int i;
+
+	if (dev->conf.flags & IEEE80211_CONF_PS)
+		mode = cpu_to_le16(P54_PSM | P54_PSM_DTIM | P54_PSM_MCBC);
+	else
+		mode = P54_PSM_CAM;
+
+	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*psm) +
+			sizeof(struct p54_hdr), P54_CONTROL_TYPE_PSM,
+			GFP_ATOMIC);
+	if (!skb)
+		return -ENOMEM;
+
+	psm = (struct p54_psm *)skb_put(skb, sizeof(*psm));
+	psm->mode = cpu_to_le16(mode);
+	psm->aid = cpu_to_le16(priv->aid);
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
@@ -1933,6 +1970,11 @@ static int p54_config(struct ieee80211_h
 		if (ret)
 			goto out;
 	}
+	if (changed & IEEE80211_CONF_CHANGE_PS) {
+		ret = p54_set_ps(dev);
+		if (ret)
+			goto out;
+	}
 
 out:
 	mutex_unlock(&priv->conf_mutex);
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2008-12-30 11:22:27.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.h	2008-12-30 13:22:05.000000000 +0100
@@ -534,6 +534,7 @@ struct p54_psm_interval {
 	__le16 periods;
 } __attribute__ ((packed));
 
+#define P54_PSM_CAM			0
 #define P54_PSM				BIT(0)
 #define P54_PSM_DTIM			BIT(1)
 #define P54_PSM_MCBC			BIT(2)
