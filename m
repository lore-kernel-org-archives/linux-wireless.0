Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:7881 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750992AbdHOIOp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Aug 2017 04:14:45 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Avinash Patil <avinashp@quantenna.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH v2] nl80211: add an option to allow MFP without requiring it
Date: Tue, 15 Aug 2017 11:14:26 +0300
Message-Id: <20170815081426.16767-1-emmanuel.grumbach@intel.com> (sfid-20170815_101451_194640_3755DE58)
In-Reply-To: <20170814134911.20869-1-emmanuel.grumbach@intel.com>
References: <20170814134911.20869-1-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

User space can now allow the kernel to associate to an AP
that requires MFP or that doesn't have MFP enabled in the
same NL80211_CMD_CONNECT command.
The driver / firmware will decide whether to use it or not.
Add a feature bit to inform the user space the kernel
supports this setting.

This new option will be useful for firmwares that can
generate the RSN IE internally and when the user space does
not have the RSN IE of the AP we're connecting to. Since
the user space doesn't see the RSN IE of the AP, it cannot
fully decide whether to require or to forbid MFP. It needs
to be given the possibility to allow the driver to use MFP
without making it mandatory.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
v2: * add a feature flag
    * fix the comment of NL80211_MFP_OPTIONAL as pointed out by Igor
---
 include/uapi/linux/nl80211.h | 13 +++++++++++--
 net/wireless/nl80211.c       |  1 +
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 7950c71c0ad4..e98c93d86220 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1410,8 +1410,12 @@ enum nl80211_commands {
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
@@ -4086,10 +4090,12 @@ enum nl80211_key_type {
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
@@ -5058,6 +5064,8 @@ enum nl80211_feature_flags {
  *	the first probe request in each channel at rate of at least 5.5Mbps.
  * @NL80211_EXT_FEATURE_OCE_PROBE_REQ_DEFERRAL_SUPPRESSION: Driver supports
  *	probe request tx deferral and suppression
+ * @NL80211_EXT_FEATURE_MFP_OPTIONAL: Driver supports the %NL80211_MFP_OPTIONAL
+ *	value in %NL80211_ATTR_USE_MFP.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -5083,6 +5091,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_ACCEPT_BCAST_PROBE_RESP,
 	NL80211_EXT_FEATURE_OCE_PROBE_REQ_HIGH_TX_RATE,
 	NL80211_EXT_FEATURE_OCE_PROBE_REQ_DEFERRAL_SUPPRESSION,
+	NL80211_EXT_FEATURE_MFP_OPTIONAL,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8f035d9868d1..829867132326 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9115,6 +9115,7 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 	if (info->attrs[NL80211_ATTR_USE_MFP]) {
 		connect.mfp = nla_get_u32(info->attrs[NL80211_ATTR_USE_MFP]);
 		if (connect.mfp != NL80211_MFP_REQUIRED &&
+		    connect.mfp != NL80211_MFP_OPTIONAL &&
 		    connect.mfp != NL80211_MFP_NO)
 			return -EINVAL;
 	} else {
-- 
2.9.3
