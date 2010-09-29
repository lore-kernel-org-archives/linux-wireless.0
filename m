Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39242 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab0I2Aas (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 20:30:48 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] iw:  Flush stdout when printing events.
Date: Tue, 28 Sep 2010 17:30:44 -0700
Message-Id: <1285720244-26149-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This lets one pipe output of iw event properly.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 129db1a... 60bafc5... M	event.c
 event.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/event.c b/event.c
index 129db1a..60bafc5 100644
--- a/event.c
+++ b/event.c
@@ -130,12 +130,16 @@ static void parse_cqm_event(struct nlattr *tb)
 
 static int print_event(struct nl_msg *msg, void *arg)
 {
-#define PARSE_BEACON_CHAN(_attr, _chan) do { \
-	r = parse_beacon_hint_chan(tb[_attr], \
-				   &_chan); \
-	if (r) \
-		return NL_SKIP; \
-} while (0)
+
+#define PARSE_BEACON_CHAN(_attr, _chan) do {		\
+		r = parse_beacon_hint_chan(tb[_attr],	\
+					   &_chan);	\
+		if (r) {				\
+			fflush(stdout);			\
+			return NL_SKIP;			\
+		}					\
+	} while (0)
+
 	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
 	struct nlattr *tb[NL80211_ATTR_MAX + 1], *nst;
 	struct print_event_args *args = arg;
@@ -349,6 +353,7 @@ static int print_event(struct nl_msg *msg, void *arg)
 		break;
 	}
 
+	fflush(stdout);
 	return NL_SKIP;
 #undef PARSE_BEACON_CHAN
 }
@@ -369,8 +374,8 @@ static int wait_event(struct nl_msg *msg, void *arg)
 	for (i = 0; i < wait->n_cmds; i++) {
 		if (gnlh->cmd == wait->cmds[i]) {
 			wait->cmd = gnlh->cmd;
-		if (wait->pargs)
-			print_event(msg, wait->pargs);
+			if (wait->pargs)
+				print_event(msg, wait->pargs);
 		}
 	}
 
-- 
1.5.4.3

