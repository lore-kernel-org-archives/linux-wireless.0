Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60802 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759590Ab1D0TBc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 15:01:32 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat: handle fail of vmalloc()
Date: Wed, 27 Apr 2011 21:01:22 +0200
Message-Id: <1303930882-8529-1-git-send-email-hauke@hauke-m.de> (sfid-20110427_210135_502263_AC7F014C)
In-Reply-To: <1303927685.3542.6.camel@jlt3.sipsolutions.net>
References: <1303927685.3542.6.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only memset the memory if we get a valid pointer.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.37.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/compat/compat-2.6.37.c b/compat/compat-2.6.37.c
index c49efea..8698e1d 100644
--- a/compat/compat-2.6.37.c
+++ b/compat/compat-2.6.37.c
@@ -348,7 +348,8 @@ void *vzalloc(unsigned long size)
 {
 	void *buf;
 	buf = vmalloc(size);
-	memset(buf, 0, size);
+	if (buf)
+		memset(buf, 0, size);
 	return buf;
 }
 EXPORT_SYMBOL(vzalloc);
-- 
1.7.1

