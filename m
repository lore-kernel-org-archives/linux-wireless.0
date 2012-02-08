Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56929 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2BHN0K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 08:26:10 -0500
Received: by daed14 with SMTP id d14so483656dae.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Feb 2012 05:26:09 -0800 (PST)
From: John Li <john.li.mediatek@gmail.com>
To: users@rt2x00.serialmonkey.com
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	John Li <chen-yang.li@mediatek.com>
Subject: [PATCH] rt2x00:Add debug message for new chipset
Date: Wed,  8 Feb 2012 21:25:24 +0800
Message-Id: <1328707524-11415-1-git-send-email-john.li.mediatek@gmail.com> (sfid-20120208_142614_025644_AE8464CB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: John Li <chen-yang.li@mediatek.com>

Signed-off-by: John Li <chen-yang.li@mediatek.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 22a1a8f..6bdf6d6 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3949,7 +3949,7 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	case RT5390:
 		break;
 	default:
-		ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
+		ERROR(rt2x00dev, "Invalid RT chipset 0x%04x detected.\n", rt2x00dev->chip.rt);
 		return -ENODEV;
 	}
 
@@ -3968,7 +3968,7 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	case RF5390:
 		break;
 	default:
-		ERROR(rt2x00dev, "Invalid RF chipset 0x%x detected.\n",
+		ERROR(rt2x00dev, "Invalid RF chipset 0x%04x detected.\n",
 		      rt2x00dev->chip.rf);
 		return -ENODEV;
 	}
-- 
1.7.6.5

