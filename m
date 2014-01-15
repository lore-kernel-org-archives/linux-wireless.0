Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:60295 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbaAOQHl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 11:07:41 -0500
Received: from ultralex.lan ([93.218.75.192]) by mail.gmx.com (mrgmx003) with
 ESMTPSA (Nemesis) id 0MZTP3-1VnKEE1ZaH-00LEYV for
 <linux-wireless@vger.kernel.org>; Wed, 15 Jan 2014 17:07:40 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	ath5k-devel@lists.ath5k.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 1/5] ath: add common function ath_is_mybeacon
Date: Wed, 15 Jan 2014 17:07:14 +0100
Message-Id: <1389802038-6688-2-git-send-email-linux@rempel-privat.de> (sfid-20140115_170743_985185_6CB2BD42)
In-Reply-To: <1389802038-6688-1-git-send-email-linux@rempel-privat.de>
References: <1389802038-6688-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

this function is used by most ath driver, so it can be moved here.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath.h  |  2 ++
 drivers/net/wireless/ath/main.c | 11 +++++++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index e0ba7cd..b59cfbe 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -17,6 +17,7 @@
 #ifndef ATH_H
 #define ATH_H
 
+#include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/if_ether.h>
 #include <linux/spinlock.h>
@@ -165,6 +166,7 @@ struct ath_common {
 struct sk_buff *ath_rxbuf_alloc(struct ath_common *common,
 				u32 len,
 				gfp_t gfp_mask);
+bool ath_is_mybeacon(struct ath_common *common, struct ieee80211_hdr *hdr);
 
 void ath_hw_setbssidmask(struct ath_common *common);
 void ath_key_delete(struct ath_common *common, struct ieee80211_key_conf *key);
diff --git a/drivers/net/wireless/ath/main.c b/drivers/net/wireless/ath/main.c
index 8e99540..9cb15d9 100644
--- a/drivers/net/wireless/ath/main.c
+++ b/drivers/net/wireless/ath/main.c
@@ -59,6 +59,17 @@ struct sk_buff *ath_rxbuf_alloc(struct ath_common *common,
 }
 EXPORT_SYMBOL(ath_rxbuf_alloc);
 
+bool ath_is_mybeacon(struct ath_common *common, struct ieee80211_hdr *hdr)
+{
+	if (ieee80211_is_beacon(hdr->frame_control) &&
+			!is_zero_ether_addr(common->curbssid) &&
+			ether_addr_equal_64bits(hdr->addr3, common->curbssid))
+		return true;
+
+	return false;
+}
+EXPORT_SYMBOL(ath_is_mybeacon);
+
 void ath_printk(const char *level, const struct ath_common* common,
 		const char *fmt, ...)
 {
-- 
1.8.5.2

