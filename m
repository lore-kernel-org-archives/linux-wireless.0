Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:36606 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbbJLUhY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 16:37:24 -0400
Received: by wicgb1 with SMTP id gb1so163157716wic.1
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2015 13:37:22 -0700 (PDT)
From: Ola Olsson <ola1olsson@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ola Olsson <ola1olsson@gmail.com>,
	Ola Olsson <ola.olsson@sonymobile.com>
Subject: [PATCH] iw: Fixes help text for event
Date: Mon, 12 Oct 2015 22:37:08 +0200
Message-Id: <1444682228-25855-1-git-send-email-ola1olsson@gmail.com> (sfid-20151012_223733_173635_95B2C474)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to source, the -t and -r options are
mutually exclusive. This commit fixes the help
text accordingly.

Signed-off-by: Ola Olsson <ola.olsson@sonymobile.com>
---
 event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/event.c b/event.c
index 5d0bfde..a342dc4 100644
--- a/event.c
+++ b/event.c
@@ -775,7 +775,7 @@ static int print_events(struct nl80211_state *state,
 
 	return __do_listen_events(state, 0, NULL, &args);
 }
-TOPLEVEL(event, "[-t] [-r] [-f]", 0, 0, CIB_NONE, print_events,
+TOPLEVEL(event, "[-t|-r] [-f]", 0, 0, CIB_NONE, print_events,
 	"Monitor events from the kernel.\n"
 	"-t - print timestamp\n"
 	"-r - print relative timstamp\n"
-- 
1.7.9.5

