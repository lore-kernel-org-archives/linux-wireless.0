Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:41945 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbbCJXAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 19:00:15 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] iw:  Allow configuring empty legacy and ht ratesets.
Date: Tue, 10 Mar 2015 19:00:12 -0400
Message-Id: <1426028412-17438-1-git-send-email-greearb@candelatech.com> (sfid-20150311_000023_385232_99329E0A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This allows one to configure exactly one rate for drivers
such as ath10k that will only allow a single rate to be
configured.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 bitrate.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/bitrate.c b/bitrate.c
index 4df6185..21217bf 100644
--- a/bitrate.c
+++ b/bitrate.c
@@ -176,6 +176,8 @@ static int handle_bitrates(struct nl80211_state *state,
 			tmpd = strtod(argv[i], &end);
 			if (*end != '\0')
 				return 1;
+                        if (tmpd == -1) /* terminator, could be empty list */
+                           break;
 			if (tmpd < 1 || tmpd > 255 * 2)
 				return 1;
 			legacy[(*n_legacy)++] = tmpd * 2;
@@ -184,6 +186,8 @@ static int handle_bitrates(struct nl80211_state *state,
 			tmpl = strtol(argv[i], &end, 0);
 			if (*end != '\0')
 				return 1;
+                        if (tmpl == -1) /* terminator, could be empty list */
+                           break;
 			if (tmpl < 0 || tmpl > 255)
 				return 1;
 			mcs[(*n_mcs)++] = tmpl;
-- 
1.9.3

