Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:57519 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbZAGPkN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 10:40:13 -0500
From: Christian Lamparter <chunkeey@web.de>
To: wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] p54: return NETDEV_TX_OK in p54_tx and fix sparse warnings
Date: Wed, 7 Jan 2009 16:40:08 +0100
Cc: John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200901071640.08721.chunkeey@web.de> (sfid-20090107_164019_902499_4A19755B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch addresses all recent comments from Johannes Berg:

1st: (reference http://marc.info/?l=linux-wireless&m=123124685019631 )
>First off: all those should return NETDEV_TX_OK/BUSY.
>iwl-agn: returns 0 (== NETDEV_TX_OK, but still should be changed) 
>[...]
>p54: same (some paths)

2nd:
> due to your PS patch ("p54: power save management"), please run sparse:
> make C=2 CF=-D__CHECK_ENDIAN__ M=...
> +drivers/net/wireless/p54/p54common.c:1753:8: warning: incorrect type in assignment (different base types)
> +drivers/net/wireless/p54/p54common.c:1769:29: warning: incorrect type in assignment (different base types)
The cpu_to_le16 ended up in the wrong line... Sorry!

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index c4ad148..1702eac 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -1508,7 +1508,7 @@ static int p54_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 	queue_delayed_work(dev->workqueue, &priv->work,
 			   msecs_to_jiffies(P54_TX_FRAME_LIFETIME));
 
-	return 0;
+	return NETDEV_TX_OK;
 
  err:
 	skb_pull(skb, sizeof(*hdr) + sizeof(*txhdr) + padding);
@@ -1750,7 +1750,7 @@ static int p54_set_ps(struct ieee80211_hw *dev)
 	int i;
 
 	if (dev->conf.flags & IEEE80211_CONF_PS)
-		mode = cpu_to_le16(P54_PSM | P54_PSM_DTIM | P54_PSM_MCBC);
+		mode = P54_PSM | P54_PSM_DTIM | P54_PSM_MCBC;
 	else
 		mode = P54_PSM_CAM;
 
@@ -1766,7 +1766,7 @@ static int p54_set_ps(struct ieee80211_hw *dev)
 	for (i = 0; i < ARRAY_SIZE(psm->intervals); i++) {
 		psm->intervals[i].interval =
 			cpu_to_le16(dev->conf.listen_interval);
-		psm->intervals[i].periods = 1;
+		psm->intervals[i].periods = cpu_to_le16(1);
 	}
 
 	psm->beacon_rssi_skip_max = 60;
