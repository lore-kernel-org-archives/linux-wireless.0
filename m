Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:11126 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbbLUFPJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 00:15:09 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 01/46] staging: wilc1000: remove define COMPLEMENT_BOOT
Date: Mon, 21 Dec 2015 14:18:05 +0900
Message-ID: <1450675130-17866-2-git-send-email-glen.lee@atmel.com> (sfid-20151221_061512_833972_326F0710)
In-Reply-To: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
References: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes define COMPLEMENT_BOOT in Makefile. The feature was removed
by commit b46d68825c2d ('staging: wilc1000: remove COMPLEMENT_BOOT') but
the define was not removed. So remove completely.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/Makefile | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
index 198d536..c55fdd2 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -1,7 +1,5 @@
 obj-$(CONFIG_WILC1000) += wilc1000.o
 
-ccflags-$(CONFIG_WILC1000_SDIO) += -DCOMPLEMENT_BOOT
-
 ccflags-y += -DSTA_FIRMWARE=\"atmel/wilc1000_fw.bin\" \
 		-DAP_FIRMWARE=\"atmel/wilc1000_ap_fw.bin\" \
 		-DP2P_CONCURRENCY_FIRMWARE=\"atmel/wilc1000_p2p_fw.bin\"
-- 
1.9.1

