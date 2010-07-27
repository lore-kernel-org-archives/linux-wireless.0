Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513Ab0G0OsY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 10:48:24 -0400
Date: Tue, 27 Jul 2010 10:48:17 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: sgruszka@redhat.com, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Message-Id: <20100727144811.6012.56633.send-patch@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <20100727144804.6012.94740.send-patch@dhcp-lab-109.englab.brq.redhat.com>
References: <20100727144804.6012.94740.send-patch@dhcp-lab-109.englab.brq.redhat.com>
Subject: [PATCH w-t 2/3] rt2500usb: truly disable encryption when initialize
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Without cipher part nullify of TXRX_CSR0 register we can receive
corrupted frames (removed IV or IVC), after reloading rt2500usb module
with nohwcrypt=1 option, if previous some keys were configured into
the hardware.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 7892647..3028abb 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -813,6 +813,7 @@ static int rt2500usb_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2500usb_register_write(rt2x00dev, MAC_CSR8, reg);
 
 	rt2500usb_register_read(rt2x00dev, TXRX_CSR0, &reg);
+	rt2x00_set_field16(&reg, TXRX_CSR0_ALGORITHM, CIPHER_NONE);
 	rt2x00_set_field16(&reg, TXRX_CSR0_IV_OFFSET, IEEE80211_HEADER);
 	rt2x00_set_field16(&reg, TXRX_CSR0_KEY_ID, 0);
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR0, reg);
-- 
1.7.1

