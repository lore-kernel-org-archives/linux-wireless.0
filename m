Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:12656 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab0LQDXn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 22:23:43 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 19:23:28 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC 6/8] iw: synch up nl80211.h
Date: Thu, 16 Dec 2010 19:23:15 -0800
Message-ID: <1292556197-4820-7-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1292556197-4820-1-git-send-email-lrodriguez@atheros.com>
References: <1292556197-4820-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 nl80211.h |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/nl80211.h b/nl80211.h
index 3804212..061c9a1 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -773,6 +773,9 @@ enum nl80211_commands {
  *	cache, a wiphy attribute.
  *
  * @NL80211_ATTR_DURATION: Duration of an operation in milliseconds, u32.
+ * @NL80211_ATTR_MAX_REMAIN_ON_CHANNEL_DURATION: Device attribute that
+ *	specifies the maximum duration that can be requested with the
+ *	remain-on-channel operation, in milliseconds, u32.
  *
  * @NL80211_ATTR_COOKIE: Generic 64-bit cookie to identify objects.
  *
@@ -851,6 +854,13 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_BSS_HTOPMODE: HT operation mode (u16)
  *
+ * @NL80211_ATTR_KEY_DEFAULT_TYPES: A nested attribute containing flags
+ *	attributes, specifying what a key should be set as default as.
+ *	See &enum nl80211_key_default_types.
+ *
+ * @NL80211_ATTR_REG_COUNTRY_FLAGS: Country specific regulatory flags.
+ *	These are @NL80211_CFLAG_DFS_FCC_*
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1029,6 +1039,12 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_BSS_HT_OPMODE,
 
+	NL80211_ATTR_KEY_DEFAULT_TYPES,
+
+	NL80211_ATTR_MAX_REMAIN_ON_CHANNEL_DURATION,
+
+	NL80211_ATTR_REG_COUNTRY_FLAGS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1466,6 +1482,24 @@ enum nl80211_reg_rule_flags {
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
@@ -1775,6 +1809,23 @@ enum nl80211_wpa_versions {
 };
 
 /**
+ * enum nl80211_key_default_types - key default types
+ * @__NL80211_KEY_DEFAULT_TYPE_INVALID: invalid
+ * @NL80211_KEY_DEFAULT_TYPE_UNICAST: key should be used as default
+ *	unicast key
+ * @NL80211_KEY_DEFAULT_TYPE_MULTICAST: key should be used as default
+ *	multicast key
+ * @NUM_NL80211_KEY_DEFAULT_TYPES: number of default types
+ */
+enum nl80211_key_default_types {
+	__NL80211_KEY_DEFAULT_TYPE_INVALID,
+	NL80211_KEY_DEFAULT_TYPE_UNICAST,
+	NL80211_KEY_DEFAULT_TYPE_MULTICAST,
+
+	NUM_NL80211_KEY_DEFAULT_TYPES
+};
+
+/**
  * enum nl80211_key_attributes - key attributes
  * @__NL80211_KEY_INVALID: invalid
  * @NL80211_KEY_DATA: (temporal) key data; for TKIP this consists of
@@ -1790,6 +1841,9 @@ enum nl80211_wpa_versions {
  * @NL80211_KEY_TYPE: the key type from enum nl80211_key_type, if not
  *	specified the default depends on whether a MAC address was
  *	given with the command using the key or not (u32)
+ * @NL80211_KEY_DEFAULT_TYPES: A nested attribute containing flags
+ *	attributes, specifying what a key should be set as default as.
+ *	See &enum nl80211_key_default_types.
  * @__NL80211_KEY_AFTER_LAST: internal
  * @NL80211_KEY_MAX: highest key attribute
  */
@@ -1802,6 +1856,7 @@ enum nl80211_key_attributes {
 	NL80211_KEY_DEFAULT,
 	NL80211_KEY_DEFAULT_MGMT,
 	NL80211_KEY_TYPE,
+	NL80211_KEY_DEFAULT_TYPES,
 
 	/* keep last */
 	__NL80211_KEY_AFTER_LAST,
-- 
1.7.3.2.90.gd4c43

