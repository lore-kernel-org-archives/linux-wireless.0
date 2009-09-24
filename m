Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:56702 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbZIXSCt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 14:02:49 -0400
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id n8OI1YAF014003
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2009 13:02:03 -0500
Received: from [127.0.1.1] (essapo-nirac25264.europe.nokia.com [10.162.252.64])
	by mgw-sa01.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id n8OI2eM5011497
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2009 21:02:41 +0300
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 1/2] cfg80211: add firmware and hardware version to wiphy
To: linux-wireless@vger.kernel.org
Date: Thu, 24 Sep 2009 11:02:42 -0700
Message-ID: <20090924180242.14503.11148.stgit@tikku>
In-Reply-To: <20090924180048.14503.9579.stgit@tikku>
References: <20090924180048.14503.9579.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

It's useful to provide firmware and hardware version to user space and have a
generic interface to retrieve them. Users can provide the version information
in bug reports etc.

Add fields for firmware and hardware version to struct wiphy and return
them to user space in NL80211_CMD_GET_WIPHY reply.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 include/linux/nl80211.h |    3 +++
 include/net/cfg80211.h  |    5 +++++
 net/wireless/nl80211.c  |   11 +++++++++++
 3 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index a8d71ed..6d6651f 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -714,6 +714,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_PID,
 
+	NL80211_ATTR_FW_VERSION,
+	NL80211_ATTR_HW_VERSION,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 3d874c6..de3da19 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1070,6 +1070,8 @@ struct cfg80211_ops {
  * and registration/helper functions
  */
 
+#define CFG80211_VERSION_LEN 32
+
 /**
  * struct wiphy - wireless hardware description
  * @idx: the wiphy index assigned to this item
@@ -1142,6 +1144,9 @@ struct wiphy {
 	u32 frag_threshold;
 	u32 rts_threshold;
 
+	char fw_version[CFG80211_VERSION_LEN];
+	char hw_version[CFG80211_VERSION_LEN];
+
 	/* If multiple wiphys are registered and you're handed e.g.
 	 * a regular netdev with assigned ieee80211_ptr, you won't
 	 * know whether it points to a wiphy your driver has registered
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index eddab09..9e2214e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -138,6 +138,14 @@ static struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] __read_mostly = {
 	[NL80211_ATTR_CIPHER_SUITE_GROUP] = { .type = NLA_U32 },
 	[NL80211_ATTR_WPA_VERSIONS] = { .type = NLA_U32 },
 	[NL80211_ATTR_PID] = { .type = NLA_U32 },
+	[NL80211_ATTR_FW_VERSION] = {
+		.type = NLA_NUL_STRING,
+		.len = CFG80211_VERSION_LEN,
+	},
+	[NL80211_ATTR_HW_VERSION] = {
+		.type = NLA_NUL_STRING,
+		.len = CFG80211_VERSION_LEN,
+	},
 };
 
 /* policy for the attributes */
@@ -420,6 +428,9 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_RTS_THRESHOLD,
 		    dev->wiphy.rts_threshold);
 
+	NLA_PUT_STRING(msg, NL80211_ATTR_FW_VERSION, dev->wiphy.fw_version);
+	NLA_PUT_STRING(msg, NL80211_ATTR_HW_VERSION, dev->wiphy.hw_version);
+
 	NLA_PUT_U8(msg, NL80211_ATTR_MAX_NUM_SCAN_SSIDS,
 		   dev->wiphy.max_scan_ssids);
 	NLA_PUT_U16(msg, NL80211_ATTR_MAX_SCAN_IE_LEN,

