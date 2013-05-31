Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62910 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab3EaCKi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:10:38 -0400
Received: by mail-pb0-f46.google.com with SMTP id rq2so1384357pbb.33
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:10:37 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 12/40] crda: explicitly munmap() on reglib_get_rd_alpha2()
Date: Thu, 30 May 2013 19:09:01 -0700
Message-Id: <1369966169-23640-13-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_041040_554772_F8CBA3BA)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Although the region mapped by mmap() is also automatically
unmapped when the process is terminated lets just munmap()
it ourselves to be more tidy.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 reglib.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/reglib.c b/reglib.c
index 867e8cf..bb6f23f 100644
--- a/reglib.c
+++ b/reglib.c
@@ -357,6 +357,7 @@ reglib_get_rd_alpha2(const char *alpha2, const char *file)
 
 out:
 	close(fd);
+	munmap(db, dblen);
 	return rd;
 }
 
-- 
1.7.10.4

