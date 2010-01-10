Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:34889 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254Ab0AJKxC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jan 2010 05:53:02 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Bob Copeland <me@bobcopeland.com>
Subject: Ath5k on 2.6.32 suddenly fails
Date: Sun, 10 Jan 2010 11:52:33 +0100
Cc: Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <201001101152.34316.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I just upgraded my AccessPoint to 2.6.32.3. It has an atheros wireless card,
which basically runs fine with ath5k. Well, it did run fine until I upgraded
to 2.6.32. I upgraded from 2.6.31, but I used compat-wireless-2009-10-28 for wireless.
(I'm not exactly sure on the compat package. Maybe it was even older. But it was stable).

I'm currently using the vanilla ath5k driver on 2.6.32.

So yesterday, after two days of uptime, the atheros card suddenly failed to
work at all. Completely dead.
Reloading the module only resulted in:
 11 Jan 10 11:11:28 quimby kernel: [163143.871947] ath5k phy0: failed to wakeup the MAC Chip

So I added a debug patch:

Index: linux-2.6.32/drivers/net/wireless/ath/ath5k/reset.c
===================================================================
--- linux-2.6.32.orig/drivers/net/wireless/ath/ath5k/reset.c	2010-01-10 11:16:00.000000000 +0100
+++ linux-2.6.32/drivers/net/wireless/ath/ath5k/reset.c	2010-01-10 11:27:03.000000000 +0100
@@ -223,6 +223,7 @@
 int ath5k_hw_set_power(struct ath5k_hw *ah, enum ath5k_power_mode mode,
 		bool set_chip, u16 sleep_duration)
 {
+	struct pci_dev *pdev = ah->ah_sc->pdev;
 	unsigned int i;
 	u32 staid, data;
 
@@ -273,7 +274,7 @@
 							AR5K_SLEEP_CTL);
 		udelay(15);
 
-		for (i = 200; i > 0; i--) {
+		for (i = 20000; i > 0; i--) {
 			/* Check if the chip did wake up */
 			if ((ath5k_hw_reg_read(ah, AR5K_PCICFG) &
 					AR5K_PCICFG_SPWR_DN) == 0)
@@ -286,8 +287,13 @@
 		}
 
 		/* Fail if the chip didn't wake up */
-		if (i == 0)
+		if (i == 0) {
+			u32 val;
+			int res = pci_read_config_dword(pdev, PCI_STATUS, &val);
+			printk("%d, 0x%08X\n", res, val);
 			return -EIO;
+		}
+		printk("Wakeup %d\n", i);
 
 		break;
 
Which resulted in these messages:

 35 Jan 10 11:28:30 quimby kernel: [164165.417931] 135, 0x00000000
 36 Jan 10 11:28:30 quimby kernel: [164165.417940] ath5k phy0: failed to wakeup the MAC Chip

So the card really is completely dead. It doesn't even respond to standard PCI reads.

Only a complete reboot (warmstart) of the machine brought it back to life.

-- 
Greetings, Michael.
