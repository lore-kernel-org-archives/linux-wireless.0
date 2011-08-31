Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:59749 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518Ab1HaGZW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 02:25:22 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 30 Aug 2011 23:24:34 -0700
From: Suraj Sumangala <surajs@qca.qualcomm.com>
To: <johannes@sipsolutions.net>, <linville@tuxdriver.com>,
	<ath6kl-devel@qualcomm.com>
CC: <senthilb@qca.qualcomm.com>, <vipimeht@qca.qualcomm.com>,
	<kvalo@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>,
	Suraj Sumangala <surajs@qca.qualcomm.com>
Subject: [RFC] nl80211: Added NL80211 commands for Bluetooth-WiFi coex
Date: Wed, 31 Aug 2011 11:55:15 +0530
Message-ID: <1314771915-8848-1-git-send-email-surajs@qca.qualcomm.com> (sfid-20110831_082525_612687_34CC3735)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch propose a new set of NL80211 commands and attributes
to communicate information about ongoing Bluetooth operations to the
wifi chip in case of a Bluetooth-WiFi coex solution.

It can then be used by the WiFi hardware to understand the requirements
of a Bluetooth radio and manage shared resources between
Bluetooth and Wifi modules better.

The proposed Bluetooth information sent are mainly regarding Bluetooth
SCO, A2DP connection, inquiry and master/slave role of Bluetooth chip.

This information can be sent by a userspace Bluetooth filter utility
application to the WiFi driver.

Signed-off-by: Suraj Sumangala <surajs@qca.qualcomm.com>
---
 include/linux/nl80211.h |   73 +++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.c  |    6 ++++
 2 files changed, 79 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 0343504..301ac13 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -499,6 +499,31 @@
  *	this command may also be sent by the driver as an MLME event to
  *	inform userspace of the new replay counter.
  *
+ * @NL80211_CMD_BTCOEX_INQ: This command is used to provide WiFi driver the
+ *	Bluetooth inquiry status. The status will be available in flag
+ *	%NL80211_ATTR_BTCOEX_INQ_STATUS. This information can be used to
+ *	manage shared resources when the wireless device is a Bluetooth-Wifi
+ *	coex solution.
+ *
+ * @NL80211_CMD_BTCOEX_SCO: This command is used to give the driver the
+ *	Bluetooth SCO connection status. The SCO status is available in
+ *	%NL80211_ATTR_BTCOEX_SCO_STATUS flag. It also provide
+ *	%NL80211_ATTR_BTCOEX_TYPE_ESCO to specify if the connection is ESCO.
+ *	It also has %NL80211_ATTR_BTCOEX_SCO_MAX_SLOT specifing the maximum
+ *	number of slots used for a SCO packet. This feature is typically used
+ *	when the wireless device is a Bluetooth-Wifi coex solution.
+ *
+ * @NL80211_CMD_BTCOEX_A2DP: This command is used to give the driver the
+ *	Bluetooth A2DP profile connection status. The A2DP profile connection
+ *	status is available in %NL80211_ATTR_BTCOEX_A2DP_STATUS flag.
+ *	This feature is typically used when the wireless device is a
+ *	Bluetooth-Wifi coex solution.
+ *
+ * @NL80211_CMD_BTCOEX_ACL_ROLE: This command is used to let the wifi driver
+ *	know whether the Bluetooth chip is master or slave in an ACL link.
+ *	The role is available as %NL80211_ATTR_BTCOEX_ACL_ROLE. This feature is
+ *	useful when the wireless device is a Bluetooth-Wifi coex solution.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -623,6 +648,11 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_REKEY_OFFLOAD,
 
