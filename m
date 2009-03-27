Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38102 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbZC0NNV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 09:13:21 -0400
Subject: [PATCH] rfkill: remove deprecated state constants
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 27 Mar 2009 14:12:46 +0100
Message-Id: <1238159566.4452.2.camel@johannes.local> (sfid-20090327_141340_972564_BD683700)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I only did superficial review (and assumed that wimax, being
written after rfkill, was OK), but these constants are stupid
to have and without proper warnings nobody will review the
code anyway.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 arch/arm/mach-pxa/tosa-bt.c |    4 ++--
 drivers/net/usb/hso.c       |    4 ++--
 include/linux/rfkill.h      |    8 --------
 net/wimax/op-rfkill.c       |    8 ++++----
 4 files changed, 8 insertions(+), 16 deletions(-)

--- wireless-testing.orig/include/linux/rfkill.h	2009-03-27 13:37:14.000000000 +0100
+++ wireless-testing/include/linux/rfkill.h	2009-03-27 14:11:28.000000000 +0100
@@ -52,14 +52,6 @@ enum rfkill_state {
 	RFKILL_STATE_MAX,		/* marker for last valid state */
 };
 
-/*
- * These are DEPRECATED, drivers using them should be verified to
- * comply with the rfkill usage guidelines in Documentation/rfkill.txt
- * and then converted to use the new names for rfkill_state
- */
-#define RFKILL_STATE_OFF RFKILL_STATE_SOFT_BLOCKED
-#define RFKILL_STATE_ON  RFKILL_STATE_UNBLOCKED
-
 /**
  * struct rfkill - rfkill control structure.
  * @name: Name of the switch.
--- wireless-testing.orig/arch/arm/mach-pxa/tosa-bt.c	2009-03-27 14:10:12.000000000 +0100
+++ wireless-testing/arch/arm/mach-pxa/tosa-bt.c	2009-03-27 14:10:28.000000000 +0100
@@ -38,9 +38,9 @@ static void tosa_bt_off(struct tosa_bt_d
 static int tosa_bt_toggle_radio(void *data, enum rfkill_state state)
 {
 	pr_info("BT_RADIO going: %s\n",
-			state == RFKILL_STATE_ON ? "on" : "off");
+			state == RFKILL_STATE_UNBLOCKED ? "on" : "off");
 
-	if (state == RFKILL_STATE_ON) {
+	if (state == RFKILL_STATE_UNBLOCKED) {
 		pr_info("TOSA_BT: going ON\n");
 		tosa_bt_on(data);
 	} else {
--- wireless-testing.orig/drivers/net/usb/hso.c	2009-03-27 14:10:36.000000000 +0100
+++ wireless-testing/drivers/net/usb/hso.c	2009-03-27 14:10:42.000000000 +0100
@@ -2477,7 +2477,7 @@ static int add_net_device(struct hso_dev
 static int hso_radio_toggle(void *data, enum rfkill_state state)
 {
 	struct hso_device *hso_dev = data;
-	int enabled = (state == RFKILL_STATE_ON);
+	int enabled = (state == RFKILL_STATE_UNBLOCKED);
 	int rv;
 
 	mutex_lock(&hso_dev->mutex);
@@ -2515,7 +2515,7 @@ static void hso_create_rfkill(struct hso
 	snprintf(rfkn, 20, "hso-%d",
 		 interface->altsetting->desc.bInterfaceNumber);
 	hso_net->rfkill->name = rfkn;
-	hso_net->rfkill->state = RFKILL_STATE_ON;
+	hso_net->rfkill->state = RFKILL_STATE_UNBLOCKED;
 	hso_net->rfkill->data = hso_dev;
 	hso_net->rfkill->toggle_radio = hso_radio_toggle;
 	if (rfkill_register(hso_net->rfkill) < 0) {
--- wireless-testing.orig/net/wimax/op-rfkill.c	2009-03-27 14:09:09.000000000 +0100
+++ wireless-testing/net/wimax/op-rfkill.c	2009-03-27 14:11:27.000000000 +0100
@@ -113,7 +113,7 @@ void wimax_report_rfkill_hw(struct wimax
 	if (state != wimax_dev->rf_hw) {
 		wimax_dev->rf_hw = state;
 		rfkill_state = state == WIMAX_RF_ON ?
-			RFKILL_STATE_OFF : RFKILL_STATE_ON;
+			RFKILL_STATE_SOFT_BLOCKED : RFKILL_STATE_UNBLOCKED;
 		if (wimax_dev->rf_hw == WIMAX_RF_ON
 		    && wimax_dev->rf_sw == WIMAX_RF_ON)
 			wimax_state = WIMAX_ST_READY;
@@ -259,10 +259,10 @@ int wimax_rfkill_toggle_radio(void *data
 
 	d_fnstart(3, dev, "(wimax_dev %p state %u)\n", wimax_dev, state);
 	switch (state) {
-	case RFKILL_STATE_ON:
+	case RFKILL_STATE_UNBLOCKED:
 		rf_state = WIMAX_RF_OFF;
 		break;
-	case RFKILL_STATE_OFF:
+	case RFKILL_STATE_SOFT_BLOCKED:
 		rf_state = WIMAX_RF_ON;
 		break;
 	default:
@@ -361,7 +361,7 @@ int wimax_rfkill_add(struct wimax_dev *w
 	wimax_dev->rfkill = rfkill;
 
 	rfkill->name = wimax_dev->name;
-	rfkill->state = RFKILL_STATE_OFF;
+	rfkill->state = RFKILL_STATE_SOFT_BLOCKED;
 	rfkill->data = wimax_dev;
 	rfkill->toggle_radio = wimax_rfkill_toggle_radio;
 	rfkill->user_claim_unsupported = 1;


