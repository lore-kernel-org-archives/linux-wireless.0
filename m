Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:45753 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbbK0Jhv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2015 04:37:51 -0500
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NYG032WWW311N40@mailout1.samsung.com> for
 linux-wireless@vger.kernel.org; Fri, 27 Nov 2015 18:37:49 +0900 (KST)
From: Rahul Jain <rahul.jain@samsung.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Amit Khatri <amit.khatri@samsung.com>,
	Rahul Jain <rahul.jain@samsung.com>
Subject: [PATCH] iw:Fix memory leak if nla_put fails
Date: Fri, 27 Nov 2015 15:07:21 +0530
Message-id: <1448617041-20120-1-git-send-email-rahul.jain@samsung.com> (sfid-20151127_103816_538601_61168CF0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amit Khatri <amit.khatri@samsung.com>

Avoid memory leak because of nla_put_failure

Signed-off-by: Rahul Jain <rahul.jain@samsung.com>
Signed-off-by: Amit Khatri <amit.khatri@samsung.com>
---
 coalesce.c |  7 ++++++-
 wowlan.c   | 33 +++++++++++++++++++++++++++------
 2 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/coalesce.c b/coalesce.c
index 36dcaef..822da4f 100644
--- a/coalesce.c
+++ b/coalesce.c
@@ -124,7 +124,8 @@ static int handle_coalesce_enable(struct nl80211_state *state,
 					nla_nest_end(msg, nl_pat);
 					free(mask);
 					free(pat);
-
+					pat = NULL;
+					mask = NULL;
 					if (!next_pat)
 						break;
 					cur_pat = next_pat;
@@ -155,6 +156,10 @@ static int handle_coalesce_enable(struct nl80211_state *state,
 		err = 1;
 	goto close;
 nla_put_failure:
+	if (pat)
+		free(pat);
+	if (mask)
+		free(mask);
 	err = -ENOBUFS;
 close:
 	fclose(f);
diff --git a/wowlan.c b/wowlan.c
index e0cf316..c674e2c 100644
--- a/wowlan.c
+++ b/wowlan.c
@@ -89,7 +89,11 @@ static int wowlan_parse_tcp_file(struct nl_msg *msg, const char *fn)
 
 			if (!pkt)
 				goto close;
-			NLA_PUT(msg, NL80211_WOWLAN_TCP_DATA_PAYLOAD, len, pkt);
+			if (nla_put(msg, NL80211_WOWLAN_TCP_DATA_PAYLOAD, len,
+				pkt) < 0) {
+				free(pkt);
+				goto nla_put_failure;
+			}
 			free(pkt);
 		} else if (strncmp(buf, "data.interval=", 14) == 0) {
 			NLA_PUT_U32(msg, NL80211_WOWLAN_TCP_DATA_INTERVAL,
@@ -97,13 +101,24 @@ static int wowlan_parse_tcp_file(struct nl_msg *msg, const char *fn)
 		} else if (strncmp(buf, "wake=", 5) == 0) {
 			unsigned char *pat, *mask;
 			size_t patlen;
-
 			if (parse_hex_mask(buf + 5, &pat, &patlen, &mask))
 				goto close;
-			NLA_PUT(msg, NL80211_WOWLAN_TCP_WAKE_MASK,
-				DIV_ROUND_UP(patlen, 8), mask);
-			NLA_PUT(msg, NL80211_WOWLAN_TCP_WAKE_PAYLOAD,
-				patlen, pat);
+			if (nla_put(msg, NL80211_WOWLAN_TCP_WAKE_MASK,
+				DIV_ROUND_UP(patlen, 8), mask) < 0) {
+				free(mask);
+				free(pat);
+				mask = NULL;
+				pat = NULL;
+				goto nla_put_failure;
+			}
+			if (nla_put(msg, NL80211_WOWLAN_TCP_WAKE_PAYLOAD,
+				patlen, pat) < 0){
+				free(pat);
+				free(mask);
+				pat = NULL;
+				mask = NULL;
+				goto nla_put_failure;
+			}
 			free(mask);
 			free(pat);
 		} else if (strncmp(buf, "data.seq=", 9) == 0) {
@@ -300,6 +315,8 @@ static int handle_wowlan_enable(struct nl80211_state *state,
 			nla_nest_end(patterns, pattern);
 			free(mask);
 			free(pat);
+			pat = NULL;
+			mask = NULL;
 			break;
 		}
 		argv++;
@@ -313,6 +330,10 @@ static int handle_wowlan_enable(struct nl80211_state *state,
 	nla_nest_end(msg, wowlan);
 	err = 0;
  nla_put_failure:
+	if (pat)
+		free(pat);
+	if (mask)
+		free(mask);
 	nlmsg_free(patterns);
 	return err;
 }
-- 
1.9.1

