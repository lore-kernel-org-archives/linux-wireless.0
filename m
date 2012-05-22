Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:52300 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572Ab2EVIlV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2012 04:41:21 -0400
Received: from [195.4.92.140] (helo=mjail0.freenet.de)
	by mout2.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1SWked-0005la-QI
	for linux-wireless@vger.kernel.org; Tue, 22 May 2012 10:41:19 +0200
Received: from localhost ([::1]:32945 helo=mjail0.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1SWked-00027h-Ln
	for linux-wireless@vger.kernel.org; Tue, 22 May 2012 10:41:19 +0200
Received: from [195.4.92.28] (port=53264 helo=18.mx.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1SWkcE-0000XV-IF
	for linux-wireless@vger.kernel.org; Tue, 22 May 2012 10:38:50 +0200
Received: from [2002:4fde:14c6:2:5054:ff:feb8:40bd] (port=39471 helo=mail.maya.org)
	by 18.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1SWkc5-0008Ek-0C
	for linux-wireless@vger.kernel.org; Tue, 22 May 2012 10:38:50 +0200
Message-ID: <4FBB5083.4000606@01019freenet.de> (sfid-20120522_104127_655308_C670F202)
Date: Tue, 22 May 2012 10:38:27 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rt2800: Initialize max_txpower to MAX_G_TXPOWER and MAX_A_TXPOWER
 respectively
References: <20120517230400.GB22418@yumi.tdiedrich.de> <CAGXE3d_Yz=-UWO+PiJkRQ7ZSBgh_fdcwsPz6FCig2VjOOoMQOg@mail.gmail.com> <20120518162158.GE22418@yumi.tdiedrich.de> <CAGXE3d8e+hYo_MT30XUW+r4-Dq6AgqLTJxD_oGnRuR94zjZ7_Q@mail.gmail.com> <4FB769DF.5060400@01019freenet.de>
In-Reply-To: <4FB769DF.5060400@01019freenet.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andreas Hartmann wrote:
> Helmut Schaa wrote:
>> On Fri, May 18, 2012 at 6:21 PM, Tobias Diedrich <ranma@tdiedrich.de> wrote:
>>>> So, maybe we should do it the safe way and just register a safe default
>>>> of 20dBm for all channels?
>>>
>>> AFAIU that would cap you to 20dBm even if you are in a country that
>>> has higher limits (e.g. 27dBm in the US?).
>>
>> Not necessarily because the driver won't allow tx power adjustments at all
>> if EEPROM_EIRP_MAX_TX_POWER is unused.
> 
> This means:
> Tx settings in cfg80211 as given by "iw reg get" e.g. are ignored
> completely as long as EEPROM_EIRP_MAX_TX_POWER is unused.
> Thus it is more or less chance that the device actually uses the allowed
> / correct Tx power at all. Maybe it's too high or too low. Both would be
> bad.

Please Helmut, I would be really grateful if you could confirm or negate
my conclusion.

>> For these devices we cannot rely on the tx power output at all and maybe
>> it makes sense to register a max power of 0 just to tell mac80211/cfg80211
>> that no tx power adjustments are possible on these devices?
> 
> Hmmm, this sounds really strange. How can I see if a device uses
> EEPROM_EIRP_MAX_TX_POWER at all?
> It would be good to have a log entry, telling the user that the Tx power
> of the device can't be adjusted at all and therefore it is possible,
> that the operation of the device might be illegal in the current country
> even if cfg80211 is set correctly.


Thank you Helmut,
kind regards,
Andreas
