Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42497 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab0H3TQb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 15:16:31 -0400
Received: by mail-ey0-f174.google.com with SMTP id 5so3422616eyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Aug 2010 12:16:30 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 05/10] rt2x00: Wakeup hardware before loading firmware
Date: Mon, 30 Aug 2010 21:13:54 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201008302112.25578.IvDoorn@gmail.com> <201008302113.09605.IvDoorn@gmail.com> <201008302113.31006.IvDoorn@gmail.com>
In-Reply-To: <201008302113.31006.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201008302113.55101.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to the legacy drivers the AUTOWAKEUP_CFG
register must be reset to 0 before loading the firmware.

Instead of during rt2800{pci,usb}_write_firmware it
must actually be done in rt2800_load_firmware() before
resetting the WPDMA_GLO_CFG and PWR_PIN_CFG registers.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    6 ++++++
 drivers/net/wireless/rt2x00/rt2800pci.c |    2 --
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index c8af221..1bc7f49 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -385,6 +385,12 @@ int rt2800_load_firmware(struct rt2x00_dev *rt2x00dev,
 	u32 reg;
 
 	/*
+	 * If driver doesn't wake up firmware here,
+	 * rt2800_load_firmware will hang forever when interface is up again.
+	 */
+	rt2800_register_write(rt2x00dev, AUTOWAKEUP_CFG, 0x00000000);
+
+	/*
 	 * Wait for stable hardware.
 	 */
 	if (rt2800_wait_csr_ready(rt2x00dev))
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 4d93204..2bcb150 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -196,8 +196,6 @@ static int rt2800pci_write_firmware(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg;
 
-	rt2800_register_write(rt2x00dev, AUTOWAKEUP_CFG, 0x00000000);
-
 	/*
 	 * enable Host program ram write selection
 	 */
-- 
1.7.2.2

