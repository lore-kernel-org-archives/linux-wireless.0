Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:2749 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752111Ab1KPWQc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 17:16:32 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.org>
Cc: <linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH] rt2x00: Fix efuse EEPROM reading on PPC32.
Date: Wed, 16 Nov 2011 23:16:15 +0100
Message-Id: <1321481775-10853-1-git-send-email-gwingerde@gmail.com> (sfid-20111116_231640_730656_D310E44D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix __le32 to __le16 conversion of the first word of an 8-word block
of EEPROM read via the efuse method.

Reported-and-tested-by: Ingvar Hagelund <ingvar@redpill-linpro.com>
Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
CC: <stable@vger.kernel.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 3f183a1..1ba079d 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3771,7 +3771,7 @@ static void rt2800_efuse_read(struct rt2x00_dev *rt2x00dev, unsigned int i)
 	/* Apparently the data is read from end to start */
 	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA3, &reg);
 	/* The returned value is in CPU order, but eeprom is le */
-	rt2x00dev->eeprom[i] = cpu_to_le32(reg);
+	*(u32 *)&rt2x00dev->eeprom[i] = cpu_to_le32(reg);
 	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA2, &reg);
 	*(u32 *)&rt2x00dev->eeprom[i + 2] = cpu_to_le32(reg);
 	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA1, &reg);
-- 
1.7.7

