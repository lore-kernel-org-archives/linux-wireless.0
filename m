Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D132BC0015E
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Aug 2023 07:38:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbjHCHiZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 3 Aug 2023 03:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233772AbjHCHgh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2023 03:36:37 -0400
Received: from mail.nfschina.com (unknown [42.101.60.195])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id E293F30FF;
        Thu,  3 Aug 2023 00:35:00 -0700 (PDT)
Received: from localhost.localdomain (unknown [180.167.10.98])
        by mail.nfschina.com (Maildata Gateway V2.8.8) with ESMTPA id 6343E6091588C;
        Thu,  3 Aug 2023 15:34:58 +0800 (CST)
X-MD-Sfrom: yunchuan@nfschina.com
X-MD-SrcIP: 180.167.10.98
From:   Wu Yunchuan <yunchuan@nfschina.com>
To:     kvalo@kernel.org
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Wu Yunchuan <yunchuan@nfschina.com>
Subject: [PATCH net-next v2 2/9] wifi: rsi: rsi_91x_debugfs: Remove unnecessary (void*) conversions
Date:   Thu,  3 Aug 2023 15:34:55 +0800
Message-Id: <20230803073455.3666306-1-yunchuan@nfschina.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

No need cast (void*) to (struct rsi_91x_sdiodev *).

Signed-off-by: Wu Yunchuan <yunchuan@nfschina.com>
---
 drivers/net/wireless/rsi/rsi_91x_debugfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_debugfs.c b/drivers/net/wireless/rsi/rsi_91x_debugfs.c
index bf22fd948276..c528e6ca2c8d 100644
--- a/drivers/net/wireless/rsi/rsi_91x_debugfs.c
+++ b/drivers/net/wireless/rsi/rsi_91x_debugfs.c
@@ -28,8 +28,7 @@ static int rsi_sdio_stats_read(struct seq_file *seq, void *data)
 {
 	struct rsi_common *common = seq->private;
 	struct rsi_hw *adapter = common->priv;
-	struct rsi_91x_sdiodev *dev =
-		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
+	struct rsi_91x_sdiodev *dev = adapter->rsi_dev;
 
 	seq_printf(seq, "total_sdio_interrupts: %d\n",
 		   dev->rx_info.sdio_int_counter);
-- 
2.30.2

