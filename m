Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f197.google.com ([209.85.223.197]:56399 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab0AKQLa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2010 11:11:30 -0500
Received: by iwn35 with SMTP id 35so14862346iwn.4
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jan 2010 08:11:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201001101152.34316.mb@bu3sch.de>
References: <201001101152.34316.mb@bu3sch.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 11 Jan 2010 08:11:10 -0800
Message-ID: <43e72e891001110811u49ddb2d5qbc7bef3a7e3e76d1@mail.gmail.com>
Subject: Re: Ath5k on 2.6.32 suddenly fails
To: Michael Buesch <mb@bu3sch.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bob Copeland <me@bobcopeland.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 10, 2010 at 2:52 AM, Michael Buesch <mb@bu3sch.de> wrote:
> Hi,
>
> I just upgraded my AccessPoint to 2.6.32.3. It has an atheros wireless card,
> which basically runs fine with ath5k. Well, it did run fine until I upgraded
> to 2.6.32. I upgraded from 2.6.31, but I used compat-wireless-2009-10-28 for wireless.
> (I'm not exactly sure on the compat package. Maybe it was even older. But it was stable).
>
> I'm currently using the vanilla ath5k driver on 2.6.32.
>
> So yesterday, after two days of uptime, the atheros card suddenly failed to
> work at all. Completely dead.
> Reloading the module only resulted in:
>  11 Jan 10 11:11:28 quimby kernel: [163143.871947] ath5k phy0: failed to wakeup the MAC Chip

So to be clear, this seems to be a regression from 2.6.31 to 2.6.32.
Can you confirm if ath5k worked in AP mode smoothly without this issue
or was this a regression against some random wireless-testing based
snapshit (which seems to be the case).

Rafael, please add to your list if Michael confirms this was working
fine on 2.6.31.

Michael, it seems this is not easy to reproduce but can you try the
latest 2.6.33-rc code to see if the issue is also there? I can make a
new compat-wireless snapshot for that soon if it helps.

> So I added a debug patch:
>
> Index: linux-2.6.32/drivers/net/wireless/ath/ath5k/reset.c
> ===================================================================
> --- linux-2.6.32.orig/drivers/net/wireless/ath/ath5k/reset.c    2010-01-10 11:16:00.000000000 +0100
> +++ linux-2.6.32/drivers/net/wireless/ath/ath5k/reset.c 2010-01-10 11:27:03.000000000 +0100
> @@ -223,6 +223,7 @@
>  int ath5k_hw_set_power(struct ath5k_hw *ah, enum ath5k_power_mode mode,
>                bool set_chip, u16 sleep_duration)
>  {
> +       struct pci_dev *pdev = ah->ah_sc->pdev;
>        unsigned int i;
>        u32 staid, data;
>
> @@ -273,7 +274,7 @@
>                                                        AR5K_SLEEP_CTL);
>                udelay(15);
>
> -               for (i = 200; i > 0; i--) {
> +               for (i = 20000; i > 0; i--) {
>                        /* Check if the chip did wake up */
>                        if ((ath5k_hw_reg_read(ah, AR5K_PCICFG) &
>                                        AR5K_PCICFG_SPWR_DN) == 0)
> @@ -286,8 +287,13 @@
>                }
>
>                /* Fail if the chip didn't wake up */
> -               if (i == 0)
> +               if (i == 0) {
> +                       u32 val;
> +                       int res = pci_read_config_dword(pdev, PCI_STATUS, &val);
> +                       printk("%d, 0x%08X\n", res, val);
>                        return -EIO;
> +               }
> +               printk("Wakeup %d\n", i);
>
>                break;
>
> Which resulted in these messages:
>
>  35 Jan 10 11:28:30 quimby kernel: [164165.417931] 135, 0x00000000
>  36 Jan 10 11:28:30 quimby kernel: [164165.417940] ath5k phy0: failed to wakeup the MAC Chip
>
> So the card really is completely dead. It doesn't even respond to standard PCI reads.
>
> Only a complete reboot (warmstart) of the machine brought it back to life.
