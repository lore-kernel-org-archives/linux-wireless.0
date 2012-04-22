Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63302 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab2DVXv1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Apr 2012 19:51:27 -0400
Received: by yenl12 with SMTP id l12so5862090yen.19
        for <linux-wireless@vger.kernel.org>; Sun, 22 Apr 2012 16:51:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1334913493.27776.28.camel@t41.thuisdomein>
References: <1334869564.25074.35.camel@t41.thuisdomein>
	<CAFtRNNyNg4gqu16FzERGRzYCbJv_mR00BqwLhAKOXcMtJMhmTQ@mail.gmail.com>
	<1334913493.27776.28.camel@t41.thuisdomein>
Date: Mon, 23 Apr 2012 02:51:26 +0300
Message-ID: <CAFtRNNyvn3g_-XP1dPA4vfZi25AmiXokF5-nep2HY9xTF0cXQQ@mail.gmail.com> (sfid-20120423_015131_513890_555C4BB0)
Subject: Re: [ath5k-devel] ath5k phy0: failed to warm reset the MAC Chip
From: Nick Kossifidis <mickflemm@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/4/20 Paul Bolle <pebolle@tiscali.nl>:
> On Fri, 2012-04-20 at 01:51 +0300, Nick Kossifidis wrote:
>> 2012/4/20 Paul Bolle <pebolle@tiscali.nl>:
>> How frequently do they appear ?
>
> At most once a day (with light usage: on this laptop I try to track
> Fedora Rawhide, which means I use another machine to actually get things
> done).
>
>> You do suspend/resume on your laptop ?
>
> Yes.
>
>> Any other hw issues with your laptop ?
>
> Not really. It's a ThinkPad T41, which is still rather well supported,
> so any issues should stand out. Even minor issues like the one I'm
> reporting here.
>
>> > 3) Do these message really indicate errors? Or can they perhaps be
>> > downgraded to (say) KERN_INFO level (ie, <6> prefix)?
>>
>> Yup, if your card doesn't come back in time it's usually a hw error,
>> it can be the pci bus, the card itself or it might mean that your
>> pc/laptop doesn't count the time correctly (it happens e.g. because of
>> sleep state changes).
>
> But it seems something does (silently) reset the card later on. Or,
> alternatively, perhaps the next time something wants to use the card the
> warm reset is finally finished (ie, we reported an error while the reset
> actually succeeded, eventually). That's something I ran into last year
> with commit 5cd2ad81f912c8535491f541108b655f4552dff9 ("ALSA: intel8x0m:
> wait a bit before warm reset check"), but the details will not be
> comparable.
>
> Anyhow, I'm not familiar with this code at all. Are there some unsubtle
> debugging hacks I could try, like setting AR5K_TUNE_REGISTER_TIMEOUT to
> something bizarre? Or a printk of (some of) the registers involved if we
> exceed this timeout? Things like that ...
>

Sure you can play with register timeout and see how it goes, just
remember the actual time is AR5K_TUNE_REGISTER_TIMEOUT * 15us (check
out reset.c for the implementation).

>> If you want to debug this further it'll help if you posted somewhere
>> (e.g. pastebin) the dmesg output and lspci output.
>
> (Pastebin will mean that things get lost eventually, won't it? I'll use
> this message but I'll try to be brief.)
>
> lspci:
> 00:00.0 Host bridge: Intel Corporation 82855PM Processor to I/O Controller (rev 03)
> 00:01.0 PCI bridge: Intel Corporation 82855PM Processor to AGP Controller (rev 03)
> 00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 01)
> 00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 01)
> 00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3 (rev 01)
> 00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI Controller (rev 01)
> 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 81)
> 00:1f.0 ISA bridge: Intel Corporation 82801DBM (ICH4-M) LPC Interface Bridge (rev 01)
> 00:1f.1 IDE interface: Intel Corporation 82801DBM (ICH4-M) IDE Controller (rev 01)
> 00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) SMBus Controller (rev 01)
> 00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 01)
> 00:1f.6 Modem: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Modem Controller (rev 01)
> 01:00.0 VGA compatible controller: ATI Technologies Inc Radeon RV250 [Mobility FireGL 9000] (rev 02)
> 02:00.0 CardBus bridge: Texas Instruments PCI4520 PC card Cardbus Controller (rev 01)
> 02:00.1 CardBus bridge: Texas Instruments PCI4520 PC card Cardbus Controller (rev 01)
> 02:01.0 Ethernet controller: Intel Corporation 82540EP Gigabit Ethernet Controller (Mobile) (rev 03)
> 02:02.0 Ethernet controller: Atheros Communications Inc. AR5212 802.11abg NIC (rev 01)
>

