Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61775 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab0KDTn4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 15:43:56 -0400
Received: by mail-ew0-f46.google.com with SMTP id 7so1281934ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Nov 2010 12:43:56 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 10/13] rt2x00: Fix MCU_SLEEP arguments
Date: Thu, 4 Nov 2010 20:40:46 +0100
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
References: <201011042037.00178.IvDoorn@gmail.com> <201011042039.49521.IvDoorn@gmail.com> <201011042040.12419.IvDoorn@gmail.com>
In-Reply-To: <201011042040.12419.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011042040.47235.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Legacy driver uses 0xff as the second argument for the MCU_SLEEP
command. It is still unknown what the values actually mean, but
this will at least keep the command in-sync with the original
driver.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt2800usb.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 6dc61b7..1db0c3b 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -442,7 +442,7 @@ static int rt2800pci_set_state(struct rt2x00_dev *rt2x00dev,
 	 * if the device is booting and wasn't asleep it will return
 	 * failure when attempting to wakeup.
 	 */
-	rt2800_mcu_request(rt2x00dev, MCU_SLEEP, 0xff, 0, 2);
+	rt2800_mcu_request(rt2x00dev, MCU_SLEEP, 0xff, 0xff, 2);
 
 	if (state == STATE_AWAKE) {
 		rt2800_mcu_request(rt2x00dev, MCU_WAKEUP, TOKEN_WAKUP, 0, 0);
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 04dfedc..5c31e33 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -184,9 +184,9 @@ static int rt2800usb_set_state(struct rt2x00_dev *rt2x00dev,
 			       enum dev_state state)
 {
 	if (state == STATE_AWAKE)
-		rt2800_mcu_request(rt2x00dev, MCU_WAKEUP, 0xff, 0, 0);
+		rt2800_mcu_request(rt2x00dev, MCU_WAKEUP, 0xff, 0, 2);
 	else
-		rt2800_mcu_request(rt2x00dev, MCU_SLEEP, 0xff, 0, 2);
+		rt2800_mcu_request(rt2x00dev, MCU_SLEEP, 0xff, 0xff, 2);
 
 	return 0;
 }
-- 
1.7.2.3

