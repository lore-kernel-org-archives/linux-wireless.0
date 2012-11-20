Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42088 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab2KTVp0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 16:45:26 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 10/10] mac80211_hwsim: advertise VHT support
Date: Tue, 20 Nov 2012 22:45:16 +0100
Message-Id: <1353447916-17304-11-git-send-email-johannes@sipsolutions.net> (sfid-20121120_224643_238615_33B25A5C)
In-Reply-To: <1353447916-17304-1-git-send-email-johannes@sipsolutions.net>
References: <1353447916-17304-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the number of channels is > 1, which means that
hwsim will use mac80211 channel contexts, it can
also advertise VHT support.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 6be3fae..f1c05d5 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2208,6 +2208,34 @@ static int __init init_mac80211_hwsim(void)
 			sband->ht_cap.mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
 
 			hw->wiphy->bands[band] = sband;
+
+			if (channels == 1)
+				continue;
+
+			sband->vht_cap.vht_supported = true;
+			sband->vht_cap.cap =
+				IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454 |
+				IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ |
+				IEEE80211_VHT_CAP_RXLDPC |
+				IEEE80211_VHT_CAP_SHORT_GI_80 |
+				IEEE80211_VHT_CAP_SHORT_GI_160 |
+				IEEE80211_VHT_CAP_TXSTBC |
+				IEEE80211_VHT_CAP_RXSTBC_1 |
+				IEEE80211_VHT_CAP_RXSTBC_2 |
+				IEEE80211_VHT_CAP_RXSTBC_3 |
+				IEEE80211_VHT_CAP_RXSTBC_4 |
+				IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT;
+			sband->vht_cap.vht_mcs.rx_mcs_map =
+				cpu_to_le16(IEEE80211_VHT_MCS_SUPPORT_0_8 << 0 |
+					    IEEE80211_VHT_MCS_SUPPORT_0_8 << 2 |
+					    IEEE80211_VHT_MCS_SUPPORT_0_9 << 4 |
+					    IEEE80211_VHT_MCS_SUPPORT_0_8 << 6 |
+					    IEEE80211_VHT_MCS_SUPPORT_0_8 << 8 |
+					    IEEE80211_VHT_MCS_SUPPORT_0_9 << 10 |
+					    IEEE80211_VHT_MCS_SUPPORT_0_9 << 12 |
+					    IEEE80211_VHT_MCS_SUPPORT_0_8 << 14);
+			sband->vht_cap.vht_mcs.tx_mcs_map =
+				sband->vht_cap.vht_mcs.rx_mcs_map;
 		}
 		/* By default all radios are belonging to the first group */
 		data->group = 1;
-- 
1.8.0

