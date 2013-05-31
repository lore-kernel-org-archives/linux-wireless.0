Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:59893 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab3EaCKm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:10:42 -0400
Received: by mail-pd0-f174.google.com with SMTP id 3so1376641pdj.33
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:10:41 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 13/40] crda: explicitly close file descriptor and munmap() on failures
Date: Thu, 30 May 2013 19:09:02 -0700
Message-Id: <1369966169-23640-14-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_041044_658822_948DAFF0)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Just do this explicitly.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 reglib.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/reglib.c b/reglib.c
index bb6f23f..cbe9676 100644
--- a/reglib.c
+++ b/reglib.c
@@ -307,33 +307,37 @@ reglib_get_rd_alpha2(const char *alpha2, const char *file)
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
-- 
1.7.10.4

