Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54915 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab2BDB0H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 20:26:07 -0500
Received: by mail-pz0-f46.google.com with SMTP id p15so3176528dad.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Feb 2012 17:26:07 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [RFC 05/11] crda: add new reglib_get_country_alpha2()
Date: Fri,  3 Feb 2012 17:25:42 -0800
Message-Id: <1328318748-21044-6-git-send-email-mcgrof@frijolero.org> (sfid-20120204_022618_122765_29A4FE81)
In-Reply-To: <1328318748-21044-1-git-send-email-mcgrof@frijolero.org>
References: <1328318748-21044-1-git-send-email-mcgrof@frijolero.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will be used by CRDA to find the alpha2.

Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 reglib.c |   74 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 reglib.h |    3 ++
 2 files changed, 77 insertions(+), 0 deletions(-)

diff --git a/reglib.c b/reglib.c
index 0cef7a5..642f907 100644
--- a/reglib.c
+++ b/reglib.c
@@ -7,6 +7,8 @@
 #include <stdlib.h>
 #include <sys/mman.h>
 #include <fcntl.h>
+#include <stdbool.h>
+#include <unistd.h>
 
 #include <arpa/inet.h> /* ntohl */
 
@@ -281,3 +283,75 @@ reglib_get_country_idx(unsigned int idx, const char *file)
 
 	return rd;
 }
+
+struct ieee80211_regdomain *
+reglib_get_country_alpha2(const char *alpha2, const char *file)
+{
+	int fd;
+	struct stat stat;
+	uint8_t *db;
+	struct regdb_file_header *header;
+	struct regdb_file_reg_country *countries;
+	int dblen, siglen, num_countries;
+	struct ieee80211_regdomain *rd = NULL;
+	struct regdb_file_reg_country *country;
+	unsigned int i;
+	bool found_country = false;
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
+	for (i = 0; i < num_countries; i++) {
+		country = countries + i;
+		if (memcmp(country->alpha2, alpha2, 2) == 0) {
+			found_country = 1;
+			break;
+		}
+	}
+
+	if (!found_country)
+		goto out;
+
+	rd = country2rd(db, dblen, country);
+	if (!rd)
+		goto out;
+
+out:
+	close(fd);
+	return rd;
+}
diff --git a/reglib.h b/reglib.h
index ef85fac..d76ec52 100644
--- a/reglib.h
+++ b/reglib.h
@@ -87,6 +87,9 @@ reglib_get_country_idx(unsigned int idx, const char *file);
 	     __rd = reglib_get_country_idx(__idx, __file),		\
 	     __idx++)
 
+struct ieee80211_regdomain *
+reglib_get_country_alpha2(const char *alpha2, const char *file);
+
 /* reg helpers */
 void print_regdom(struct ieee80211_regdomain *rd);
 
-- 
1.7.4.15.g7811d

