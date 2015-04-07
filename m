Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56741 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755111AbbDGQFg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2015 12:05:36 -0400
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH 2/2] mac80211_hwsim: Fix the supported VHT mcs rates
Date: Tue,  7 Apr 2015 19:05:22 +0300
Message-Id: <1428422722-655-2-git-send-email-ilan.peer@intel.com> (sfid-20150407_180543_406719_3DA9D5FF)
In-Reply-To: <1428422722-655-1-git-send-email-ilan.peer@intel.com>
References: <1428422722-655-1-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Declare that MCS 0-9 are supported for all Rx chains.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 2f0ebda..c5f5841 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2453,14 +2453,14 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 				IEEE80211_VHT_CAP_RXSTBC_4 |
 				IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK;
 			sband->vht_cap.vht_mcs.rx_mcs_map =
-				cpu_to_le16(IEEE80211_VHT_MCS_SUPPORT_0_8 << 0 |
-					    IEEE80211_VHT_MCS_SUPPORT_0_8 << 2 |
+				cpu_to_le16(IEEE80211_VHT_MCS_SUPPORT_0_9 << 0 |
+					    IEEE80211_VHT_MCS_SUPPORT_0_9 << 2 |
 					    IEEE80211_VHT_MCS_SUPPORT_0_9 << 4 |
-					    IEEE80211_VHT_MCS_SUPPORT_0_8 << 6 |
-					    IEEE80211_VHT_MCS_SUPPORT_0_8 << 8 |
+					    IEEE80211_VHT_MCS_SUPPORT_0_9 << 6 |
+					    IEEE80211_VHT_MCS_SUPPORT_0_9 << 8 |
 					    IEEE80211_VHT_MCS_SUPPORT_0_9 << 10 |
 					    IEEE80211_VHT_MCS_SUPPORT_0_9 << 12 |
-					    IEEE80211_VHT_MCS_SUPPORT_0_8 << 14);
+					    IEEE80211_VHT_MCS_SUPPORT_0_9 << 14);
 			sband->vht_cap.vht_mcs.tx_mcs_map =
 				sband->vht_cap.vht_mcs.rx_mcs_map;
 			break;
-- 
1.9.1

