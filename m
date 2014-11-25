Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbaKYO6s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 09:58:48 -0500
Date: Tue, 25 Nov 2014 15:17:29 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ronald Wahl <ronald.wahl@raritan.com>,
	linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Mike Romberg <mike-romberg@comcast.net>,
	users@rt2x00.serialmonkey.com
Subject: [PATCH] rt2800: calculate tx power temperature compensation on
 selected chips
Message-ID: <20141125141728.GB2032@redhat.com> (sfid-20141125_155851_780920_675E410A)
References: <1415207010-9622-1-git-send-email-ronald.wahl@raritan.com>
 <20141106102753.GA1891@redhat.com>
 <20141120210859.GE31881@tuxdriver.com>
 <546F085B.3060408@raritan.com>
 <20141125135744.GA2032@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141125135744.GA2032@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently implemented temperature compensation is only valid on some of
supported chips. Other chips do not need temperature compensation or
need different way to do this (not yet implemented in the rt2800
driver). Trying to do run rt2800_get_gain_calibration_delta() when this
is not appropriate on particular chip gives bogus result of TX power
and can make connection unstable.

This is follow up to commit 8c8d2017ba25c510ddf093419048460db1109bc4
"rt2800: fix RT5390 & RT3290 TX power settings regression". On that
commit we avoid setting BBP_R1 register, but the real problem is wrong
temperature compensation calculation.

Reported-and-tested-by: Ronald Wahl <ronald.wahl@raritan.com>
Debugged-by: Ronald Wahl <ronald.wahl@raritan.com>
Cc: Mike Romberg <mike-romberg@comcast.net>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c | 45 +++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 9f57a2d..81ee481 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4119,7 +4119,20 @@ static void rt2800_config_txpower_rt28xx(struct rt2x00_dev *rt2x00dev,
 	 * expected. We adjust it, based on TSSI reference and boundaries values
 	 * provided in EEPROM.
 	 */
-	delta += rt2800_get_gain_calibration_delta(rt2x00dev);
+	switch (rt2x00dev->chip.rt) {
+	case RT2860:
+	case RT2872:
+	case RT2883:
+	case RT3070:
+	case RT3071:
+	case RT3090:
+	case RT3572:
+		delta += rt2800_get_gain_calibration_delta(rt2x00dev);
+		break;
+	default:
+		/* TODO: temperature compensation code for other chips. */
+		break;
+	}
 
 	/*
 	 * Decrease power according to user settings, on devices with unknown
@@ -4136,25 +4149,19 @@ static void rt2800_config_txpower_rt28xx(struct rt2x00_dev *rt2x00dev,
 	 * TODO: we do not use +6 dBm option to do not increase power beyond
 	 * regulatory limit, however this could be utilized for devices with
 	 * CAPABILITY_POWER_LIMIT.
-	 *
-	 * TODO: add different temperature compensation code for RT3290 & RT5390
-	 * to allow to use BBP_R1 for those chips.
-	 */
-	if (!rt2x00_rt(rt2x00dev, RT3290) &&
-	    !rt2x00_rt(rt2x00dev, RT5390)) {
-		rt2800_bbp_read(rt2x00dev, 1, &r1);
-		if (delta <= -12) {
-			power_ctrl = 2;
-			delta += 12;
-		} else if (delta <= -6) {
-			power_ctrl = 1;
-			delta += 6;
-		} else {
-			power_ctrl = 0;
-		}
-		rt2x00_set_field8(&r1, BBP1_TX_POWER_CTRL, power_ctrl);
-		rt2800_bbp_write(rt2x00dev, 1, r1);
+	 */
+	if (delta <= -12) {
+		power_ctrl = 2;
+		delta += 12;
+	} else if (delta <= -6) {
+		power_ctrl = 1;
+		delta += 6;
+	} else {
+		power_ctrl = 0;
 	}
+	rt2800_bbp_read(rt2x00dev, 1, &r1);
+	rt2x00_set_field8(&r1, BBP1_TX_POWER_CTRL, power_ctrl);
+	rt2800_bbp_write(rt2x00dev, 1, r1);
 
 	offset = TX_PWR_CFG_0;
 
-- 
1.8.3.1

