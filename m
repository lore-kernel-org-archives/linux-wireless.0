Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34551 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbbJUMLq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2015 08:11:46 -0400
Received: by padhk11 with SMTP id hk11so53690314pad.1
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2015 05:11:46 -0700 (PDT)
From: Ola Olsson <ola1olsson@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ola Olsson <ola1olsson@gmail.com>,
	Ola Olsson <ola.olsson@sonymobile.com>
Subject: [PATCH] iw: Print help text to "set bitrates" in case of no args
Date: Wed, 21 Oct 2015 14:11:38 +0200
Message-Id: <1445429499-22075-1-git-send-email-ola1olsson@gmail.com> (sfid-20151021_141149_517903_724075C9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ola Olsson <ola.olsson@sonymobile.com>
---
 bitrate.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/bitrate.c b/bitrate.c
index 4a026a4..974b49c 100644
--- a/bitrate.c
+++ b/bitrate.c
@@ -110,6 +110,9 @@ static int handle_bitrates(struct nl80211_state *state,
 		S_GI,
 	} parser_state = S_NONE;
 
+	if (argc == 0)
+		return 1;
+
 	for (i = 0; i < argc; i++) {
 		char *end;
 		double tmpd;
-- 
1.7.9.5

