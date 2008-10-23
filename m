Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.188]:37657 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbYJWXGl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 19:06:41 -0400
Received: by fk-out-0910.google.com with SMTP id 18so373113fkq.5
        for <linux-wireless@vger.kernel.org>; Thu, 23 Oct 2008 16:06:41 -0700 (PDT)
Date: Fri, 24 Oct 2008 01:06:35 +0200
From: Davide Pesavento <davidepesa@gmail.com>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [CRDA PATCH 4/6] Use the correct index when iterating over the
	array of public keys.
Message-ID: <20081023230635.GA8860@PesaBook.pesa.homelinux.org> (sfid-20081024_010644_272216_7E1890AE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Davide Pesavento <davidepesa@gmail.com>
---
 regdb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/regdb.c b/regdb.c
index f786ae3..e2e2185 100644
--- a/regdb.c
+++ b/regdb.c
@@ -102,9 +102,9 @@ int crda_verify_db_signature(__u8 *db, int dblen, int siglen)
 
 	for (i = 0; (i < sizeof(keys)/sizeof(keys[0])) && (!ok); i++) {
 		if (gcry_mpi_scan(&mpi_e, GCRYMPI_FMT_USG,
-				keys[0].e, keys[0].len_e, NULL) ||
+				keys[i].e, keys[i].len_e, NULL) ||
 		    gcry_mpi_scan(&mpi_n, GCRYMPI_FMT_USG,
-				keys[0].n, keys[0].len_n, NULL)) {
+				keys[i].n, keys[i].len_n, NULL)) {
 			fprintf(stderr, "Failed to convert numbers.\n");
 			goto out;
 		}
-- 
1.6.0.2

