Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.229]:42227 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbYGVVxk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 17:53:40 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2068481rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2008 14:53:39 -0700 (PDT)
Message-ID: <2da21fe50807221453m5275f59dj7369da5e667815d7@mail.gmail.com> (sfid-20080722_235343_852753_2B55D1CD)
Date: Tue, 22 Jul 2008 23:53:39 +0200
From: "Davide Pesavento" <davidepesa@gmail.com>
To: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	ath9k-devel@lists.ath9k.org
Subject: AR5418 works with ath9k
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Great news!

Today I applied ath9k patches on top of linux-wireless git tree on a
MacBookPro2,2 and I found that it works! (after a little bit of
hacking...)

First of all, my hardware is the following:

# lspci -v
03:00.0 Network controller: Atheros Communications Inc. AR5418
802.11abgn Wireless PCI Express Adapter (rev 01)
        Flags: bus master, fast devsel, latency 0, IRQ 17
        Memory at 98100000 (64-bit, non-prefetchable) [size=64K]
        Capabilities: [40] Power Management version 2
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable-
        Capabilities: [60] Express Legacy Endpoint, MSI 00
        Capabilities: [90] MSI-X: Enable- Mask- TabSize=1
        Kernel driver in use: ath9k
        Kernel modules: ath9k

# dmesg
[    7.760727] ath9k: 0.1
[    7.760727] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level,
low) -> IRQ 17
[    7.760727] PCI: Setting latency timer of device 0000:03:00.0 to 64
[    7.892753] Bad EEPROM checksum 0x866 or revision 0x000e
[    7.894551] phy0: Selected rate control algorithm 'ath9k_rate_control'
[    8.167891] phy0: Atheros 5416: mem=0xffffc20000500000, irq=17

The "bad eeprom checksum" message is printed (but the failure is
ignored) because I made a small change to ath9k/hw.c:

--------------------
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 5ebf35e..aa0a3d9 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -911,10 +911,10 @@ static inline enum hal_status
ath9k_hw_check_eeprom(struct ath_hal *ah)

        if (sum != 0xffff || ar5416_get_eep_ver(ahp) != AR5416_EEP_VER ||
            ar5416_get_eep_rev(ahp) < AR5416_EEP_NO_BACK_VER) {
-               HDPRINTF(ah, HAL_DBG_EEPROM,
+               printk(KERN_DEBUG
                         "Bad EEPROM checksum 0x%x or revision 0x%04x\n",
                         sum, ar5416_get_eep_ver(ahp));
-               return HAL_EEBADSUM;
+               //return HAL_EEBADSUM;
        }

        return HAL_OK;
--------------------

Without the above patch, the module would fail with the following error:
"ath_init: unable to attach hardware; HAL status 7"
Status code 7 is HAL_EEBADSUM indeed.

Maybe MacBook Pro's card has different eeprom's contents? Anyway the
card now works fine, and it also appears quite stable! ;-)
Thank you very much for your work!

Regards,

Davide

P.S.: I haven't been able to compile a kernel from wireless-testing
git tree with debug info + frame pointers, because they all failed to
boot very early (before console initialization). Is this a known bug?
