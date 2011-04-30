Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55400 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337Ab1D3PSt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Apr 2011 11:18:49 -0400
Received: by eyx24 with SMTP id 24so1390656eyx.19
        for <linux-wireless@vger.kernel.org>; Sat, 30 Apr 2011 08:18:48 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/6] rt2x00: Fix optimize register access for rt2800pci
Date: Sat, 30 Apr 2011 17:14:49 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201104301713.47545.IvDoorn@gmail.com> <201104301714.24685.IvDoorn@gmail.com>
In-Reply-To: <201104301714.24685.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104301714.49872.IvDoorn@gmail.com> (sfid-20110430_171854_447936_8E68BB47)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch
	rt2x00: Optimize register access in rt2800pci
from Helmut Schaa missed one register call, namely
the rt2800_register_multiwrite which should be changed
to rt2x00pci_register_multiwrite.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 08d3947..cc4a54f 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -302,8 +302,8 @@ static int rt2800pci_write_firmware(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Write firmware to device.
 	 */
-	rt2800_register_multiwrite(rt2x00dev, FIRMWARE_IMAGE_BASE,
-				   data, len);
+	rt2x00pci_register_multiwrite(rt2x00dev, FIRMWARE_IMAGE_BASE,
+				      data, len);
 
 	rt2x00pci_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000);
 	rt2x00pci_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00001);
-- 
1.7.2.3

