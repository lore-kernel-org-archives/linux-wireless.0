Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46092 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751592AbdHNNtO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Aug 2017 09:49:14 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Avinash Patil <avinashp@quantenna.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] nl80211: add an option to allow MFP without requiring it
Date: Mon, 14 Aug 2017 16:49:11 +0300
Message-Id: <20170814134911.20869-1-emmanuel.grumbach@intel.com> (sfid-20170814_154918_033805_9680F582)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

User space can now allow the kernel to associate to an AP
that requires MFP or that doesn't have MFP enabled in the
same NL80211_CMD_CONNECT command.
The driver / firmware will decide whether to use it or not.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
A short tour of the drivers taught me that only Quantenna really look
at cfg80211_connect_params::sme which can now be 2. This is why
the maintainer of this driver is CCed.
---
 include/uapi/linux/nl80211.h | 10 ++++++++--
 net/wireless/nl80211.c       |  1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 7950c71c0ad4..ea1cfecbf6f4 100644
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
+ * @NL80211_MFP_OPTIONAL: Management frame is optional
  */
 enum nl80211_mfp {
 	NL80211_MFP_NO,
 	NL80211_MFP_REQUIRED,
+	NL80211_MFP_OPTIONAL,
 };
 
 enum nl80211_wpa_versions {
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
