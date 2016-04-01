Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33796 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbcDAIbX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2016 04:31:23 -0400
Received: by mail-pf0-f194.google.com with SMTP id n5so13751574pfn.1
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2016 01:31:18 -0700 (PDT)
From: Sunil Shahu <shshahu@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] Prevent unnecessary iteration in __handle_cmd
Date: Fri,  1 Apr 2016 14:01:01 +0530
Message-Id: <1459499461-4422-1-git-send-email-shshahu@gmail.com> (sfid-20160401_103128_799298_5A639F36)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Break the loop after matching sectcmd is found. Remove redundant
variable copying.

Signed-off-by: Sunil Shahu <shshahu@gmail.com>
---
 iw.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/iw.c b/iw.c
index 0f511d9..73ae347 100644
--- a/iw.c
+++ b/iw.c
@@ -376,11 +376,9 @@ static int __handle_cmd(struct nl80211_state *state, enum id_input idby,
 		if (match && sectcmd->idby != command_idby)
 			continue;
 		if (strcmp(sectcmd->name, section) == 0)
-			match = sectcmd;
+			break;
 	}
 
-	sectcmd = match;
-	match = NULL;
 	if (!sectcmd)
 		return 1;
 
-- 
1.9.1

