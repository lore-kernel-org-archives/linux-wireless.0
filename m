Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:53941 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab3EaCK7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:10:59 -0400
Received: by mail-pb0-f48.google.com with SMTP id md4so1378975pbc.21
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:10:58 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 17/40] crda: use gcry_mpi_release() when using gcry_mpi_scan()
Date: Thu, 30 May 2013 19:09:06 -0700
Message-Id: <1369966169-23640-18-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_042937_404907_2CD6DB18)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Its not well documented you should do this but I found out
through valgrind. This fixes the last 4 valgrind issues
I was seeing with regdbdump.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 reglib.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/reglib.c b/reglib.c
index 3d13782..72ea78f 100644
--- a/reglib.c
+++ b/reglib.c
@@ -158,10 +158,14 @@ int crda_verify_db_signature(uint8_t *db, int dblen, int siglen)
 				    "(public-key (rsa (n %m) (e %m)))",
 				    mpi_n, mpi_e)) {
 			fprintf(stderr, "Failed to build RSA S-expression.\n");
+			gcry_mpi_release(mpi_e);
+			gcry_mpi_release(mpi_n);
 			goto out;
 		}
 
 		ok = gcry_pk_verify(signature, data, rsa) == 0;
+		gcry_mpi_release(mpi_e);
+		gcry_mpi_release(mpi_n);
 		gcry_sexp_release(rsa);
 	}
 
-- 
1.7.10.4

