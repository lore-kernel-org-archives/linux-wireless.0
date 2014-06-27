Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f51.google.com ([209.85.216.51]:34403 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbaF0Ojr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2014 10:39:47 -0400
MIME-Version: 1.0
Date: Fri, 27 Jun 2014 16:39:42 +0200
Message-ID: <CALtMJEBWPM+75wxM2Mp5EX_o6NWtZUJdYRCv6psbvdUn4k295w@mail.gmail.com> (sfid-20140627_163953_850269_AAC37D9E)
Subject: mwifiex card reset
From: Andreas Fenkart <afenkart@gmail.com>
To: Bing Zhao <bzhao@marvell.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linux-mmc <linux-mmc@vger.kernel.org>, devicetree@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>, Daniel Mack <daniel@zonque.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have an mwifiex module(sd8787) behind omap_hsmmc(am33xx-soc)
The module is non-removable wired fix to soc. Now the wifi module
needs 2 clocks; one is a sleep clock the other used when not
sleeping.
While the sleep clock is fixed, @32 kHz, the system clock can be
one out of several values, but can be be derived automatically
from the sleep clock. But this requires the clock to be present
when the wifi module comes out of reset.

Another problem is software reboot, at initial power on the wifi
card will react to mmc discovery. After a software reset of the
host it will not, because it has already been disvovered and
didn't notice the host rebooted, unless we reset it as well.
While this seems obvious, the problem is that the reset is needed
before the card can be discovered. Which means we cannot move the
reset logic into the mwifiex driver, since that driver has not
yet been selected through vendor/product id.

the reset logic:
        gpiod_set_value(card->gpiod_reset, 0);
        clk_enable(card->sleep_clock);
        udelay(1000);
        gpiod_set_value(card->gpiod_reset, 1);

The idea so far was to extend the device-tree node of the
mmc slot by some reset leafs;

&mmc {
        ti,non-removable;
        ..
        peripheral-clocks = <&clk &clk2 ...>;
        peripheral-reset-gpios = <&gpio0 1 1 &gpio1 2 3 ...>;
}

in mmc_add_host, all clocks will be enabled and gpios be pulled
low for 1 msec

Is this a feasible solution?


Another related issue, is the card reset in mwifiex driver:

static void sdio_card_reset_worker(struct work_struct *work)
{
        struct mmc_host *target = reset_host;

        pr_err("Resetting card...\n");
        mmc_remove_host(target);
        /* 20ms delay is based on experiment with sdhci controller */
        mdelay(20);
        mmc_add_host(target);
}
static DECLARE_WORK(card_reset_work, sdio_card_reset_worker);

There are obviously a lot of problems with this, e.g. custom debugfs
entries created in the driver will be lost. But sometimes this
code might avert disaster in case the command handlers between
driver and firmware lost synchronization

How could this be done in a better way?
