Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1767 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757256Ab0KUCkt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Nov 2010 21:40:49 -0500
From: Joe Perches <joe@perches.com>
To: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 62/62] zd1211rw: Use const
Date: Sat, 20 Nov 2010 18:39:03 -0800
Message-Id: <15a8b7cda630f3514fd640a2ffd8a84f57e4f084.1290305776.git.joe@perches.com>
In-Reply-To: <cover.1290305773.git.joe@perches.com>
References: <cover.1290305773.git.joe@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mark arrays const that are unmodified after initializations.

   text	   data	    bss	    dec	    hex	filename
  19291	     56	   4136	  23483	   5bbb	drivers/net/wireless/zd1211rw/zd_chip.o.old
  19291	     56	   4136	  23483	   5bbb	drivers/net/wireless/zd1211rw/zd_chip.o.new

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/zd1211rw/zd_chip.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
index 87a95bc..30f8d40 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -1448,7 +1448,7 @@ int zd_rfwritev_locked(struct zd_chip *chip,
  */
 int zd_rfwrite_cr_locked(struct zd_chip *chip, u32 value)
 {
-	struct zd_ioreq16 ioreqs[] = {
+	const struct zd_ioreq16 ioreqs[] = {
 		{ CR244, (value >> 16) & 0xff },
 		{ CR243, (value >>  8) & 0xff },
 		{ CR242,  value        & 0xff },
@@ -1475,7 +1475,7 @@ int zd_rfwritev_cr_locked(struct zd_chip *chip,
 int zd_chip_set_multicast_hash(struct zd_chip *chip,
 	                       struct zd_mc_hash *hash)
 {
-	struct zd_ioreq32 ioreqs[] = {
+	const struct zd_ioreq32 ioreqs[] = {
 		{ CR_GROUP_HASH_P1, hash->low },
 		{ CR_GROUP_HASH_P2, hash->high },
 	};
-- 
1.7.3.2.245.g03276.dirty

