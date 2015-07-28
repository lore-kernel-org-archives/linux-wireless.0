Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:48122 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257AbbG1Ith (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2015 04:49:37 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 14/21] staging: wilc1000: remove warnings on unnecessary braces
Date: Tue, 28 Jul 2015 17:47:33 +0900
Message-ID: <1438073261-28315-15-git-send-email-tony.cho@atmel.com> (sfid-20150728_104945_386388_09B0F59C)
In-Reply-To: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
References: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the warnings reported by checkpatch.pl on the braces
{} not necessary for any arm of this statement.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 1621f91..5e7e3f0 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -654,11 +654,10 @@ static int sdio_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 		goto _fail_;
 	}
 	g_sdio.dPrint(N_ERR, "[wilc sdio]: chipid (%08x)\n", chipid);
-	if ((chipid & 0xfff) > 0x2a0) {
+	if ((chipid & 0xfff) > 0x2a0)
 		g_sdio.has_thrpt_enh3 = 1;
-	} else {
+	else
 		g_sdio.has_thrpt_enh3 = 0;
-	}
 	g_sdio.dPrint(N_ERR, "[wilc sdio]: has_thrpt_enh3 = %d...\n", g_sdio.has_thrpt_enh3);
 
 	return 1;
-- 
1.9.1

