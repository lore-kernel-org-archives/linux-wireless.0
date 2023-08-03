Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5023C001E0
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Aug 2023 07:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbjHCHiq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 3 Aug 2023 03:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjHCHgw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2023 03:36:52 -0400
Received: from mail.nfschina.com (unknown [42.101.60.195])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 8C6613AA3;
        Thu,  3 Aug 2023 00:35:55 -0700 (PDT)
Received: from localhost.localdomain (unknown [180.167.10.98])
        by mail.nfschina.com (Maildata Gateway V2.8.8) with ESMTPA id 761F0609158A6;
        Thu,  3 Aug 2023 15:35:52 +0800 (CST)
X-MD-Sfrom: yunchuan@nfschina.com
X-MD-SrcIP: 180.167.10.98
From:   Wu Yunchuan <yunchuan@nfschina.com>
To:     kvalo@kernel.org
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Wu Yunchuan <yunchuan@nfschina.com>
Subject: [PATCH net-next v2 7/9] wifi: rsi: rsi_91x_sdio_ops: Remove unnecessary (void*) conversions
Date:   Thu,  3 Aug 2023 15:35:50 +0800
Message-Id: <20230803073550.3666829-1-yunchuan@nfschina.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

No need cast (void*) to (struct rsi_91x_sdiodev *).

Signed-off-by: Wu Yunchuan <yunchuan@nfschina.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
index b2b47a0abcbf..597b238e2294 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
@@ -88,8 +88,7 @@ void rsi_sdio_rx_thread(struct rsi_common *common)
 static int rsi_process_pkt(struct rsi_common *common)
 {
 	struct rsi_hw *adapter = common->priv;
-	struct rsi_91x_sdiodev *dev =
-		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
+	struct rsi_91x_sdiodev *dev = adapter->rsi_dev;
 	u8 num_blks = 0;
 	u32 rcv_pkt_len = 0;
 	int status = 0;
@@ -147,8 +146,7 @@ static int rsi_process_pkt(struct rsi_common *common)
  */
 int rsi_init_sdio_slave_regs(struct rsi_hw *adapter)
 {
-	struct rsi_91x_sdiodev *dev =
-		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
+	struct rsi_91x_sdiodev *dev = adapter->rsi_dev;
 	u8 function = 0;
 	u8 byte;
 	int status = 0;
@@ -233,8 +231,7 @@ int rsi_init_sdio_slave_regs(struct rsi_hw *adapter)
 static void rsi_rx_handler(struct rsi_hw *adapter)
 {
 	struct rsi_common *common = adapter->priv;
-	struct rsi_91x_sdiodev *dev =
-		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
+	struct rsi_91x_sdiodev *dev = adapter->rsi_dev;
 	int status;
 	u8 isr_status = 0;
 	u8 fw_status = 0;
@@ -339,8 +336,7 @@ static void rsi_rx_handler(struct rsi_hw *adapter)
 int rsi_sdio_check_buffer_status(struct rsi_hw *adapter, u8 q_num)
 {
 	struct rsi_common *common = adapter->priv;
-	struct rsi_91x_sdiodev *dev =
-		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
+	struct rsi_91x_sdiodev *dev = adapter->rsi_dev;
 	u8 buf_status = 0;
 	int status = 0;
 	static int counter = 4;
@@ -409,8 +405,7 @@ int rsi_sdio_check_buffer_status(struct rsi_hw *adapter, u8 q_num)
  */
 int rsi_sdio_determine_event_timeout(struct rsi_hw *adapter)
 {
-	struct rsi_91x_sdiodev *dev =
-		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
+	struct rsi_91x_sdiodev *dev = adapter->rsi_dev;
 
 	/* Once buffer full is seen, event timeout to occur every 2 msecs */
 	if (dev->rx_info.buffer_full)
-- 
2.30.2

