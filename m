Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:59862 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbaGXKjy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 06:39:54 -0400
Received: by mail-wi0-f170.google.com with SMTP id f8so8913534wiw.1
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2014 03:39:53 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Philippe Duchein <wireless-dev@duchein.net>
Subject: [PATCHv2 2/2] iw: add auto parameter to set distance command
Date: Thu, 24 Jul 2014 12:39:48 +0200
Message-Id: <1406198388-5040-3-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140724_123959_922206_23DD3958)
In-Reply-To: <1406198388-5040-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1406198388-5040-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add auto parameter to set distance command in order to enable ack timeout
estimation algorithm (dynack). Currently dynack is supported just by ath9k

This patch is based on "configure ack timeout estimation algorithm through
mac80211 stack" patchset sent on linux-wireless

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 info.c    | 16 +++++++++++-----
 nl80211.h |  5 +++++
 phy.c     | 44 +++++++++++++++++++++++++-------------------
 3 files changed, 41 insertions(+), 24 deletions(-)

diff --git a/info.c b/info.c
index 97ff39d..0806666 100644
--- a/info.c
+++ b/info.c
@@ -266,11 +266,17 @@ next:
 	}
 
 	if (tb_msg[NL80211_ATTR_WIPHY_COVERAGE_CLASS]) {
-		unsigned char coverage;
-
-		coverage = nla_get_u8(tb_msg[NL80211_ATTR_WIPHY_COVERAGE_CLASS]);
-		/* See handle_distance() for an explanation where the '450' comes from */
-		printf("\tCoverage class: %d (up to %dm)\n", coverage, 450 * coverage);
+		signed short coverage;
+
+		coverage = nla_get_u16(tb_msg[NL80211_ATTR_WIPHY_COVERAGE_CLASS]);
+		if (coverage >= 0) {
+			/* See handle_distance() for an explanation
+			 * where the '450' comes from */
+			printf("\tCoverage class: %d (up to %dm)\n",
+			       coverage, 450 * coverage);
+		} else {
+			printf("\tCoverage class: auto\n");
+		}
 	}
 
 	if (tb_msg[NL80211_ATTR_CIPHER_SUITES]) {
diff --git a/nl80211.h b/nl80211.h
index f1db15b..7cc5ecd 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -1594,6 +1594,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_TDLS_INITIATOR: flag attribute indicating the current end is
  *	the TDLS link initiator.
  *
+ * @NL80211_ATTR_WIPHY_DYNACK: whether dynamic ack timeout estimation algorithm
+ *	is enabled
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1936,6 +1939,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_TDLS_INITIATOR,
 
+	NL80211_ATTR_WIPHY_DYNACK,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/phy.c b/phy.c
index 517d203..068f9fc 100644
--- a/phy.c
+++ b/phy.c
@@ -362,40 +362,46 @@ static int handle_distance(struct nl80211_state *state,
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
+		NLA_PUT_FLAG(msg, NL80211_ATTR_WIPHY_DYNACK);
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
-	"Valid values: 0 - 114750");
+	"Enable ack timeout estimation algorithm or set appropriate\n"
+	"coverage class for given link distance in meters.\n"
+	"Valid values for coverage class: 0 - 114750");
 
 static int handle_txpower(struct nl80211_state *state,
 			  struct nl_cb *cb,
-- 
1.9.1

