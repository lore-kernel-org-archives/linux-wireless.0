Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44064 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab1H2LyB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 07:54:01 -0400
Received: by wyg24 with SMTP id 24so3995857wyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Aug 2011 04:54:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD2nsn2Bbxxy9ZYpBe_QEqCkGYYROHE+j7qASRq3OkKmWD5PMg@mail.gmail.com>
References: <20110827113253.GA1444@ecki>
	<CAD2nsn2Bbxxy9ZYpBe_QEqCkGYYROHE+j7qASRq3OkKmWD5PMg@mail.gmail.com>
Date: Mon, 29 Aug 2011 17:23:58 +0530
Message-ID: <CAD2nsn1+5QWtzeG-3RHEJi8+oDthAfXYunHnDTLie84oJPOQuw@mail.gmail.com> (sfid-20110829_135406_728182_A80818ED)
Subject: Re: ath9k: irq storm after suspend/resume
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Clemens Buchacher <drizzd@aon.at>
Cc: linux-wireless@vger.kernel.org, beta992@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 29, 2011 at 1:25 PM, Mohammed Shafi
<shafi.wireless@gmail.com> wrote:
> On Sat, Aug 27, 2011 at 5:02 PM, Clemens Buchacher <drizzd@aon.at> wrote:
>> Hi,
>>
> Hi Clemens,
>
>> I am trying to debug this issue:
>> https://bugzilla.kernel.org/show_bug.cgi?id=39112
>>
>> An IRQ storm triggers during resume after suspend to RAM. The IRQ
>> storm also triggers during insmod after suspend/resume, even if
>> ath9k is not loaded during suspend.
>
> a recent commit, not sure this will help suspend/resume
>
> commit 0682c9b52bf51fbc67c4e79fcbdadcf70bd600f8
> Author: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> Date:   Sat Aug 13 10:28:09 2011 +0530
>
>    ath9k: Fix rx overrun interrupt storm
>
>    Whenever RXEOL is received, both RXORN and RXEOL got cleared
>    to avoid rx overrun interrupt storm. This was handled only for
>    edma chips. The same scenario was also observered with AR9280,
>    doing frequent channel type switch b/w HT20/40 with bidi traffic
>    that is causing failure to stop rx dma. This patch clears
>    the RXEOL & RXORN interrupts for all chips.
>
>
>>
>> In the former case, the IRQ storm happens right after the PCI
>> subsystem restores the config space for ath9k.
>>
>> In the latter case, the IRQ storm happens immediately after
>> request_irq in ath_pci_probe. So I have moved ath9k_init_device
>> ahead of request_irq, in order to call ath9k_hw_set_interrupts(ah,
>> 0) before enabling the interrupt.
>>
>> But still, the interrupts come. Note that according to
>> /proc/interrupts, the IRQ line is not shared with any other device.
>> I did not manage to determine which interrupt it is exactly,
>> because the device is not in a ready state (SC_OP_INVALID is set)
>> when they happen (in either scenario that triggers the IRQ storm).
>> And SC_OP_INVALID is cleared only much later in ath9k_start.
>>
>> So, I am at a loss. Any ideas?
>
> please provide the lspci -vvvxx.
> also looking at
> /sys/kernel/debug/ieee80211/phy0/ath9k$ sudo cat interrupt.

hi, i think this will help, please get the message sudo modprobe ath9k
debug=0xffffffff.
few fatal PCI interrupt messages are based on ATH_DEBUG_ANY.
thanks.

