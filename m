Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:51652 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223AbXENVHd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2007 17:07:33 -0400
Received: by ug-out-1314.google.com with SMTP id 44so1435187uga
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2007 14:07:32 -0700 (PDT)
To: "John Linville" <linville@tuxdriver.com>
Subject: [PATCH] eeprom_93cx6: Add comment for 1us delay after pulse
Date: Mon, 14 May 2007 23:06:01 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200705142306.01172.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will add a comment for the 1us delay which is taken
after the pulse has been switched. The 1us delay is based
on the specifications so that should be made clear.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/misc/eeprom_93cx6.c b/drivers/misc/eeprom_93cx6.c
index a948ddc..8c8b43f 100644
--- a/drivers/misc/eeprom_93cx6.c
+++ b/drivers/misc/eeprom_93cx6.c
@@ -39,6 +39,12 @@ static inline void eeprom_93cx6_pulse_high(struct eeprom_93cx6 *eeprom)
 {
 	eeprom->reg_data_clock = 1;
 	eeprom->register_write(eeprom);
+
+	/*
+	 * Add a short delay for the pulse to work.
+	 * According to the specifications the minimal time
+	 * should be 450ns so a 1us delay is sufficient.
+	 */
 	udelay(1);
 }
 
@@ -46,6 +52,12 @@ static inline void eeprom_93cx6_pulse_low(struct eeprom_93cx6 *eeprom)
 {
 	eeprom->reg_data_clock = 0;
 	eeprom->register_write(eeprom);
+
+	/*
+	 * Add a short delay for the pulse to work.
+	 * According to the specifications the minimal time
+	 * should be 450ns so a 1us delay is sufficient.
+	 */
 	udelay(1);
 }
 
