Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:45711 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757683Ab3DSIN4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 04:13:56 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH] rt2x00: rt2800lib: rename rt2800_init_bbb_early to rt2800_init_bbp_early
Date: Fri, 19 Apr 2013 10:13:52 +0200
Message-Id: <1366359232-31513-1-git-send-email-juhosg@openwrt.org> (sfid-20130419_101406_820714_28FBD991)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function is used for BBP register initialization,
fix the typo in the function name to reflect that.

The patch contains no functional changes.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 72bbb96..4a87556 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3924,7 +3924,7 @@ static void rt2800_init_bbp_5592_glrt(struct rt2x00_dev *rt2x00dev)
 	}
 };
 
-static void rt2800_init_bbb_early(struct rt2x00_dev *rt2x00dev)
+static void rt2800_init_bbp_early(struct rt2x00_dev *rt2x00dev)
 {
 	rt2800_bbp_write(rt2x00dev, 65, 0x2C);
 	rt2800_bbp_write(rt2x00dev, 66, 0x38);
@@ -3950,7 +3950,7 @@ static void rt2800_init_bbp_5592(struct rt2x00_dev *rt2x00dev)
 	u16 eeprom;
 	u8 value;
 
-	rt2800_init_bbb_early(rt2x00dev);
+	rt2800_init_bbp_early(rt2x00dev);
 
 	rt2800_bbp_read(rt2x00dev, 105, &value);
 	rt2x00_set_field8(&value, BBP105_MLD,
-- 
1.7.10

