Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:63934 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757760Ab2EVLcR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2012 07:32:17 -0400
Received: by gglu4 with SMTP id u4so5234134ggl.19
        for <linux-wireless@vger.kernel.org>; Tue, 22 May 2012 04:32:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FBB77D4.9050801@01019freenet.de>
References: <20120517230400.GB22418@yumi.tdiedrich.de>
	<CAGXE3d_Yz=-UWO+PiJkRQ7ZSBgh_fdcwsPz6FCig2VjOOoMQOg@mail.gmail.com>
	<20120518162158.GE22418@yumi.tdiedrich.de>
	<CAGXE3d8e+hYo_MT30XUW+r4-Dq6AgqLTJxD_oGnRuR94zjZ7_Q@mail.gmail.com>
	<4FB769DF.5060400@01019freenet.de>
	<4FBB5083.4000606@01019freenet.de>
	<CAGXE3d-2ndXX1D-JQLo6m=Osg6RRe4Z2gb_=BPrz0wASzFciNA@mail.gmail.com>
	<4FBB77D4.9050801@01019freenet.de>
Date: Tue, 22 May 2012 13:32:16 +0200
Message-ID: <CAGXE3d8m_0E2HGjCY9uMtj-Kahg9QCJjpsCCGjm+go6n_+V1Pg@mail.gmail.com> (sfid-20120522_133220_683486_C553CA21)
Subject: Re: [PATCH] rt2800: Initialize max_txpower to MAX_G_TXPOWER and
 MAX_A_TXPOWER respectively
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 22, 2012 at 1:26 PM, Andreas Hartmann
<andihartmann@01019freenet.de> wrote:
> Hello Helmut,
>
> Helmut Schaa wrote:
>> Hi Andreas,
>>
>> Sorry, missed your previous mail.
>
> Thanks for your response!! This made things more clear to me!
>
>> On Tue, May 22, 2012 at 10:38 AM, Andreas Hartmann
>> <andihartmann@01019freenet.de> wrote:
>>> Andreas Hartmann wrote:
>>>> Helmut Schaa wrote:
>>>>> On Fri, May 18, 2012 at 6:21 PM, Tobias Diedrich <ranma@tdiedrich.de> wrote:
>>>>>>> So, maybe we should do it the safe way and just register a safe default
>>>>>>> of 20dBm for all channels?
>>>>>>
>>>>>> AFAIU that would cap you to 20dBm even if you are in a country that
>>>>>> has higher limits (e.g. 27dBm in the US?).
>>>>>
>>>>> Not necessarily because the driver won't allow tx power adjustments at all
>>>>> if EEPROM_EIRP_MAX_TX_POWER is unused.
>>>>
>>>> This means:
>>>> Tx settings in cfg80211 as given by "iw reg get" e.g. are ignored
>>>> completely as long as EEPROM_EIRP_MAX_TX_POWER is unused.
>>>> Thus it is more or less chance that the device actually uses the allowed
>>>> / correct Tx power at all. Maybe it's too high or too low. Both would be
>>>> bad.
>
> [Most ralink devices have fixed max Tx power depended on the region, the
> device was sold]
>
>> Either we have to tune cfg80211 to allow setting the tx power by percentage
>> or disallow tx power control on these device or we trick cfg80211 by registering
>> a reasonable default value (like 20dBm) to cfg80211 but do adjustments
>> by percentage.
>>
>> So, if a device is actually calibrated to 17dBm but we register 20dBm
>> to cfg80211
>> and a user sets the new tx power to 17dBm we can apply the actual delta to
>> the device tx power configuration. Hence, the device will then
>> transmit with 14dBm
>> while cfg80211 shows 17dBm. This would be a compromise to still allow tx power
>> settings without having to add all the overhead to cfg80211.
>
> What about this idea: The driver gets an option to set the calibrated
> region (devcalreg), say US. This is a static value in respect of the device.
> If the user operates the device in DE, he just would have to change the
> value of cfg80211 from US to DE.
>
> Device sold in US
> =================
>
> Device operated in US
> devcalreg=US                                    23dBm
> cfg80211=US             100% max Tx power       23dBm
>
> Device operated in DE
> devcalreg=US                                    23dBm
> cfg80211=DE             87%  max Tx power       20dBm
>
> If cfg80211 is set to a region which allows higher values, the
> percentage would be >100%, but this could be probably easily prohibited.
>
> If the user doesn't provide devcalreg your default value gets applied.
>
> The difference to your idea is, that the "default" could be dynamically
> derived from cfg80211 on the basis of the devcalreg. This would prohibit
> the problem you showed above.

Understood, but that would require the user to know the domain the
device is calibrated for.

I think we should just always run the device at 100% but add an option in
the future to allow rx power reduction by percentage.

Helmut
