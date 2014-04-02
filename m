Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35558 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756889AbaDBCIW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2014 22:08:22 -0400
Received: by mail-pa0-f41.google.com with SMTP id fa1so10812728pad.28
        for <linux-wireless@vger.kernel.org>; Tue, 01 Apr 2014 19:08:22 -0700 (PDT)
From: Fariya Fatima <fariyaf@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Fariya Fatima <fariyaf@gmail.com>
Subject: [PATCH 4/6] rsi: Fixed issue relating to return value.
Date: Wed,  2 Apr 2014 07:38:03 +0530
Message-Id: <1396404485-3989-5-git-send-email-fariyaf@gmail.com> (sfid-20140402_040826_160517_E7B1D9A7)
In-Reply-To: <1396404485-3989-1-git-send-email-fariyaf@gmail.com>
References: <1396404485-3989-1-git-send-email-fariyaf@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fariya Fatima <fariyaf@gmail.com>

Signed-off-by: Fariya Fatima <fariyaf@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
index f1cb99c..20d11cc 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
@@ -247,7 +247,7 @@ static int rsi_process_pkt(struct rsi_common *common)
 	if (!common->rx_data_pkt) {
 		rsi_dbg(ERR_ZONE, "%s: Failed in memory allocation\n",
 			__func__);
-		return -1;
+		return -ENOMEM;
 	}
 
 	status = rsi_sdio_host_intf_read_pkt(adapter,
@@ -260,12 +260,10 @@ static int rsi_process_pkt(struct rsi_common *common)
 	}
 
 	status = rsi_read_pkt(common, rcv_pkt_len);
-	kfree(common->rx_data_pkt);
-	return status;
 
 fail:
 	kfree(common->rx_data_pkt);
-	return -1;
+	return status;
 }
 
 /**
-- 
1.7.5.4