>
> also this additional information might help:
> in case have you seen this is happening in 32 bit also ?
> is this happening in wireless-testing  Linux 3.1-rc3 ? or the latest
> compat wireless?
> i did some preliminary testing, not able to recreate it. will try
> further.thanks!
>
>>
>> Below is the output I get during insmod'ing right after resume
>> (complete logs can be found in the bug report). Below that are the
>> changes I made to produce the output.
>>
>> Clemens
>> ---
>>
>> [   53.387989] ath9k 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
>> [   53.389306] ath9k 0000:02:00.0: setting latency timer to 64
>> [   53.389371] ath: reset power on
>> [   53.392725] ath: UNDEFINED -> AWAKE
>> [   53.392783] ath: serialize_regmode is 0
>> [   53.438096] ath: Eeprom VER: 14, REV: 13
>> [   53.438098] ath: Initialize ANI
>> [   53.438112] ath: Enable MIB counters
>> [   53.438143] ath: Setup TX queue: 9
>> [   53.438144] ath: Set queue properties for: 9
>> [   53.438146] ath: Setup TX queue: 8
>> [   53.438147] ath: Set queue properties for: 8
>> [   53.438149] ath: Set queue properties for: 8
>> [   53.438151] ath: Reset TX queue: 8
>> [   53.438176] ath: tx ok 0x0 err 0x0 desc 0x100 eol 0x100 urn 0x0
>> [   53.438178] ath: Setup TX queue: 0
>> [   53.438179] ath: Set queue properties for: 0
>> [   53.438181] ath: Setup TX queue: 1
>> [   53.438182] ath: Set queue properties for: 1
>> [   53.438184] ath: Setup TX queue: 2
>> [   53.438185] ath: Set queue properties for: 2
>> [   53.438186] ath: Setup TX queue: 3
>> [   53.438187] ath: Set queue properties for: 3
>> [   53.439692] ath: TX streams 1, RX streams: 1
>> [   53.439694] ath: EEPROM regdomain: 0x60
>> [   53.439695] ath: EEPROM indicates we should expect a direct regpair map
>> [   53.439698] ath: Country alpha2 being used: 00
>> [   53.439699] ath: Regpair used: 0x60
>> [   53.439702] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
>> [   53.439704] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
>> [   53.439706] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
>> [   53.439709] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
>> [   53.439710] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
>> [   53.439713] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
>> [   53.439714] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
>> [   53.439717] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
>> [   53.439719] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
>> [   53.439721] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
>> [   53.439723] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
>> [   53.439725] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
>> [   53.439727] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
>> [   53.439729] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
>> [   53.439731] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
>> [   53.439733] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
>> [   53.439735] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
>> [   53.439737] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
>> [   53.439739] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
>> [   53.439741] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
>> [   53.439743] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
>> [   53.439746] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
>> [   53.439747] cfg80211: Updating information on frequency 2467 MHz for a 20 MHz width channel with regulatory rule:
>> [   53.439750] cfg80211: 2457000 KHz - 2482000 KHz @  KHz), (N/A mBi, 2000 mBm)
>> [   53.439751] cfg80211: Updating information on frequency 2472 MHz for a 20 MHz width channel with regulatory rule:
>> [   53.439754] cfg80211: 2457000 KHz - 2482000 KHz @  KHz), (N/A mBi, 2000 mBm)
>> [   53.439756] cfg80211: Updating information on frequency 2484 MHz for a 20 MHz width channel with regulatory rule:
>> [   53.439758] cfg80211: 2474000 KHz - 2494000 KHz @  KHz), (N/A mBi, 2000 mBm)
>> [   53.439761] ath: tx DMA: 512 buffers 1 desc/buf
>> [   53.439772] ath: tx DMA map: ffff880071f90000 (54600) -> 71f90000 (54600)
>> [   53.439792] ath: beacon DMA: 4 buffers 1 desc/buf
>> [   53.439795] ath: beacon DMA map: ffff880071ecc000 (416) -> 71ecc000 (416)
>> [   53.439797] ath: cachelsz 64 rxbufsize 1926
>> [   53.439799] ath: rx DMA: 512 buffers 1 desc/buf
>> [   53.439811] ath: rx DMA map: ffff880071fb0000 (54600) -> 71fb0000 (54600)
>> [   53.441193] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
>> [   53.441269] ieee80211 phy1: Selected rate control algorithm 'ath9k_rate_control'
>> [   53.441628] Registered led device: ath9k-phy1
>> [   53.441641] ath9k: disabling interrupts
>> [   53.442979] ath: disable IER
>> [   53.442990] ath: 0x0 => 0x0
>> [   53.442992] ath: new IMR 0x0
>> [   53.443013] ath9k: requesting irq
>> [   53.444293] ath9k: interrupt with invalid flag set (1 times)
>> [   53.444296] wait 500 ms
>> [   53.446255] ath9k: interrupt with invalid flag set (2 times)
>> [   53.446288] ath9k: interrupt with invalid flag set (4 times)
>> [   53.446330] ath9k: interrupt with invalid flag set (8 times)
>> [   53.446374] ath9k: interrupt with invalid flag set (16 times)
>> [   53.446453] ath9k: interrupt with invalid flag set (32 times)
>> [   53.446572] ath9k: interrupt with invalid flag set (64 times)
>> [   53.446821] ath9k: interrupt with invalid flag set (128 times)
>> [   53.447319] ath9k: interrupt with invalid flag set (256 times)
>> [   53.448526] ath9k: interrupt with invalid flag set (512 times)
>> [   53.450942] ath9k: interrupt with invalid flag set (1024 times)
>> [   53.454793] ath9k: interrupt with invalid flag set (2048 times)
>> [   53.462493] ath9k: interrupt with invalid flag set (4096 times)
>> [   53.477738] ath9k: interrupt with invalid flag set (8192 times)
>> [   53.508164] ath9k: interrupt with invalid flag set (16384 times)
>> [   53.571798] ath9k: interrupt with invalid flag set (32768 times)
>> [   53.697472] ath9k: interrupt with invalid flag set (65536 times)
>> [   53.832522] irq 17: nobody cared (try booting with the "irqpoll" option)
>> [   53.834253] Pid: 0, comm: kworker/0:0 Tainted: G         C  3.1.0-rc2-ath9k-debug #16
>> [   53.835991] Call Trace:
>> [   53.837727]  <IRQ>  [<ffffffff810c64fd>] __report_bad_irq+0x3d/0xe0
>> [   53.839487]  [<ffffffff810c693d>] note_interrupt+0x14d/0x210
>> [   53.841220]  [<ffffffff810c49d9>] handle_irq_event_percpu+0xc9/0x2a0
>> [   53.842952]  [<ffffffff810c4bf8>] handle_irq_event+0x48/0x70
>> [   53.844659]  [<ffffffff810c727a>] handle_fasteoi_irq+0x5a/0xe0
>> [   53.846379]  [<ffffffff81016982>] handle_irq+0x22/0x40
>> [   53.848073]  [<ffffffff813eb45a>] do_IRQ+0x5a/0xe0
>> [   53.849751]  [<ffffffff813e80ae>] common_interrupt+0x6e/0x6e
>> [   53.851438]  <EOI>  [<ffffffff813e4a96>] ? schedule+0x316/0x9b0
>> [   53.853151]  [<ffffffff812732bb>] ? intel_idle+0xcb/0x120
>> [   53.854822]  [<ffffffff8127329d>] ? intel_idle+0xad/0x120
>> [   53.856502]  [<ffffffff81311e66>] cpuidle_idle_call+0xc6/0x350
>> [   53.858166]  [<ffffffff81013229>] cpu_idle+0xc9/0x120
>> [   53.859806]  [<ffffffff813d6f71>] start_secondary+0x202/0x209
>> [   53.861438] handlers:
>> [   53.863009] [<ffffffffa0557600>] ath_isr
>> [   53.864524] Disabling IRQ #17
>> [   53.943777] done waiting
>> [   53.944849] ieee80211 phy1: Atheros AR9285 Rev:2 mem=0xffffc90010ea0000, irq=17
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
>> index 8dcefe7..fe7780c 100644
>> --- a/drivers/net/wireless/ath/ath9k/hw.c
>> +++ b/drivers/net/wireless/ath/ath9k/hw.c
>> @@ -16,6 +16,7 @@
>>
>>  #include <linux/io.h>
>>  #include <linux/slab.h>
>> +#include <linux/delay.h>
>>  #include <asm/unaligned.h>
>>
>>  #include "hw.h"
>> @@ -532,6 +533,7 @@ static int __ath9k_hw_init(struct ath_hw *ah)
>>        ah->WARegVal |= (AR_WA_D3_L1_DISABLE |
>>                         AR_WA_ASPM_TIMER_BASED_DISABLE);
>>
>> +       ath_dbg(common, ATH_DBG_RESET, "reset power on\n");
>>        if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)) {
>>                ath_err(common, "Couldn't reset chip\n");
>>                return -EIO;
>> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
>> index 9098aaa..fdd5dd1 100644
>> --- a/drivers/net/wireless/ath/ath9k/main.c
>> +++ b/drivers/net/wireless/ath/ath9k/main.c
>> @@ -16,6 +16,7 @@
>>
>>  #include <linux/nl80211.h>
>>  #include <linux/delay.h>
>> +#include <linux/log2.h>
>>  #include "ath9k.h"
>>  #include "btcoex.h"
>>
>> @@ -770,14 +771,28 @@ irqreturn_t ath_isr(int irq, void *dev)
>>         * touch anything. Note this can happen early
>>         * on if the IRQ is shared.
>>         */
>> -       if (sc->sc_flags & SC_OP_INVALID)
>> +       if (sc->sc_flags & SC_OP_INVALID) {
>> +               static int count = 0;
>> +               if (count < INT_MAX) {
>> +                       count++;
>> +                       if (is_power_of_2(count))
>> +                               printk(KERN_DEBUG "ath9k: interrupt with invalid flag set (%d times)\n", count);
>> +               }
>>                return IRQ_NONE;
>> +       }
>>
>>
>>        /* shared irq, not for us */
>>
>> -       if (!ath9k_hw_intrpend(ah))
>> +       if (!ath9k_hw_intrpend(ah)) {
>> +               static int count = 0;
>> +               if (count < INT_MAX) {
>> +                       count++;
>> +                       if (is_power_of_2(count))
>> +                               printk(KERN_DEBUG "ath9k: shared irq, not for us (%d times)\n", count);
>> +               }
>>                return IRQ_NONE;
>> +       }
>>
>>        /*
>>         * Figure out the reason(s) for the interrupt.  Note
>> @@ -792,8 +807,15 @@ irqreturn_t ath_isr(int irq, void *dev)
>>         * If there are no status bits set, then this interrupt was not
>>         * for me (should have been caught above).
>>         */
>> -       if (!status)
>> +       if (!status) {
>> +               static int count = 0;
>> +               if (count < INT_MAX) {
>> +                       count++;
>> +                       if (is_power_of_2(count))
>> +                               printk(KERN_DEBUG "ath9k: interrupt, but no status bit set (%d times)\n", count);
>> +               }
>>                return IRQ_NONE;
>> +       }
>>
>>        /* Cache the status */
>>        sc->intrstatus = status;
>> diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
>> index be4ea13..6fdabd8 100644
>> --- a/drivers/net/wireless/ath/ath9k/pci.c
>> +++ b/drivers/net/wireless/ath/ath9k/pci.c
>> @@ -242,21 +242,35 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>        /* Will be cleared in ath9k_start() */
>>        sc->sc_flags |= SC_OP_INVALID;
>>
>> +       pci_read_config_word(pdev, PCI_SUBSYSTEM_ID, &subsysid);
>> +       ret = ath9k_init_device(id->device, sc, subsysid, &ath_pci_bus_ops);
>> +       if (ret) {
>> +               dev_err(&pdev->dev, "Failed to initialize device\n");
>> +               goto err_init;
>> +       }
>> +
>> +       {
>> +               struct ath_hw *ah = sc->sc_ah;
>> +               printk(KERN_INFO "ath9k: disabling interrupts\n");
>> +               ath9k_ps_wakeup(sc);
>> +               mutex_lock(&sc->mutex);
>> +               ath9k_hw_set_interrupts(ah, 0);
>> +               mutex_unlock(&sc->mutex);
>> +               ath9k_ps_restore(sc);
>> +       }
>> +
>> +       printk(KERN_INFO "ath9k: requesting irq\n");
>>        ret = request_irq(pdev->irq, ath_isr, IRQF_SHARED, "ath9k", sc);
>>        if (ret) {
>>                dev_err(&pdev->dev, "request_irq failed\n");
>>                goto err_irq;
>>        }
>> +       printk(KERN_INFO "wait 500 ms\n");
>> +       msleep(500);
>> +       printk(KERN_INFO "done waiting\n");
>>
>>        sc->irq = pdev->irq;
>>
>> -       pci_read_config_word(pdev, PCI_SUBSYSTEM_ID, &subsysid);
>> -       ret = ath9k_init_device(id->device, sc, subsysid, &ath_pci_bus_ops);
>> -       if (ret) {
>> -               dev_err(&pdev->dev, "Failed to initialize device\n");
>> -               goto err_init;
>> -       }
>> -
>>        ath9k_hw_name(sc->sc_ah, hw_name, sizeof(hw_name));
>>        wiphy_info(hw->wiphy, "%s mem=0x%lx, irq=%d\n",
>>                   hw_name, (unsigned long)mem, pdev->irq);
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> shafi
>



-- 
shafi
