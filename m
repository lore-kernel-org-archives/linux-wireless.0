Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:40459 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758544Ab2EVL2c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2012 07:28:32 -0400
Received: from [195.4.92.141] (helo=mjail1.freenet.de)
	by mout0.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1SWnGQ-0002HP-VJ
	for linux-wireless@vger.kernel.org; Tue, 22 May 2012 13:28:30 +0200
Received: from localhost ([::1]:60087 helo=mjail1.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1SWnGQ-0007AE-Is
	for linux-wireless@vger.kernel.org; Tue, 22 May 2012 13:28:30 +0200
Received: from [195.4.92.15] (port=36856 helo=5.mx.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1SWnEP-0006Ix-Cg
	for linux-wireless@vger.kernel.org; Tue, 22 May 2012 13:26:25 +0200
Received: from [2002:4fde:514:2:5054:ff:feb8:40bd] (port=38620 helo=mail.maya.org)
	by 5.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1SWnEO-0001Ao-Vz
	for linux-wireless@vger.kernel.org; Tue, 22 May 2012 13:26:25 +0200
Message-ID: <4FBB77D4.9050801@01019freenet.de> (sfid-20120522_132906_061241_65480E1D)
Date: Tue, 22 May 2012 13:26:12 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rt2800: Initialize max_txpower to MAX_G_TXPOWER and MAX_A_TXPOWER
 respectively
References: <20120517230400.GB22418@yumi.tdiedrich.de> <CAGXE3d_Yz=-UWO+PiJkRQ7ZSBgh_fdcwsPz6FCig2VjOOoMQOg@mail.gmail.com> <20120518162158.GE22418@yumi.tdiedrich.de> <CAGXE3d8e+hYo_MT30XUW+r4-Dq6AgqLTJxD_oGnRuR94zjZ7_Q@mail.gmail.com> <4FB769DF.5060400@01019freenet.de> <4FBB5083.4000606@01019freenet.de> <CAGXE3d-2ndXX1D-JQLo6m=Osg6RRe4Z2gb_=BPrz0wASzFciNA@mail.gmail.com>
In-Reply-To: <CAGXE3d-2ndXX1D-JQLo6m=Osg6RRe4Z2gb_=BPrz0wASzFciNA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Helmut,

Helmut Schaa wrote:
> Hi Andreas,
> 
> Sorry, missed your previous mail.

Thanks for your response!! This made things more clear to me!

> On Tue, May 22, 2012 at 10:38 AM, Andreas Hartmann
> <andihartmann@01019freenet.de> wrote:
>> Andreas Hartmann wrote:
>>> Helmut Schaa wrote:
>>>> On Fri, May 18, 2012 at 6:21 PM, Tobias Diedrich <ranma@tdiedrich.de> wrote:
>>>>>> So, maybe we should do it the safe way and just register a safe default
>>>>>> of 20dBm for all channels?
>>>>>
>>>>> AFAIU that would cap you to 20dBm even if you are in a country that
>>>>> has higher limits (e.g. 27dBm in the US?).
>>>>
>>>> Not necessarily because the driver won't allow tx power adjustments at all
>>>> if EEPROM_EIRP_MAX_TX_POWER is unused.
>>>
>>> This means:
>>> Tx settings in cfg80211 as given by "iw reg get" e.g. are ignored
>>> completely as long as EEPROM_EIRP_MAX_TX_POWER is unused.
>>> Thus it is more or less chance that the device actually uses the allowed
>>> / correct Tx power at all. Maybe it's too high or too low. Both would be
>>> bad.

[Most ralink devices have fixed max Tx power depended on the region, the
device was sold]

> Either we have to tune cfg80211 to allow setting the tx power by percentage
> or disallow tx power control on these device or we trick cfg80211 by registering
> a reasonable default value (like 20dBm) to cfg80211 but do adjustments
> by percentage.
> 
> So, if a device is actually calibrated to 17dBm but we register 20dBm
> to cfg80211
> and a user sets the new tx power to 17dBm we can apply the actual delta to
> the device tx power configuration. Hence, the device will then
> transmit with 14dBm
> while cfg80211 shows 17dBm. This would be a compromise to still allow tx power
> settings without having to add all the overhead to cfg80211.

What about this idea: The driver gets an option to set the calibrated
region (devcalreg), say US. This is a static value in respect of the device.
If the user operates the device in DE, he just would have to change the
value of cfg80211 from US to DE.

Device sold in US
=================

Device operated in US
devcalreg=US					23dBm
cfg80211=US		100% max Tx power	23dBm

Device operated in DE
devcalreg=US					23dBm
cfg80211=DE		87%  max Tx power	20dBm

If cfg80211 is set to a region which allows higher values, the
percentage would be >100%, but this could be probably easily prohibited.

If the user doesn't provide devcalreg your default value gets applied.

The difference to your idea is, that the "default" could be dynamically
derived from cfg80211 on the basis of the devcalreg. This would prohibit
the problem you showed above.


Kind regards,
Andreas
