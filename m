Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:33445 "EHLO
        mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757504AbcILJno (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 05:43:44 -0400
Received: by mail-pa0-f67.google.com with SMTP id h5so7563262pao.0
        for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2016 02:43:43 -0700 (PDT)
From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
To: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        johannes.berg@intel.com, hofrat@osadl.org
Cc: prameela.j04cs@gmail.com, prameela.garnepudi@redpinesignals.com
Subject: [PATCH 7/9] rsi: zone changed for debug message and cleanup in file rsi_91x_sdio_ops.c
Date: Mon, 12 Sep 2016 15:08:22 +0530
Message-Id: <f04ae6642c7112e750cecb2f11876fe949102e3e.1473669618.git.prameela.j04cs@gmail.com> (sfid-20160912_114351_024774_A91FE710)
In-Reply-To: <cover.1473669618.git.prameela.j04cs@gmail.com>
References: <cover.1473669618.git.prameela.j04cs@gmail.com>
In-Reply-To: <cover.1473669618.git.prameela.j04cs@gmail.com>
References: <cover.1473669618.git.prameela.j04cs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
index 40d7231..4287360 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
@@ -36,7 +36,7 @@ static int rsi_sdio_master_access_msword(struct rsi_hw *adapter,
 
 	byte = (u8)(ms_word & 0x00FF);
 
-	rsi_dbg(INIT_ZONE,
+	rsi_dbg(INFO_ZONE,
 		"%s: MASTER_ACCESS_MSBYTE:0x%x\n", __func__, byte);
 
 	status = rsi_sdio_write_register(adapter,
@@ -52,7 +52,7 @@ static int rsi_sdio_master_access_msword(struct rsi_hw *adapter,
 
 	byte = (u8)(ms_word >> 8);
 
-	rsi_dbg(INIT_ZONE, "%s:MASTER_ACCESS_LSBYTE:0x%x\n", __func__, byte);
+	rsi_dbg(INFO_ZONE, "%s:MASTER_ACCESS_LSBYTE:0x%x\n", __func__, byte);
 	status = rsi_sdio_write_register(adapter,
 					 function,
 					 SDIO_MASTER_ACCESS_LSBYTE,
@@ -435,7 +435,7 @@ void rsi_interrupt_handler(struct rsi_hw *adapter)
 				} else {
 					rsi_dbg(ERR_ZONE,
 						"%s: Firmware Status is 0x%x\n",
-						__func__ , fw_status);
+						__func__, fw_status);
 					rsi_sdio_ack_intr(common->priv,
 							  (1 << FW_ASSERT_IND));
 				}
-- 
2.4.11
