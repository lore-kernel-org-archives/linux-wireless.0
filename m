Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38421 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892Ab0F2TvU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 15:51:20 -0400
Received: by mail-wy0-f174.google.com with SMTP id 38so2999627wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jun 2010 12:51:20 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 20/21] rt2x00: Always set BBP_CSR_CFG_BBP_RW_MODE to 1
Date: Tue, 29 Jun 2010 21:49:26 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006292138.13509.IvDoorn@gmail.com> <201006292148.38803.IvDoorn@gmail.com> <201006292149.06304.IvDoorn@gmail.com>
In-Reply-To: <201006292149.06304.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006292149.27751.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivo van Doorn <IvDoorn@gmail.com>

Latest rt2870 legacy driver also sets BBP_CSR_CFG_BBP_RW_MODE to 1
when reading or writing the EEPROM. This means we can make the
BBP reading and writing completely equal on all platforms.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 0cf7796..f813b43 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -99,8 +99,7 @@ static void rt2800_bbp_write(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field32(&reg, BBP_CSR_CFG_REGNUM, word);
 		rt2x00_set_field32(&reg, BBP_CSR_CFG_BUSY, 1);
 		rt2x00_set_field32(&reg, BBP_CSR_CFG_READ_CONTROL, 0);
-		if (rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev))
-			rt2x00_set_field32(&reg, BBP_CSR_CFG_BBP_RW_MODE, 1);
+		rt2x00_set_field32(&reg, BBP_CSR_CFG_BBP_RW_MODE, 1);
 
 		rt2800_register_write_lock(rt2x00dev, BBP_CSR_CFG, reg);
 	}
@@ -128,8 +127,7 @@ static void rt2800_bbp_read(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field32(&reg, BBP_CSR_CFG_REGNUM, word);
 		rt2x00_set_field32(&reg, BBP_CSR_CFG_BUSY, 1);
 		rt2x00_set_field32(&reg, BBP_CSR_CFG_READ_CONTROL, 1);
-		if (rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev))
-			rt2x00_set_field32(&reg, BBP_CSR_CFG_BBP_RW_MODE, 1);
+		rt2x00_set_field32(&reg, BBP_CSR_CFG_BBP_RW_MODE, 1);
 
 		rt2800_register_write_lock(rt2x00dev, BBP_CSR_CFG, reg);
 
-- 
1.6.6.1

