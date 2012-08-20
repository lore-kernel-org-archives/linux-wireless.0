Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34787 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab2HTV0z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 17:26:55 -0400
From: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Subject: [PATCH] ath6kl: consolidate WoW pattern length
Date: Mon, 20 Aug 2012 14:26:50 -0700
Message-ID: <1345498010-21170-1-git-send-email-c_tpeder@qca.qualcomm.com> (sfid-20120820_232731_461759_EDBDAD57)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since WOW_MASK_SIZE and WOW_PATTERN_SIZE have the same value, are
logically equivalent, and part of the WMI API so therefore unlikely to
change, consolidate these into WOW_PATTERN_SIZE.

Reported-by Kalle Valo <kvalo@qualcomm.com>
Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    2 +-
 drivers/net/wireless/ath/ath6kl/wmi.h      |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index f5300c3..19d9b9b 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1870,7 +1870,7 @@ static int ath6kl_wow_usr(struct ath6kl *ar, struct ath6kl_vif *vif,
 			  struct cfg80211_wowlan *wow, u32 *filter)
 {
 	int ret, pos;
-	u8 mask[WOW_MASK_SIZE];
+	u8 mask[WOW_PATTERN_SIZE];
 	u16 i;
 
 	/* Configure the patterns that we received from the user. */
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index a791b1b..a638151 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -2062,7 +2062,6 @@ struct wmi_set_ie_cmd {
 
 #define WOW_MAX_FILTERS_PER_LIST 4
 #define WOW_PATTERN_SIZE	 64
-#define WOW_MASK_SIZE		 64
 
 #define MAC_MAX_FILTERS_PER_LIST 4
 
@@ -2071,7 +2070,7 @@ struct wow_filter {
 	u8 wow_filter_id;
 	u8 wow_filter_size;
 	u8 wow_filter_offset;
-	u8 wow_filter_mask[WOW_MASK_SIZE];
+	u8 wow_filter_mask[WOW_PATTERN_SIZE];
 	u8 wow_filter_pattern[WOW_PATTERN_SIZE];
 } __packed;
 
-- 
1.7.5.4

