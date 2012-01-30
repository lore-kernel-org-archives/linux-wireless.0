Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679Ab2A3PSe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 10:18:34 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/4] rt2800: radio 3xxx: reprogram only lower bits of RF_R3
Date: Mon, 30 Jan 2012 16:17:56 +0100
Message-Id: <1327936679-12576-1-git-send-email-sgruszka@redhat.com> (sfid-20120130_161838_674804_F6EC7660)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Synchronize code with Ralink driver:
2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPO
(functions: RT33xx_ChipSwitchChannel() and RT30xx_ChipSwitchChannel())

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2800.h    |    5 +++++
 drivers/net/wireless/rt2x00/rt2800lib.c |    5 ++++-
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 2571a2f..abf2ae5 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -1796,6 +1796,11 @@ struct mac_iveiv_entry {
 #define RFCSR2_RESCAL_EN		FIELD8(0x80)
 
 /*
+ * RFCSR 3:
+ */
+#define RFCSR3_K			FIELD8(0x0f)
+
+/*
  * FRCSR 5:
  */
 #define RFCSR5_R1			FIELD8(0x0c)
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 22a1a8f..6edf566 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1649,7 +1649,10 @@ static void rt2800_config_channel_rf3xxx(struct rt2x00_dev *rt2x00dev,
 	u8 rfcsr;
 
 	rt2800_rfcsr_write(rt2x00dev, 2, rf->rf1);
-	rt2800_rfcsr_write(rt2x00dev, 3, rf->rf3);
+
+	rt2800_rfcsr_read(rt2x00dev, 3, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR3_K, rf->rf3);
+	rt2800_rfcsr_write(rt2x00dev, 3, rfcsr);
 
 	rt2800_rfcsr_read(rt2x00dev, 6, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR6_R1, rf->rf2);
-- 
1.7.1

