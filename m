Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:17904 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbYKWSJz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Nov 2008 13:09:55 -0500
Received: by nf-out-0910.google.com with SMTP id d3so887064nfc.21
        for <linux-wireless@vger.kernel.org>; Sun, 23 Nov 2008 10:09:53 -0800 (PST)
Date: Sun, 23 Nov 2008 19:09:51 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?=
	<ariveira@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] Fix warning in info.c with gcc 4.3 (Ubuntu 8.10)
Message-ID: <20081123190951.686d099a@varda> (sfid-20081123_190959_217904_7A0AF3AB)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


 fix this warning i got with last pull

info.c: In function 'print_flag':
info.c:19: warning: format not a string literal and no format arguments
---
 info.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/info.c b/info.c
index 9b04719..a9c23a4 100644
--- a/info.c
+++ b/info.c
@@ -16,7 +16,7 @@ static void print_flag(const char *name, int *open)
                printf(" (");
        else
                printf(", ");
-       printf(name);
+       printf("%s\n",name);
        *open = 1;
 }
 
-- 
1.6.0.4.766.g6fc4a
