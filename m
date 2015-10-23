Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34700 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbbJWWdf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 18:33:35 -0400
Received: by padhk11 with SMTP id hk11so129402047pad.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2015 15:33:34 -0700 (PDT)
From: Ola Olsson <ola1olsson@gmail.com>
To: johannes.berg@intel.com
Cc: linux-wireless@vger.kernel.org, Ola Olsson <ola1olsson@gmail.com>,
	Ola Olsson <ola.olsson@sonymobile.com>
Subject: [PATCH] iw: Fix memory leak if nla_put fails
Date: Sat, 24 Oct 2015 00:33:12 +0200
Message-Id: <1445639592-5559-1-git-send-email-ola1olsson@gmail.com> (sfid-20151024_003338_280380_D4EE8ED5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The NLA_PUT macro will automatically goto nla_put_failure if
the underlying nla_put fails. This will in turn leak our malloced
memory in both the scan and wowlan commands.
Fix that by not using the macro in the cases where we have
allocated heap mem.

Signed-off-by: Ola Olsson <ola.olsson@sonymobile.com>
---
 scan.c   |    5 ++++-
 wowlan.c |    8 ++++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/scan.c b/scan.c
index 8762784..06c4255 100644
--- a/scan.c
+++ b/scan.c
@@ -458,7 +458,10 @@ static int handle_scan(struct nl80211_state *state,
 			memcpy(&tmpies[ies_len], meshid, meshid_len);
 			free(meshid);
 		}
-		NLA_PUT(msg, NL80211_ATTR_IE, ies_len + meshid_len, tmpies);
+		if (nla_put(msg, NL80211_ATTR_IE, ies_len + meshid_len, tmpies) < 0) {
+			free(tmpies);
+			goto nla_put_failure;
+		}
 		free(tmpies);
 	}
 
diff --git a/wowlan.c b/wowlan.c
index e1d3750..c30eab7 100644
--- a/wowlan.c
+++ b/wowlan.c
@@ -159,8 +159,12 @@ static int wowlan_parse_tcp_file(struct nl_msg *msg, const char *fn)
 			tok->offset = atoi(offs);
 			memcpy(tok->token_stream, stream, stream_len);
 
-			NLA_PUT(msg, NL80211_WOWLAN_TCP_DATA_PAYLOAD_TOKEN,
-				sizeof(*tok) + stream_len, tok);
+			if (nla_put(msg, NL80211_WOWLAN_TCP_DATA_PAYLOAD_TOKEN,
+				sizeof(*tok) + stream_len, tok) < 0) {
+				free(stream);
+				free(tok);
+				goto nla_put_failure;
+			}
 			free(stream);
 			free(tok);
 		} else {
-- 
1.7.9.5

