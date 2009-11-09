Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:61840 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455AbZKIMxE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 07:53:04 -0500
Received: by bwz27 with SMTP id 27so3407458bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 04:53:09 -0800 (PST)
From: Rui Paulo <rpaulo@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Rui Paulo <rpaulo@gmail.com>
Subject: iw [PATCH] print a header before printing the list of mesh paths
Date: Mon,  9 Nov 2009 12:53:06 +0000
Message-Id: <1257771187-7894-1-git-send-email-rpaulo@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rui Paulo <rpaulo@gmail.com>
---
 mpath.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mpath.c b/mpath.c
index e848481..eb5ad6a 100644
--- a/mpath.c
+++ b/mpath.c
@@ -184,6 +184,8 @@ static int handle_mpath_dump(struct nl80211_state *state,
 			     struct nl_msg *msg,
 			     int argc, char **argv)
 {
+	printf("DEST ADDR         NEXT HOP          IFACE\tDSN\tMETRIC\tQLEN\t"
+	       "EXPTIME\t\tDTIM\tDRET\tFLAGS\n");
 	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM, print_mpath_handler, NULL);
 	return 0;
 }
-- 
1.5.6.5

