Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37276 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab1HYLXh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 07:23:37 -0400
Received: by wyg24 with SMTP id 24so1570280wyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 04:23:36 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 1/3] nl80211/cfg80211: add WIPHY_FLAG_AP_UAPSD flag
Date: Thu, 25 Aug 2011 14:24:52 +0300
Message-Id: <1314271494-8756-1-git-send-email-eliad@wizery.com> (sfid-20110825_132349_072275_B99352FC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

add WIPHY_FLAG_AP_UAPSD flag to indicate uapsd support on
AP mode.

Advertise it to userspace by including a new
NL80211_ATTR_SUPPORT_AP_UAPSD attribute.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 include/linux/nl80211.h |    5 +++++
 include/net/cfg80211.h  |    2 ++
 net/wireless/nl80211.c  |    2 ++
 3 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 3769303..075497e 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1042,6 +1042,9 @@ enum nl80211_commands {
  *	(Re)Association Response frames when the driver (or firmware) replies to
  *	(Re)Association Request frames.
  *
+ * @NL80211_ATTR_SUPPORT_AP_UAPSD: the device supports uapsd when working
+ *	as AP.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1252,6 +1255,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_IE_PROBE_RESP,
 	NL80211_ATTR_IE_ASSOC_RESP,
 
+	NL80211_ATTR_SUPPORT_AP_UAPSD,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a37f264..707f95d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1617,6 +1617,7 @@ struct cfg80211_ops {
  * @WIPHY_FLAG_MESH_AUTH: The device supports mesh authentication by routing
  *	auth frames to userspace. See @NL80211_MESH_SETUP_USERSPACE_AUTH.
  * @WIPHY_FLAG_SUPPORTS_SCHED_SCAN: The device supports scheduled scans.
+ * @WIPHY_FLAG_AP_UAPSD: The device supports uapsd on AP.
  */
 enum wiphy_flags {
 	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
@@ -1631,6 +1632,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_MESH_AUTH			= BIT(10),
 	WIPHY_FLAG_SUPPORTS_SCHED_SCAN		= BIT(11),
 	WIPHY_FLAG_ENFORCE_COMBINATIONS		= BIT(12),
+	WIPHY_FLAG_AP_UAPSD			= BIT(13),
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 57ecfa4..a1854ec 100644
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
-- 
1.7.6.401.g6a319

