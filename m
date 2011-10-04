Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:34933 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933860Ab1JDXsQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 19:48:16 -0400
Received: by mail-pz0-f42.google.com with SMTP id 1so2684409pzk.1
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2011 16:48:16 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH 7/8] iw: synch nl80211.h
Date: Tue,  4 Oct 2011 16:47:46 -0700
Message-Id: <1317772067-6998-8-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111005_014820_295464_DD072D7F)
In-Reply-To: <1317772067-6998-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1317772067-6998-1-git-send-email-mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 nl80211.h |  168 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 166 insertions(+), 2 deletions(-)

diff --git a/nl80211.h b/nl80211.h
index 0343504..3d7f468 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -238,6 +238,8 @@
  *
  * @NL80211_CMD_GET_SCAN: get scan results
  * @NL80211_CMD_TRIGGER_SCAN: trigger a new scan with the given parameters
+ *	%NL80211_ATTR_TX_NO_CCK_RATE is used to decide whether to send the
+ *	probe requests at CCK rate or not.
  * @NL80211_CMD_NEW_SCAN_RESULTS: scan notification (as a reply to
  *	NL80211_CMD_GET_SCAN and on the "scan" multicast group)
  * @NL80211_CMD_SCAN_ABORTED: scan was aborted, for unspecified reasons,
@@ -432,6 +434,8 @@
  *	specified using %NL80211_ATTR_DURATION. When called, this operation
  *	returns a cookie (%NL80211_ATTR_COOKIE) that will be included with the
  *	TX status event pertaining to the TX request.
+ *	%NL80211_ATTR_TX_NO_CCK_RATE is used to decide whether to send the
+ *	management frames at CCK rate or not in 2GHz band.
  * @NL80211_CMD_FRAME_WAIT_CANCEL: When an off-channel TX was requested, this
  *	command may be used with the corresponding cookie to cancel the wait
  *	time if it is known that it is no longer necessary.
@@ -499,6 +503,12 @@
  *	this command may also be sent by the driver as an MLME event to
  *	inform userspace of the new replay counter.
  *
+ * @NL80211_CMD_PMKSA_CANDIDATE: This is used as an event to inform userspace
+ *	of PMKSA caching dandidates.
+ *
+ * @NL80211_CMD_TDLS_OPER: Perform a high-level TDLS command (e.g. link setup).
+ * @NL80211_CMD_TDLS_MGMT: Send a TDLS management frame.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -623,6 +633,11 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_REKEY_OFFLOAD,
 
