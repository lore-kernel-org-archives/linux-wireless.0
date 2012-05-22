Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45181 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab2EVKCZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2012 06:02:25 -0400
Received: by yhmm54 with SMTP id m54so5237902yhm.19
        for <linux-wireless@vger.kernel.org>; Tue, 22 May 2012 03:02:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FBB5083.4000606@01019freenet.de>
References: <20120517230400.GB22418@yumi.tdiedrich.de>
	<CAGXE3d_Yz=-UWO+PiJkRQ7ZSBgh_fdcwsPz6FCig2VjOOoMQOg@mail.gmail.com>
	<20120518162158.GE22418@yumi.tdiedrich.de>
	<CAGXE3d8e+hYo_MT30XUW+r4-Dq6AgqLTJxD_oGnRuR94zjZ7_Q@mail.gmail.com>
	<4FB769DF.5060400@01019freenet.de>
	<4FBB5083.4000606@01019freenet.de>
Date: Tue, 22 May 2012 12:02:24 +0200
Message-ID: <CAGXE3d-2ndXX1D-JQLo6m=Osg6RRe4Z2gb_=BPrz0wASzFciNA@mail.gmail.com> (sfid-20120522_120231_746525_F3A3AA61)
Subject: Re: [PATCH] rt2800: Initialize max_txpower to MAX_G_TXPOWER and
 MAX_A_TXPOWER respectively
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andreas,

Sorry, missed your previous mail.

On Tue, May 22, 2012 at 10:38 AM, Andreas Hartmann
<andihartmann@01019freenet.de> wrote:
> Andreas Hartmann wrote:
>> Helmut Schaa wrote:
>>> On Fri, May 18, 2012 at 6:21 PM, Tobias Diedrich <ranma@tdiedrich.de> wrote:
>>>>> So, maybe we should do it the safe way and just register a safe default
>>>>> of 20dBm for all channels?
>>>>
>>>> AFAIU that would cap you to 20dBm even if you are in a country that
>>>> has higher limits (e.g. 27dBm in the US?).
>>>
>>> Not necessarily because the driver won't allow tx power adjustments at all
>>> if EEPROM_EIRP_MAX_TX_POWER is unused.
>>
>> This means:
>> Tx settings in cfg80211 as given by "iw reg get" e.g. are ignored
>> completely as long as EEPROM_EIRP_MAX_TX_POWER is unused.
>> Thus it is more or less chance that the device actually uses the allowed
>> / correct Tx power at all. Maybe it's too high or too low. Both would be
>> bad.
>
> Please Helmut, I would be really grateful if you could confirm or negate
> my conclusion.

There are two classes of ralink devices the manufacturers could actually
produce: Devices that rely on software regulatory handling and devices
that are calibrated for a specific region.

The ones that rely on sw regulatory handling specify EEPROM_EIRP_MAX_TX_POWER
in their calibration data such that the driver is able to specify
arbitrary tx power
values. I've never seen such a device ...

The others are just calibrated for a specific country. For example
there could be
a device sold in the US that is calibrated to 23dBm while one that is sold in
Europe is calibrated to 18dBm. However, the driver has no information about
this.

Hence, using the US device in Europe is not allowed but there's nothing the
driver can actually do against that. The other way if you take your European
device with you to US you would be allowed (from a FCC POV) to use more
then 20dBm tx power but since the driver doesn't know how to configure the
device to a specific value you would have to live with the lower tx power.

>>> For these devices we cannot rely on the tx power output at all and maybe
>>> it makes sense to register a max power of 0 just to tell mac80211/cfg80211
>>> that no tx power adjustments are possible on these devices?
>>
>> Hmmm, this sounds really strange. How can I see if a device uses
>> EEPROM_EIRP_MAX_TX_POWER at all?
>> It would be good to have a log entry, telling the user that the Tx power
>> of the device can't be adjusted at all and therefore it is possible,
>> that the operation of the device might be illegal in the current country
>> even if cfg80211 is set correctly.

The same problem arises with different operating systems as well. If you
take your 23dBm US card to Europe it will also transmit with 23dBm when
using the ralink legacy drivers or the windows drivers. So there is nothing
the driver should warn about.

Btw. the legacy driver also allows tx power control on devices without
EEPROM_EIRP_MAX_TX_POWER but it doesn't allow arbitrary dBm values
to be specified. It only allows to set the tx power to a percentage value (up to
100%) of the calibrated value. This is however not possible with the current
regulatory implementation in cfg80211.

Either we have to tune cfg80211 to allow setting the tx power by percentage
or disallow tx power control on these device or we trick cfg80211 by registering
a reasonable default value (like 20dBm) to cfg80211 but do adjustments
by percentage.

So, if a device is actually calibrated to 17dBm but we register 20dBm
to cfg80211
and a user sets the new tx power to 17dBm we can apply the actual delta to
the device tx power configuration. Hence, the device will then
transmit with 14dBm
while cfg80211 shows 17dBm. This would be a compromise to still allow tx power
settings without having to add all the overhead to cfg80211.

Btw. I've got a proof-of-concept patch for this but need to dig it up first.

Helmut
