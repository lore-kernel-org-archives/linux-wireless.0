Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:44376 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751036AbdHRMbv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2017 08:31:51 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 18 Aug 2017 15:31:41 +0300
Message-Id: <20170818123141.19253-1-luca@coelho.fi> (sfid-20170818_143155_090387_2CAAEA7B)
In-Reply-To: <20170815082807.22055-1-emmanuel.grumbach@intel.com>
References: <20170815082807.22055-1-emmanuel.grumbach@intel.com>
Subject: [PATCH v4 12/19] nl80211: add an option to allow MFP without requiring it
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The user space can now allow the kernel to associate to an AP that
requires MFP or that doesn't have MFP enabled in the same
NL80211_CMD_CONNECT command, by using a new NL80211_MFP_OPTIONAL flag.
The driver / firmware will decide whether to use it or not.

Include a feature bit to advertise support for NL80211_MFP_OPTIONAL.
This allows new user space to run on old kernels and know that it
cannot use the new attribute if it isn't supported.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
v2: * add a feature flag
    * fix the comment of NL80211_MFP_OPTIONAL as pointed out by Igor
v3: check the feature flag
v4: return -EOPNOTSUPP if OPTIONAL is set but not supported by the
    driver (internal review)

 include/uapi/linux/nl80211.h | 13 +++++++++++--
 net/wireless/nl80211.c       |  8 +++++++-
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 76404d8a8863..59ba6ca66a0d 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1407,8 +1407,12 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_USE_MFP: Whether management frame protection (IEEE 802.11w) is
  *	used for the association (&enum nl80211_mfp, represented as a u32);
- *	this attribute can be used
- *	with %NL80211_CMD_ASSOCIATE and %NL80211_CMD_CONNECT requests
+ *	this attribute can be used with %NL80211_CMD_ASSOCIATE and
+ *	%NL80211_CMD_CONNECT requests. %NL80211_MFP_OPTIONAL is not allowed for
+ *	%NL80211_CMD_ASSOCIATE since user space SME is expected and hence, it
+ *	must have decided whether to use management frame protection or not.
+ *	Setting %NL80211_MFP_OPTIONAL with a %NL80211_CMD_CONNECT request will
+ *	let the driver (or the firmware) decide whether to use MFP or not.
  *
  * @NL80211_ATTR_STA_FLAGS2: Attribute containing a
  *	&struct nl80211_sta_flag_update.
@@ -3947,10 +3951,12 @@ enum nl80211_key_type {
  * enum nl80211_mfp - Management frame protection state
  * @NL80211_MFP_NO: Management frame protection not used
  * @NL80211_MFP_REQUIRED: Management frame protection required
+ * @NL80211_MFP_OPTIONAL: Management frame protection is optional
  */
 enum nl80211_mfp {
 	NL80211_MFP_NO,
 	NL80211_MFP_REQUIRED,
+	NL80211_MFP_OPTIONAL,
 };
 
 enum nl80211_wpa_versions {
@@ -4923,6 +4929,8 @@ enum nl80211_feature_flags {
  *	the first probe request in each channel at rate of at least 5.5Mbps.
  * @NL80211_EXT_FEATURE_OCE_PROBE_REQ_DEFERRAL_SUPPRESSION: Driver supports
  *	probe request tx deferral and suppression
+ * @NL80211_EXT_FEATURE_MFP_OPTIONAL: Driver supports the %NL80211_MFP_OPTIONAL
+ *	value in %NL80211_ATTR_USE_MFP.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -4949,6 +4957,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_ACCEPT_BCAST_PROBE_RESP,
 	NL80211_EXT_FEATURE_OCE_PROBE_REQ_HIGH_TX_RATE,
 	NL80211_EXT_FEATURE_OCE_PROBE_REQ_DEFERRAL_SUPPRESSION,
+	NL80211_EXT_FEATURE_MFP_OPTIONAL,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d57abdfa60da..8ed9ef40bbee 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8948,8 +8948,14 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 
 	if (info->attrs[NL80211_ATTR_USE_MFP]) {
 		connect.mfp = nla_get_u32(info->attrs[NL80211_ATTR_USE_MFP]);
+		if (connect.mfp == NL80211_MFP_OPTIONAL &&
+		    !wiphy_ext_feature_isset(&rdev->wiphy,
+					     NL80211_EXT_FEATURE_MFP_OPTIONAL))
+			return -EOPNOTSUPP;
+
 		if (connect.mfp != NL80211_MFP_REQUIRED &&
-		    connect.mfp != NL80211_MFP_NO)
+		    connect.mfp != NL80211_MFP_NO &&
+		    connect.mfp != NL80211_MFP_OPTIONAL)
 			return -EINVAL;
 	} else {
 		connect.mfp = NL80211_MFP_NO;
-- 
2.14.1
