Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:37646 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab0DCLvI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Apr 2010 07:51:08 -0400
Received: by wwb17 with SMTP id 17so1758062wwb.19
        for <linux-wireless@vger.kernel.org>; Sat, 03 Apr 2010 04:51:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <t2qefe7343f1004030447i9d6f290fvd7dd317c63b5b61@mail.gmail.com>
References: <k2g880c1631004011414z59ce4547j1bcea7ad5aff7229@mail.gmail.com>
	<t2qefe7343f1004030447i9d6f290fvd7dd317c63b5b61@mail.gmail.com>
From: Luis Correia <luis.f.correia@gmail.com>
Date: Sat, 3 Apr 2010 12:49:53 +0100
Message-ID: <l2mefe7343f1004030449refb18c80l3a81242338a8a4a7@mail.gmail.com>
Subject: [PATCH V4] rt2x00: remove MCU requests for SoC platforms
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Ivo Van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ralink SoC platforms do not have an MCU.

Signed-off-by: Luis Correia <luis.f.correia@gmail.com>
---

Removed flag usage as per Gertjan suggestion.

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c
b/drivers/net/wireless/rt2x00/rt2800pci.c
index ce7e88e..1df2d44 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -60,6 +60,12 @@ static void rt2800pci_mcu_status(struct rt2x00_dev
*rt2x00dev, const u8 token)
       unsigned int i;
       u32 reg;

+       /*
+        * SOC devices don't support MCU requests.
+        */
+       if (rt2x00_is_soc(rt2x00dev))
+               return;
+
       for (i = 0; i < 200; i++) {
               rt2800_register_read(rt2x00dev, H2M_MAILBOX_CID, &reg);