Well we also need the chip revision to make sense so we need the part
from dmesg where ath5k loads.

> About 100 lines from dmesg (roughly one resume and suspend cycle):
> [...]
> <6>[12383.828448] ACPI: Waking up from system sleep state S3
> <6>[12383.912201] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> <6>[12383.912206] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> <6>[12383.952121] uhci_hcd 0000:00:1d.0: wake-up capability disabled by ACPI
> <6>[12383.952126] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> <6>[12383.952130] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> <6>[12383.952136] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
> <6>[12383.952140] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
> <6>[12383.982198] uhci_hcd 0000:00:1d.1: wake-up capability disabled by ACPI
> <6>[12383.982203] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
> <6>[12383.982206] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
> <6>[12384.042316]  pci0000:00: wake-up capability disabled by ACPI
> <6>[12384.042325] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
> <6>[12384.042330] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
> <6>[12384.152963] PM: noirq resume of devices complete after 240.824 msecs
> <6>[12384.153077] PM: early resume of devices complete after 0.086 msecs
> <6>[12384.153142] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> <6>[12384.153146] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> <7>[12384.153157] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> <4>[12384.153178] usb usb2: root hub lost power or was reset
> <6>[12384.153189] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
> <6>[12384.153192] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
> <7>[12384.153201] uhci_hcd 0000:00:1d.1: setting latency timer to 64
> <4>[12384.153219] usb usb3: root hub lost power or was reset
> <7>[12384.153260] uhci_hcd 0000:00:1d.2: setting latency timer to 64
> <4>[12384.153279] usb usb4: root hub lost power or was reset
> <6>[12384.153289] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
> <6>[12384.153294] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
> <7>[12384.153304] ehci_hcd 0000:00:1d.7: setting latency timer to 64
> <7>[12384.153327] pci 0000:00:1e.0: setting latency timer to 64
> <7>[12384.153341] ata_piix 0000:00:1f.1: setting latency timer to 64
> <7>[12384.153355] snd_intel8x0 0000:00:1f.5: setting latency timer to 64
> <7>[12384.153391] snd_intel8x0m 0000:00:1f.6: setting latency timer to 64
> <6>[12384.153428] radeon 0000:01:00.0: power state changed by ACPI to D0
> <6>[12384.154416] radeon 0000:01:00.0: power state changed by ACPI to D0
> <6>[12384.154422] radeon 0000:01:00.0: power state changed by ACPI to D0
> <6>[12384.154433] radeon 0000:01:00.0: power state changed by ACPI to D0
> <6>[12384.154459] pci 0000:00:1e.0: wake-up capability disabled by ACPI
> <6>[12384.154583] [drm] AGP mode requested: 1
> <6>[12384.154586] agpgart-intel 0000:00:00.0: AGP 2.0 bridge
> <6>[12384.154599] agpgart-intel 0000:00:00.0: putting AGP V2 device into 1x mode
> <6>[12384.154634] radeon 0000:01:00.0: putting AGP V2 device into 1x mode
> <6>[12384.154658] radeon 0000:01:00.0: GTT: 256M 0xD0000000 - 0xDFFFFFFF
> <6>[12384.177594] radeon 0000:01:00.0: WB disabled
> <6>[12384.177598] [drm] fence driver on ring 0 use gpu addr 0xd0000000 and cpu addr 0xf8e9a000
> <6>[12384.177644] [drm] radeon: ring at 0x00000000D0001000
> <6>[12384.177677] [drm] ring test succeeded in 1 usecs
> <6>[12384.177880] [drm] ib test succeeded in 0 usecs
> <6>[12384.317666] serial 00:0a: activated
> <6>[12384.318042] parport_pc 00:0b: activated
> <6>[12384.331312] ata2.00: ACPI cmd ef/03:42:00:00:00:a0 (SET FEATURES) filtered out
> <6>[12384.331317] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
> <7>[12384.331588] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
> <7>[12384.331798] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
> <6>[12384.340180] ata2.00: configured for UDMA/33
> <7>[12385.748174] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> <6>[12385.748179] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> <6>[12385.748183] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
> <6>[12385.748188] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
> <6>[12385.757603] ata1.00: configured for UDMA/100
> <5>[12385.757651] sd 0:0:0:0: [sda] Starting disk
> <6>[12386.046555] PM: resume of devices complete after 1893.472 msecs
> <7>[12386.270267] PM: Finishing wakeup.
> <4>[12386.270270] Restarting tasks ... done.
> <6>[12386.311353] video LNXVIDEO:00: Restoring backlight state
> <6>[12387.671589] ADDRCONF(NETDEV_UP): eth0: link is not ready
> <6>[12387.719414] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> <7>[12396.630127] wlan0: authenticate with [...]
> <7>[12396.639481] wlan0: send auth to [...] (try 1/3)
> <7>[12396.641111] wlan0: authenticated
> <7>[12396.654064] wlan0: associate with [...] (try 1/3)
> <7>[12396.656836] wlan0: RX AssocResp from [...] (capab=0x411 status=0 aid=5)
> <7>[12396.656848] wlan0: associated
> <6>[12396.658376] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> <7>[12407.314034] wlan0: no IPv6 routers present
> <3>[13053.997856] ath5k phy0: failed to warm reset the MAC Chip
> <3>[13053.997871] ath5k phy0: can't reset hardware (-5)
> <7>[17006.956496] wlan0: deauthenticating from [...] by local choice (reason=3)
> <6>[17006.958555] cfg80211: Calling CRDA to update world regulatory domain
> <6>[17007.162565] cfg80211: World regulatory domain updated:
> <6>[17007.162579] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> <6>[17007.162592] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> <6>[17007.162603] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> <6>[17007.162614] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> <6>[17007.162625] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> <6>[17007.162636] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> <6>[17007.162678] cfg80211: Calling CRDA for country: NL
> <6>[17007.193693] cfg80211: Regulatory domain changed to country: NL
> <6>[17007.193707] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> <6>[17007.193719] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> <6>[17007.193729] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> <6>[17007.193739] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> <6>[17007.193749] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
> <6>[17009.384655] PM: Syncing filesystems ... done.
> <7>[17009.420080] PM: Preparing system for mem sleep
> <4>[17009.511437] Freezing user space processes ... (elapsed 0.01 seconds) done.
> <4>[17009.523166] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> <7>[17009.534215] PM: Entering mem sleep
> <4>[17009.534239] Suspending console(s) (use no_console_suspend to debug)
> [...]
>
> Which looks rather uninteresting. But if I look at the few instances of
> these errors still logged in /var/log/messages* I see ntpd activity
> preceding these errors. Coincidence?
>

Well if there is a problem with your laptop's clock it might be the
reason for this, you see some time ago we started using hr (high
resolution) timers inside ath5k instead of the standard busy waits
(udelay) and if there is any clock drifting or frequency changes (e.g.
CPU sleep states or some governor) on the clock we use (e.g. CPU's
cycle counter or TSC) it affects us (I think also that ntp changes the
system clock and this affects hr timers too but I'm not sure). Inside
register_timeout we use udelay but other parts of reset use hr timers,
here is a suspect:

inside ath5k_hw_nic_reset (reset.c)

410         /* Wait at least 128 PCI clocks */
411         usleep_range(15, 20);

inside ath5k_hw_set_power_mode

564                 usleep_range(15, 20);
[...]
572                         /* Wait a bit and retry */
573                         usleep_range(50, 75);


It seems kind of extreme because most of these intervals are small and
register timeout should be enough to cover such clock drifts (it's
20000 * 15us) even on old chips but it might explain the link with ntp
activity. Try using a more "stable" time source such as PIT or HPET
(you can use e.g. clock=pit on kernel's command line for this) and see
how it goes. You can also try disabling ntp and see if the problem
remains...

-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
