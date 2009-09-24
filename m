Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:57289 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbZIXSJT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 14:09:19 -0400
Received: from esebh106.NOE.Nokia.com (esebh106.ntc.nokia.com [172.21.138.213])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id n8OI8GDm019461
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2009 13:08:33 -0500
Received: from [127.0.1.1] (essapo-nirac25264.europe.nokia.com [10.162.252.64])
	by mgw-sa01.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id n8OI98Pt020286
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2009 21:09:12 +0300
From: Kalle Valo <kalle.valo@nokia.com>
Subject: [PATCH 1/2] iw: update nl80211.h from wireless-testing
To: linux-wireless@vger.kernel.org
Date: Thu, 24 Sep 2009 11:09:10 -0700
Message-ID: <20090924180910.14692.28950.stgit@tikku>
In-Reply-To: <20090924180048.14503.9579.stgit@tikku>
References: <20090924180048.14503.9579.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


---

 nl80211.h |   26 +++++++++++++++++++++-----
 1 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/nl80211.h b/nl80211.h
index 962e223..a8d71ed 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -262,6 +262,9 @@
  *	reasons, for this the %NL80211_ATTR_DISCONNECTED_BY_AP and
  *	%NL80211_ATTR_REASON_CODE attributes are used.
  *
+ * @NL80211_CMD_SET_WIPHY_NETNS: Set a wiphy's netns. Note that all devices
+ *	associated with this wiphy must be down and will follow.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -336,6 +339,8 @@ enum nl80211_commands {
 	NL80211_CMD_ROAM,
 	NL80211_CMD_DISCONNECT,
 
+	NL80211_CMD_SET_WIPHY_NETNS,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -475,10 +480,6 @@ enum nl80211_commands {
  * @NL80211_ATTR_SCAN_FREQUENCIES: nested attribute with frequencies (in MHz)
  * @NL80211_ATTR_SCAN_SSIDS: nested attribute with SSIDs, leave out for passive
  *	scanning and include a zero-length SSID (wildcard) for wildcard scan
- * @NL80211_ATTR_SCAN_GENERATION: the scan generation increases whenever the
- *	scan result list changes (BSS expired or added) so that applications
- *	can verify that they got a single, consistent snapshot (when all dump
- *	messages carried the same generation number)
  * @NL80211_ATTR_BSS: scan result BSS
  *
  * @NL80211_ATTR_REG_INITIATOR: indicates who requested the regulatory domain
@@ -573,6 +574,16 @@ enum nl80211_commands {
  *	and join_ibss(), key information is in a nested attribute each
  *	with %NL80211_KEY_* sub-attributes
  *
+ * @NL80211_ATTR_PID: Process ID of a network namespace.
+ *
+ * @NL80211_ATTR_GENERATION: Used to indicate consistent snapshots for
+ *	dumps. This number increases whenever the object list being
+ *	dumped changes, and as such userspace can verify that it has
+ *	obtained a complete and consistent snapshot by verifying that
+ *	all dump messages contain the same generation number. If it
+ *	changed then the list changed and the dump should be repeated
+ *	completely from scratch.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -644,7 +655,7 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SCAN_FREQUENCIES,
 	NL80211_ATTR_SCAN_SSIDS,
-	NL80211_ATTR_SCAN_GENERATION,
+	NL80211_ATTR_GENERATION, /* replaces old SCAN_GENERATION */
 	NL80211_ATTR_BSS,
 
 	NL80211_ATTR_REG_INITIATOR,
@@ -701,12 +712,17 @@ enum nl80211_attrs {
 	NL80211_ATTR_KEY,
 	NL80211_ATTR_KEYS,
 
+	NL80211_ATTR_PID,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
 	NL80211_ATTR_MAX = __NL80211_ATTR_AFTER_LAST - 1
 };
 
+/* source-level API compatibility */
+#define NL80211_ATTR_SCAN_GENERATION NL80211_ATTR_GENERATION
+
 /*
  * Allow user space programs to use #ifdef on new attributes by defining them
  * here

