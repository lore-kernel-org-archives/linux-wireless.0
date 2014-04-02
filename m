Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:46013 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbaDBEAU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2014 00:00:20 -0400
Received: by mail-pb0-f45.google.com with SMTP id uo5so10856198pbc.4
        for <linux-wireless@vger.kernel.org>; Tue, 01 Apr 2014 21:00:20 -0700 (PDT)
From: Fariya Fatima <fariyaf@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Fariya Fatima <fariyaf@gmail.com>
Subject: [PATCH 4/6] rsi: Fixed issue relating to return value.
Date: Wed,  2 Apr 2014 09:29:53 +0530
Message-Id: <1396411195-5051-5-git-send-email-fariyaf@gmail.com> (sfid-20140402_060029_753256_3A447446)
In-Reply-To: <1396411195-5051-1-git-send-email-fariyaf@gmail.com>
References: <1396411195-5051-1-git-send-email-fariyaf@gmail.com>
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