+	NL80211_CMD_BTCOEX_INQ,
+	NL80211_CMD_BTCOEX_SCO,
+	NL80211_CMD_BTCOEX_A2DP,
+	NL80211_CMD_BTCOEX_ACL_ROLE,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1045,6 +1075,33 @@ enum nl80211_commands {
  * @NL80211_ATTR_STA_WME: Nested attribute containing the wme configuration
  *	of the station, see &enum nl80211_sta_wme_attr.
  *
+ * @%NL80211_ATTR_BTCOEX_INQ_STATUS: A flag indicating if Bluetooth inquiry
+ *	is in progress. this flag is useful for resource management in a
+ *	bluetooth wifi combo solution.
+ *
+ * @%NL80211_ATTR_BTCOEX_SCO_STATUS: A flag indicating if Bluetooth SCO audio
+ *	connection is active. this flag is useful for resource management in a
+ *	bluetooth wifi combo solution.
+ *
+ * @%NL80211_ATTR_BTCOEX_TYPE_ESCO: A flag indicating if the audio connection
+ *	is of type ESCO. If this attribute is available, the audio connection
+ *	is of type ESCO. this information is useful for resource management
+ *	in a bluetooth wifi combo solution.
+ *
+ * @%NL80211_ATTR_BTCOEX_SCO_MAX_SLOT: Provides the maximum number of slots
+ *	possible for a SCO packet in an active SCO connection.
+ *	this information is useful for resource management in a bluetooth
+ *	wifi combo solution.
+ *
+ * @%NL80211_ATTR_BTCOEX_A2DP_STATUS: A flag indicating the Bluetooth
+ *	A2DP connection status. This flag is useful for resource management
+ *	in a bluetooth wifi combo solution.
+ *
+ * @%NL80211_ATTR_BTCOEX_ACL_ROLE: Indicates if Bluetooth chip's role
+ *	in an ACL connection. See &enum nl80211_btcoex_acl_role for possible
+ *	value. This flag is useful for resource management in a bluetooth
+ *	wifi combo solution.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1257,6 +1314,13 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_STA_WME,
 
+	NL80211_ATTR_BTCOEX_INQ_STATUS,
+	NL80211_ATTR_BTCOEX_SCO_STATUS,
+	NL80211_ATTR_BTCOEX_TYPE_ESCO,
+	NL80211_ATTR_BTCOEX_SCO_MAX_SLOT,
+	NL80211_ATTR_BTCOEX_A2DP_STATUS,
+	NL80211_ATTR_BTCOEX_ACL_ROLE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2505,4 +2569,13 @@ enum nl80211_sta_wme_attr {
 	NL80211_STA_WME_MAX = __NL80211_STA_WME_AFTER_LAST - 1
 };
 
+/**
+ * enum nl80211_btcoex_acl_role - Bluetooth ACL link role
+ * @NL80211_BTCOEX_ACL_ROLE_MASTER: Bluetooth chip is in master role.
+ * @NL80211_BTCOEX_ACL_ROLE_SLAVE: Bluetooth chip is in slave role.
+ */
+enum nl80211_btcoex_acl_role {
+	NL80211_BTCOEX_ACL_ROLE_MASTER,
+	NL80211_BTCOEX_ACL_ROLE_SLAVE
+};
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index bddb559..da2d24f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -189,6 +189,12 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 					 .len = IEEE80211_MAX_DATA_LEN },
 	[NL80211_ATTR_IE_ASSOC_RESP] = { .type = NLA_BINARY,
 					 .len = IEEE80211_MAX_DATA_LEN },
+	[NL80211_ATTR_BTCOEX_INQ_STATUS] = { .type = NLA_FLAG },
+	[NL80211_ATTR_BTCOEX_SCO_STATUS] = { .type = NLA_FLAG },
+	[NL80211_ATTR_BTCOEX_TYPE_ESCO] = { .type = NLA_FLAG },
+	[NL80211_ATTR_BTCOEX_SCO_MAX_SLOT] = { .type = NLA_U32 },
+	[NL80211_ATTR_BTCOEX_A2DP_STATUS] = { .type = NLA_FLAG },
+	[NL80211_ATTR_BTCOEX_ACL_ROLE] = { .type = NLA_U32 },
 };
 
 /* policy for the key attributes */
-- 
1.7.0.4

