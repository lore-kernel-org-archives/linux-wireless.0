Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:49192 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbbKXLqR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2015 06:46:17 -0500
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NYB00JQ0I13P0D0@mailout3.samsung.com> for
 linux-wireless@vger.kernel.org; Tue, 24 Nov 2015 20:46:15 +0900 (KST)
From: Rahul Jain <rahul.jain@samsung.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Amit Khatri <amit.khatri@samsung.com>,
	Rahul Jain <rahul.jain@samsung.com>
Subject: [PATCH] Fix memory leak if nla_put fails
Date: Tue, 24 Nov 2015 17:15:27 +0530
Message-id: <1448365527-14498-1-git-send-email-rahul.jain@samsung.com> (sfid-20151124_124627_493286_6E5F7541)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amit Khatri <amit.khatri@samsung.com>

Signed-off-by: Amit Khatri <amit.khatri@samsung.com>
Signed-off-by: Rahul Jain  <rahul.jain@samsung.com>

avoid memory leak because of nla_put_failure
---
 coalesce.c |  7 ++++++-
 wowlan.c   | 28 ++++++++++++++++++++++------
 2 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/coalesce.c b/coalesce.c
index 36dcaef..9b13ab3 100644
--- a/coalesce.c
+++ b/coalesce.c
@@ -124,7 +124,8 @@ static int handle_coalesce_enable(struct nl80211_state *state,
 					nla_nest_end(msg, nl_pat);
 					free(mask);
 					free(pat);
-
+					pat=NULL;
+					mask=NULL;
 					if (!next_pat)
 						break;
 					cur_pat = next_pat;
@@ -155,6 +156,10 @@ static int handle_coalesce_enable(struct nl80211_state *state,
 		err = 1;
 	goto close;
 nla_put_failure:
+	if(pat)
+		free(pat);
+	if(mask)
+		free(mask);
 	err = -ENOBUFS;
 close:
 	fclose(f);
diff --git a/wowlan.c b/wowlan.c
index c30eab7..2e1d43d 100644
--- a/wowlan.c
+++ b/wowlan.c
@@ -89,7 +89,10 @@ static int wowlan_parse_tcp_file(struct nl_msg *msg, const char *fn)
 
 			if (!pkt)
 				goto close;
-			NLA_PUT(msg, NL80211_WOWLAN_TCP_DATA_PAYLOAD, len, pkt);
+			if(nla_put(msg, NL80211_WOWLAN_TCP_DATA_PAYLOAD, len, pkt) < 0){
+				free(pkt);
+				goto nla_put_failure;
+			}
 			free(pkt);
 		} else if (strncmp(buf, "data.interval=", 14) == 0) {
 			NLA_PUT_U32(msg, NL80211_WOWLAN_TCP_DATA_INTERVAL,
@@ -97,13 +100,20 @@ static int wowlan_parse_tcp_file(struct nl_msg *msg, const char *fn)
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
+			if(nla_put(msg, NL80211_WOWLAN_TCP_WAKE_MASK,
+				DIV_ROUND_UP(patlen, 8), mask) < 0){
+				free(mask);
+				free(pat);
+				goto nla_put_failure;
+			}
+			if(nla_put(msg, NL80211_WOWLAN_TCP_WAKE_PAYLOAD,
+				patlen, pat) < 0){
+				free(pat);
+				free(mask);
+				goto nla_put_failure;
+			}
 			free(mask);
 			free(pat);
 		} else if (strncmp(buf, "data.seq=", 9) == 0) {
@@ -299,6 +309,8 @@ static int handle_wowlan_enable(struct nl80211_state *state,
 			nla_nest_end(patterns, pattern);
 			free(mask);
 			free(pat);
+			pat=NULL;
+			mask=NULL;
 			break;
 		}
 		argv++;
@@ -312,6 +324,10 @@ static int handle_wowlan_enable(struct nl80211_state *state,
 	nla_nest_end(msg, wowlan);
 	err = 0;
  nla_put_failure:
+	if(pat)
+		free(pat);
+	if(mask)
+		free(mask);
 	nlmsg_free(patterns);
 	return err;
 }
-- 
1.9.1

