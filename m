Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 220-133-188-53.HINET-IP.hinet.net ([220.133.188.53]:59071 "EHLO
	ns.kevlo.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751201Ab3JEOgn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Oct 2013 10:36:43 -0400
Message-ID: <525023D4.6000801@kevlo.org> (sfid-20131005_163658_157559_DA7EC832)
Date: Sat, 05 Oct 2013 22:36:04 +0800
From: Kevin Lo <kevlo@kevlo.org>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: [PATCH] rt2x00: rt2800lib: no need to toggle RF R30 bit 7 twice
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In rt2800_config_channel_rf3xxx(), there's no need to toggle
RF R30 bit 7 twice.

Signed-off-by: Kevin Lo <kevlo@kevlo.org>
---

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c 
b/drivers/net/wireless/rt2x00/rt2800lib.c
index 25aaa5e..65b4416 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2029,13 +2029,6 @@ static void rt2800_config_channel_rf3xxx(struct 
rt2x00_dev *rt2x00dev,
                           rt2x00dev->default_ant.tx_chain_num <= 2);
         rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);

-       rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
-       rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
-       rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
-       msleep(1);
-       rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 0);
-       rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
-
         rt2800_rfcsr_read(rt2x00dev, 23, &rfcsr);
         rt2x00_set_field8(&rfcsr, RFCSR23_FREQ_OFFSET, 
rt2x00dev->freq_offset);
         rt2800_rfcsr_write(rt2x00dev, 23, rfcsr);

