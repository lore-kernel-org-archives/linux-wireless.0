Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38808 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab3H3It1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Aug 2013 04:49:27 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>
Subject: [PATCH 2/3] ieee80211: fix vht cap definitions
Date: Fri, 30 Aug 2013 10:49:20 +0200
Message-Id: <1377852561-16754-2-git-send-email-johannes@sipsolutions.net> (sfid-20130830_104933_745876_8986D88D)
In-Reply-To: <1377852561-16754-1-git-send-email-johannes@sipsolutions.net>
References: <1377852561-16754-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

VHT_CAP_BEAMFORMER_ANTENNAS cap is actually defined in the draft as
VHT_CAP_BEAMFORMEE_STS_MAX, and its size is 3 bits long.

VHT_CAP_SOUNDING_DIMENSIONS is also 3 bits long.

Fix the definitions and change the cap masking accordingly.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h | 4 ++--
 net/mac80211/vht.c        | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 23a8877..57b699e 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1390,8 +1390,8 @@ struct ieee80211_vht_operation {
 #define IEEE80211_VHT_CAP_RXSTBC_MASK				0x00000700
 #define IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE			0x00000800
 #define IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE			0x00001000
-#define IEEE80211_VHT_CAP_BEAMFORMER_ANTENNAS_MAX		0x00006000
-#define IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_MAX		0x00030000
+#define IEEE80211_VHT_CAP_BEAMFORMEE_STS_MAX			0x0000e000
+#define IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_MAX		0x00070000
 #define IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE			0x00080000
 #define IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE			0x00100000
 #define IEEE80211_VHT_CAP_VHT_TXOP_PS				0x00200000
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index 97c28941..de01127 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -185,13 +185,13 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 	if (own_cap.cap & IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE) {
 		vht_cap->cap |= cap_info &
 				(IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE |
-				 IEEE80211_VHT_CAP_BEAMFORMER_ANTENNAS_MAX |
 				 IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_MAX);
 	}
 
 	if (own_cap.cap & IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE)
 		vht_cap->cap |= cap_info &
-				IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE;
+				(IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE |
+				 IEEE80211_VHT_CAP_BEAMFORMEE_STS_MAX);
 
 	if (own_cap.cap & IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE)
 		vht_cap->cap |= cap_info &
-- 
1.8.4.rc3

