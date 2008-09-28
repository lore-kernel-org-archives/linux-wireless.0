Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:42768 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbYI1UHi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Sep 2008 16:07:38 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1208835fgg.17
        for <linux-wireless@vger.kernel.org>; Sun, 28 Sep 2008 13:07:36 -0700 (PDT)
Date: Sun, 28 Sep 2008 22:07:27 +0200
From: Davide Pesavento <davidepesa@gmail.com>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [CRDA PATCH 2/4] Delay netlink initialization and cache allocation.
Message-ID: <20080928200727.GA5813@PesaBook.pesa.homelinux.org> (sfid-20080928_220741_120063_B7112811)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By calling nl80211_init() a bit later, we can simplify error handling
and avoid a lot of goto's in error paths.

While at it, fix a couple of minor leaks in openssl-related code.

Signed-off-by: Davide Pesavento <davidepesa@gmail.com>
---
 crda.c |   52 +++++++++++++++++++++-------------------------------
 1 files changed, 21 insertions(+), 31 deletions(-)

diff --git a/crda.c b/crda.c
index 4c7681c..e4cbe96 100644
--- a/crda.c
+++ b/crda.c
@@ -219,21 +219,15 @@ int main(int argc, char **argv)
 
 	memcpy(alpha2, env_country, 2);
 
-	r = nl80211_init(&nlstate);
-	if (r)
-		return -EIO;
-
 	fd = open(regdb, O_RDONLY);
 	if (fd < 0) {
 		perror("failed to open db file");
-		r = -ENOENT;
-		goto out;
+		return -ENOENT;
 	}
 
 	if (fstat(fd, &stat)) {
 		perror("failed to fstat db file");
-		r = -EIO;
-		goto out;
+		return -EIO;
 	}
 
 	dblen = stat.st_size;
@@ -241,22 +235,19 @@ int main(int argc, char **argv)
 	db = mmap(NULL, dblen, PROT_READ, MAP_PRIVATE, fd, 0);
 	if (db == MAP_FAILED) {
 		perror("failed to mmap db file");
-		r = -EIO;
-		goto out;
+		return -EIO;
 	}
 
 	header = get_file_ptr(db, dblen, sizeof(*header), 0);
 
 	if (ntohl(header->magic) != REGDB_MAGIC) {
 		fprintf(stderr, "Invalid database magic\n");
-		r = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	if (ntohl(header->version) != REGDB_VERSION) {
 		fprintf(stderr, "Invalid database version\n");
-		r = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	siglen = ntohl(header->signature_length);
@@ -265,8 +256,7 @@ int main(int argc, char **argv)
 
 	if (dblen <= sizeof(*header)) {
 		fprintf(stderr, "Invalid signature length %d\n", siglen);
-		r = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	/* verify signature */
@@ -274,14 +264,13 @@ int main(int argc, char **argv)
 	rsa = RSA_new();
 	if (!rsa) {
 		fprintf(stderr, "Failed to create RSA key\n");
-		r = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	if (SHA1(db, dblen, hash) != hash) {
 		fprintf(stderr, "Failed to calculate SHA sum\n");
-		r = -EINVAL;
-		goto out;
+		RSA_free(rsa);
+		return -EINVAL;
 	}
 
 	for (i = 0; i < sizeof(keys)/sizeof(keys[0]); i++) {
@@ -297,18 +286,16 @@ int main(int argc, char **argv)
 			break;
 	}
 
-	if (!ok) {
-		fprintf(stderr, "Database signature wrong\n");
-		r = -EINVAL;
-		goto out;
-	}
-
 	rsa->e = NULL;
 	rsa->n = NULL;
 	RSA_free(rsa);
 
-	BN_print_fp(stdout, &keys[0].n);
+	if (!ok) {
+		fprintf(stderr, "Database signature wrong\n");
+		return -EINVAL;
+	}
 
+	BN_print_fp(stdout, &keys[0].n);
 #endif
 
 #ifdef USE_GCRYPT
@@ -356,7 +343,6 @@ int main(int argc, char **argv)
 		fprintf(stderr, "Database signature wrong\n");
 		return 2;
 	}
-
 #endif
 
 	num_countries = ntohl(header->reg_country_num);
@@ -377,16 +363,20 @@ int main(int argc, char **argv)
 		return -1;
 	}
 
+	r = nl80211_init(&nlstate);
+	if (r)
+		return -EIO;
+
 	msg = nlmsg_alloc();
 	if (!msg) {
-		fprintf(stderr, "failed to allocate netlink msg\n");
-		return -1;
+		fprintf(stderr, "Failed to allocate netlink message.\n");
+		r = -1;
+		goto out;
 	}
 
 	genlmsg_put(msg, 0, 0, genl_family_get_id(nlstate.nl80211), 0,
 		0, NL80211_CMD_SET_REG, 0);
 
-
 	rcoll = get_file_ptr(db, dblen, sizeof(*rcoll), country->reg_collection_ptr);
 	num_rules = ntohl(rcoll->reg_rule_num);
 	/* re-get pointer with sanity checking for num_rules */
-- 
1.6.0.2

