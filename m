Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:40896 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933394Ab1INVvE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 17:51:04 -0400
Received: by yie30 with SMTP id 30so1788041yie.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Sep 2011 14:51:03 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Stable <stable@kernel.org>
Subject: [PATCH 2/2] rtl2800usb: Fix incorrect storage of MAC address on big-endian platforms
Date: Wed, 14 Sep 2011 16:50:23 -0500
Message-Id: <1316037024-17340-3-git-send-email-Larry.Finger@lwfinger.net> (sfid-20110914_235115_700222_0000FEF6)
In-Reply-To: <1316037024-17340-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1316037024-17340-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The eeprom data is stored in little-endian order in the rt2x00 library.
As it was converted to cpu order in the read routines, the data need to
be converted to LE on a big-endian platform.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@kernel.org>
---

 drivers/net/wireless/rt2x00/rt2800lib.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 23568af..0019dfd 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3697,14 +3697,15 @@ static void rt2800_efuse_read(struct rt2x00_dev *rt2x00dev, unsigned int i)
 	rt2800_regbusy_read(rt2x00dev, EFUSE_CTRL, EFUSE_CTRL_KICK, &reg);
 
 	/* Apparently the data is read from end to start */
-	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA3,
-					(u32 *)&rt2x00dev->eeprom[i]);
-	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA2,
-					(u32 *)&rt2x00dev->eeprom[i + 2]);
-	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA1,
-					(u32 *)&rt2x00dev->eeprom[i + 4]);
-	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA0,
-					(u32 *)&rt2x00dev->eeprom[i + 6]);
+	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA3, &reg);
+	/* The returned value is in CPU order, but eeprom is le */
+	rt2x00dev->eeprom[i] = cpu_to_le32(reg);
+	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA2, &reg);
+	*(u32 *)&rt2x00dev->eeprom[i + 2] = cpu_to_le32(reg);
+	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA1, &reg);
+	*(u32 *)&rt2x00dev->eeprom[i + 4] = cpu_to_le32(reg);
+	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA0, &reg);
+	*(u32 *)&rt2x00dev->eeprom[i + 6] = cpu_to_le32(reg);
 
 	mutex_unlock(&rt2x00dev->csr_mutex);
 }
-- 
1.7.6.1

