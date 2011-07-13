Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8030 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab1GMMYg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 08:24:36 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [RFC 2/3] wireless: Add 40MHz Intolerance support to HT capablities.
Date: Wed, 13 Jul 2011 17:54:32 +0530
Message-ID: <1310559873-10314-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110713_142440_143428_FA651F52)
In-Reply-To: <1310559873-10314-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1310559873-10314-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 include/net/cfg80211.h |    5 +++++
 net/wireless/core.c    |    3 +++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 4bf101b..eaa9dee 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -128,6 +128,8 @@ enum ieee80211_channel_flags {
  * @beacon_found: helper to regulatory code to indicate when a beacon
  *	has been found on this channel. Use regulatory_hint_found_beacon()
  *	to enable this, this is useful only on 5 GHz band.
+ * @is_40mhz_intolerant: one of the bss in this channel disallows the use of
+ *	20/40 MHz BSS. this will be used by Intolerant Channel Report.
  * @orig_mag: internal use
  * @orig_mpwr: internal use
  */
@@ -139,6 +141,7 @@ struct ieee80211_channel {
 	int max_antenna_gain;
 	int max_power;
 	bool beacon_found;
+	bool is_40mhz_intolerant;
 	u32 orig_flags;
 	int orig_mag, orig_mpwr;
 };
@@ -1746,6 +1749,7 @@ struct wiphy_wowlan_support {
  *	add to probe request frames transmitted during a scan, must not
  *	include fixed IEs like supported rates
  * @coverage_class: current coverage class
+ * @dot11FortyMHzIntolerant: Enable/Disable Forty MHz Intolerance
  * @fw_version: firmware version for ethtool reporting
  * @hw_version: hardware version for ethtool reporting
  * @max_num_pmkids: maximum number of PMKIDs supported by device
@@ -1806,6 +1810,7 @@ struct wiphy {
 	u32 frag_threshold;
 	u32 rts_threshold;
 	u8 coverage_class;
+	bool dot11FortyMHzIntolerant;
 
 	char fw_version[ETHTOOL_BUSINFO_LEN];
 	u32 hw_version;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 880dbe2..e4b9321 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -412,6 +412,7 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 	rdev->wiphy.frag_threshold = (u32) -1;
 	rdev->wiphy.rts_threshold = (u32) -1;
 	rdev->wiphy.coverage_class = 0;
+	rdev->wiphy.dot11FortyMHzIntolerant = false;
 
 	return &rdev->wiphy;
 }
@@ -532,6 +533,8 @@ int wiphy_register(struct wiphy *wiphy)
 			sband->ht_cap.cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 			sband->ht_cap.cap &= ~IEEE80211_HT_CAP_SGI_40;
 		}
+		if (wiphy->dot11FortyMHzIntolerant)
+			sband->ht_cap.cap |= IEEE80211_HT_CAP_40MHZ_INTOLERANT;
 
 		/*
 		 * Since we use a u32 for rate bitmaps in
-- 
1.7.6

