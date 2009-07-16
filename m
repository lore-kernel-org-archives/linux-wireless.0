Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:51451 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932946AbZGPSFt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 14:05:49 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] p54: fix a fw crash caused by statistic feedback
Date: Thu, 16 Jul 2009 20:05:41 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907162005.41841.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a bug which crawled into the tree with the split-up
changes.

The memory-manager wasn't aware of the statistic feedback
extra_len space requirements and happily placed following frames
into the allegedly free spots.

Thanks fly out to Larry Finger for taking the time to 
test all (permutations of) patches and theories all day long.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Christian Lamparter <chunkeey@web.de>
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
---
diff --git a/drivers/net/wireless/p54/fwio.c b/drivers/net/wireless/p54/fwio.c
index 349375f..efe47ec 100644
--- a/drivers/net/wireless/p54/fwio.c
+++ b/drivers/net/wireless/p54/fwio.c
@@ -686,6 +686,8 @@ int p54_upload_key(struct p54_common *priv, u8 algo, int slot, u8 idx, u8 len,
 
 int p54_fetch_statistics(struct p54_common *priv)
 {
+	struct ieee80211_tx_info *txinfo;
+	struct p54_tx_info *p54info;
 	struct sk_buff *skb;
 
 	skb = p54_alloc_skb(priv, P54_HDR_FLAG_CONTROL,
@@ -694,6 +696,20 @@ int p54_fetch_statistics(struct p54_common *priv)
 	if (!skb)
 		return -ENOMEM;
 
+	/*
+	 * The statistic feedback causes some extra headaches here, if it
+	 * is not to crash/corrupt the firmware data structures.
+	 *
+	 * Unlike all other Control Get OIDs we can not use helpers like
+	 * skb_put to reserve the space for the data we're requesting.
+	 * Instead the extra frame length -which will hold the results later-
+	 * will only be told to the p54_assign_address, so that following
+	 * frames won't be placed into the  allegedly empty area.
+	 */
+	txinfo = IEEE80211_SKB_CB(skb);
+	p54info = (void *) txinfo->rate_driver_data;
+	p54info->extra_len = sizeof(struct p54_statistics);
+
 	p54_tx(priv, skb);
 	return 0;
 }
