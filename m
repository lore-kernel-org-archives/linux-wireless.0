Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:35710 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752894AbdDJN35 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Apr 2017 09:29:57 -0400
Date: Mon, 10 Apr 2017 15:29:45 +0200
From: Daniel Golle <daniel@makrotopia.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v3] rt2x00: reverse external PA capability flag logic
Message-ID: <20170410132940.GA3308@makrotopia.org> (sfid-20170410_153004_185497_5575C2BE)
References: <20170410130614.GA8462@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170410130614.GA8462@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Consequently refer to external PA instead of inverting the logic and
use an internal PA capability flag which is a bit confusing.
Currently this is used for Rt3352 only, but MT7620A also allows for an
external PA which will be supported by a follow up patch.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
v3: fix typo in assignment of rfcsr register 51, thanks to Stanislaw
v2: replace remaining use of int_pa_* variables

 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 40 +++++++++++++-------------
 drivers/net/wireless/ralink/rt2x00/rt2x00.h    |  4 +--
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 201b12ed90c6..ba06ac2d876d 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -7014,9 +7014,9 @@ static void rt2800_init_rfcsr_3290(struct rt2x00_dev *rt2x00dev)
 
 static void rt2800_init_rfcsr_3352(struct rt2x00_dev *rt2x00dev)
 {
-	int tx0_int_pa = test_bit(CAPABILITY_INTERNAL_PA_TX0,
+	int tx0_ext_pa = test_bit(CAPABILITY_EXTERNAL_PA_TX0,
 				  &rt2x00dev->cap_flags);
-	int tx1_int_pa = test_bit(CAPABILITY_INTERNAL_PA_TX1,
+	int tx1_ext_pa = test_bit(CAPABILITY_EXTERNAL_PA_TX1,
 				  &rt2x00dev->cap_flags);
 	u8 rfcsr;
 
@@ -7056,9 +7056,9 @@ static void rt2800_init_rfcsr_3352(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 32, 0x80);
 	rt2800_rfcsr_write(rt2x00dev, 33, 0x00);
 	rfcsr = 0x01;
-	if (!tx0_int_pa)
+	if (tx0_ext_pa)
 		rt2x00_set_field8(&rfcsr, RFCSR34_TX0_EXT_PA, 1);
-	if (!tx1_int_pa)
+	if (tx1_ext_pa)
 		rt2x00_set_field8(&rfcsr, RFCSR34_TX1_EXT_PA, 1);
 	rt2800_rfcsr_write(rt2x00dev, 34, rfcsr);
 	rt2800_rfcsr_write(rt2x00dev, 35, 0x03);
@@ -7068,13 +7068,13 @@ static void rt2800_init_rfcsr_3352(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 39, 0xc5);
 	rt2800_rfcsr_write(rt2x00dev, 40, 0x33);
 	rfcsr = 0x52;
-	if (tx0_int_pa) {
+	if (!tx0_ext_pa) {
 		rt2x00_set_field8(&rfcsr, RFCSR41_BIT1, 1);
 		rt2x00_set_field8(&rfcsr, RFCSR41_BIT4, 1);
 	}
 	rt2800_rfcsr_write(rt2x00dev, 41, rfcsr);
 	rfcsr = 0x52;
-	if (tx1_int_pa) {
+	if (!tx1_ext_pa) {
 		rt2x00_set_field8(&rfcsr, RFCSR42_BIT1, 1);
 		rt2x00_set_field8(&rfcsr, RFCSR42_BIT4, 1);
 	}
@@ -7087,19 +7087,19 @@ static void rt2800_init_rfcsr_3352(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 48, 0x14);
 	rt2800_rfcsr_write(rt2x00dev, 49, 0x00);
 	rfcsr = 0x2d;
-	if (!tx0_int_pa)
+	if (tx0_ext_pa)
 		rt2x00_set_field8(&rfcsr, RFCSR50_TX0_EXT_PA, 1);
-	if (!tx1_int_pa)
+	if (tx1_ext_pa)
 		rt2x00_set_field8(&rfcsr, RFCSR50_TX1_EXT_PA, 1);
 	rt2800_rfcsr_write(rt2x00dev, 50, rfcsr);
-	rt2800_rfcsr_write(rt2x00dev, 51, (tx0_int_pa ? 0x7f : 0x52));
-	rt2800_rfcsr_write(rt2x00dev, 52, (tx0_int_pa ? 0x00 : 0xc0));
-	rt2800_rfcsr_write(rt2x00dev, 53, (tx0_int_pa ? 0x52 : 0xd2));
-	rt2800_rfcsr_write(rt2x00dev, 54, (tx0_int_pa ? 0x1b : 0xc0));
-	rt2800_rfcsr_write(rt2x00dev, 55, (tx1_int_pa ? 0x7f : 0x52));
-	rt2800_rfcsr_write(rt2x00dev, 56, (tx1_int_pa ? 0x00 : 0xc0));
-	rt2800_rfcsr_write(rt2x00dev, 57, (tx0_int_pa ? 0x52 : 0x49));
-	rt2800_rfcsr_write(rt2x00dev, 58, (tx1_int_pa ? 0x1b : 0xc0));
+	rt2800_rfcsr_write(rt2x00dev, 51, (tx0_ext_pa ? 0x52 : 0x7f));
+	rt2800_rfcsr_write(rt2x00dev, 52, (tx0_ext_pa ? 0xc0 : 0x00));
+	rt2800_rfcsr_write(rt2x00dev, 53, (tx0_ext_pa ? 0xd2 : 0x52));
+	rt2800_rfcsr_write(rt2x00dev, 54, (tx0_ext_pa ? 0xc0 : 0x1b));
+	rt2800_rfcsr_write(rt2x00dev, 55, (tx1_ext_pa ? 0x52 : 0x7f));
+	rt2800_rfcsr_write(rt2x00dev, 56, (tx1_ext_pa ? 0xc0 : 0x00));
+	rt2800_rfcsr_write(rt2x00dev, 57, (tx0_ext_pa ? 0x49 : 0x52));
+	rt2800_rfcsr_write(rt2x00dev, 58, (tx1_ext_pa ? 0xc0 : 0x1b));
 	rt2800_rfcsr_write(rt2x00dev, 59, 0x00);
 	rt2800_rfcsr_write(rt2x00dev, 60, 0x00);
 	rt2800_rfcsr_write(rt2x00dev, 61, 0x00);
@@ -8782,13 +8782,13 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2800_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
 
 	if (rt2x00_rt(rt2x00dev, RT3352)) {
-		if (!rt2x00_get_field16(eeprom,
+		if (rt2x00_get_field16(eeprom,
 		    EEPROM_NIC_CONF1_EXTERNAL_TX0_PA_3352))
-		    __set_bit(CAPABILITY_INTERNAL_PA_TX0,
+		    __set_bit(CAPABILITY_EXTERNAL_PA_TX0,
 			      &rt2x00dev->cap_flags);
-		if (!rt2x00_get_field16(eeprom,
+		if (rt2x00_get_field16(eeprom,
 		    EEPROM_NIC_CONF1_EXTERNAL_TX1_PA_3352))
-		    __set_bit(CAPABILITY_INTERNAL_PA_TX1,
+		    __set_bit(CAPABILITY_EXTERNAL_PA_TX1,
 			      &rt2x00dev->cap_flags);
 	}
 
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index 8fdd2f9726ee..1bc353eafe37 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -719,8 +719,8 @@ enum rt2x00_capability_flags {
 	CAPABILITY_DOUBLE_ANTENNA,
 	CAPABILITY_BT_COEXIST,
 	CAPABILITY_VCO_RECALIBRATION,
-	CAPABILITY_INTERNAL_PA_TX0,
-	CAPABILITY_INTERNAL_PA_TX1,
+	CAPABILITY_EXTERNAL_PA_TX0,
+	CAPABILITY_EXTERNAL_PA_TX1,
 };
 
 /*
-- 
2.12.1
