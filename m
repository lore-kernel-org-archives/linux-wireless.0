Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49172 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757384Ab3BVUJ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 15:09:27 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 3.9] ath9k: fix RSSI dummy marker value
Date: Fri, 22 Feb 2013 21:09:17 +0100
Message-Id: <1361563757-85141-1-git-send-email-nbd@openwrt.org> (sfid-20130222_210930_791638_255E44E5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RSSI is being stored internally as s8 in several places. The indication
of an unset RSSI value, ATH_RSSI_DUMMY_MARKER, was supposed to have been
set to 127, but ended up being set to 0x127 because of a code cleanup
mistake. This could lead to invalid signal strength values in a few
places.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@vger.kernel.org
---
 drivers/net/wireless/ath/ath9k/common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index 5f845be..050ca4a 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -27,7 +27,7 @@
 #define WME_MAX_BA              WME_BA_BMP_SIZE
 #define ATH_TID_MAX_BUFS        (2 * WME_MAX_BA)
 
-#define ATH_RSSI_DUMMY_MARKER   0x127
+#define ATH_RSSI_DUMMY_MARKER   127
 #define ATH_RSSI_LPF_LEN 		10
 #define RSSI_LPF_THRESHOLD		-20
 #define ATH_RSSI_EP_MULTIPLIER     (1<<7)
-- 
1.8.0.2

