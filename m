Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:47211 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab1HIQOw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 12:14:52 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MWU-Mas_c814EcMjSgAh5dbOmDDrLzbtCFaf3wpMEHexA@mail.gmail.com>
References: <CAG1a4rtHedO66ot4B7TWmKG5_mrnSS78O74_xxmgXk7UeoX_gA@mail.gmail.com>
 <CACqU3MWU-Mas_c814EcMjSgAh5dbOmDDrLzbtCFaf3wpMEHexA@mail.gmail.com>
From: Pavel Ivanov <paivanof@gmail.com>
Date: Tue, 9 Aug 2011 12:14:22 -0400
Message-ID: <CAG1a4rtd6UoD1r2crLhkbvViSL9q8b_Zw+afGj4HFSbwzKiUEA@mail.gmail.com> (sfid-20110809_181456_302599_F328AB5F)
Subject: Re: Cannot easily set CONFIG_WIRELESS_EXT in kernel 3.0 build
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Arnaud.

>> I've tried to build and install kernel 3.0. The standard Ubuntu
>> configuration worked very well. But after I ran 'make localmodconfig',
>> rebuilt and rebooted my wireless didn't work. After some investigation
>> I've found that option CONFIG_WIRELESS_EXT is no longer set in .config
>> file.
> what is the ubuntu kernel version ?

Ubuntu's version is 2.6.38.11-generic.

>> But no matter how I tried to include it in .config file it was
>> automatically deleted by 'make oldconfig' and again kernel compiled
>> without it.
> well, .config is not meant to be edited manually. It is written at the
> top of the file:
>
> # Automatically generated file; DO NOT EDIT.

Well, then how am I expected to manually change configuration
parameters without running any automated program? Manual editing of
.config worked (well, except some automatic changes which I've already
got used to). Should I edit some other file instead?

>> In fact even if
>> I add 'select WIRELESS_EXT' to Kconfig of the driver for my wireless
>> card (ath9k) everything works as well.
>>
> did you look at ubuntu kernel sources to see if the Kconfig entry
> ath9k driver had been changed to 'select WIRELESS_EXT' ? What may be
> more likely is that ubuntu is building a bundle of driver, and one of
> them include WIRELESS_EXT.

I didn't look at Ubuntu sources yet but I've just assumed the same -
as some of compiled drivers include WIRELESS_EXT everything works with
any driver.

> Could you generate a patch for the change you made to make your
> adapter works and send them to the wireless folks ? They are likely to
> be more aware of the various requirement and inter-dependency of the
> subsystem.

Will do, thanks.

Pavel
