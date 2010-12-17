Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:12653 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab0LQDXi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 22:23:38 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 19:23:23 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC 5/8] crda: synch up nl80211.h header with upstream for country flags
Date: Thu, 16 Dec 2010 19:23:14 -0800
Message-ID: <1292556197-4820-6-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1292556197-4820-1-git-send-email-lrodriguez@atheros.com>
References: <1292556197-4820-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 nl80211.h |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/nl80211.h b/nl80211.h
index 1cee56b..061c9a1 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -858,6 +858,9 @@ enum nl80211_commands {
  *	attributes, specifying what a key should be set as default as.
  *	See &enum nl80211_key_default_types.
  *
+ * @NL80211_ATTR_REG_COUNTRY_FLAGS: Country specific regulatory flags.
+ *	These are @NL80211_CFLAG_DFS_FCC_*
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1040,6 +1043,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_MAX_REMAIN_ON_CHANNEL_DURATION,
 
+	NL80211_ATTR_REG_COUNTRY_FLAGS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1477,6 +1482,24 @@ enum nl80211_reg_rule_flags {
 };
 
 /**
+ * enum nl80211_cflags - country regulatory flags
+ *
+ * @NL80211_CFLAG_DFS_FCC_: Country follows DFS master rules from FCC
+ * @NL80211_CFLAG_DFS_FCC_: Country follows DFS master rules from ETSI
+ * @NL80211_CFLAG_DFS_JP_: Country follows DFS master rules from JP/Telec
+ */
+enum nl80211_cflags {
+	NL80211_CFLAG_DFS_FCC		= 1<<0,
+	NL80211_CFLAG_DFS_ETSI		= 1<<1,
+	NL80211_CFLAG_DFS_JP		= 1<<2,
+};
+
+#define NL80211_CFLAG_ALL_DFS_FLAGS \
+	(NL80211_CFLAG_DFS_FCC | \
+	 NL80211_CFLAG_DFS_ETSI | \
+	 NL80211_CFLAG_DFS_JP)
+
+/**
  * enum nl80211_survey_info - survey information
  *
  * These attribute types are used with %NL80211_ATTR_SURVEY_INFO
-- 
1.7.3.2.90.gd4c43

