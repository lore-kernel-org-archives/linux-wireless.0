Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:51359 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab1GNTLC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 15:11:02 -0400
Received: by mail-fx0-f52.google.com with SMTP id 18so1505335fxd.11
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jul 2011 12:11:01 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/4] bcma: extract SPROM rev 9 the same way as rev 8
Date: Thu, 14 Jul 2011 21:49:21 +0200
Message-Id: <1310672961-5311-4-git-send-email-zajec5@gmail.com> (sfid-20110714_211106_360045_3ED0A3F2)
In-Reply-To: <1310672961-5311-1-git-send-email-zajec5@gmail.com>
References: <1310672961-5311-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SPROM rev 9 was discovered on 14e4:4331, it seems to have very similar
layout to rev 8 one. Use the same extracting function until we find some
differences.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/sprom.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index 8e8d5cf..52917e5 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -112,7 +112,7 @@ static int bcma_sprom_valid(const u16 *sprom)
 		return err;
 
 	revision = sprom[SSB_SPROMSIZE_WORDS_R4 - 1] & SSB_SPROM_REVISION_REV;
-	if (revision != 8) {
+	if (revision != 8 && revision != 9) {
 		pr_err("Unsupported SPROM revision: %d\n", revision);
 		return -ENOENT;
 	}
-- 
1.7.3.4

