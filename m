Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:62076 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbaKFHyj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 02:54:39 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@qca.qualcomm.com, sujith@msujith.org, nbd@openwrt.org,
	patro@cs.wisc.edu, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 07/21] ath: add struct ath_ps_ops
Date: Thu,  6 Nov 2014 08:53:24 +0100
Message-Id: <1415260418-14321-8-git-send-email-linux@rempel-privat.de> (sfid-20141106_085445_055013_AB70E4B7)
In-Reply-To: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
References: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

we will need it to make common code

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 999d24f..ccba4fe 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -135,6 +135,11 @@ struct ath_ops {
 struct ath_common;
 struct ath_bus_ops;
 
+struct ath_ps_ops {
+	void (*wakeup)(struct ath_common *common);
+	void (*restore)(struct ath_common *common);
+};
+
 struct ath_common {
 	void *ah;
 	void *priv;
@@ -169,6 +174,7 @@ struct ath_common {
 	struct ath_regulatory reg_world_copy;
 	const struct ath_ops *ops;
 	const struct ath_bus_ops *bus_ops;
+	const struct ath_ps_ops *ps_ops;
 
 	bool btcoex_enabled;
 	bool disable_ani;
@@ -178,6 +184,11 @@ struct ath_common {
 	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
 };
 
+static inline const struct ath_ps_ops *ath_ps_ops(struct ath_common *common)
+{
+	return common->ps_ops;
+}
+
 struct sk_buff *ath_rxbuf_alloc(struct ath_common *common,
 				u32 len,
 				gfp_t gfp_mask);
-- 
1.9.1

