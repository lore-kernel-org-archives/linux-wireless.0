Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:33306 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbbLLRuf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Dec 2015 12:50:35 -0500
Received: by mail-wm0-f53.google.com with SMTP id l68so11673274wml.0
        for <linux-wireless@vger.kernel.org>; Sat, 12 Dec 2015 09:50:35 -0800 (PST)
From: Ola Olsson <ola1olsson@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ola Olsson <ola1olsson@gmail.com>,
	Ola Olsson <ola.olsson@sonymobile.com>
Subject: [PATCH] ocb: remove unnecessary variable increments
Date: Sat, 12 Dec 2015 18:50:20 +0100
Message-Id: <1449942620-29997-1-git-send-email-ola1olsson@gmail.com> (sfid-20151212_185038_984953_C69E62B0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The arg[c|v] variables are incremented even if
they are not used afterwards. Fix that.

Signed-off-by: Ola Olsson <ola.olsson@sonymobile.com>
---
 ocb.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/ocb.c b/ocb.c
index 767eb82..b43fba8 100644
--- a/ocb.c
+++ b/ocb.c
@@ -33,7 +33,6 @@ static int join_ocb(struct nl80211_state *state,
 
 	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FREQ, freq);
 	argv++;
-	argc--;
 
 	/* channel width */
 	for (i = 0; i < ARRAY_SIZE(chanmode); i++) {
@@ -47,8 +46,6 @@ static int join_ocb(struct nl80211_state *state,
 			    chanmode_selected->width);
 		NLA_PUT_U32(msg, NL80211_ATTR_CENTER_FREQ1, freq);
 
-		argv++;
-		argc--;
 	} else {
 		return 1;
 	}
-- 
1.7.9.5

