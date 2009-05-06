Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:46896 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753959AbZEFRfM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2009 13:35:12 -0400
Date: Wed, 6 May 2009 20:35:06 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: =?utf-8?Q?=5BPATCH=5D=C2=A0nl80211?=
	=?utf-8?Q?=3A?= Add support for configuring MFP
Message-ID: <20090506173506.GB2960@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NL80211_CMD_ASSOCIATE request must be able to indicate whether
management frame protection (IEEE 802.11w) is being used. mac80211 was
able to use MFP in client mode only with WEXT, but the new
NL80211_ATTR_USE_MFP attribute will allow this to be done with
nl80211, too.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 include/linux/nl80211.h |    6 ++++++
 include/net/cfg80211.h  |    2 ++
 net/mac80211/cfg.c      |    8 ++++++++
 net/wireless/nl80211.c  |    3 +++
 4 files changed, 19 insertions(+)

--- uml.orig/include/linux/nl80211.h	2009-05-06 20:24:57.000000000 +0300
+++ uml/include/linux/nl80211.h	2009-05-06 20:25:00.000000000 +0300
@@ -494,6 +494,10 @@ enum nl80211_commands {
  * @NL80211_ATTR_TIMED_OUT: a flag indicating than an operation timed out; this
  *	is used, e.g., with %NL80211_CMD_AUTHENTICATE event
  *
+ * @NL80211_ATTR_USE_MFP: a flag indicating that management frame protection
+ *	(IEEE 802.11w) is used for the association; this attribute can be used
+ *	with %NL80211_CMD_ASSOCIATE request
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -596,6 +600,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_TIMED_OUT,
 
+	NL80211_ATTR_USE_MFP,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
--- uml.orig/include/net/cfg80211.h	2009-05-06 20:24:57.000000000 +0300
+++ uml/include/net/cfg80211.h	2009-05-06 20:25:00.000000000 +0300
@@ -672,6 +672,7 @@ struct cfg80211_auth_request {
  * @ssid_len: Length of ssid in octets
  * @ie: Extra IEs to add to (Re)Association Request frame or %NULL
  * @ie_len: Length of ie buffer in octets
+ * @use_mfp: Use management frame protection (IEEE 802.11w) in this association
  */
 struct cfg80211_assoc_request {
 	struct ieee80211_channel *chan;
@@ -680,6 +681,7 @@ struct cfg80211_assoc_request {
 	size_t ssid_len;
 	const u8 *ie;
 	size_t ie_len;
+	bool use_mfp;
 };
 
 /**
--- uml.orig/net/mac80211/cfg.c	2009-05-06 20:24:57.000000000 +0300
+++ uml/net/mac80211/cfg.c	2009-05-06 20:25:00.000000000 +0300
@@ -1253,6 +1253,14 @@ static int ieee80211_assoc(struct wiphy 
 	if (ret)
 		return ret;
 
+	if (req->use_mfp) {
+		sdata->u.mgd.mfp = IEEE80211_MFP_REQUIRED;
+		sdata->u.mgd.flags |= IEEE80211_STA_MFP_ENABLED;
+	} else {
+		sdata->u.mgd.mfp = IEEE80211_MFP_DISABLED;
+		sdata->u.mgd.flags &= ~IEEE80211_STA_MFP_ENABLED;
+	}
+
 	sdata->u.mgd.flags |= IEEE80211_STA_EXT_SME;
 	sdata->u.mgd.state = IEEE80211_STA_MLME_ASSOCIATE;
 	ieee80211_sta_req_auth(sdata);
--- uml.orig/net/wireless/nl80211.c	2009-05-06 20:24:57.000000000 +0300
+++ uml/net/wireless/nl80211.c	2009-05-06 20:25:00.000000000 +0300
@@ -122,6 +122,7 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_REASON_CODE] = { .type = NLA_U16 },
 	[NL80211_ATTR_FREQ_FIXED] = { .type = NLA_FLAG },
 	[NL80211_ATTR_TIMED_OUT] = { .type = NLA_FLAG },
+	[NL80211_ATTR_USE_MFP] = { .type = NLA_FLAG },
 };
 
 /* IE validation */
@@ -3012,6 +3013,8 @@ static int nl80211_associate(struct sk_b
 		req.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 	}
 
+	req.use_mfp = info->attrs[NL80211_ATTR_USE_MFP] != NULL;
+
 	err = drv->ops->assoc(&drv->wiphy, dev, &req);
 
 out:

-- 
Jouni Malinen                                            PGP id EFC895FA
