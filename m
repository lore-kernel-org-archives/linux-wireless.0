Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:54769 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab3KKSOJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 13:14:09 -0500
Received: by mail-ee0-f51.google.com with SMTP id t10so2574219eei.24
        for <linux-wireless@vger.kernel.org>; Mon, 11 Nov 2013 10:14:08 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/2] mac80211: enable easier manipulation of VHT beamforming caps
Date: Mon, 11 Nov 2013 20:14:00 +0200
Message-Id: <1384193641-25813-1-git-send-email-egrumbach@gmail.com> (sfid-20131111_191414_145536_38CC673C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Introduce shift and mask defines for beamformee STS cap and number
of sounding dimensions cap as these can take any 3 bit value.
While at it also cleanup an unrequired parenthesis.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/linux/ieee80211.h |    8 ++++++--
 net/mac80211/vht.c        |    7 +++----
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 8c3b26a..776cbb8 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1411,8 +1411,12 @@ struct ieee80211_vht_operation {
 #define IEEE80211_VHT_CAP_RXSTBC_MASK				0x00000700
 #define IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE			0x00000800
 #define IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE			0x00001000
-#define IEEE80211_VHT_CAP_BEAMFORMEE_STS_MAX			0x0000e000
-#define IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_MAX		0x00070000
+#define IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT                  13
+#define IEEE80211_VHT_CAP_BEAMFORMEE_STS_MASK			\
+		(7 << IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT)
+#define IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_SHIFT		16
+#define IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_MASK		\
+		(7 << IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_SHIFT)
 #define IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE			0x00080000
 #define IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE			0x00100000
 #define IEEE80211_VHT_CAP_VHT_TXOP_PS				0x00200000
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index de01127..d75f35c 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -182,16 +182,15 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 			 IEEE80211_VHT_CAP_SHORT_GI_160);
 
 	/* remaining ones */
-	if (own_cap.cap & IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE) {
+	if (own_cap.cap & IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE)
 		vht_cap->cap |= cap_info &
 				(IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE |
-				 IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_MAX);
-	}
+				 IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_MASK);
 
 	if (own_cap.cap & IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE)
 		vht_cap->cap |= cap_info &
 				(IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE |
-				 IEEE80211_VHT_CAP_BEAMFORMEE_STS_MAX);
+				 IEEE80211_VHT_CAP_BEAMFORMEE_STS_MASK);
 
 	if (own_cap.cap & IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE)
 		vht_cap->cap |= cap_info &
-- 
1.7.9.5

