Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:33009 "EHLO
	mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbcAFNcQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2016 08:32:16 -0500
From: Anjali Menon <cse.anjalimenon@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org,
	Anjali Menon <cse.anjalimenon@gmail.com>
Subject: [PATCH] staging: wilc1000: Removed unnecessary braces
Date: Wed,  6 Jan 2016 18:59:51 +0530
Message-Id: <1452086991-6997-1-git-send-email-cse.anjalimenon@gmail.com> (sfid-20160106_143236_332280_2E7B519A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removed unnecessary braces for single statement blocks to
fix the warning detected by checkpatch.pl

WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Anjali Menon <cse.anjalimenon@gmail.com>
---
 drivers/staging/wilc1000/wilc_wlan_cfg.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index a34a81c..afb5d2c 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -251,9 +251,8 @@ static int wilc_wlan_cfg_set_bin(u8 *frame, u32 offset, u16 id, u8 *b, u32 size)
 
 	if ((b != NULL) && (size != 0)) {
 		memcpy(&buf[4], b, size);
-		for (i = 0; i < size; i++) {
+		for (i = 0; i < size; i++)
 			checksum += buf[i + 4];
-		}
 	}
 
 	buf[size + 4] = checksum;
-- 
1.9.1

