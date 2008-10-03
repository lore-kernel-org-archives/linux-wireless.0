Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hpsmtp-eml12.kpnxchange.com ([213.75.38.112]:12457 "EHLO
	hpsmtp-eml12.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753059AbYJCUCI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2008 16:02:08 -0400
Message-ID: <48E67A3C.8090501@kpnplanet.nl> (sfid-20081003_220221_806652_1E0CD035)
Date: Fri, 03 Oct 2008 22:02:04 +0200
From: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>, mcgrof@gmail.com,
	linux-wireless@vger.kernel.org
Subject: Re: Regulatory Framework & rt2x00.
References: <48E52D07.8050900@kpnplanet.nl> <1223021104.24551.61.camel@johannes.berg> <200810032018.24910.IvDoorn@gmail.com>
In-Reply-To: <200810032018.24910.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo van Doorn wrote:
> Hi,
>
>    
>>> The problem I'm facing is that many of the Ralink devices have 2 region
>>> settings in their EEPROM, one for 802.11a networks, and one for
>>> 802.11[bgn] networks. So far I have only seen devices where these two
>>> settings contain the same region indication, but I don't know whether
>>> this is the case for all devices.
>>>
>>> At this point in time I use the regulatory_hint function at driver
>>> start-up time to communicate the region setting that matches the
>>> configured band, but that would (probably) not hold up when the user
>>> reconfigures the mode.
>>>        
>> I think you basically have two choices depending on whether you have a
>> country code in the eeprom or not.
>>
>> If you have a country code, I suggest you just use either one.
>>
>> As far as I know, though, you don't have country codes. So if there's a
>> valid code in the EEPROM you probably should use the regdomain struct
>> hint rather than the alpha2 hint and build a regdomain that contains
>> both 2.4 and 5 GHz channels based on the two region values you have.
>>      
>
> For rt61pci and rt73usb you should do as Johannes suggested by using the
> regdomain struct. For rt2500pci and rt2500usb it sounds much easier to
> take the country code from the EEPROM since those devices only contain
> a single regdom value.

Hmm, but building the regdomain struct would mean detailed region 
knowledge inside the driver. This is something I was trying to prevent, 
as all that knowledge has been moved to user-space with crda.

Luis, any other suggestions?

---
Gertjan.
