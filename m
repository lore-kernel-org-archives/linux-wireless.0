Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679Ab2A3PSm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 10:18:42 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 3/4] rt2800: radio 3xxx: add channel switch calibration routines
Date: Mon, 30 Jan 2012 16:17:58 +0100
Message-Id: <1327936679-12576-3-git-send-email-sgruszka@redhat.com> (sfid-20120130_161845_447156_29B45B1A)
In-Reply-To: <1327936679-12576-1-git-send-email-sgruszka@redhat.com>
References: <1327936679-12576-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Synchronize code with Ralink driver:
2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPO
Based on functions:
RT33xx_ChipSwitchChannel
RT30xx_ChipSwitchChannel

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index a841918..b5dcc48 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1700,6 +1700,13 @@ static void rt2800_config_channel_rf3xxx(struct rt2x00_dev *rt2x00dev,
 	}
 	rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);
 
+	rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
+	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
+	msleep(1);
+	rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 0);
+	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
+
 	rt2800_rfcsr_read(rt2x00dev, 23, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR23_FREQ_OFFSET, rt2x00dev->freq_offset);
 	rt2800_rfcsr_write(rt2x00dev, 23, rfcsr);
@@ -1710,6 +1717,13 @@ static void rt2800_config_channel_rf3xxx(struct rt2x00_dev *rt2x00dev,
 	rt2800_rfcsr_read(rt2x00dev, 7, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR7_RF_TUNING, 1);
 	rt2800_rfcsr_write(rt2x00dev, 7, rfcsr);
+
+	rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
+	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
+	msleep(1);
+	rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 0);
+	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
 }
 
 static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
-- 
1.7.1

