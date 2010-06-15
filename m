Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:62873 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab0FOJqz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 05:46:55 -0400
From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: [PATCH v2] iw: Configure basic rates when joining ibss network
Date: Tue, 15 Jun 2010 12:46:09 +0300
Message-Id: <1276595169-3669-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds option to configure basic rates when joining ibss network.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
---
 ibss.c |   35 ++++++++++++++++++++++++++++++++++-
 1 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/ibss.c b/ibss.c
index 4715ac8..9260a9f 100644
--- a/ibss.c
+++ b/ibss.c
@@ -18,6 +18,11 @@ static int join_ibss(struct nl80211_state *state,
 {
 	char *end;
 	unsigned char abssid[6];
+	unsigned char rates[NL80211_MAX_SUPP_RATES];
+	int n_rates = 0;
+	char *value = NULL, *sptr = NULL;
+	float rate;
+
 
 	if (argc < 2)
 		return 1;
@@ -41,6 +46,32 @@ static int join_ibss(struct nl80211_state *state,
 		argc--;
 	}
 
+	/* basic rates */
+	if (argc > 1 && strcmp(argv[0], "basic-rates") == 0) {
+		argv++;
+		argc--;
+
+		value = strtok_r(argv[0], ",", &sptr);
+
+		while (value && n_rates < NL80211_MAX_SUPP_RATES) {
+			rate = strtod(value, &end);
+			rates[n_rates] = rate * 2;
+
+			/* filter out suspicious values  */
+			if (*end != '\0' || !rates[n_rates] ||
+			    rate*2 != rates[n_rates])
+				return 1;
+
+			n_rates++;
+			value = strtok_r(NULL, ",", &sptr);
+		}
+
+		NLA_PUT(msg, NL80211_ATTR_BSS_BASIC_RATES, n_rates, rates);
+
+		argv++;
+		argc--;
+	}
+
 	if (argc) {
 		if (mac_addr_a2n(abssid, argv[0]) == 0) {
 			NLA_PUT(msg, NL80211_ATTR_MAC, 6, abssid);
@@ -73,7 +104,9 @@ static int leave_ibss(struct nl80211_state *state,
 COMMAND(ibss, leave, NULL,
 	NL80211_CMD_LEAVE_IBSS, 0, CIB_NETDEV, leave_ibss,
 	"Leave the current IBSS cell.");
-COMMAND(ibss, join, "<SSID> <freq in MHz> [fixed-freq] [<fixed bssid>] [key d:0:abcde]",
+COMMAND(ibss, join,
+	"<SSID> <freq in MHz> [fixed-freq] [<fixed bssid>] "
+	"[basic-rates <rate in Mbps,rate2,...>] [key d:0:abcde]",
 	NL80211_CMD_JOIN_IBSS, 0, CIB_NETDEV, join_ibss,
 	"Join the IBSS cell with the given SSID, if it doesn't exist create\n"
 	"it on the given frequency. When fixed frequency is requested, don't\n"
-- 
1.5.6.3

