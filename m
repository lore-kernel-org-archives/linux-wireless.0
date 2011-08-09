Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1468 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab1HIL13 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 07:27:29 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl: Include scatterlist.h in hif.h to fix compilation error
Date: Tue, 9 Aug 2011 16:57:34 +0530
Message-ID: <1312889254-30996-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110809_132732_652578_25F0368B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/ath/ath6kl/hif.h:194: error: array type has incomplete element type
commit b7f080cfe223b3b7424872639d153695615a9255 exposes this issue. scatterlist.h used to
get included from dma-mapping.h<-dmaengine.h<-skbuff.h.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/hif.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/hif.h b/drivers/net/wireless/ath/ath6kl/hif.h
index 465876f..abd8798 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.h
+++ b/drivers/net/wireless/ath/ath6kl/hif.h
@@ -19,6 +19,7 @@
 
 #include "common.h"
 #include "core.h"
+#include <linux/scatterlist.h>
 
 #define BUS_REQUEST_MAX_NUM                64
 #define HIF_MBOX_BLOCK_SIZE                128
-- 
1.7.0.4

