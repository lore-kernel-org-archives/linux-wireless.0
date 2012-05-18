Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:35634 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967112Ab2ERJSs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 05:18:48 -0400
Received: by gglu4 with SMTP id u4so2619251ggl.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 May 2012 02:18:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120517230400.GB22418@yumi.tdiedrich.de>
References: <20120517230400.GB22418@yumi.tdiedrich.de>
Date: Fri, 18 May 2012 11:18:47 +0200
Message-ID: <CAGXE3d_Yz=-UWO+PiJkRQ7ZSBgh_fdcwsPz6FCig2VjOOoMQOg@mail.gmail.com> (sfid-20120518_111852_990420_C02D99C5)
Subject: Re: [PATCH] rt2800: Initialize max_txpower to MAX_G_TXPOWER and
 MAX_A_TXPOWER respectively
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Tobias Diedrich <ranma+openwrt@tdiedrich.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Hong Wu <Hong.Wu@dspg.com>, openwrt-devel@lists.openwrt.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, May 18, 2012 at 1:04 AM, Tobias Diedrich
<ranma+openwrt@tdiedrich.de> wrote:
> rt2800: Initialize max_txpower to MAX_G_TXPOWER and MAX_A_TXPOWER
> respectively, similar to how it is already done in rt2[45]00pci.c
>
> rt2800lib.c doesn't initialize max_power and thus after
> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next.git;a=commitdiff;h=eccc068e8e84c8fe997115629925e0422a98e4de
> was applied txpower is limited to 0 for these devices.
>
> This should be the proper fix compared to the net/wireless/reg.c
> hack in http://patchwork.openwrt.org/patch/2165/
>
> (Patch against the OpenWRT compat-wireless version, but applies
> equally well against wireless-next with a 19-line offset)
>
> Signed-off-by: Tobias Diedrich <ranma+openwrt@tdiedrich.de>
>
>
> Index: compat-wireless-2012-04-17/drivers/net/wireless/rt2x00/rt2800lib.c
> ===================================================================
> --- compat-wireless-2012-04-17.orig/drivers/net/wireless/rt2x00/rt2800lib.c     2012-05-18 00:25:22.515271380 +0200
> +++ compat-wireless-2012-04-17/drivers/net/wireless/rt2x00/rt2800lib.c  2012-05-18 00:28:48.809658951 +0200
> @@ -4622,6 +4622,7 @@
>        default_power2 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_BG2);
>
>        for (i = 0; i < 14; i++) {
> +               info[i].max_power = MAX_G_TXPOWER;

31dBm? That's ~1.3W.

I'd say we have to find a different way to deal with this issue.

Theoretically the device eeprom contains the allowed max tx power in
EEPROM_EIRP_MAX_TX_POWER however most devices don't use this
value at all :( so we cannot rely on it for most devices.

Typically the ralink devices are calibrated for 100% tx power. However,
without EEPROM_EIRP_MAX_TX_POWER we don't know the real tx
power of the device at all (have to consider antenna gain which should be
part of EEPROM_EIRP_MAX_TX_POWER).

So, maybe we should do it the safe way and just register a safe default
of 20dBm for all channels?

Helmut
