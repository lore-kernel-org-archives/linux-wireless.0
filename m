Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:40970 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966255Ab3DQMH3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 08:07:29 -0400
From: stf_xl@wp.pl
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH v2 02/11] rt2800: move rf init calibration code
Date: Wed, 17 Apr 2013 14:08:11 +0200
Message-Id: <1366200500-4661-3-git-send-email-stf_xl@wp.pl> (sfid-20130417_140807_156909_68C05977)
In-Reply-To: <1366200500-4661-1-git-send-email-stf_xl@wp.pl>
References: <1366200500-4661-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Add separate function for rf init calibration code and use it
on all init rf subroutines.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   54 ++++++++++++++++++------------
 1 files changed, 32 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 22c10e1..6e9ca3e 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4396,6 +4396,19 @@ static u8 rt2800_init_rx_filter(struct rt2x00_dev *rt2x00dev,
 	return rfcsr24;
 }
 
+static void rt2800_rf_init_calibration(struct rt2x00_dev *rt2x00dev,
+				       const unsigned int rf_reg)
+{
+	u8 rfcsr;
+
+	rt2800_rfcsr_read(rt2x00dev, rf_reg, &rfcsr);
+	rt2x00_set_field8(&rfcsr, FIELD8(0x80), 1);
+	rt2800_rfcsr_write(rt2x00dev, rf_reg, rfcsr);
+	msleep(1);
+	rt2x00_set_field8(&rfcsr, FIELD8(0x80), 0);
+	rt2800_rfcsr_write(rt2x00dev, rf_reg, rfcsr);
+}
+
 static void rt2800_normal_mode_setup_5xxx(struct rt2x00_dev *rt2x00dev)
 {
 	u8 reg;
@@ -4427,6 +4440,8 @@ static void rt2800_normal_mode_setup_5xxx(struct rt2x00_dev *rt2x00dev)
 
 static void rt2800_init_rfcsr_305x_soc(struct rt2x00_dev *rt2x00dev)
 {
+	rt2800_rf_init_calibration(rt2x00dev, 30);
+
 	rt2800_rfcsr_write(rt2x00dev, 0, 0x50);
 	rt2800_rfcsr_write(rt2x00dev, 1, 0x01);
 	rt2800_rfcsr_write(rt2x00dev, 2, 0xf7);
@@ -4463,6 +4478,9 @@ static void rt2800_init_rfcsr_305x_soc(struct rt2x00_dev *rt2x00dev)
 
 static void rt2800_init_rfcsr_30xx(struct rt2x00_dev *rt2x00dev)
 {
+	/* XXX vendor driver do this only for 3070 */
+	rt2800_rf_init_calibration(rt2x00dev, 30);
+
 	rt2800_rfcsr_write(rt2x00dev, 4, 0x40);
 	rt2800_rfcsr_write(rt2x00dev, 5, 0x03);
 	rt2800_rfcsr_write(rt2x00dev, 6, 0x02);
@@ -4486,6 +4504,8 @@ static void rt2800_init_rfcsr_30xx(struct rt2x00_dev *rt2x00dev)
 
 static void rt2800_init_rfcsr_3290(struct rt2x00_dev *rt2x00dev)
 {
+	rt2800_rf_init_calibration(rt2x00dev, 2);
+
 	rt2800_rfcsr_write(rt2x00dev, 1, 0x0f);
 	rt2800_rfcsr_write(rt2x00dev, 2, 0x80);
 	rt2800_rfcsr_write(rt2x00dev, 3, 0x08);
@@ -4536,6 +4556,8 @@ static void rt2800_init_rfcsr_3290(struct rt2x00_dev *rt2x00dev)
 
 static void rt2800_init_rfcsr_3352(struct rt2x00_dev *rt2x00dev)
 {
+	rt2800_rf_init_calibration(rt2x00dev, 30);
+
 	rt2800_rfcsr_write(rt2x00dev, 0, 0xf0);
 	rt2800_rfcsr_write(rt2x00dev, 1, 0x23);
 	rt2800_rfcsr_write(rt2x00dev, 2, 0x50);
@@ -4603,6 +4625,8 @@ static void rt2800_init_rfcsr_3352(struct rt2x00_dev *rt2x00dev)
 
 static void rt2800_init_rfcsr_3390(struct rt2x00_dev *rt2x00dev)
 {
+	rt2800_rf_init_calibration(rt2x00dev, 30);
+
 	rt2800_rfcsr_write(rt2x00dev, 0, 0xa0);
 	rt2800_rfcsr_write(rt2x00dev, 1, 0xe1);
 	rt2800_rfcsr_write(rt2x00dev, 2, 0xf1);
@@ -4639,6 +4663,8 @@ static void rt2800_init_rfcsr_3390(struct rt2x00_dev *rt2x00dev)
 
 static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
 {
+	rt2800_rf_init_calibration(rt2x00dev, 30);
+
 	rt2800_rfcsr_write(rt2x00dev, 0, 0x70);
 	rt2800_rfcsr_write(rt2x00dev, 1, 0x81);
 	rt2800_rfcsr_write(rt2x00dev, 2, 0xf1);
@@ -4674,6 +4700,8 @@ static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
 
 static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
 {
+	rt2800_rf_init_calibration(rt2x00dev, 2);
+
 	rt2800_rfcsr_write(rt2x00dev, 1, 0x0f);
 	rt2800_rfcsr_write(rt2x00dev, 2, 0x80);
 	rt2800_rfcsr_write(rt2x00dev, 3, 0x88);
@@ -4760,6 +4788,8 @@ static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
 
 static void rt2800_init_rfcsr_5392(struct rt2x00_dev *rt2x00dev)
 {
+	rt2800_rf_init_calibration(rt2x00dev, 2);
+
 	rt2800_rfcsr_write(rt2x00dev, 1, 0x17);
 	rt2800_rfcsr_write(rt2x00dev, 2, 0x80);
 	rt2800_rfcsr_write(rt2x00dev, 3, 0x88);
@@ -4825,6 +4855,8 @@ static void rt2800_init_rfcsr_5392(struct rt2x00_dev *rt2x00dev)
 
 static void rt2800_init_rfcsr_5592(struct rt2x00_dev *rt2x00dev)
 {
+	rt2800_rf_init_calibration(rt2x00dev, 30);
+
 	rt2800_rfcsr_write(rt2x00dev, 1, 0x3F);
 	rt2800_rfcsr_write(rt2x00dev, 3, 0x08);
 	rt2800_rfcsr_write(rt2x00dev, 3, 0x08);
@@ -4882,28 +4914,6 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	    !rt2800_is_305x_soc(rt2x00dev))
 		return 0;
 
-	/*
-	 * Init RF calibration.
-	 */
-
-	if (rt2x00_rt(rt2x00dev, RT3290) ||
-	    rt2x00_rt(rt2x00dev, RT5390) ||
-	    rt2x00_rt(rt2x00dev, RT5392)) {
-		rt2800_rfcsr_read(rt2x00dev, 2, &rfcsr);
-		rt2x00_set_field8(&rfcsr, RFCSR2_RESCAL_EN, 1);
-		rt2800_rfcsr_write(rt2x00dev, 2, rfcsr);
-		msleep(1);
-		rt2x00_set_field8(&rfcsr, RFCSR2_RESCAL_EN, 0);
-		rt2800_rfcsr_write(rt2x00dev, 2, rfcsr);
-	} else {
-		rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
-		rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
-		rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
-		msleep(1);
-		rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 0);
-		rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
-	}
-
 	if (rt2800_is_305x_soc(rt2x00dev)) {
 		rt2800_init_rfcsr_305x_soc(rt2x00dev);
 		return 0;
-- 
1.7.4.4

