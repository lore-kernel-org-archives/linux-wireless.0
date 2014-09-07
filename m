Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:64835 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbaIGRc0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Sep 2014 13:32:26 -0400
Received: by mail-we0-f180.google.com with SMTP id t60so165131wes.39
        for <linux-wireless@vger.kernel.org>; Sun, 07 Sep 2014 10:32:24 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCHv3 1/2] iw: update nl80211.h
Date: Sun,  7 Sep 2014 19:32:19 +0200
Message-Id: <1410111140-4340-2-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140907_193237_526948_2EB29AB2)
In-Reply-To: <1410111140-4340-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1410111140-4340-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sync nl80211_attrs enumeration and nl80211_feature_flags enumeration with
mac80211-next tree. This change is necessary to add support to dynack
configuration.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 nl80211.h | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/nl80211.h b/nl80211.h
index be9519b..8951c31 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -1591,6 +1591,20 @@ enum nl80211_commands {
  *	creation then the new interface will be owned by the netlink socket
  *	that created it and will be destroyed when the socket is closed
  *
+ * @NL80211_ATTR_TDLS_INITIATOR: flag attribute indicating the current end is
+ *	the TDLS link initiator.
+ *
+ * @NL80211_ATTR_USE_RRM: flag for indicating whether the current connection
+ *	shall support Radio Resource Measurements (11k). This attribute can be
+ *	used with %NL80211_CMD_ASSOCIATE and %NL80211_CMD_CONNECT requests.
+ *	User space applications are expected to use this flag only if the
+ *	underlying device supports these minimal RRM features:
+ *		%NL80211_FEATURE_DS_PARAM_SET_IE_IN_PROBES,
+ *		%NL80211_FEATURE_QUIET,
+ *	If this flag is used, driver must add the Power Capabilities IE to the
+ *	association request. In addition, it must also set the RRM capability
+ *	flag in the association request's Capability Info field.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1931,6 +1945,10 @@ enum nl80211_attrs {
 	NL80211_ATTR_CSA_C_OFFSETS_TX,
 	NL80211_ATTR_MAX_CSA_COUNTERS,
 
+	NL80211_ATTR_TDLS_INITIATOR,
+
+	NL80211_ATTR_USE_RRM,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3951,6 +3969,16 @@ enum nl80211_ap_sme_features {
  * @NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE: This driver supports dynamic
  *	channel bandwidth change (e.g., HT 20 <-> 40 MHz channel) during the
  *	lifetime of a BSS.
+ * @NL80211_FEATURE_DS_PARAM_SET_IE_IN_PROBES: This device adds a DS Parameter
+ *	Set IE to probe requests.
+ * @NL80211_FEATURE_WFA_TPC_IE_IN_PROBES: This device adds a WFA TPC Report IE
+ *	to probe requests.
+ * @NL80211_FEATURE_QUIET: This device, in client mode, supports Quiet Period
+ *	requests sent to it by an AP.
+ * @NL80211_FEATURE_TX_POWER_INSERTION: This device is capable of inserting the
+ *	current tx power value into the TPC Report IE in the spectrum
+ *	management TPC Report action frame, and in the Radio Measurement Link
+ *	Measurement Report action frame.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -3972,6 +4000,10 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_USERSPACE_MPM			= 1 << 16,
 	NL80211_FEATURE_ACTIVE_MONITOR			= 1 << 17,
 	NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE	= 1 << 18,
+	NL80211_FEATURE_DS_PARAM_SET_IE_IN_PROBES	= 1 << 19,
+	NL80211_FEATURE_WFA_TPC_IE_IN_PROBES		= 1 << 20,
+	NL80211_FEATURE_QUIET				= 1 << 21,
+	NL80211_FEATURE_TX_POWER_INSERTION		= 1 << 22,
 };
 
 /**
-- 
1.9.1

