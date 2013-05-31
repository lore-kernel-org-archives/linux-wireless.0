Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:65378 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab3EaCKy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:10:54 -0400
Received: by mail-pb0-f51.google.com with SMTP id jt11so1381749pbb.38
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:10:54 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 16/40] crda: explicitly use close() and munmap() on reglib_get_rd_alpha2()
Date: Thu, 30 May 2013 19:09:05 -0700
Message-Id: <1369966169-23640-17-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_041056_920054_327B39BB)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 reglib.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/reglib.c b/reglib.c
index 634525b..3d13782 100644
--- a/reglib.c
+++ b/reglib.c
@@ -262,33 +262,37 @@ reglib_get_rd_idx(unsigned int idx, const char *file)
 	if (fd < 0)
 		return NULL;
 
-	if (fstat(fd, &stat))
+	if (fstat(fd, &stat)) {
+		close(fd);
 		return NULL;
+	}
 
 	dblen = stat.st_size;
 
 	db = mmap(NULL, dblen, PROT_READ, MAP_PRIVATE, fd, 0);
-	if (db == MAP_FAILED)
+	if (db == MAP_FAILED) {
+		close(fd);
 		return NULL;
+	}
 
 	header = crda_get_file_ptr(db, dblen, sizeof(*header), 0);
 
 	if (ntohl(header->magic) != REGDB_MAGIC)
-		return NULL;
+		goto out;
 
 	if (ntohl(header->version) != REGDB_VERSION)
-		return NULL;
+		goto out;
 
 	siglen = ntohl(header->signature_length);
 	/* adjust dblen so later sanity checks don't run into the signature */
 	dblen -= siglen;
 
 	if (dblen <= (int)sizeof(*header))
-		return NULL;
+		goto out;
 
 	/* verify signature */
 	if (!crda_verify_db_signature(db, dblen, siglen))
-		return NULL;
+		goto out;
 
 	num_countries = ntohl(header->reg_country_num);
 	countries = crda_get_file_ptr(db, dblen,
@@ -296,14 +300,17 @@ reglib_get_rd_idx(unsigned int idx, const char *file)
 			header->reg_country_ptr);
 
 	if (idx >= num_countries)
-		return NULL;
+		goto out;
 
 	country = countries + idx;
 
 	rd = country2rd(db, dblen, country);
 	if (!rd)
-		return NULL;
+		goto out;
 
+out:
+	close(fd);
+	munmap(db, dblen);
 	return rd;
 }
 
-- 
1.7.10.4

