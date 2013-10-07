Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 220-133-188-53.HINET-IP.hinet.net ([220.133.188.53]:34003 "EHLO
	ns.kevlo.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751917Ab3JGINH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 04:13:07 -0400
Date: Mon, 7 Oct 2013 16:02:01 +0800
From: Kevin Lo <kevlo@kevlo.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: [PATCH v2] rt2x00: rt2800lib: no need to toggle RF R30 bit 7 twice
Message-ID: <20131007080201.GA18265@ns.kevlo.org> (sfid-20131007_101310_904681_95C737B2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In rt2800_config_channel_rf3xxx(), there's no need to toggle
RF R30 bit 7 twice. 

Signed-off-by: Kevin Lo <kevlo@kevlo.org>
---
Changes since v1:
  - the previous patch was malformed
--- 

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 25aaa5e..65b4416 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2029,13 +2029,6 @@ static void rt2800_config_channel_rf3xxx(struct rt2x00_dev *rt2x00dev,
 			  rt2x00dev->default_ant.tx_chain_num <= 2);
 	rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);
 
-	rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
-	rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
-	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
-	msleep(1);
-	rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 0);
-	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
-
 	rt2800_rfcsr_read(rt2x00dev, 23, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR23_FREQ_OFFSET, rt2x00dev->freq_offset);
 	rt2800_rfcsr_write(rt2x00dev, 23, rfcsr);
