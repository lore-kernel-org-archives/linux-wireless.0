Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:2884 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751605Ab0ESP0O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 11:26:14 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 4/7] rt2x00: Simplify check for external LNA in rt2800_init_rfcsr.
Date: Wed, 19 May 2010 17:26:06 +0200
Message-Id: <1274282769-19244-5-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1274282769-19244-1-git-send-email-gwingerde@gmail.com>
References: <1274282769-19244-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of parsing the EEPROM information, use the flag that was set during
device initialization.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 5183249..d46d1b8 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2071,8 +2071,7 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	if (rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
 	    rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E) ||
 	    rt2x00_rt_rev_lt(rt2x00dev, RT3390, REV_RT3390E)) {
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC, &eeprom);
-		if (rt2x00_get_field16(eeprom, EEPROM_NIC_EXTERNAL_LNA_BG))
+		if (test_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags))
 			rt2x00_set_field8(&rfcsr, RFCSR17_R, 1);
 	}
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_TXMIXER_GAIN_BG, &eeprom);
-- 
1.7.1

