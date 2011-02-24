Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33773 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab1BXNMv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Feb 2011 08:12:51 -0500
Received: by fxm17 with SMTP id 17so516349fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Feb 2011 05:12:49 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] p54: implement set_coverage_class
Date: Thu, 24 Feb 2011 14:12:20 +0100
Cc: linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201102241412.21225.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The callback sets slot time as specified in IEEE 802.11-2007
section 17.3.8.6 and raises round trip delay accordingly.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/p54/fwio.c b/drivers/net/wireless/p54/fwio.c
index 0d3d108..2fab7d2 100644
--- a/drivers/net/wireless/p54/fwio.c
+++ b/drivers/net/wireless/p54/fwio.c
@@ -559,6 +559,7 @@ int p54_set_edcf(struct p54_common *priv)
 {
 	struct sk_buff *skb;
 	struct p54_edcf *edcf;
+	u8 rtd;
 
 	skb = p54_alloc_skb(priv, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*edcf),
 			    P54_CONTROL_TYPE_DCFINIT, GFP_ATOMIC);
@@ -575,9 +576,15 @@ int p54_set_edcf(struct p54_common *priv)
 		edcf->sifs = 0x0a;
 		edcf->eofpad = 0x06;
 	}
+	/*
+	 * calculate the extra round trip delay according to the
+	 * formula from 802.11-2007 17.3.8.6.
+	 */
+	rtd = 3 * priv->coverage_class;
+	edcf->slottime += rtd;
+	edcf->round_trip_delay = cpu_to_le16(rtd);
 	/* (see prism54/isl_oid.h for further details) */
 	edcf->frameburst = cpu_to_le16(0);
-	edcf->round_trip_delay = cpu_to_le16(0);
 	edcf->flags = 0;
 	memset(edcf->mapping, 0, sizeof(edcf->mapping));
 	memcpy(edcf->queue, priv->qos_params, sizeof(edcf->queue));
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 0a45aa9..987b225 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -566,6 +566,17 @@ static void p54_flush(struct ieee80211_hw *dev, bool drop)
 	WARN(total, "tx flush timeout, unresponsive firmware");
 }
 
+static void p54_set_coverage_class(struct ieee80211_hw *dev, u8 coverage_class)
+{
+	struct p54_common *priv = dev->priv;
+
+	mutex_lock(&priv->conf_mutex);
+	/* support all coverage class values as in 802.11-2007 Table 7-27 */
+	priv->coverage_class = clamp_t(u8, coverage_class, 0, 31);
+	p54_set_edcf(priv);
+	mutex_unlock(&priv->conf_mutex);
+}
+
 static const struct ieee80211_ops p54_ops = {
 	.tx			= p54_tx_80211,
 	.start			= p54_start,
@@ -584,6 +595,7 @@ static const struct ieee80211_ops p54_ops = {
 	.conf_tx		= p54_conf_tx,
 	.get_stats		= p54_get_stats,
 	.get_survey		= p54_get_survey,
+	.set_coverage_class	= p54_set_coverage_class,
 };
 
 struct ieee80211_hw *p54_init_common(size_t priv_data_len)
diff --git a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
index f951c8f..558dd3f 100644
--- a/drivers/net/wireless/p54/p54.h
+++ b/drivers/net/wireless/p54/p54.h
@@ -218,6 +218,7 @@ struct p54_common {
 	u32 basic_rate_mask;
 	u16 aid;
+	u8 coverage_class;
 	bool powersave_override;
 	__le32 beacon_req_id;
 	struct completion beacon_comp;
 
