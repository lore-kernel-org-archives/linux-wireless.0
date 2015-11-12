Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35251 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbbKLR7p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 12:59:45 -0500
From: Peter Oh <poh@qca.qualcomm.com>
To: <johannes@sipsolutions.net>, <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] cfg80211: add VHT support for Mesh
Date: Thu, 12 Nov 2015 09:59:12 -0800
Message-ID: <ab294ba62856f00c06dde10b1bf57f5f341a7198.1447351137.git.poh@qca.qualcomm.com> (sfid-20151112_185948_640566_FA55802F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add NL80211_EXT_FEATURE_VHT_MESH flag to allow drivers
to indicate support for VHT in Mesh mode.
This flag will be used by wireless drivers to indicate
the capability of VHT Mesh support and wpa_supplicant to inspect
wireless drivers' capability of VHT Mesh.
In addition to this patch, separate patches to ath10k driver and
wpa_supplicant are also sent out.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>

---
v2:
	- updated commit message for details
---
 include/uapi/linux/nl80211.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 1f0b4cf..4a16ed5 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4389,12 +4389,14 @@ enum nl80211_feature_flags {
 /**
  * enum nl80211_ext_feature_index - bit index of extended features.
  * @NL80211_EXT_FEATURE_VHT_IBSS: This driver supports IBSS with VHT datarates.
+ * @NL80211_EXT_FEATURE_VHT_MESH: This driver supports Mesh with VHT datarates.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
  */
 enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_VHT_IBSS,
+	NL80211_EXT_FEATURE_VHT_MESH,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
-- 
1.9.1

