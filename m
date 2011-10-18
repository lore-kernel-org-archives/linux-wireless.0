Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63875 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab1JRJSh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 05:18:37 -0400
Received: by wwe6 with SMTP id 6so591576wwe.1
        for <linux-wireless@vger.kernel.org>; Tue, 18 Oct 2011 02:18:36 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 1/2] iw: Update nl80211.h
Date: Tue, 18 Oct 2011 11:18:26 +0200
Message-Id: <1318929507-11447-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20111018_111840_558713_48664334)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 nl80211.h |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/nl80211.h b/nl80211.h
index c73582f..013ec4b 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -506,6 +506,9 @@
  * @NL80211_CMD_PMKSA_CANDIDATE: This is used as an event to inform userspace
  *	of PMKSA caching dandidates.
  *
+ * @NL80211_CMD_TDLS_OPER: Perform a high-level TDLS command (e.g. link setup).
+ * @NL80211_CMD_TDLS_MGMT: Send a TDLS management frame.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -632,6 +635,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_PMKSA_CANDIDATE,
 
+	NL80211_CMD_TDLS_OPER,
+	NL80211_CMD_TDLS_MGMT,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1089,6 +1095,20 @@ enum nl80211_commands {
  *	This attribute is used with %NL80211_CMD_TRIGGER_SCAN and
  *	%NL80211_CMD_FRAME commands.
  *
+ * @NL80211_ATTR_TDLS_ACTION: Low level TDLS action code (e.g. link setup
+ *	request, link setup confirm, link teardown, etc.). Values are
+ *	described in the TDLS (802.11z) specification.
+ * @NL80211_ATTR_TDLS_DIALOG_TOKEN: Non-zero token for uniquely identifying a
+ *	TDLS conversation between two devices.
+ * @NL80211_ATTR_TDLS_OPERATION: High level TDLS operation; see
+ *	&enum nl80211_tdls_operation, represented as a u8.
+ * @NL80211_ATTR_TDLS_SUPPORT: A flag indicating the device can operate
+ *	as a TDLS peer sta.
+ * @NL80211_ATTR_TDLS_EXTERNAL_SETUP: The TDLS discovery/setup and teardown
+ *	procedures should be performed by sending TDLS packets via
+ *	%NL80211_CMD_TDLS_MGMT. Otherwise %NL80211_CMD_TDLS_OPER should be
+ *	used for asking the driver to perform a TDLS operation.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1311,6 +1331,12 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_TX_NO_CCK_RATE,
 
+	NL80211_ATTR_TDLS_ACTION,
+	NL80211_ATTR_TDLS_DIALOG_TOKEN,
+	NL80211_ATTR_TDLS_OPERATION,
+	NL80211_ATTR_TDLS_SUPPORT,
+	NL80211_ATTR_TDLS_EXTERNAL_SETUP,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1408,6 +1434,7 @@ enum nl80211_iftype {
  * @NL80211_STA_FLAG_WME: station is WME/QoS capable
  * @NL80211_STA_FLAG_MFP: station uses management frame protection
  * @NL80211_STA_FLAG_AUTHENTICATED: station is authenticated
+ * @NL80211_STA_FLAG_TDLS_PEER: station is a TDLS peer
  * @NL80211_STA_FLAG_MAX: highest station flag number currently defined
  * @__NL80211_STA_FLAG_AFTER_LAST: internal use
  */
@@ -1418,6 +1445,7 @@ enum nl80211_sta_flags {
 	NL80211_STA_FLAG_WME,
 	NL80211_STA_FLAG_MFP,
 	NL80211_STA_FLAG_AUTHENTICATED,
+	NL80211_STA_FLAG_TDLS_PEER,
 
 	/* keep last */
 	__NL80211_STA_FLAG_AFTER_LAST,
@@ -1520,6 +1548,7 @@ enum nl80211_sta_bss_param {
  * @NL80211_STA_INFO_BSS_PARAM: current station's view of BSS, nested attribute
  *     containing info as possible, see &enum nl80211_sta_bss_param
  * @NL80211_STA_INFO_CONNECTED_TIME: time since the station is last connected
+ * @NL80211_STA_INFO_STA_FLAGS: Contains a struct nl80211_sta_flag_update. 
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -1541,6 +1570,7 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_RX_BITRATE,
 	NL80211_STA_INFO_BSS_PARAM,
 	NL80211_STA_INFO_CONNECTED_TIME,
+	NL80211_STA_INFO_STA_FLAGS,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
@@ -2604,4 +2634,20 @@ enum nl80211_pmksa_candidate_attr {
 	MAX_NL80211_PMKSA_CANDIDATE = NUM_NL80211_PMKSA_CANDIDATE - 1
 };
 
+/**
+ * enum nl80211_tdls_operation - values for %NL80211_ATTR_TDLS_OPERATION
+ * @NL80211_TDLS_DISCOVERY_REQ: Send a TDLS discovery request
+ * @NL80211_TDLS_SETUP: Setup TDLS link
+ * @NL80211_TDLS_TEARDOWN: Teardown a TDLS link which is already established
+ * @NL80211_TDLS_ENABLE_LINK: Enable TDLS link
+ * @NL80211_TDLS_DISABLE_LINK: Disable TDLS link
+ */
+enum nl80211_tdls_operation {
+	NL80211_TDLS_DISCOVERY_REQ,
+	NL80211_TDLS_SETUP,
+	NL80211_TDLS_TEARDOWN,
+	NL80211_TDLS_ENABLE_LINK,
+	NL80211_TDLS_DISABLE_LINK,
+};
+
 #endif /* __LINUX_NL80211_H */
-- 
1.7.3.4

