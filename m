Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:44733 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753924AbbCQOMM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 10:12:12 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Mar 2015 16:11:50 +0200
Message-Id: <1426601510-8251-5-git-send-email-luca@coelho.fi> (sfid-20150317_151219_480805_4B22BBDE)
In-Reply-To: <1426601510-8251-1-git-send-email-luca@coelho.fi>
References: <1426601510-8251-1-git-send-email-luca@coelho.fi>
Subject: [PATCH iw v2 4/4] iw: add randomise option for sched_scan
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Like with normal scans, we can randomise the MAC address sent out in
active scheduled scans.  Add the randomise option to sched_scan (and
net-detect) parsing code.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 iw.h   |  2 +-
 scan.c | 11 +++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/iw.h b/iw.h
index fc20838..78195ea 100644
--- a/iw.h
+++ b/iw.h
@@ -174,7 +174,7 @@ void parse_bitrate(struct nlattr *bitrate_attr, char *buf, int buflen);
 void iw_hexdump(const char *prefix, const __u8 *data, size_t len);
 
 #define SCHED_SCAN_OPTIONS "interval <in_msecs> [delay <in_secs>] " \
-	"[freqs <freq>+] [matches [ssid <ssid>]+]] [active [ssid <ssid>]+|passive] "
+	"[freqs <freq>+] [matches [ssid <ssid>]+]] [active [ssid <ssid>]+|passive] [randomise[=<addr>/<mask>]]"
 int parse_sched_scan(struct nl_msg *msg, int *argc, char ***argv);
 
 DECLARE_SECTION(set);
diff --git a/scan.c b/scan.c
index 7ff04ec..e959c1b 100644
--- a/scan.c
+++ b/scan.c
@@ -115,6 +115,7 @@ int parse_sched_scan(struct nl_msg *msg, int *argc, char ***argv)
 	unsigned int freq, interval = 0, delay = 0;
 	bool have_matchset = false, have_freqs = false, have_ssids = false;
 	bool have_active = false, have_passive = false;
+	uint32_t flags = 0;
 
 	matchset = nlmsg_alloc();
 	if (!matchset) {
@@ -208,6 +209,14 @@ int parse_sched_scan(struct nl_msg *msg, int *argc, char ***argv)
 				}
 
 				have_passive = true;
+			} else if (!strncmp(v[0], "randomise", 9) ||
+				   !strncmp(v[0], "randomize", 9)) {
+				flags |= NL80211_SCAN_FLAG_RANDOM_ADDR;
+				if (c > 0) {
+					err = parse_random_mac_addr(msg, v[0]);
+					if (err)
+						goto nla_put_failure;
+				}
 			} else {
 				/* this element is not for us, so
 				 * return to continue parsing.
@@ -312,6 +321,8 @@ int parse_sched_scan(struct nl_msg *msg, int *argc, char ***argv)
 		nla_put_nested(msg, NL80211_ATTR_SCAN_FREQUENCIES, freqs);
 	if (have_matchset)
 		nla_put_nested(msg, NL80211_ATTR_SCHED_SCAN_MATCH, matchset);
+	if (flags)
+		NLA_PUT_U32(msg, NL80211_ATTR_SCAN_FLAGS, flags);
 
 nla_put_failure:
 	if (match)
-- 
2.1.4

