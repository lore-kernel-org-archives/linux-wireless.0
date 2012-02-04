Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60041 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab2BDB0C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 20:26:02 -0500
Received: by pbdu11 with SMTP id u11so3334452pbd.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Feb 2012 17:26:01 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [RFC 03/11] crda: make intersect.c use reglib_for_each_country()
Date: Fri,  3 Feb 2012 17:25:40 -0800
Message-Id: <1328318748-21044-4-git-send-email-mcgrof@frijolero.org> (sfid-20120204_022639_433011_5F853506)
In-Reply-To: <1328318748-21044-1-git-send-email-mcgrof@frijolero.org>
References: <1328318748-21044-1-git-send-email-mcgrof@frijolero.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 intersect.c |   93 +++++++---------------------------------------------------
 1 files changed, 12 insertions(+), 81 deletions(-)

diff --git a/intersect.c b/intersect.c
index 2e5dacf..6d3d393 100644
--- a/intersect.c
+++ b/intersect.c
@@ -182,101 +182,26 @@ static struct ieee80211_regdomain *regdom_intersect(
 
 int main(int argc, char **argv)
 {
-	int fd;
-	struct stat stat;
-	uint8_t *db;
-	struct regdb_file_header *header;
-	struct regdb_file_reg_country *countries;
-	int dblen, siglen, num_countries, i, r = 0;
+	int r = 0;
 	struct ieee80211_regdomain *prev_world = NULL, *rd = NULL, *world = NULL;
 	int intersected = 0;
+	unsigned int idx = 0;
 
 	if (argc != 2) {
-		fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
-		return 2;
-	}
-
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
+		fprintf(stderr, "You must specify a file\n");
 		return -EINVAL;
-
-	num_countries = ntohl(header->reg_country_num);
-
-	if (num_countries <= 0)
-		return 0;
-
-	countries = crda_get_file_ptr(db, dblen,
-			sizeof(struct regdb_file_reg_country) * num_countries,
-			header->reg_country_ptr);
+	}
 
 	/* We intersect only when we have to rd structures ready */
-	for (i = 0; i < num_countries; i++) {
-		struct regdb_file_reg_country *country = countries + i;
-
-		if (is_world_regdom((const char *) country->alpha2))
+	reglib_for_each_country(rd, idx, argv[1]) {
+		if (is_world_regdom((const char *) rd->alpha2))
 			continue;
 
-		/* Gets the rd for the current country */
-		rd = country2rd(db, dblen, country);
-		if (!rd) {
-			r = -ENOMEM;
-			fprintf(stderr, "Could not covert country "
-				"(%.2s) to rd\n", country->alpha2);
-			goto out;
-		}
-
-		if (num_countries == 1) {
-			world = rd;
-			rd = NULL;
-			break;
-		}
-
 		if (!prev_world) {
 			prev_world = rd;
 			continue;
 		}
 
-
 		if (world) {
 			free(prev_world);
 			prev_world = world;
@@ -318,6 +243,12 @@ int main(int argc, char **argv)
 		intersected++;
 	}
 
+	if (idx == 1) {
+		world = rd;
+		rd = NULL;
+	}
+
+
 	if (intersected > 1)
 		printf("%d regulatory domains intersected\n", intersected);
 	else
-- 
1.7.4.15.g7811d

