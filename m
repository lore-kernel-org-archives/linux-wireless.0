Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:41880 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753515AbbCMU1e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 16:27:34 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Date: Fri, 13 Mar 2015 22:27:20 +0200
Message-Id: <1426278441-10304-4-git-send-email-luca@coelho.fi> (sfid-20150313_212741_668017_68FDBE48)
In-Reply-To: <1426278441-10304-1-git-send-email-luca@coelho.fi>
References: <1426278441-10304-1-git-send-email-luca@coelho.fi>
Subject: [PATCH iw 3/4] iw: add support for active scheduled scan
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Add options to explicitly use active or passive scans on schedule
scans (and net-detect).  If neither active nor passive parameters are
passed, the default is to do active scans with the wildcard SSID.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 iw.h   |  2 +-
 scan.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 59 insertions(+), 3 deletions(-)

diff --git a/iw.h b/iw.h
index 21e2229..d6b51cf 100644
--- a/iw.h
+++ b/iw.h
@@ -174,7 +174,7 @@ void parse_bitrate(struct nlattr *bitrate_attr, char *buf, int buflen);
 void iw_hexdump(const char *prefix, const __u8 *data, size_t len);
 
 #define SCHED_SCAN_OPTIONS "interval <in_msecs> [delay <in_secs> " \
-	"[freqs <freq>+] [matches [ssid <ssid>]+]]"
+	"[freqs <freq>+] [matches [ssid <ssid>]+]] [active [ssid <ssid>]+|passive] "
 int parse_sched_scan(struct nl_msg *msg, int *argc, char ***argv);
 
 DECLARE_SECTION(set);
diff --git a/scan.c b/scan.c
index e534fd4..7ff04ec 100644
--- a/scan.c
+++ b/scan.c
@@ -101,18 +101,20 @@ static int parse_random_mac_addr(struct nl_msg *msg, char *arg)
 
 int parse_sched_scan(struct nl_msg *msg, int *argc, char ***argv)
 {
-	struct nl_msg *matchset = NULL, *freqs = NULL;
+	struct nl_msg *matchset = NULL, *freqs = NULL, *ssids = NULL;
 	struct nlattr *match = NULL;
 	enum {
 		ND_TOPLEVEL,
 		ND_MATCH,
 		ND_FREQS,
+		ND_ACTIVE,
 	} parse_state = ND_TOPLEVEL;
 	int c  = *argc;
 	char *end, **v = *argv;
 	int err = 0, i = 0;
 	unsigned int freq, interval = 0, delay = 0;
-	bool have_matchset = false, have_freqs = false;
+	bool have_matchset = false, have_freqs = false, have_ssids = false;
+	bool have_active = false, have_passive = false;
 
 	matchset = nlmsg_alloc();
 	if (!matchset) {
@@ -126,6 +128,12 @@ int parse_sched_scan(struct nl_msg *msg, int *argc, char ***argv)
 		goto out;
 	}
 
+	ssids = nlmsg_alloc();
+	if (!ssids) {
+		err = -ENOMEM;
+		goto out;
+	}
+
 	while (c) {
 		switch (parse_state) {
 		case ND_TOPLEVEL:
@@ -184,6 +192,22 @@ int parse_sched_scan(struct nl_msg *msg, int *argc, char ***argv)
 
 				have_freqs = true;
 				i = 0;
+			} else if (!strcmp(v[0], "active")) {
+				parse_state = ND_ACTIVE;
+				if (have_active || have_passive) {
+					err = -EINVAL;
+					goto nla_put_failure;
+				}
+
+				have_active = true;
+				i = 0;
+			} else if (!strcmp(v[0], "passive")) {
+				if (have_active || have_passive) {
+					err = -EINVAL;
+					goto nla_put_failure;
+				}
+
+				have_passive = true;
 			} else {
 				/* this element is not for us, so
 				 * return to continue parsing.
@@ -249,9 +273,41 @@ int parse_sched_scan(struct nl_msg *msg, int *argc, char ***argv)
 				c--; v++;
 			}
 			break;
+		case ND_ACTIVE:
+			if (!strcmp(v[0], "ssid")) {
+				c--; v++;
+				if (c == 0) {
+					err = -EINVAL;
+					goto nla_put_failure;
+				}
+
+				NLA_PUT(ssids,
+					NL80211_SCHED_SCAN_MATCH_ATTR_SSID,
+					strlen(v[0]), v[0]);
+
+				have_ssids = true;
+				i++;
+				c--; v++;
+			} else {
+				/* other element that cannot be part
+				 * of a match indicates the end of the
+				 * active set. */
+				/* need at least one item in the set */
+				if (i == 0) {
+					err = -EINVAL;
+					goto nla_put_failure;
+				}
+
+				parse_state = ND_TOPLEVEL;
+			}
+			break;
 		}
 	}
 
+	if (!have_ssids)
+		NLA_PUT(ssids, 1, 0, "");
+	if (!have_passive)
+		nla_put_nested(msg, NL80211_ATTR_SCAN_SSIDS, ssids);
 	if (have_freqs)
 		nla_put_nested(msg, NL80211_ATTR_SCAN_FREQUENCIES, freqs);
 	if (have_matchset)
-- 
2.1.4

