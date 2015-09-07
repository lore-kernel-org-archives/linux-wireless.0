Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:45732 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbbIGKJY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2015 06:09:24 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 3/3] staging: wilc1000: fix potential memory leak
Date: Mon, 7 Sep 2015 19:09:31 +0900
Message-ID: <1441620571-23033-3-git-send-email-tony.cho@atmel.com> (sfid-20150907_120928_221566_47894D8D)
In-Reply-To: <1441620571-23033-1-git-send-email-tony.cho@atmel.com>
References: <1441620571-23033-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds kfree(mgmt_tx) when memory allocation of mgmt_tx->buff
fails in the second calls of kmalloc() to avoid the memory leak from mgmt_tx
first allocated before the second calls of kmalloc().

Signed-off-by: Tony Cho <tony.cho@atmel.com>
Signed-off-by: Chris Park <chirs.park@atmel.com>
---
 drivers/staging/wilc1000/linux_mon.c              | 1 +
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index b5db23f..dd80071 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -242,6 +242,7 @@ static int mon_mgmt_tx(struct net_device *dev, const u8 *buf, size_t len)
 	mgmt_tx->buff = kmalloc(len, GFP_ATOMIC);
 	if (mgmt_tx->buff == NULL) {
 		PRINT_ER("Failed to allocate memory for mgmt_tx buff\n");
+		kfree(mgmt_tx);
 		return WILC_FAIL;
 
 	}
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 663d0f8..cf76a33 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2533,6 +2533,7 @@ int WILC_WFI_mgmt_tx(struct wiphy *wiphy,
 		mgmt_tx->buff = WILC_MALLOC(buf_len);
 		if (mgmt_tx->buff == NULL) {
 			PRINT_ER("Failed to allocate memory for mgmt_tx buff\n");
+			kfree(mgmt_tx);
 			return WILC_FAIL;
 		}
 		memcpy(mgmt_tx->buff, buf, len);
-- 
1.9.1

