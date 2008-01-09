Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:9383 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbYAISSd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2008 13:18:33 -0500
Received: by fk-out-0910.google.com with SMTP id z23so221899fkz.5
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jan 2008 10:18:29 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Subject: [PATCH] rt2x00: Corectly initialize rt2500usb MAC
Date: Wed, 9 Jan 2008 19:18:25 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801091918.26034.IvDoorn@gmail.com> (sfid-20080109_181838_228654_6CF032F3)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac is a pointer, obviously we shouldn't use the address
of a pointer as MAC address.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
John this is a really important fix.
Please queue this for 2.6.24 as well.

 drivers/net/wireless/rt2x00/rt2500usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 496cded..3084e24 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -310,7 +310,7 @@ static void rt2500usb_led_brightness(struct led_classdev *led_cdev,
 static void rt2500usb_config_mac_addr(struct rt2x00_dev *rt2x00dev,
 				      __le32 *mac)
 {
-	rt2500usb_register_multiwrite(rt2x00dev, MAC_CSR2, &mac,
+	rt2500usb_register_multiwrite(rt2x00dev, MAC_CSR2, mac,
 				      (3 * sizeof(__le16)));
 }
 
-- 
1.5.3.7

