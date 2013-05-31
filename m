Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:58264 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab3EaCM3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:12:29 -0400
Received: by mail-pd0-f182.google.com with SMTP id g10so1382849pdj.27
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:12:28 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 38/40] crda: add reglib regdb context helpers: reglib_(malloc|free)_regdb_ctx()
Date: Thu, 30 May 2013 19:09:27 -0700
Message-Id: <1369966169-23640-39-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_042937_866875_8255251B)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

These are used to allow users of reglib to instantiate a
reglib context to be used with reglib without having to
always open the regdb, mmap() it and verify it. It also
allows us to tuck away all that magic from users and put
the responsibility on reglib to do all the sanity work
for users.

To start with consolidate with two users:

reglib_get_rd_idx() and reglib_get_rd_alpha2()

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 reglib.c |  206 +++++++++++++++++++++++++++++++-------------------------------
 reglib.h |   65 ++++++++++++++++++++
 2 files changed, 167 insertions(+), 104 deletions(-)

diff --git a/reglib.c b/reglib.c
index 67f5b2b..6f076ff 100644
--- a/reglib.c
+++ b/reglib.c
@@ -186,6 +186,92 @@ int reglib_verify_db_signature(uint8_t *db, int dblen, int siglen)
 }
 #endif
 
+const struct reglib_regdb_ctx *reglib_malloc_regdb_ctx(const char *regdb_file)
+{
+	struct regdb_file_header *header;
+	struct reglib_regdb_ctx *ctx;
+
+	ctx = malloc(sizeof(struct reglib_regdb_ctx));
+	if (!ctx)
+		return NULL;
+
+	memset(ctx, 0, sizeof(struct reglib_regdb_ctx));
+
+	ctx->fd = open(regdb_file, O_RDONLY);
+
+	if (ctx->fd < 0) {
+		free(ctx);
+		return NULL;
+	}
+
+	if (fstat(ctx->fd, &ctx->stat)) {
+		close(ctx->fd);
+		free(ctx);
+		return NULL;
+	}
+
+	ctx->real_dblen = ctx->stat.st_size;
+
+	ctx->db = mmap(NULL, ctx->real_dblen, PROT_READ,
+		       MAP_PRIVATE, ctx->fd, 0);
+	if (ctx->db == MAP_FAILED) {
+		close(ctx->fd);
+		free(ctx);
+		return NULL;
+	}
+
+	ctx->header = reglib_get_file_ptr(ctx->db, ctx->dblen,
+					  sizeof(struct regdb_file_header),
+					  0);
+	header = ctx->header;
+
+	if (ntohl(header->magic) != REGDB_MAGIC)
+		goto err_out;
+
+	if (ntohl(header->version) != REGDB_VERSION)
+		goto err_out;
+
+	ctx->siglen = ntohl(header->signature_length);
+	/* The actual dblen does not take into account the signature */
+	ctx->dblen = ctx->real_dblen - ctx->siglen;
+
+	if (ctx->dblen <= sizeof(*header))
+		goto err_out;
+
+	/* verify signature */
+	if (!reglib_verify_db_signature(ctx->db, ctx->dblen, ctx->siglen))
+		goto err_out;
+
+	ctx->verified = true;
+	ctx->num_countries = ntohl(header->reg_country_num);
+	ctx->countries = reglib_get_file_ptr(ctx->db,
+					     ctx->dblen,
+					     sizeof(struct regdb_file_reg_country) * ctx->num_countries,
+					     header->reg_country_ptr);
+	return ctx;
+
+err_out:
+	close(ctx->fd);
+	munmap(ctx->db, ctx->real_dblen);
+	free(ctx);
+	return NULL;
+}
+
+void reglib_free_regdb_ctx(const struct reglib_regdb_ctx *regdb_ctx)
+{
+	struct reglib_regdb_ctx *ctx;
+
+	if (!regdb_ctx)
+		return;
+
+	ctx = (struct reglib_regdb_ctx *) regdb_ctx;
+
+	memset(ctx, 0, sizeof(struct reglib_regdb_ctx));
+	close(ctx->fd);
+	munmap(ctx->db, ctx->real_dblen);
+	free(ctx);
+}
+
 static void reg_rule2rd(uint8_t *db, int dblen,
 	uint32_t ruleptr, struct ieee80211_reg_rule *rd_reg_rule)
 {
@@ -252,130 +338,43 @@ country2rd(uint8_t *db, int dblen,
 const struct ieee80211_regdomain *
 reglib_get_rd_idx(unsigned int idx, const char *file)
 {
-	int fd;
-	struct stat stat;
-	uint8_t *db;
-	struct regdb_file_header *header;
-	struct regdb_file_reg_country *countries;
-	int dblen, siglen, num_countries;
-	const struct ieee80211_regdomain *rd = NULL;
+	const struct reglib_regdb_ctx *ctx;
 	struct regdb_file_reg_country *country;
+	const struct ieee80211_regdomain *rd = NULL;
 
-	fd = open(file, O_RDONLY);
-
-	if (fd < 0)
-		return NULL;
-
-	if (fstat(fd, &stat)) {
-		close(fd);
-		return NULL;
-	}
-
-	dblen = stat.st_size;
-
-	db = mmap(NULL, dblen, PROT_READ, MAP_PRIVATE, fd, 0);
-	if (db == MAP_FAILED) {
-		close(fd);
+	ctx = reglib_malloc_regdb_ctx(file);
+	if (!ctx)
 		return NULL;
-	}
-
-	header = reglib_get_file_ptr(db, dblen, sizeof(*header), 0);
 
-	if (ntohl(header->magic) != REGDB_MAGIC)
+	if (idx >= ctx->num_countries)
 		goto out;
 
-	if (ntohl(header->version) != REGDB_VERSION)
-		goto out;
+	country = ctx->countries + idx;
 
-	siglen = ntohl(header->signature_length);
-	/* adjust dblen so later sanity checks don't run into the signature */
-	dblen -= siglen;
-
-	if (dblen <= (int)sizeof(*header))
-		goto out;
-
-	/* verify signature */
-	if (!reglib_verify_db_signature(db, dblen, siglen))
-		goto out;
-
-	num_countries = ntohl(header->reg_country_num);
-	countries = reglib_get_file_ptr(db, dblen,
-			sizeof(struct regdb_file_reg_country) * num_countries,
-			header->reg_country_ptr);
-
-	if (idx >= num_countries)
-		goto out;
-
-	country = countries + idx;
-
-	rd = country2rd(db, dblen, country);
+	rd = country2rd(ctx->db, ctx->dblen, country);
 	if (!rd)
 		goto out;
 
 out:
-	close(fd);
-	munmap(db, dblen);
+	reglib_free_regdb_ctx(ctx);
 	return rd;
 }
 
 const struct ieee80211_regdomain *
 reglib_get_rd_alpha2(const char *alpha2, const char *file)
 {
-	int fd;
-	struct stat stat;
-	uint8_t *db;
-	struct regdb_file_header *header;
-	struct regdb_file_reg_country *countries;
-	int dblen, siglen, num_countries;
+	const struct reglib_regdb_ctx *ctx;
 	const struct ieee80211_regdomain *rd = NULL;
 	struct regdb_file_reg_country *country;
-	unsigned int i;
 	bool found_country = false;
+	unsigned int i;
 
-	fd = open(file, O_RDONLY);
-
-	if (fd < 0)
-		return NULL;
-
-	if (fstat(fd, &stat)) {
-		close(fd);
-		return NULL;
-	}
-
-	dblen = stat.st_size;
-
-	db = mmap(NULL, dblen, PROT_READ, MAP_PRIVATE, fd, 0);
-	if (db == MAP_FAILED) {
-		close(fd);
+	ctx = reglib_malloc_regdb_ctx(file);
+	if (!ctx)
 		return NULL;
-	}
-
-	header = reglib_get_file_ptr(db, dblen, sizeof(*header), 0);
-
-	if (ntohl(header->magic) != REGDB_MAGIC)
-		goto out;
-
-	if (ntohl(header->version) != REGDB_VERSION)
-		goto out;
-
-	siglen = ntohl(header->signature_length);
-	/* adjust dblen so later sanity checks don't run into the signature */
-	dblen -= siglen;
-
-	if (dblen <= (int)sizeof(*header))
-		goto out;
-
-	/* verify signature */
-	if (!reglib_verify_db_signature(db, dblen, siglen))
-		goto out;
-
-	num_countries = ntohl(header->reg_country_num);
-	countries = reglib_get_file_ptr(db, dblen,
-			sizeof(struct regdb_file_reg_country) * num_countries,
-			header->reg_country_ptr);
 
-	for (i = 0; i < num_countries; i++) {
-		country = countries + i;
+	for (i = 0; i < ctx->num_countries; i++) {
+		country = ctx->countries + i;
 		if (memcmp(country->alpha2, alpha2, 2) == 0) {
 			found_country = 1;
 			break;
@@ -385,13 +384,12 @@ reglib_get_rd_alpha2(const char *alpha2, const char *file)
 	if (!found_country)
 		goto out;
 
-	rd = country2rd(db, dblen, country);
+	rd = country2rd(ctx->db, ctx->dblen, country);
 	if (!rd)
 		goto out;
 
 out:
-	close(fd);
-	munmap(db, dblen);
+	reglib_free_regdb_ctx(ctx);
 	return rd;
 }
 
diff --git a/reglib.h b/reglib.h
index 2681164..f1bd6b8 100644
--- a/reglib.h
+++ b/reglib.h
@@ -3,6 +3,10 @@
 
 #include <stdlib.h>
 #include <stdint.h>
+#include <stdbool.h>
+#include <sys/stat.h>
+
+#include "regdb.h"
 
 /* Common regulatory structures, functions and helpers */
 
@@ -31,6 +35,44 @@ struct ieee80211_regdomain {
 	struct ieee80211_reg_rule reg_rules[];
 };
 
+/**
+ * struct reglib_regdb_ctx - reglib regdb context
+ *
+ * This can be used to interat with reglib without
+ * having to open() / close() / mmap() / munmap()
+ * and check the regdb binary file for integrity and
+ * authorship.
+ *
+ * @fd: file descriptor of the db
+ * @stat: @fd fstat()
+ * @db: mmap() of the db of @real_dblen
+ * @real_dblen: file size in bytes of @fd
+ * @siglen: size in bytes of the signature at the end of the file
+ * @dblen: database lenghth, this is the @real_dblen - @siglen
+ * @verified: whether or not this regdb has been RSA verified.
+ * 	This value is dependent on whether or not you enabled
+ * 	signature verification with gcrypt, openssl, or none
+ * 	at all. If no signature verification was not compiled
+ * 	in then this will always be true otherwise this will
+ * 	only be true if the RSA digital signature of the SHA1
+ * 	sum of the regulatory database at the end of the
+ * 	regulatory database can be verified with the one of
+ * 	the trusted public keys.
+ */
+struct reglib_regdb_ctx {
+	int fd;
+	struct stat stat;
+	uint8_t *db;
+	uint32_t real_dblen;
+	uint32_t siglen;
+	uint32_t dblen;
+	bool verified;
+
+	struct regdb_file_header *header;
+	uint32_t num_countries;
+	struct regdb_file_reg_country *countries;
+};
+
 static inline int reglib_is_world_regdom(const char *alpha2)
 {
 	if (alpha2[0] == '0' && alpha2[1] == '0')
@@ -73,6 +115,29 @@ static inline uint32_t reglib_min(uint32_t a, uint32_t b)
 void *reglib_get_file_ptr(uint8_t *db, int dblen, int structlen, uint32_t ptr);
 int reglib_verify_db_signature(uint8_t *db, int dblen, int siglen);
 
+/**
+ * reglib_malloc_regdb_ctx - create a regdb context for usage with reglib
+ *
+ * @regdb_file: file name
+ *
+ * Most operations on reglib iterate over the database somehow and prior
+ * to iterating over it it must check the signature. Use this context helper
+ * to let you query the db within different contexts in your program and
+ * just be sure to call reglib_free_regdb_ctx() when done. This helper will
+ * open the file passed and mmap() it.
+ */
+const struct reglib_regdb_ctx *reglib_malloc_regdb_ctx(const char *regdb_file);
+
+/**
+ * reglib_free_regdb_ctx - free a regdb context used with reglib
+ *
+ * @regdb_ctx: the reglib regdb context created with reglib_malloc_regdb_ctx()
+ *
+ * This will do all the handy work to close up, munmap, and free the
+ * reglib regdb context passed.
+ */
+void reglib_free_regdb_ctx(const struct reglib_regdb_ctx *regdb_ctx);
+
 const struct ieee80211_regdomain *
 reglib_get_rd_idx(unsigned int idx, const char *file);
 
-- 
1.7.10.4

