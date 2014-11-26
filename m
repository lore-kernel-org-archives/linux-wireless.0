Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132AbaKZOcT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 09:32:19 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com,
	Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 2/4] rt2x00: change REGISTER_BUSY_COUNT for USB
Date: Wed, 26 Nov 2014 15:29:14 +0100
Message-Id: <1417012156-26197-2-git-send-email-sgruszka@redhat.com> (sfid-20141126_153233_283744_618B0432)
In-Reply-To: <1417012156-26197-1-git-send-email-sgruszka@redhat.com>
References: <1417012156-26197-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Because of delays on USB we do not have to iterate so many times on
USB hardware when waiting for H/W register become valid.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c | 8 ++++----
 drivers/net/wireless/rt2x00/rt2x00.h    | 5 ++++-
 drivers/net/wireless/rt2x00/rt2x00usb.c | 2 +-
 drivers/net/wireless/rt2x00/rt73usb.c   | 2 +-
 4 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index c878e3f..05c6459 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -47,7 +47,7 @@ MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
  * BBP and RF register require indirect register access,
  * and use the CSR registers BBPCSR and RFCSR to achieve this.
  * These indirect registers work with busy bits,
- * and we will try maximal REGISTER_BUSY_COUNT times to access
+ * and we will try maximal REGISTER_USB_BUSY_COUNT times to access
  * the register while taking a REGISTER_BUSY_DELAY us delay
  * between each attampt. When the busy bit is still set at that time,
  * the access attempt is considered to have failed,
@@ -122,7 +122,7 @@ static int rt2500usb_regbusy_read(struct rt2x00_dev *rt2x00dev,
 {
 	unsigned int i;
 
-	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
+	for (i = 0; i < REGISTER_USB_BUSY_COUNT; i++) {
 		rt2500usb_register_read_lock(rt2x00dev, offset, reg);
 		if (!rt2x00_get_field16(*reg, field))
 			return 1;
@@ -904,7 +904,7 @@ static int rt2500usb_wait_bbp_ready(struct rt2x00_dev *rt2x00dev)
 	unsigned int i;
 	u8 value;
 
-	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
+	for (i = 0; i < REGISTER_USB_BUSY_COUNT; i++) {
 		rt2500usb_bbp_read(rt2x00dev, 0, &value);
 		if ((value != 0xff) && (value != 0x00))
 			return 0;
@@ -1023,7 +1023,7 @@ static int rt2500usb_set_state(struct rt2x00_dev *rt2x00dev,
 	 * We must wait until the register indicates that the
 	 * device has entered the correct state.
 	 */
-	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
+	for (i = 0; i < REGISTER_USB_BUSY_COUNT; i++) {
 		rt2500usb_register_read(rt2x00dev, MAC_CSR17, &reg2);
 		bbp_state = rt2x00_get_field16(reg2, MAC_CSR17_BBP_CURR_STATE);
 		rf_state = rt2x00_get_field16(reg2, MAC_CSR17_RF_CURR_STATE);
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index d13f25c..361fcad 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -1019,9 +1019,12 @@ struct rt2x00_bar_list_entry {
  * Register defines.
  * Some registers require multiple attempts before success,
  * in those cases REGISTER_BUSY_COUNT attempts should be
- * taken with a REGISTER_BUSY_DELAY interval.
+ * taken with a REGISTER_BUSY_DELAY interval. Due to USB
+ * bus delays, we do not have to loop so many times to wait
+ * for valid register value on that bus.
  */
 #define REGISTER_BUSY_COUNT	100
+#define REGISTER_USB_BUSY_COUNT 20
 #define REGISTER_BUSY_DELAY	100
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 258e2a8..c2346f8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -150,7 +150,7 @@ int rt2x00usb_regbusy_read(struct rt2x00_dev *rt2x00dev,
 	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
 		return -ENODEV;
 
-	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
+	for (i = 0; i < REGISTER_USB_BUSY_COUNT; i++) {
 		rt2x00usb_register_read_lock(rt2x00dev, offset, reg);
 		if (!rt2x00_get_field32(*reg, field))
 			return 1;
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 95724ff..a5458cf 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1295,7 +1295,7 @@ static int rt73usb_wait_bbp_ready(struct rt2x00_dev *rt2x00dev)
 	unsigned int i;
 	u8 value;
 
-	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
+	for (i = 0; i < REGISTER_USB_BUSY_COUNT; i++) {
 		rt73usb_bbp_read(rt2x00dev, 0, &value);
 		if ((value != 0xff) && (value != 0x00))
 			return 0;
-- 
1.8.3.1

