Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62449 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab0H3TQf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 15:16:35 -0400
Received: by ewy23 with SMTP id 23so3413183ewy.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Aug 2010 12:16:34 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 07/10] rt2x00: Set PWR_PIN_CFG during initialization
Date: Mon, 30 Aug 2010 21:14:38 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201008302112.25578.IvDoorn@gmail.com> <201008302113.55101.IvDoorn@gmail.com> <201008302114.16125.IvDoorn@gmail.com>
In-Reply-To: <201008302114.16125.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201008302114.38933.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add PWR_PIN_CFG initialization for rt2800usb at the same point
as rt2800pci.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index b1a8e94..d275549 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -132,6 +132,8 @@ static int rt2800usb_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_read(rt2x00dev, PBF_SYS_CTRL, &reg);
 	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, reg & ~0x00002000);
 
+	rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);
+
 	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_CSR, 1);
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_BBP, 1);
-- 
1.7.2.2

