Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54915 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab2BDBZ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 20:25:59 -0500
Received: by mail-pz0-f46.google.com with SMTP id p15so3176528dad.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Feb 2012 17:25:58 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [RFC 02/11] crda: add a reglib iterator reglib_for_each_country()
Date: Fri,  3 Feb 2012 17:25:39 -0800
Message-Id: <1328318748-21044-3-git-send-email-mcgrof@frijolero.org> (sfid-20120204_022615_406639_30F319C6)
In-Reply-To: <1328318748-21044-1-git-send-email-mcgrof@frijolero.org>
References: <1328318748-21044-1-git-send-email-mcgrof@frijolero.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To allow for a simple library on reglib.c we want to enable
an iterator over the regulatory database that does not have
to lock the file, or pass references to the file. We instead
add an iterator reglib_get_country_idx() which will use a
new reglib_get_country_idx(), that does an O(n) search for
each new regulatory domain it needs to read.

The trade off here is to allow for a simple reglib.c implementation
at the cost that upon each iteration reglib_get_country_idx()
we will will be opening the regdb, and verifying the db signature.
Given that the only user of this iterator is regdbdump though and
that this is used for debugging for now this is trade off I am
willing to live with.

Systems that want to use the regdb as a database for fine tuning
radio parameters dynamically and reading this file very *often*
(seconds, minutes, who knows what the future holds) may want to
consider a slight optimization of exporting the direct mmap()
through the library but we are I think light years away from that.

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 Makefile    |    2 +-
 regdbdump.c |   79 +++--------------------------------------------------------
 reglib.c    |   69 +++++++++++++++++++++++++++++++++++++++++++++++++++
 reglib.h    |    9 ++++++
 4 files changed, 83 insertions(+), 76 deletions(-)

