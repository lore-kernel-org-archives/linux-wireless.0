Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:58213 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbaARMyi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jan 2014 07:54:38 -0500
Received: from ultralex.lan ([93.218.86.193]) by mail.gmx.com (mrgmx101) with
 ESMTPSA (Nemesis) id 0LjeWC-1VTEix0jFo-00bcJr for
 <linux-wireless@vger.kernel.org>; Sat, 18 Jan 2014 13:54:37 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH v3 1/5] ath: add common function ath_is_mybeacon
Date: Sat, 18 Jan 2014 13:54:15 +0100
Message-Id: <1390049659-27021-2-git-send-email-linux@rempel-privat.de> (sfid-20140118_135450_355473_86AB406D)
In-Reply-To: <1390049659-27021-1-git-send-email-linux@rempel-privat.de>
References: <1390049659-27021-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

this function is used by most ath driver, so it can be moved here.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index e0ba7cd..ab6a0c8 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -17,6 +17,7 @@
 #ifndef ATH_H
 #define ATH_H
 
+#include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/if_ether.h>
 #include <linux/spinlock.h>
@@ -162,10 +163,17 @@ struct ath_common {
 	bool bt_ant_diversity;
 };
 
+static inline bool ath_is_mybeacon(struct ath_common *common,
+				   struct ieee80211_hdr *hdr)
+{
+	return ieee80211_is_beacon(hdr->frame_control) &&
+		!is_zero_ether_addr(common->curbssid) &&
+		ether_addr_equal_64bits(hdr->addr3, common->curbssid);
+}
+
 struct sk_buff *ath_rxbuf_alloc(struct ath_common *common,
 				u32 len,
 				gfp_t gfp_mask);
-
 void ath_hw_setbssidmask(struct ath_common *common);
 void ath_key_delete(struct ath_common *common, struct ieee80211_key_conf *key);
 int ath_key_config(struct ath_common *common,
-- 
1.8.5.2

