Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36640 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758363AbcLSKzO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Dec 2016 05:55:14 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 10/11] rt2800: replace msleep() with usleep_range() on channel switch
Date: Mon, 19 Dec 2016 11:52:56 +0100
Message-Id: <1482144777-16760-11-git-send-email-sgruszka@redhat.com> (sfid-20161219_120239_378724_FC90D445)
In-Reply-To: <1482144777-16760-1-git-send-email-sgruszka@redhat.com>
References: <1482144777-16760-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

msleep(1) can sleep much more time then requested 1ms, this is not good
on channel switch, which we want to be performed fast (i.e. to make scan
faster). Replace msleep() with usleep_range(), which has much smaller
maximum sleeping time boundary.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 29d98e4..0220184 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -2110,7 +2110,9 @@ static void rt2800_config_channel_rf3xxx(struct rt2x00_dev *rt2x00dev,
 	rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
 	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
-	msleep(1);
+
+	usleep_range(1000, 1500);
+
 	rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 0);
 	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
 }
@@ -3442,7 +3444,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		}
 	}
 
-	msleep(1);
+	usleep_range(1000, 1500);
 
 	/*
 	 * Clear channel statistic counters
-- 
1.7.1
