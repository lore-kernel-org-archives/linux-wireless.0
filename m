Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.191]:30629 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbYJWXHZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 19:07:25 -0400
Received: by mu-out-0910.google.com with SMTP id g7so337546muf.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Oct 2008 16:07:21 -0700 (PDT)
Date: Fri, 24 Oct 2008 01:07:16 +0200
From: Davide Pesavento <davidepesa@gmail.com>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [CRDA PATCH 5/6] Fix some trivial warnings.
Message-ID: <20081023230716.GA8869@PesaBook.pesa.homelinux.org> (sfid-20081024_010728_469763_E202AD2F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix warnings spit out by gcc -Wextra and checkpatch.pl

Signed-off-by: Davide Pesavento <davidepesa@gmail.com>
---
 crda.c |   28 +++++++++++++++-------------
 dump.c |    6 +++---
 2 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/crda.c b/crda.c
index a465ead..5b0e80f 100644
--- a/crda.c
+++ b/crda.c
@@ -73,20 +73,22 @@ static void nl80211_cleanup(struct nl80211_state *state)
 	nl_handle_destroy(state->nl_handle);
 }
 
-static int reg_handler(struct nl_msg *msg, void *arg)
+static int reg_handler(struct nl_msg __attribute__((unused)) *msg,
+			void __attribute__((unused)) *arg)
 {
 	return NL_SKIP;
 }
 
-static int wait_handler(struct nl_msg *msg, void *arg)
+static int wait_handler(struct nl_msg __attribute__((unused)) *msg, void *arg)
 {
 	int *finished = arg;
 	*finished = 1;
 	return NL_STOP;
 }
 
-
-static int error_handler(struct sockaddr_nl *nla, struct nlmsgerr *err, void *arg)
+static int error_handler(struct sockaddr_nl __attribute__((unused)) *nla,
+			    struct nlmsgerr *err,
+			    void __attribute__((unused)) *arg)
 {
 	fprintf(stderr, "nl80211 error %d\n", err->error);
 	exit(err->error);
@@ -113,14 +115,13 @@ static int is_world_regdom(const char *alpha2)
 	return 0;
 }
 
-static int is_valid_regdom(const char * alpha2)
+static int is_valid_regdom(const char *alpha2)
 {
 	if (strlen(alpha2) != 2)
 		return 0;
 
-	if (!is_alpha2(alpha2) && !is_world_regdom(alpha2)) {
+	if (!is_alpha2(alpha2) && !is_world_regdom(alpha2))
 		return 0;
-	}
 
 	return 1;
 }
@@ -226,7 +227,7 @@ int main(int argc, char **argv)
 	/* adjust dblen so later sanity checks don't run into the signature */
 	dblen -= siglen;
 
-	if (dblen <= sizeof(*header)) {
+	if (dblen <= (int)sizeof(*header)) {
 		fprintf(stderr, "Invalid signature length %d\n", siglen);
 		return -EINVAL;
 	}
@@ -237,8 +238,8 @@ int main(int argc, char **argv)
 
 	num_countries = ntohl(header->reg_country_num);
 	countries = crda_get_file_ptr(db, dblen,
-				 sizeof(struct regdb_file_reg_country) * num_countries,
-				 header->reg_country_ptr);
+			sizeof(struct regdb_file_reg_country) * num_countries,
+			header->reg_country_ptr);
 
 	for (i = 0; i < num_countries; i++) {
 		country = countries + i;
@@ -249,7 +250,7 @@ int main(int argc, char **argv)
 	}
 
 	if (!found_country) {
-		fprintf(stderr, "failed to find a country match in regulatory database\n");
+		fprintf(stderr, "No country match in regulatory database.\n");
 		return -1;
 	}
 
@@ -305,7 +306,7 @@ int main(int argc, char **argv)
 	r = nl_send_auto_complete(nlstate.nl_handle, msg);
 
 	if (r < 0) {
-		fprintf(stderr, "failed to send regulatory request: %d\n", r);
+		fprintf(stderr, "Failed to send regulatory request: %d\n", r);
 		goto cb_out;
 	}
 
@@ -316,7 +317,8 @@ int main(int argc, char **argv)
 	if (!finished) {
 		r = nl_wait_for_ack(nlstate.nl_handle);
 		if (r < 0) {
-			fprintf(stderr, "failed to set regulatory domain: %d\n", r);
+			fprintf(stderr, "Failed to set regulatory domain: "
+				"%d\n", r);
 			goto cb_out;
 		}
 	}
diff --git a/dump.c b/dump.c
index 0580424..b78581a 100644
--- a/dump.c
+++ b/dump.c
@@ -108,7 +108,7 @@ int main(int argc, char **argv)
 	/* adjust dblen so later sanity checks don't run into the signature */
 	dblen -= siglen;
 
-	if (dblen <= sizeof(*header)) {
+	if (dblen <= (int)sizeof(*header)) {
 		fprintf(stderr, "Invalid signature length %d\n", siglen);
 		return 2;
 	}
@@ -119,8 +119,8 @@ int main(int argc, char **argv)
 
 	num_countries = ntohl(header->reg_country_num);
 	countries = crda_get_file_ptr(db, dblen,
-				 sizeof(struct regdb_file_reg_country) * num_countries,
-				 header->reg_country_ptr);
+			sizeof(struct regdb_file_reg_country) * num_countries,
+			header->reg_country_ptr);
 
 	for (i = 0; i < num_countries; i++) {
 		struct regdb_file_reg_rules_collection *rcoll;
-- 
1.6.0.2

