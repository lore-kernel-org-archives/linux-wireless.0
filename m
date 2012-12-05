Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48937 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab2LEPpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 10:45:09 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wireless: fix VHT max AMPDU exponent definition
Date: Wed,  5 Dec 2012 16:45:31 +0100
Message-Id: <1354722331-24251-1-git-send-email-johannes@sipsolutions.net> (sfid-20121205_164513_483000_C29DB818)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is really a 3-bit field, not a single bit,
so declare a mask and shift. Also fix hwsim, it
advertises the maximum possible.

While at it reindent all the defines using tabs
instead of spaces.

Change-Id: I7cd81c0d72f76deb5010aba5bfa3dd312006e898
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c |  2 +-
 include/linux/ieee80211.h             | 54 ++++++++++++++++++-----------------
 2 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 81fc664..dfc42ca 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2218,7 +2218,7 @@ static int __init init_mac80211_hwsim(void)
 				IEEE80211_VHT_CAP_RXSTBC_2 |
 				IEEE80211_VHT_CAP_RXSTBC_3 |
 				IEEE80211_VHT_CAP_RXSTBC_4 |
-				IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT;
+				IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK;
 			sband->vht_cap.vht_mcs.rx_mcs_map =
 				cpu_to_le16(IEEE80211_VHT_MCS_SUPPORT_0_8 << 0 |
 					    IEEE80211_VHT_MCS_SUPPORT_0_8 << 2 |
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index f9c5a78..bde45a5 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1236,32 +1236,34 @@ struct ieee80211_vht_operation {
 #define IEEE80211_VHT_MCS_NOT_SUPPORTED 3
 
 /* 802.11ac VHT Capabilities */
-#define IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_3895                0x00000000
-#define IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991                0x00000001
-#define IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454               0x00000002
-#define IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ              0x00000004
-#define IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ     0x00000008
-#define IEEE80211_VHT_CAP_RXLDPC                              0x00000010
-#define IEEE80211_VHT_CAP_SHORT_GI_80                         0x00000020
-#define IEEE80211_VHT_CAP_SHORT_GI_160                        0x00000040
-#define IEEE80211_VHT_CAP_TXSTBC                              0x00000080
-#define IEEE80211_VHT_CAP_RXSTBC_1                            0x00000100
-#define IEEE80211_VHT_CAP_RXSTBC_2                            0x00000200
-#define IEEE80211_VHT_CAP_RXSTBC_3                            0x00000300
-#define IEEE80211_VHT_CAP_RXSTBC_4                            0x00000400
-#define IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE               0x00000800
-#define IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE               0x00001000
-#define IEEE80211_VHT_CAP_BEAMFORMER_ANTENNAS_MAX             0x00006000
-#define IEEE80211_VHT_CAP_SOUNDING_DIMENTION_MAX              0x00030000
-#define IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE               0x00080000
-#define IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE               0x00100000
-#define IEEE80211_VHT_CAP_VHT_TXOP_PS                         0x00200000
-#define IEEE80211_VHT_CAP_HTC_VHT                             0x00400000
-#define IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT          0x00800000
-#define IEEE80211_VHT_CAP_VHT_LINK_ADAPTATION_VHT_UNSOL_MFB   0x08000000
-#define IEEE80211_VHT_CAP_VHT_LINK_ADAPTATION_VHT_MRQ_MFB     0x0c000000
-#define IEEE80211_VHT_CAP_RX_ANTENNA_PATTERN                  0x10000000
-#define IEEE80211_VHT_CAP_TX_ANTENNA_PATTERN                  0x20000000
+#define IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_3895			0x00000000
+#define IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991			0x00000001
+#define IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454			0x00000002
+#define IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ		0x00000004
+#define IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ	0x00000008
+#define IEEE80211_VHT_CAP_RXLDPC				0x00000010
+#define IEEE80211_VHT_CAP_SHORT_GI_80				0x00000020
+#define IEEE80211_VHT_CAP_SHORT_GI_160				0x00000040
+#define IEEE80211_VHT_CAP_TXSTBC				0x00000080
+#define IEEE80211_VHT_CAP_RXSTBC_1				0x00000100
+#define IEEE80211_VHT_CAP_RXSTBC_2				0x00000200
+#define IEEE80211_VHT_CAP_RXSTBC_3				0x00000300
+#define IEEE80211_VHT_CAP_RXSTBC_4				0x00000400
+#define IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE			0x00000800
+#define IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE			0x00001000
+#define IEEE80211_VHT_CAP_BEAMFORMER_ANTENNAS_MAX		0x00006000
+#define IEEE80211_VHT_CAP_SOUNDING_DIMENTION_MAX		0x00030000
+#define IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE			0x00080000
+#define IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE			0x00100000
+#define IEEE80211_VHT_CAP_VHT_TXOP_PS				0x00200000
+#define IEEE80211_VHT_CAP_HTC_VHT				0x00400000
+#define IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_SHIFT	23
+#define IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK	\
+		(7 << IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_SHIFT)
+#define IEEE80211_VHT_CAP_VHT_LINK_ADAPTATION_VHT_UNSOL_MFB	0x08000000
+#define IEEE80211_VHT_CAP_VHT_LINK_ADAPTATION_VHT_MRQ_MFB	0x0c000000
+#define IEEE80211_VHT_CAP_RX_ANTENNA_PATTERN			0x10000000
+#define IEEE80211_VHT_CAP_TX_ANTENNA_PATTERN			0x20000000
 
 /* Authentication algorithms */
 #define WLAN_AUTH_OPEN 0
-- 
1.8.0

