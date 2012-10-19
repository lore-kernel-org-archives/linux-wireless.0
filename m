Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:52308 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab2JSTBB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2012 15:01:01 -0400
From: Marcel Holtmann <marcel@holtmann.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] NFC: Removed unused details from pn544.h header file
Date: Fri, 19 Oct 2012 11:56:21 -0700
Message-Id: <1350672981-29772-1-git-send-email-marcel@holtmann.org> (sfid-20121019_210104_727021_4864FB42)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The majority of the defines and structures from pn544.h are no
longer in use. So just remove them.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
---
 drivers/nfc/pn544.h | 62 -----------------------------------------------------
 1 file changed, 62 deletions(-)

diff --git a/drivers/nfc/pn544.h b/drivers/nfc/pn544.h
index 9890bba..299575c 100644
--- a/drivers/nfc/pn544.h
+++ b/drivers/nfc/pn544.h
@@ -23,67 +23,6 @@
 #ifndef _PN544_H_
 #define _PN544_H_
 
-#include <linux/i2c.h>
-
-#define PN544_DRIVER_NAME	"pn544"
-#define PN544_MAXWINDOW_SIZE	7
-#define PN544_WINDOW_SIZE	4
-#define PN544_RETRIES		10
-#define PN544_MAX_I2C_TRANSFER	0x0400
-#define PN544_MSG_MAX_SIZE	0x21 /* at normal HCI mode */
-
-/* ioctl */
-#define PN544_CHAR_BASE		'P'
-#define PN544_IOR(num, dtype)	_IOR(PN544_CHAR_BASE, num, dtype)
-#define PN544_IOW(num, dtype)	_IOW(PN544_CHAR_BASE, num, dtype)
-#define PN544_GET_FW_MODE	PN544_IOW(1, unsigned int)
-#define PN544_SET_FW_MODE	PN544_IOW(2, unsigned int)
-#define PN544_GET_DEBUG		PN544_IOW(3, unsigned int)
-#define PN544_SET_DEBUG		PN544_IOW(4, unsigned int)
-
-/* Timing restrictions (ms) */
-#define PN544_RESETVEN_TIME	30 /* 7 */
-#define PN544_PVDDVEN_TIME	0
-#define PN544_VBATVEN_TIME	0
-#define PN544_GPIO4VEN_TIME	0
-#define PN544_WAKEUP_ACK	5
-#define PN544_WAKEUP_GUARD	(PN544_WAKEUP_ACK + 1)
-#define PN544_INACTIVITY_TIME	1000
-#define PN544_INTERFRAME_DELAY	200 /* us */
-#define PN544_BAUDRATE_CHANGE	150 /* us */
-
-/* Debug bits */
-#define PN544_DEBUG_BUF		0x01
-#define PN544_DEBUG_READ	0x02
-#define PN544_DEBUG_WRITE	0x04
-#define PN544_DEBUG_IRQ		0x08
-#define PN544_DEBUG_CALLS	0x10
-#define PN544_DEBUG_MODE	0x20
-
-/* Normal (HCI) mode */
-#define PN544_LLC_HCI_OVERHEAD	3 /* header + crc (to length) */
-#define PN544_LLC_MIN_SIZE	(1 + PN544_LLC_HCI_OVERHEAD) /* length + */
-#define PN544_LLC_MAX_DATA	(PN544_MSG_MAX_SIZE - 2)
-#define PN544_LLC_MAX_HCI_SIZE	(PN544_LLC_MAX_DATA - 2)
-
-struct pn544_llc_packet {
-	unsigned char length; /* of rest of packet */
-	unsigned char header;
-	unsigned char data[PN544_LLC_MAX_DATA]; /* includes crc-ccitt */
-};
-
-/* Firmware upgrade mode */
-#define PN544_FW_HEADER_SIZE	3
-/* max fw transfer is 1024bytes, but I2C limits it to 0xC0 */
-#define PN544_MAX_FW_DATA	(PN544_MAX_I2C_TRANSFER - PN544_FW_HEADER_SIZE)
-
-struct pn544_fw_packet {
-	unsigned char command; /* status in answer */
-	unsigned char length[2]; /* big-endian order (msf) */
-	unsigned char data[PN544_MAX_FW_DATA];
-};
-
-#ifdef __KERNEL__
 enum {
 	NFC_GPIO_ENABLE,
 	NFC_GPIO_FW_RESET,
@@ -99,6 +38,5 @@ struct pn544_nfc_platform_data {
 	void (*disable) (void);
 	int (*get_gpio)(int type);
 };
-#endif /* __KERNEL__ */
 
 #endif /* _PN544_H_ */
-- 
1.7.11.7

