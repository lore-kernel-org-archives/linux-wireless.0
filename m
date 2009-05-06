Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:53309 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753112AbZEFRij (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2009 13:38:39 -0400
Date: Wed, 6 May 2009 20:38:32 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] nl80211: Add request for dropping unencrypted frames
Message-ID: <20090506173832.GC2960@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order for mac80211 to be able to drop unencrypted frames correctly,
we must let it know when this has to be done. In theory, some of the
cases (e.g., unicast frames) would be trivial to handle based on the
configured key, but we do not do that currently (rx->key selection is
skipped for unprotected frames) and it would be less trivial for
broadcast frames (key index not available for unprotected frames). The
safest option seems to be to introduce an association request
attribute into nl80211 to set drop_unencrypted variable that is used
with WEXT.

This patch (with a matching update to wpa_supplicant) fixes an issue
where attackers could inject unencrypted frames to a network that was
supposed to be protected when using mac80211 with nl80211/cfg80211.
This is a critical issue for station mode, but can also affect AP mode
when MFP is used. The earlier plan for adding support for setting
authorized flag for station mode would reduce the effect of the
attack, but would not completely remove it. As far as AP mode is
concerned, a new BSS command attribute would likely be needed to cover
the MFP case, but that can be added in a separate patch once the more
critical client side issue is resolved.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 include/linux/nl80211.h |    5 +++++
 include/net/cfg80211.h  |    3 +++
 net/mac80211/cfg.c      |    1 +
 net/wireless/nl80211.c  |    3 +++
 4 files changed, 12 insertions(+)

--- uml.orig/include/linux/nl80211.h	2009-05-06 20:25:00.000000000 +0300
+++ uml/include/linux/nl80211.h	2009-05-06 20:25:03.000000000 +0300
@@ -498,6 +498,10 @@ enum nl80211_commands {
  *	(IEEE 802.11w) is used for the association; this attribute can be used
  *	with %NL80211_CMD_ASSOCIATE request
  *
+ * @NL80211_ATTR_DROP_UNENCRYPTED: a flag indicating that unencrypted data and
+ *	robust management frames (if MFP/IEEE 802.11w is used) are to be
+ *	dropped; this attribute can be used with %NL80211_CMD_ASSOCIATE request
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -601,6 +605,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_TIMED_OUT,
 
 	NL80211_ATTR_USE_MFP,
+	NL80211_ATTR_DROP_UNENCRYPTED,
 
 	/* add attributes here, update the policy in nl80211.c */
 
--- uml.orig/include/net/cfg80211.h	2009-05-06 20:25:00.000000000 +0300
+++ uml/include/net/cfg80211.h	2009-05-06 20:25:03.000000000 +0300
@@ -673,6 +673,8 @@ struct cfg80211_auth_request {
  * @ie: Extra IEs to add to (Re)Association Request frame or %NULL
  * @ie_len: Length of ie buffer in octets
  * @use_mfp: Use management frame protection (IEEE 802.11w) in this association
+ * @drop_unencrypted: Drop unencrypted data and robust management frames (if
+ *	MFP/IEEE 802.11w is used)
  */
 struct cfg80211_assoc_request {
 	struct ieee80211_channel *chan;
@@ -682,6 +684,7 @@ struct cfg80211_assoc_request {
 	const u8 *ie;
 	size_t ie_len;
 	bool use_mfp;
+	bool drop_unencrypted;
 };
 
 /**
--- uml.orig/net/mac80211/cfg.c	2009-05-06 20:25:00.000000000 +0300
+++ uml/net/mac80211/cfg.c	2009-05-06 20:25:03.000000000 +0300
@@ -1260,6 +1260,7 @@ static int ieee80211_assoc(struct wiphy 
 		sdata->u.mgd.mfp = IEEE80211_MFP_DISABLED;
 		sdata->u.mgd.flags &= ~IEEE80211_STA_MFP_ENABLED;
 	}
+	sdata->drop_unencrypted = req->drop_unencrypted;
 
 	sdata->u.mgd.flags |= IEEE80211_STA_EXT_SME;
 	sdata->u.mgd.state = IEEE80211_STA_MLME_ASSOCIATE;
--- uml.orig/net/wireless/nl80211.c	2009-05-06 20:25:00.000000000 +0300
+++ uml/net/wireless/nl80211.c	2009-05-06 20:25:03.000000000 +0300
@@ -123,6 +123,7 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_FREQ_FIXED] = { .type = NLA_FLAG },
 	[NL80211_ATTR_TIMED_OUT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_USE_MFP] = { .type = NLA_FLAG },
+	[NL80211_ATTR_DROP_UNENCRYPTED] = { .type = NLA_FLAG },
 };
 
 /* IE validation */
@@ -3014,6 +3015,8 @@ static int nl80211_associate(struct sk_b
 	}
 
 	req.use_mfp = info->attrs[NL80211_ATTR_USE_MFP] != NULL;
+	req.drop_unencrypted = info->attrs[NL80211_ATTR_DROP_UNENCRYPTED] !=
+		NULL;
 
 	err = drv->ops->assoc(&drv->wiphy, dev, &req);
 

-- 
Jouni Malinen                                            PGP id EFC895FA
