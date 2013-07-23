Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:50623 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab3GWFne (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jul 2013 01:43:34 -0400
Received: by mail-lb0-f179.google.com with SMTP id w20so5954862lbh.10
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jul 2013 22:43:31 -0700 (PDT)
From: =?UTF-8?q?Tomasz=20Mo=C5=84?= <desowin@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, bzhao@marvell.com,
	=?UTF-8?q?Tomasz=20Mo=C5=84?= <desowin@gmail.com>
Subject: [PATCH] mwifiex: Add missing endian conversion.
Date: Tue, 23 Jul 2013 07:42:49 +0200
Message-Id: <1374558169-6888-1-git-send-email-desowin@gmail.com> (sfid-20130723_074337_382695_579FE01F)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both type and pkt_len variables are in host endian and these should be in
Little Endian in the payload.

Signed-off-by: Tomasz Moń <desowin@gmail.com>
Acked-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 5ee5ed0..c9f3ecf 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1625,8 +1625,8 @@ static int mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
 	/* Allocate buffer and copy payload */
 	blk_size = MWIFIEX_SDIO_BLOCK_SIZE;
 	buf_block_len = (pkt_len + blk_size - 1) / blk_size;
-	*(u16 *) &payload[0] = (u16) pkt_len;
-	*(u16 *) &payload[2] = type;
+	*(__le16 *)&payload[0] = cpu_to_le16((u16)pkt_len);
+	*(__le16 *)&payload[2] = cpu_to_le16(type);
 
 	/*
 	 * This is SDIO specific header
-- 
1.8.3.msysgit.0

