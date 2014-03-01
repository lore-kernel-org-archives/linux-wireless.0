Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:58083 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbaCAUQo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2014 15:16:44 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, sujith@msujith.org,
	linville@tuxdriver.com
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 01/23] ath9k: move struct ath_beacon_config to common
Date: Sat,  1 Mar 2014 21:15:44 +0100
Message-Id: <1393704966-13985-2-git-send-email-linux@rempel-privat.de> (sfid-20140301_211648_461287_7573044E)
In-Reply-To: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
References: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  | 9 ---------
 drivers/net/wireless/ath/ath9k/common.h | 9 +++++++++
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index f995c37..b54bcae 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -408,15 +408,6 @@ void ath9k_calculate_iter_data(struct ieee80211_hw *hw,
 #define TSF_TO_TU(_h,_l) \
 	((((u32)(_h)) << 22) | (((u32)(_l)) >> 10))
 
-struct ath_beacon_config {
-	int beacon_interval;
-	u16 dtim_period;
-	u16 bmiss_timeout;
-	u8 dtim_count;
-	bool enable_beacon;
-	bool ibss_creator;
-};
-
 struct ath_beacon {
 	enum {
 		OK,		/* no change needed */
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index 4c449e3..26aafb3 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -44,6 +44,15 @@
 #define ATH_EP_RND(x, mul) 						\
 	(((x) + ((mul)/2)) / (mul))
 
+struct ath_beacon_config {
+	int beacon_interval;
+	u16 dtim_period;
+	u16 bmiss_timeout;
+	u8 dtim_count;
+	bool enable_beacon;
+	bool ibss_creator;
+};
+
 bool ath9k_cmn_rx_accept(struct ath_common *common,
 			 struct ieee80211_hdr *hdr,
 			 struct ieee80211_rx_status *rxs,
-- 
1.9.0

