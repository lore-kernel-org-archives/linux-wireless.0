Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44595 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755390Ab2D2AFW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2012 20:05:22 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org,
	linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	arend@broadcom.com, m@bues.ch, ralf@linux-mips.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/8] MIPS: bcm47xx: read baordrev without prefix from sprom
Date: Sun, 29 Apr 2012 02:04:09 +0200
Message-Id: <1335657853-23925-5-git-send-email-hauke@hauke-m.de> (sfid-20120429_020527_675792_47865E3E)
In-Reply-To: <1335657853-23925-1-git-send-email-hauke@hauke-m.de>
References: <1335657853-23925-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the boardrev with a prefix is not available, try to read it
without a prefix. This is based on code from the Broadcom SDK.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 arch/mips/bcm47xx/sprom.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/bcm47xx/sprom.c b/arch/mips/bcm47xx/sprom.c
index a29d207..17282e0 100644
--- a/arch/mips/bcm47xx/sprom.c
+++ b/arch/mips/bcm47xx/sprom.c
@@ -165,6 +165,8 @@ static void bcm47xx_fill_sprom_r1234589(struct ssb_sprom *sprom,
 					const char *prefix)
 {
 	nvram_read_u16(prefix, NULL, "boardrev", &sprom->board_rev, 0);
+	if (!sprom->board_rev)
+		nvram_read_u16(NULL, NULL, "boardrev", &sprom->board_rev, 0);
 	nvram_read_u16(prefix, NULL, "boardnum", &sprom->board_num, 0);
 	nvram_read_u8(prefix, NULL, "ledbh0", &sprom->gpio0, 0xff);
 	nvram_read_u8(prefix, NULL, "ledbh1", &sprom->gpio1, 0xff);
-- 
1.7.9.5

