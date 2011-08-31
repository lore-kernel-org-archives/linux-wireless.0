Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64695 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab1HaI2I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 04:28:08 -0400
Received: by wwf5 with SMTP id 5so492320wwf.1
        for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 01:28:07 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] nl80211/cfg80211: add WIPHY_FLAG_AP_UAPSD flag
Date: Wed, 31 Aug 2011 11:29:43 +0300
Message-Id: <1314779383-3557-1-git-send-email-eliad@wizery.com> (sfid-20110831_102813_012272_70236BE6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

add WIPHY_FLAG_AP_UAPSD flag to indicate uapsd support on
AP mode.

Advertise it to userspace by including a new
NL80211_ATTR_SUPPORT_AP_UAPSD attribute.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
this patch was rebased on top of wireless-testing, and contains the
all the changes that were in my v2 of the patchset, that weren't
in v1 (that was applied))

 include/linux/nl80211.h |    3 +++
 include/net/cfg80211.h  |    2 ++
 net/wireless/nl80211.c  |    5 ++++-
 3 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 0343504..a3f352f 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1044,6 +1044,8 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_STA_WME: Nested attribute containing the wme configuration
  *	of the station, see &enum nl80211_sta_wme_attr.
+ * @NL80211_ATTR_SUPPORT_AP_UAPSD: the device supports uapsd when working
+ *	as AP.
  *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -1256,6 +1258,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_IE_ASSOC_RESP,
 
 	NL80211_ATTR_STA_WME,
+	NL80211_ATTR_SUPPORT_AP_UAPSD,
 
 	/* add attributes here, update the policy in nl80211.c */
 
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ce9b7e6..5390a89 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1619,6 +1619,7 @@ struct cfg80211_ops {
  * @WIPHY_FLAG_MESH_AUTH: The device supports mesh authentication by routing
  *	auth frames to userspace. See @NL80211_MESH_SETUP_USERSPACE_AUTH.
  * @WIPHY_FLAG_SUPPORTS_SCHED_SCAN: The device supports scheduled scans.
+ * @WIPHY_FLAG_AP_UAPSD: The device supports uapsd on AP.
  */
 enum wiphy_flags {
 	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
@@ -1633,6 +1634,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_MESH_AUTH			= BIT(10),
 	WIPHY_FLAG_SUPPORTS_SCHED_SCAN		= BIT(11),
 	WIPHY_FLAG_ENFORCE_COMBINATIONS		= BIT(12),
+	WIPHY_FLAG_AP_UAPSD			= BIT(13),
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index bddb559..6ea9ffe 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -719,6 +719,8 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 		NLA_PUT_FLAG(msg, NL80211_ATTR_SUPPORT_IBSS_RSN);
 	if (dev->wiphy.flags & WIPHY_FLAG_MESH_AUTH)
 		NLA_PUT_FLAG(msg, NL80211_ATTR_SUPPORT_MESH_AUTH);
+	if (dev->wiphy.flags & WIPHY_FLAG_AP_UAPSD)
+		NLA_PUT_FLAG(msg, NL80211_ATTR_SUPPORT_AP_UAPSD);
 
 	NLA_PUT(msg, NL80211_ATTR_CIPHER_SUITES,
 		sizeof(u32) * dev->wiphy.n_cipher_suites,
@@ -2597,7 +2599,8 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 
 	/* parse WME attributes if sta is WME capable */
-	if ((params.sta_flags_set & NL80211_STA_FLAG_WME) &&
+	if ((rdev->wiphy.flags & WIPHY_FLAG_AP_UAPSD) &&
+	    (params.sta_flags_set & NL80211_STA_FLAG_WME) &&
 	    info->attrs[NL80211_ATTR_STA_WME]) {
 		struct nlattr *tb[NL80211_STA_WME_MAX + 1];
 		struct nlattr *nla;
-- 
1.7.6.401.g6a319

