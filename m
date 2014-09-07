Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:62744 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbaIGRc1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Sep 2014 13:32:27 -0400
Received: by mail-wi0-f170.google.com with SMTP id cc10so1634157wib.3
        for <linux-wireless@vger.kernel.org>; Sun, 07 Sep 2014 10:32:25 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCHv3 2/2] iw: add auto parameter to set distance command
Date: Sun,  7 Sep 2014 19:32:20 +0200
Message-Id: <1410111140-4340-3-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140907_193236_183207_03DFA642)
In-Reply-To: <1410111140-4340-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1410111140-4340-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add auto parameter to set distance command in order to enable ACK timeout
estimation algorithm (dynack). Dynack is automatically disabled setting valid
value for coverage class. Currently dynack is supported just by ath9k

This patch is based on "configure dynack through mac80211/cfg80211 stack"
patchset sent on linux-wireless

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 info.c    |  2 ++
 nl80211.h | 12 ++++++++++++
 phy.c     | 43 +++++++++++++++++++++++++------------------
 3 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/info.c b/info.c
index 97ff39d..b72801b 100644
--- a/info.c
+++ b/info.c
@@ -551,6 +551,8 @@ broken_combination:
 			printf("\tDevice supports scan flush.\n");
 		if (features & NL80211_FEATURE_AP_SCAN)
 			printf("\tDevice supports AP scan.\n");
+		if (features & NL80211_FEATURE_ACKTO_ESTIMATION)
+			printf("\tDevice supports ACK timeout estimation.\n");
 	}
 
 	if (tb_msg[NL80211_ATTR_TDLS_SUPPORT])
diff --git a/nl80211.h b/nl80211.h
index 8951c31..bad7a22 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -1605,6 +1605,12 @@ enum nl80211_commands {
  *	association request. In addition, it must also set the RRM capability
  *	flag in the association request's Capability Info field.
  *
+ * @NL80211_ATTR_WIPHY_DYN_ACK: flag attribute used to enable ACK timeout
+ *	estimation algorithm (dynack). In order to activate dynack
+ *	%NL80211_FEATURE_ACKTO_ESTIMATION feature flag must be set by lower
+ *	drivers to indicate dynack capability. Dynack is automatically disabled
+ *	setting valid value for coverage class.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1949,6 +1955,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_USE_RRM,
 
+	NL80211_ATTR_WIPHY_DYN_ACK,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3979,6 +3987,9 @@ enum nl80211_ap_sme_features {
  *	current tx power value into the TPC Report IE in the spectrum
  *	management TPC Report action frame, and in the Radio Measurement Link
  *	Measurement Report action frame.
+ * @NL80211_FEATURE_ACKTO_ESTIMATION: This driver supports dynamic ACK timeout
+ *	estimation (dynack). %NL80211_ATTR_WIPHY_DYN_ACK flag attribute is used
+ *	to enable dynack.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -4004,6 +4015,7 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_WFA_TPC_IE_IN_PROBES		= 1 << 20,
 	NL80211_FEATURE_QUIET				= 1 << 21,
 	NL80211_FEATURE_TX_POWER_INSERTION		= 1 << 22,
+	NL80211_FEATURE_ACKTO_ESTIMATION		= 1 << 23,
 };
 
 /**
diff --git a/phy.c b/phy.c
index 517d203..aab462d 100644
--- a/phy.c
+++ b/phy.c
@@ -362,39 +362,46 @@ static int handle_distance(struct nl80211_state *state,
 			int argc, char **argv,
 			enum id_input id)
 {
-	char *end;
-	unsigned int distance, coverage;
-
 	if (argc != 1)
 		return 1;
 
 	if (!*argv[0])
 		return 1;
 
-	distance = strtoul(argv[0], &end, 10);
+	if (strcmp("auto", argv[0]) == 0) {
+		NLA_PUT_FLAG(msg, NL80211_ATTR_WIPHY_DYN_ACK);
+	} else {
+		char *end;
+		unsigned int distance, coverage;
 
-	if (*end)
-		return 1;
+		distance = strtoul(argv[0], &end, 10);
 
-	/*
-	 * Divide double the distance by the speed of light in m/usec (300) to
-	 * get round-trip time in microseconds and then divide the result by
-	 * three to get coverage class as specified in IEEE 802.11-2007 table
-	 * 7-27. Values are rounded upwards.
-	 */
-	coverage = (distance + 449) / 450;
-	if (coverage > 255)
-		return 1;
+		if (*end)
+			return 1;
 
-	NLA_PUT_U8(msg, NL80211_ATTR_WIPHY_COVERAGE_CLASS, coverage);
+		/*
+		 * Divide double the distance by the speed of light
+		 * in m/usec (300) to get round-trip time in microseconds
+		 * and then divide the result by three to get coverage class
+		 * as specified in IEEE 802.11-2007 table 7-27.
+		 * Values are rounded upwards.
+		 */
+		coverage = (distance + 449) / 450;
+		if (coverage > 255)
+			return 1;
+
+		NLA_PUT_U8(msg, NL80211_ATTR_WIPHY_COVERAGE_CLASS, coverage);
+	}
 
 	return 0;
  nla_put_failure:
 	return -ENOBUFS;
 }
-COMMAND(set, distance, "<distance>",
+COMMAND(set, distance, "<auto|distance>",
 	NL80211_CMD_SET_WIPHY, 0, CIB_PHY, handle_distance,
-	"Set appropriate coverage class for given link distance in meters.\n"
+	"Enable ACK timeout estimation algorithm (dynack) or set appropriate\n"
+	"coverage class for given link distance in meters.\n"
+	"To disable dynack set valid value for coverage class.\n"
 	"Valid values: 0 - 114750");
 
 static int handle_txpower(struct nl80211_state *state,
-- 
1.9.1

