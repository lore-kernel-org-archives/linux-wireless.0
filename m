Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f167.google.com ([209.85.220.167]:38960 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbZBXOcK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 09:32:10 -0500
Received: by fxm11 with SMTP id 11so2817466fxm.13
        for <linux-wireless@vger.kernel.org>; Tue, 24 Feb 2009 06:32:07 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Luis R Rodriguez <mcgrof@gmail.com>
Subject: [PATCH] crda: allow loading of regulatory.bin from /lib/crda in addition to /usr/lib/crda
Date: Tue, 24 Feb 2009 15:31:50 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200902241531.50649.helmut.schaa@gmail.com> (sfid-20090224_153236_829195_BE5D3DFE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As crda is typically installed in /sbin it might be worth to install
regulatory.bin into /lib/crda instead of /usr/lib/crda. Hence, extend
crda to try both paths for loading the database.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

diff --git a/crda.c b/crda.c
index f2c471f..55632a6 100644
--- a/crda.c
+++ b/crda.c
@@ -143,7 +143,7 @@ nla_put_failure:
 
 int main(int argc, char **argv)
 {
-	int fd;
+	int fd = -1;
 	struct stat stat;
 	__u8 *db;
 	struct regdb_file_header *header;
@@ -162,7 +162,12 @@ int main(int argc, char **argv)
 	struct nlattr *nl_reg_rules;
 	int num_rules;
 
-	const char regdb[] = "/usr/lib/crda/regulatory.bin";
+	const char *regdb_paths[] = {
+		"/usr/lib/crda/regulatory.bin",
+		"/lib/crda/regulatory.bin",
+		NULL
+	};
+	const char **regdb = regdb_paths;
 
 	if (argc != 1) {
 		fprintf(stderr, "Usage: %s\n", argv[0]);
@@ -183,7 +188,12 @@ int main(int argc, char **argv)
 
 	memcpy(alpha2, env_country, 2);
 
-	fd = open(regdb, O_RDONLY);
+	while (*regdb != NULL) {
+		fd = open(*regdb, O_RDONLY);
+		if (fd >= 0)
+			break;
+		regdb++;
+	}
 	if (fd < 0) {
 		perror("failed to open db file");
 		return -ENOENT;
