Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37256 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031044AbbKFCPE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:15:04 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 46/73] staging: wilc1000: fixes braces {} are not necessary for any arm of this statement
Date: Fri, 6 Nov 2015 11:13:07 +0900
Message-ID: <1446776014-28094-46-git-send-email-glen.lee@atmel.com> (sfid-20151106_033804_896365_FCBF6D21)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fixes the warning reported by checkpatch.pl
for braces {} are not necessary for any arm of this statement

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 3b097c1..d7834c5 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1457,11 +1457,10 @@ static int wilc_wlan_cfg_commit(int type, u32 drvHandler)
 	int seq_no = p->cfg_seq_no % 256;
 	int driver_handler = (u32)drvHandler;
 
-	if (type == WILC_CFG_SET) {
+	if (type == WILC_CFG_SET)
 		cfg->wid_header[0] = 'W';
-	} else {
+	else
 		cfg->wid_header[0] = 'Q';
-	}
 	cfg->wid_header[1] = seq_no;
 	cfg->wid_header[2] = (u8)total_len;
 	cfg->wid_header[3] = (u8)(total_len >> 8);
-- 
1.9.1

