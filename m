Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:34339 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbbJLHgN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 03:36:13 -0400
Received: by lbbck17 with SMTP id ck17so13856156lbb.1
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2015 00:36:11 -0700 (PDT)
From: Ola Olsson <ola1olsson@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ola Olsson <ola1olsson@gmail.com>,
	Ola Olsson <ola.olsson@sonymobile.com>
Subject: [PATCH] ocb: use correct "MHz" instead of "MHZ"
Date: Mon, 12 Oct 2015 09:35:56 +0200
Message-Id: <1444635356-19975-1-git-send-email-ola1olsson@gmail.com> (sfid-20151012_093615_974296_D0669A96)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes the last typos of MHZ to MHz

Signed-off-by: Ola Olsson <ola.olsson@sonymobile.com>
---
 ocb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/ocb.c b/ocb.c
index fc48ecf..c60591c 100644
--- a/ocb.c
+++ b/ocb.c
@@ -18,9 +18,9 @@ static int join_ocb(struct nl80211_state *state,
 		const char *name;
 		unsigned int width;
 	} *chanmode_selected, chanmode[] = {
-		{ .name = "5MHZ",
+		{ .name = "5MHz",
 		  .width = NL80211_CHAN_WIDTH_5	},
-		{ .name = "10MHZ",
+		{ .name = "10MHz",
 		  .width = NL80211_CHAN_WIDTH_10 },
 	};
 
@@ -59,7 +59,7 @@ static int join_ocb(struct nl80211_state *state,
 nla_put_failure:
 	return -ENOBUFS;
 }
-COMMAND(ocb, join, "<freq in MHz> <5MHZ|10MHZ>",
+COMMAND(ocb, join, "<freq in MHz> <5MHz|10MHz>",
 	NL80211_CMD_JOIN_OCB, 0, CIB_NETDEV, join_ocb,
 	"Join the OCB mode network.");
 
-- 
1.7.9.5