+	NL80211_CMD_PMKSA_CANDIDATE,
+
+	NL80211_CMD_TDLS_OPER,
+	NL80211_CMD_TDLS_MGMT,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -769,6 +784,8 @@ enum nl80211_commands {
  *	that can be added to a scan request
  * @NL80211_ATTR_MAX_SCHED_SCAN_IE_LEN: maximum length of information
  *	elements that can be added to a scheduled scan request
+ * @NL80211_ATTR_MAX_MATCH_SETS: maximum number of sets that can be
+ *	used with @NL80211_ATTR_SCHED_SCAN_MATCH, a wiphy attribute.
  *
  * @NL80211_ATTR_SCAN_FREQUENCIES: nested attribute with frequencies (in MHz)
  * @NL80211_ATTR_SCAN_SSIDS: nested attribute with SSIDs, leave out for passive
@@ -1011,6 +1028,24 @@ enum nl80211_commands {
 
  * @NL80211_ATTR_SCHED_SCAN_INTERVAL: Interval between scheduled scan
  *	cycles, in msecs.
+
+ * @NL80211_ATTR_SCHED_SCAN_MATCH: Nested attribute with one or more
+ *	sets of attributes to match during scheduled scans.  Only BSSs
+ *	that match any of the sets will be reported.  These are
+ *	pass-thru filter rules.
+ *	For a match to succeed, the BSS must match all attributes of a
+ *	set.  Since not every hardware supports matching all types of
+ *	attributes, there is no guarantee that the reported BSSs are
+ *	fully complying with the match sets and userspace needs to be
+ *	able to ignore them by itself.
+ *	Thus, the implementation is somewhat hardware-dependent, but
+ *	this is only an optimization and the userspace application
+ *	needs to handle all the non-filtered results anyway.
+ *	If the match attributes don't make sense when combined with
+ *	the values passed in @NL80211_ATTR_SCAN_SSIDS (eg. if an SSID
+ *	is included in the probe request, but the match attributes
+ *	will never let it go through), -EINVAL may be returned.
+ *	If ommited, no filtering is done.
  *
  * @NL80211_ATTR_INTERFACE_COMBINATIONS: Nested attribute listing the supported
  *	interface combinations. In each nested item, it contains attributes
@@ -1044,6 +1079,39 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_STA_WME: Nested attribute containing the wme configuration
  *	of the station, see &enum nl80211_sta_wme_attr.
+ * @NL80211_ATTR_SUPPORT_AP_UAPSD: the device supports uapsd when working
+ *	as AP.
+ *
+ * @NL80211_ATTR_ROAM_SUPPORT: Indicates whether the firmware is capable of
+ *	roaming to another AP in the same ESS if the signal lever is low.
+ *
+ * @NL80211_ATTR_PMKSA_CANDIDATE: Nested attribute containing the PMKSA caching
+ *	candidate information, see &enum nl80211_pmksa_candidate_attr.
+ *
+ * @NL80211_ATTR_TX_NO_CCK_RATE: Indicates whether to use CCK rate or not
+ *	for management frames transmission. In order to avoid p2p probe/action
+ *	frames are being transmitted at CCK rate in 2GHz band, the user space
+ *	applications use this attribute.
+ *	This attribute is used with %NL80211_CMD_TRIGGER_SCAN and
+ *	%NL80211_CMD_FRAME commands.
+ *
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
+ * @NL80211_ATTR_DFS_REGION: region for regulatory rules which this country
+ *    abides to when initiating radiation on DFS channels. A country maps
+ *    to one DFS region.
  *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -1256,6 +1324,24 @@ enum nl80211_attrs {
 	NL80211_ATTR_IE_ASSOC_RESP,
 
 	NL80211_ATTR_STA_WME,
+	NL80211_ATTR_SUPPORT_AP_UAPSD,
+
+	NL80211_ATTR_ROAM_SUPPORT,
+
+	NL80211_ATTR_SCHED_SCAN_MATCH,
+	NL80211_ATTR_MAX_MATCH_SETS,
+
+	NL80211_ATTR_PMKSA_CANDIDATE,
+
+	NL80211_ATTR_TX_NO_CCK_RATE,
+
+	NL80211_ATTR_TDLS_ACTION,
+	NL80211_ATTR_TDLS_DIALOG_TOKEN,
+	NL80211_ATTR_TDLS_OPERATION,
+	NL80211_ATTR_TDLS_SUPPORT,
+	NL80211_ATTR_TDLS_EXTERNAL_SETUP,
+
+	NL80211_ATTR_DFS_REGION,
 
 	/* add attributes here, update the policy in nl80211.c */
 
@@ -1354,6 +1440,7 @@ enum nl80211_iftype {
  * @NL80211_STA_FLAG_WME: station is WME/QoS capable
  * @NL80211_STA_FLAG_MFP: station uses management frame protection
  * @NL80211_STA_FLAG_AUTHENTICATED: station is authenticated
+ * @NL80211_STA_FLAG_TDLS_PEER: station is a TDLS peer
  * @NL80211_STA_FLAG_MAX: highest station flag number currently defined
  * @__NL80211_STA_FLAG_AFTER_LAST: internal use
  */
@@ -1364,6 +1451,7 @@ enum nl80211_sta_flags {
 	NL80211_STA_FLAG_WME,
 	NL80211_STA_FLAG_MFP,
 	NL80211_STA_FLAG_AUTHENTICATED,
+	NL80211_STA_FLAG_TDLS_PEER,
 
 	/* keep last */
 	__NL80211_STA_FLAG_AFTER_LAST,
@@ -1716,6 +1804,26 @@ enum nl80211_reg_rule_attr {
 };
 
 /**
+ * enum nl80211_sched_scan_match_attr - scheduled scan match attributes
+ * @__NL80211_SCHED_SCAN_MATCH_ATTR_INVALID: attribute number 0 is reserved
+ * @NL80211_SCHED_SCAN_MATCH_ATTR_SSID: SSID to be used for matching,
+ * only report BSS with matching SSID.
+ * @NL80211_SCHED_SCAN_MATCH_ATTR_MAX: highest scheduled scan filter
+ *	attribute number currently defined
+ * @__NL80211_SCHED_SCAN_MATCH_ATTR_AFTER_LAST: internal use
+ */
+enum nl80211_sched_scan_match_attr {
+	__NL80211_SCHED_SCAN_MATCH_ATTR_INVALID,
+
+	NL80211_ATTR_SCHED_SCAN_MATCH_SSID,
+
+	/* keep last */
+	__NL80211_SCHED_SCAN_MATCH_ATTR_AFTER_LAST,
+	NL80211_SCHED_SCAN_MATCH_ATTR_MAX =
+		__NL80211_SCHED_SCAN_MATCH_ATTR_AFTER_LAST - 1
+};
+
+/**
  * enum nl80211_reg_rule_flags - regulatory rule flags
  *
  * @NL80211_RRF_NO_OFDM: OFDM modulation not allowed
@@ -1741,6 +1849,21 @@ enum nl80211_reg_rule_flags {
 };
 
 /**
+ * enum nl80211_dfs_regions - regulatory DFS regions
+ *
+ * @NL80211_DFS_UNSET: Country has no DFS master region specified
+ * @NL80211_DFS_FCC_: Country follows DFS master rules from FCC
+ * @NL80211_DFS_FCC_: Country follows DFS master rules from ETSI
+ * @NL80211_DFS_JP_: Country follows DFS master rules from JP/MKK/Telec
+ */
+enum nl80211_cflags {
+	NL80211_DFS_UNSET	= 0,
+	NL80211_DFS_FCC		= 1,
+	NL80211_DFS_ETSI	= 2,
+	NL80211_DFS_JP		= 3,
+};
+
+/**
  * enum nl80211_survey_info - survey information
  *
  * These attribute types are used with %NL80211_ATTR_SURVEY_INFO
@@ -2490,8 +2613,10 @@ enum nl80211_hidden_ssid {
 /**
  * enum nl80211_sta_wme_attr - station WME attributes
  * @__NL80211_STA_WME_INVALID: invalid number for nested attribute
- * @NL80211_STA_WME_QUEUES: bitmap of uapsd queues.
- * @NL80211_STA_WME_MAX_SP: max service period.
+ * @NL80211_STA_WME_UAPSD_QUEUES: bitmap of uapsd queues. the format
+ *	is the same as the AC bitmap in the QoS info field.
+ * @NL80211_STA_WME_MAX_SP: max service period. the format is the same
+ *	as the MAX_SP field in the QoS info field (but already shifted down).
  * @__NL80211_STA_WME_AFTER_LAST: internal
  * @NL80211_STA_WME_MAX: highest station WME attribute
  */
@@ -2505,4 +2630,43 @@ enum nl80211_sta_wme_attr {
 	NL80211_STA_WME_MAX = __NL80211_STA_WME_AFTER_LAST - 1
 };
 
+/**
+ * enum nl80211_pmksa_candidate_attr - attributes for PMKSA caching candidates
+ * @__NL80211_PMKSA_CANDIDATE_INVALID: invalid number for nested attributes
+ * @NL80211_PMKSA_CANDIDATE_INDEX: candidate index (u32; the smaller, the higher
+ *	priority)
+ * @NL80211_PMKSA_CANDIDATE_BSSID: candidate BSSID (6 octets)
+ * @NL80211_PMKSA_CANDIDATE_PREAUTH: RSN pre-authentication supported (flag)
+ * @NUM_NL80211_PMKSA_CANDIDATE: number of PMKSA caching candidate attributes
+ *	(internal)
+ * @MAX_NL80211_PMKSA_CANDIDATE: highest PMKSA caching candidate attribute
+ *	(internal)
+ */
+enum nl80211_pmksa_candidate_attr {
+	__NL80211_PMKSA_CANDIDATE_INVALID,
+	NL80211_PMKSA_CANDIDATE_INDEX,
+	NL80211_PMKSA_CANDIDATE_BSSID,
+	NL80211_PMKSA_CANDIDATE_PREAUTH,
+
+	/* keep last */
+	NUM_NL80211_PMKSA_CANDIDATE,
+	MAX_NL80211_PMKSA_CANDIDATE = NUM_NL80211_PMKSA_CANDIDATE - 1
+};
+
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
1.7.4.15.g7811d

