Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37113 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031099AbbKFCOR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:14:17 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 38/73] staging: wilc1000: fixes a struct allocation to match coding standards
Date: Fri, 6 Nov 2015 11:12:59 +0900
Message-ID: <1446776014-28094-38-git-send-email-glen.lee@atmel.com> (sfid-20151106_033806_672485_24DA0118)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fixes the checks reported by checkpatch.pl
for prefer kmalloc(sizeof(*tqe)...) over kmalloc(sizeof(struct txq_entry_t)...)

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 78a4359..0c08a9a 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -413,7 +413,7 @@ static int wilc_wlan_txq_add_cfg_pkt(u8 *buffer, u32 buffer_size)
 		return 0;
 	}
 
-	tqe = kmalloc(sizeof(struct txq_entry_t), GFP_ATOMIC);
+	tqe = kmalloc(sizeof(*tqe), GFP_ATOMIC);
 	if (!tqe) {
 		PRINT_ER("Failed to allocate memory\n");
 		return 0;
@@ -443,7 +443,7 @@ int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 	if (p->quit)
 		return 0;
 
-	tqe = kmalloc(sizeof(struct txq_entry_t), GFP_ATOMIC);
+	tqe = kmalloc(sizeof(*tqe), GFP_ATOMIC);
 
 	if (!tqe)
 		return 0;
@@ -472,7 +472,7 @@ int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
 	if (p->quit)
 		return 0;
 
-	tqe = kmalloc(sizeof(struct txq_entry_t), GFP_KERNEL);
+	tqe = kmalloc(sizeof(*tqe), GFP_KERNEL);
 
 	if (!tqe)
 		return 0;
-- 
1.9.1