diff --git a/Makefile b/Makefile
index 5a8ed46..1d34bde 100644
--- a/Makefile
+++ b/Makefile
@@ -105,7 +105,7 @@ keys-%.c: utils/key2pub.py $(wildcard $(PUBKEY_DIR)/*.pem)
 	$(NQ) '  Trusted pubkeys:' $(wildcard $(PUBKEY_DIR)/*.pem)
 	$(Q)./utils/key2pub.py --$* $(wildcard $(PUBKEY_DIR)/*.pem) $@
 
-%.o: %.c regdb.h
+%.o: %.c regdb.h reglib.h
 	$(NQ) '  CC  ' $@
 	$(Q)$(CC) -c $(CPPFLAGS) $(CFLAGS) -o $@ $<
 
diff --git a/regdbdump.c b/regdbdump.c
index 9ba806c..6d4cf56 100644
--- a/regdbdump.c
+++ b/regdbdump.c
@@ -1,94 +1,23 @@
 #include <errno.h>
-#include <stdlib.h>
 #include <stdio.h>
-#include <sys/mman.h>
-#include <sys/stat.h>
-#include <fcntl.h>
-#include <arpa/inet.h> /* ntohl */
 
 #include "regdb.h"
 #include "reglib.h"
 
 int main(int argc, char **argv)
 {
-	int fd;
-	struct stat stat;
-	uint8_t *db;
-	struct regdb_file_header *header;
-	struct regdb_file_reg_country *countries;
-	int dblen, siglen, num_countries, i, r = 0;
 	struct ieee80211_regdomain *rd = NULL;
+	unsigned int idx = 0;
 
 	if (argc != 2) {
 		fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
 		return 2;
 	}
 
-	fd = open(argv[1], O_RDONLY);
-	if (fd < 0) {
-		perror("failed to open db file");
-		return 2;
-	}
-
-	if (fstat(fd, &stat)) {
-		perror("failed to fstat db file");
-		return 2;
-	}
-
-	dblen = stat.st_size;
-
-	db = mmap(NULL, dblen, PROT_READ, MAP_PRIVATE, fd, 0);
-	if (db == MAP_FAILED) {
-		perror("failed to mmap db file");
-		return 2;
-	}
-
-	header = crda_get_file_ptr(db, dblen, sizeof(*header), 0);
-
-	if (ntohl(header->magic) != REGDB_MAGIC) {
-		fprintf(stderr, "Invalid database magic\n");
-		return 2;
-	}
-
-	if (ntohl(header->version) != REGDB_VERSION) {
-		fprintf(stderr, "Invalid database version\n");
-		return 2;
-	}
-
-	siglen = ntohl(header->signature_length);
-	/* adjust dblen so later sanity checks don't run into the signature */
-	dblen -= siglen;
-
-	if (dblen <= (int)sizeof(*header)) {
-		fprintf(stderr, "Invalid signature length %d\n", siglen);
-		return 2;
-	}
-
-	/* verify signature */
-	if (!crda_verify_db_signature(db, dblen, siglen))
-		return -EINVAL;
-
-	num_countries = ntohl(header->reg_country_num);
-	countries = crda_get_file_ptr(db, dblen,
-			sizeof(struct regdb_file_reg_country) * num_countries,
-			header->reg_country_ptr);
-
-	for (i = 0; i < num_countries; i++) {
-		struct regdb_file_reg_country *country = countries + i;
-
-		rd = country2rd(db, dblen, country);
-		if (!rd) {
-			r = -ENOMEM;
-			fprintf(stderr, "Could not covert country "
-			"(%.2s) to rd\n", country->alpha2);
-			goto out;
-		}
-
+	reglib_for_each_country(rd, idx, argv[1]) {
 		print_regdom(rd);
 		free(rd);
-		rd = NULL;
-
 	}
-out:
-	return r;
+
+	return 0;
 }
diff --git a/reglib.c b/reglib.c
index 5d66481..0cef7a5 100644
--- a/reglib.c
+++ b/reglib.c
@@ -3,6 +3,13 @@
 #include <arpa/inet.h>
 #include <sys/types.h>
 #include <dirent.h>
+#include <sys/stat.h>
+#include <stdlib.h>
+#include <sys/mman.h>
+#include <fcntl.h>
+
+#include <arpa/inet.h> /* ntohl */
+
 #include "reglib.h"
 
 #ifdef USE_OPENSSL
@@ -212,3 +219,65 @@ struct ieee80211_regdomain *country2rd(uint8_t *db, int dblen,
 
 	return rd;
 }
+
+struct ieee80211_regdomain *
+reglib_get_country_idx(unsigned int idx, const char *file)
+{
+	int fd;
+	struct stat stat;
+	uint8_t *db;
+	struct regdb_file_header *header;
+	struct regdb_file_reg_country *countries;
+	int dblen, siglen, num_countries;
+	struct ieee80211_regdomain *rd = NULL;
+	struct regdb_file_reg_country *country;
+
+	fd = open(file, O_RDONLY);
+
+	if (fd < 0)
+		return NULL;
+
+	if (fstat(fd, &stat))
+		return NULL;
+
+	dblen = stat.st_size;
+
+	db = mmap(NULL, dblen, PROT_READ, MAP_PRIVATE, fd, 0);
+	if (db == MAP_FAILED)
+		return NULL;
+
+	header = crda_get_file_ptr(db, dblen, sizeof(*header), 0);
+
+	if (ntohl(header->magic) != REGDB_MAGIC)
+		return NULL;
+
+	if (ntohl(header->version) != REGDB_VERSION)
+		return NULL;
+
+	siglen = ntohl(header->signature_length);
+	/* adjust dblen so later sanity checks don't run into the signature */
+	dblen -= siglen;
+
+	if (dblen <= (int)sizeof(*header))
+		return NULL;
+
+	/* verify signature */
+	if (!crda_verify_db_signature(db, dblen, siglen))
+		return NULL;
+
+	num_countries = ntohl(header->reg_country_num);
+	countries = crda_get_file_ptr(db, dblen,
+			sizeof(struct regdb_file_reg_country) * num_countries,
+			header->reg_country_ptr);
+
+	if (idx >= num_countries)
+		return NULL;
+
+	country = countries + idx;
+
+	rd = country2rd(db, dblen, country);
+	if (!rd)
+		return NULL;
+
+	return rd;
+}
diff --git a/reglib.h b/reglib.h
index e6adc14..ef85fac 100644
--- a/reglib.h
+++ b/reglib.h
@@ -78,6 +78,15 @@ int crda_verify_db_signature(uint8_t *db, int dblen, int siglen);
 struct ieee80211_regdomain *country2rd(uint8_t *db, int dblen,
 	struct regdb_file_reg_country *country);
 
+struct ieee80211_regdomain *
+reglib_get_country_idx(unsigned int idx, const char *file);
+
+#define reglib_for_each_country(__rd, __idx, __file)			\
+	for (__rd = reglib_get_country_idx(__idx, __file);		\
+	     __rd != NULL;						\
+	     __rd = reglib_get_country_idx(__idx, __file),		\
+	     __idx++)
+
 /* reg helpers */
 void print_regdom(struct ieee80211_regdomain *rd);
 
-- 
1.7.4.15.g7811d

