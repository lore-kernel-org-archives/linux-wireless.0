Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:50746 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130AbZHQQ4b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 12:56:31 -0400
Received: by ewy10 with SMTP id 10so3097928ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2009 09:56:32 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 6/7] rt2x00: Fix MCS register intialization
Date: Mon, 17 Aug 2009 18:55:40 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com,
	Benoit PAPILLAULT <benoit.papillault@free.fr>
References: <200908171853.24256.IvDoorn@gmail.com> <200908171854.50790.IvDoorn@gmail.com> <200908171855.15390.IvDoorn@gmail.com>
In-Reply-To: <200908171855.15390.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908171855.40486.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to the original Ralink driver,
LG_FBK_CFG0_OFDMMCS2FBK should be initialized to 9 rather then 3.

Based on a patch for rt2800pci from Benoit

Signed-off-by: Benoit PAPILLAULT <benoit.papillault@free.fr>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 3633e58..45e02f1 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1520,7 +1520,7 @@ static int rt2800usb_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00usb_register_read(rt2x00dev, LG_FBK_CFG0, &reg);
 	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS0FBK, 8);
 	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS1FBK, 8);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS2FBK, 3);
+	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS2FBK, 9);
 	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS3FBK, 10);
 	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS4FBK, 11);
 	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS5FBK, 12);
-- 
1.6.4

