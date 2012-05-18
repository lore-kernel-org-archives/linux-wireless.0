Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout6.freenet.de ([195.4.92.96]:50617 "EHLO mout6.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755901Ab2ERMQr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 08:16:47 -0400
Message-ID: <4FB63CEF.5020700@01019freenet.de> (sfid-20120518_141651_566967_EB535F4B)
Date: Fri, 18 May 2012 14:13:35 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: Tobias Diedrich <ranma+openwrt@tdiedrich.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	Hong Wu <Hong.Wu@dspg.com>, openwrt-devel@lists.openwrt.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2800: Initialize max_txpower to MAX_G_TXPOWER and MAX_A_TXPOWER
 respectively
References: <20120517230400.GB22418@yumi.tdiedrich.de> <CAGXE3d_Yz=-UWO+PiJkRQ7ZSBgh_fdcwsPz6FCig2VjOOoMQOg@mail.gmail.com>
In-Reply-To: <CAGXE3d_Yz=-UWO+PiJkRQ7ZSBgh_fdcwsPz6FCig2VjOOoMQOg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Helmut,

Helmut Schaa wrote:
> Hi,
> 
> On Fri, May 18, 2012 at 1:04 AM, Tobias Diedrich
> <ranma+openwrt@tdiedrich.de> wrote:
>> rt2800: Initialize max_txpower to MAX_G_TXPOWER and MAX_A_TXPOWER
>> respectively, similar to how it is already done in rt2[45]00pci.c
>>
>> rt2800lib.c doesn't initialize max_power and thus after
>> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next.git;a=commitdiff;h=eccc068e8e84c8fe997115629925e0422a98e4de
>> was applied txpower is limited to 0 for these devices.
>>
>> This should be the proper fix compared to the net/wireless/reg.c
>> hack in http://patchwork.openwrt.org/patch/2165/
>>
>> (Patch against the OpenWRT compat-wireless version, but applies
>> equally well against wireless-next with a 19-line offset)
>>
>> Signed-off-by: Tobias Diedrich <ranma+openwrt@tdiedrich.de>
>>
>>
>> Index: compat-wireless-2012-04-17/drivers/net/wireless/rt2x00/rt2800lib.c
>> ===================================================================
>> --- compat-wireless-2012-04-17.orig/drivers/net/wireless/rt2x00/rt2800lib.c     2012-05-18 00:25:22.515271380 +0200
>> +++ compat-wireless-2012-04-17/drivers/net/wireless/rt2x00/rt2800lib.c  2012-05-18 00:28:48.809658951 +0200
>> @@ -4622,6 +4622,7 @@
>>        default_power2 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_BG2);
>>
>>        for (i = 0; i < 14; i++) {
>> +               info[i].max_power = MAX_G_TXPOWER;
> 
> 31dBm? That's ~1.3W.
> 
> I'd say we have to find a different way to deal with this issue.
> 
> Theoretically the device eeprom contains the allowed max tx power in
> EEPROM_EIRP_MAX_TX_POWER however most devices don't use this
> value at all :( so we cannot rely on it for most devices.
> 
> Typically the ralink devices are calibrated for 100% tx power. However,
> without EEPROM_EIRP_MAX_TX_POWER we don't know the real tx
> power of the device at all (have to consider antenna gain which should be
> part of EEPROM_EIRP_MAX_TX_POWER).
> 
> So, maybe we should do it the safe way and just register a safe default
> of 20dBm for all channels?

What are your considerations to set it to 20dBm and not to 25dBm, e.g.?
What would be the functional consequence, if it would be set to 25dBm or
to 31dBm?


Thanks,
Andreas
