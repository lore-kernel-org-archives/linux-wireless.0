Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:64192 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbaF2Jli (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jun 2014 05:41:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140628072322.GC7410@atomide.com>
References: <CALtMJEBWPM+75wxM2Mp5EX_o6NWtZUJdYRCv6psbvdUn4k295w@mail.gmail.com>
	<20140628052220.GG10407@us.netrek.org>
	<20140628072322.GC7410@atomide.com>
Date: Sun, 29 Jun 2014 11:41:37 +0200
Message-ID: <CALtMJED5vfgkAhMBXKaDP6u9U9n41c-wziyTxt6e_7XTSxG3oQ@mail.gmail.com> (sfid-20140629_114143_993201_53723873)
Subject: Re: mwifiex card reset
From: Andreas Fenkart <afenkart@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: James Cameron <quozl@laptop.org>, Bing Zhao <bzhao@marvell.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linux-mmc <linux-mmc@vger.kernel.org>,
	devicetree@vger.kernel.org, Daniel Mack <daniel@zonque.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014-06-28 9:23 GMT+02:00 Tony Lindgren <tony@atomide.com>:
> * James Cameron <quozl@laptop.org> [140628 08:24]:
>> On Fri, Jun 27, 2014 at 04:39:42PM +0200, Andreas Fenkart wrote:
>> > I have an mwifiex module(sd8787) behind omap_hsmmc(am33xx-soc)
>> > The module is non-removable wired fix to soc. Now the wifi module
>> > needs 2 clocks; one is a sleep clock the other used when not
>> > sleeping.
>> > While the sleep clock is fixed, @32 kHz, the system clock can be
>> > one out of several values, but can be be derived automatically
>> > from the sleep clock. But this requires the clock to be present
>> > when the wifi module comes out of reset.
>> >

ref 1)

>> > Another problem is software reboot, at initial power on the wifi
>> > card will react to mmc discovery. After a software reset of the
>> > host it will not, because it has already been discovered and
>> > didn't notice the host rebooted, unless we reset it as well.
>> > While this seems obvious, the problem is that the reset is needed
>> > before the card can be discovered. Which means we cannot move the
>> > reset logic into the mwifiex driver, since that driver has not
>> > yet been selected through vendor/product id.
>> >
>>
>> we had same problem with sd8787 and a different system design.  we
>> added reset-gpios property [1] and used it in sdhci-pxav3.c [2] as
>> sdhci_pxav3_toggle_reset_gpio()
>>
>> 1.
>>
>> http://code.coreboot.org/p/openfirmware/source/tree/HEAD/cpu/arm/olpc/sdhci.fth#L104
>>
>> 2.
>>
>> http://dev.laptop.org/git/olpc-kernel/tree/drivers/mmc/host/sdhci-pxav3.c?h=arm-3.5#n229
>>
>> > the reset logic:
>> >         gpiod_set_value(card->gpiod_reset, 0);
>> >         clk_enable(card->sleep_clock);
>> >         udelay(1000);
>> >         gpiod_set_value(card->gpiod_reset, 1);
>> >
>> > The idea so far was to extend the device-tree node of the
>> > mmc slot by some reset leafs;
>> >
>> > &mmc {
>> >         ti,non-removable;
>> >         ..
>> >         peripheral-clocks = <&clk &clk2 ...>;
>> >         peripheral-reset-gpios = <&gpio0 1 1 &gpio1 2 3 ...>;
>> > }
>> >
>> > in mmc_add_host, all clocks will be enabled and gpios be pulled
>> > low for 1 msec
>>
>> we used 5ms.
>>
>> > Is this a feasible solution?
>> >
>> >
>> > Another related issue, is the card reset in mwifiex driver:
>> >
>> > static void sdio_card_reset_worker(struct work_struct *work)
>> > {
>> >         struct mmc_host *target = reset_host;
>> >
>> >         pr_err("Resetting card...\n");
>> >         mmc_remove_host(target);
>> >         /* 20ms delay is based on experiment with sdhci controller */
>> >         mdelay(20);
>> >         mmc_add_host(target);
>> > }
>> > static DECLARE_WORK(card_reset_work, sdio_card_reset_worker);
>> >
>> > There are obviously a lot of problems with this, e.g. custom debugfs
>> > entries created in the driver will be lost. But sometimes this
>> > code might avert disaster in case the command handlers between
>> > driver and firmware lost synchronization
>> >
>> > How could this be done in a better way?
>>
>> i'm interested as well.
>
> Wouldn't it be best to have the mwifiex properly handle the
> reset GPIOs and idle status pins?

doesn't work see ref 1) above

> Those are not part of the SDIO spec AFAIK, and the mmc
> controller should not need to care about those.
>
> Also, at least omaps also have an issue where suspend won't
> work with mwifiex loaded FYI.

first command after resume needs to be cmd52, not cmd53 as the
driver would by default. it's another issue

>
> Regards,
>
> Tony
