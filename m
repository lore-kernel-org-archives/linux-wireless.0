Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.102.11.253]:35366 "EHLO
	parez.praha12.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933979AbZLFR30 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2009 12:29:26 -0500
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
To: linville@tuxdriver.com
Subject: [PATCH] iw: Add support for NL80211_ATTR_WIPHY_COVERAGE_CLASS
Date: Sun, 6 Dec 2009 18:29:32 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	ath5k-devel@lists.ath5k.org
References: <200912061820.26320.8an@praha12.net>
In-Reply-To: <200912061820.26320.8an@praha12.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200912061829.32633.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New nl80211 attribute NL80211_ATTR_WIPHY_COVERAGE_CLASS allows setting
IEEE 802.11 coverage class, which is then used by drivers to calculate
slot time and ACK timeout for long distance links.

Two iw parameters are added: 'coverage' sets the coverage class
directly, while 'distance' is more user-friendly, as it allows to set
just the link distance and let iw do the necessary calculation itself.

Signed-off-by: Lukas Turek <8an@praha12.net>
---
 info.c    |    7 +++++++
 nl80211.h |   15 +++++++++++++++
 phy.c     |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 80 insertions(+), 0 deletions(-)

diff --git a/info.c b/info.c
index ddff78b..3c69afc 100644
--- a/info.c
+++ b/info.c
@@ -264,6 +264,13 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
 			printf("\tRTS threshold: %d\n", rts);
 	}
 
+	if (tb_msg[NL80211_ATTR_WIPHY_COVERAGE_CLASS]) {
+		unsigned int coverage;
+
+		coverage = nla_get_u8(tb_msg[NL80211_ATTR_WIPHY_COVERAGE_CLASS]);
+		printf("\tCoverage class: %d (up to %dm)\n", coverage, 900 * coverage);
+	}
+
 	if (!tb_msg[NL80211_ATTR_SUPPORTED_IFTYPES])
 		goto commands;
 
diff --git a/nl80211.h b/nl80211.h
index 45db17f..e241ed1 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -349,6 +349,10 @@ enum nl80211_commands {
 	NL80211_CMD_GET_SURVEY,
 	NL80211_CMD_NEW_SURVEY_RESULTS,
 
+	NL80211_CMD_SET_PMKSA,
+	NL80211_CMD_DEL_PMKSA,
+	NL80211_CMD_FLUSH_PMKSA,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -398,6 +402,8 @@ enum nl80211_commands {
  * @NL80211_ATTR_WIPHY_RTS_THRESHOLD: RTS threshold (TX frames with length
  *	larger than or equal to this use RTS/CTS handshake); allowed range:
  *	0..65536, disable with (u32)-1; dot11RTSThreshold; u32
+ * @NL80211_ATTR_WIPHY_COVERAGE_CLASS: Coverage Class as defined by IEEE 802.11
+ *	section 7.3.2.9; dot11CoverageClass; u8
  *
  * @NL80211_ATTR_IFINDEX: network interface index of the device to operate on
  * @NL80211_ATTR_IFNAME: network interface name
@@ -598,6 +604,10 @@ enum nl80211_commands {
  *      the survey response for %NL80211_CMD_GET_SURVEY, nested attribute
  *      containing info as possible, see &enum survey_info.
  *
+ * @NL80211_ATTR_PMKID: PMK material for PMKSA caching.
+ * @NL80211_ATTR_MAX_NUM_PMKIDS: maximum number of PMKIDs a firmware can
+ *	cache, a wiphy attribute.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -732,6 +742,11 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SURVEY_INFO,
 
+	NL80211_ATTR_PMKID,
+	NL80211_ATTR_MAX_NUM_PMKIDS,
+
+	NL80211_ATTR_WIPHY_COVERAGE_CLASS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/phy.c b/phy.c
index 8dd01aa..eb95bd5 100644
--- a/phy.c
+++ b/phy.c
@@ -164,3 +164,61 @@ static int handle_netns(struct nl80211_state *state,
 COMMAND(set, netns, "<pid>",
 	NL80211_CMD_SET_WIPHY_NETNS, 0, CIB_PHY, handle_netns,
 	"Put this wireless device into a different network namespace");
+
+static int handle_coverage(struct nl80211_state *state,
+			struct nl_cb *cb,
+			struct nl_msg *msg,
+			int argc, char **argv)
+{
+	unsigned int coverage;
+
+	if (argc != 1)
+		return 1;
+
+	coverage = strtoul(argv[0], NULL, 10);
+	if (coverage > 255)
+		return 1;
+	
+	NLA_PUT_U8(msg, NL80211_ATTR_WIPHY_COVERAGE_CLASS, coverage);
+
+	return 0;
+ nla_put_failure:
+	return -ENOBUFS;
+}
+COMMAND(set, coverage, "<coverage class>",
+	NL80211_CMD_SET_WIPHY, 0, CIB_PHY, handle_coverage,
+	"Set coverage class (1 for every 3 usec of air propagation time).\n"
+	"Valid values: 0 - 255.");
+
+static int handle_distance(struct nl80211_state *state,
+			struct nl_cb *cb,
+			struct nl_msg *msg,
+			int argc, char **argv)
+{
+	unsigned int distance, coverage;
+
+	if (argc != 1)
+		return 1;
+
+	distance = strtoul(argv[0], NULL, 10);
+	
+	/*
+	 * Divide distance by speed of light in m/usec (300) to get air
+	 * propagation time and then by three to get coverage class as
+	 * specified in IEEE 802.11-2007 table 7-27 and round the result
+	 * upwards.
+	 */
+	coverage = (distance + 899) / 900;
+	if (coverage > 255)
+		return 1;
+	
+	NLA_PUT_U8(msg, NL80211_ATTR_WIPHY_COVERAGE_CLASS, coverage);
+
+	return 0;
+ nla_put_failure:
+	return -ENOBUFS;
+}
+COMMAND(set, distance, "<distance>",
+	NL80211_CMD_SET_WIPHY, 0, CIB_PHY, handle_distance,
+	"Set appropriate coverage class for given link distance in meters.\n"
+	"Valid values: 0 - 229500");
-- 
1.6.4.4
