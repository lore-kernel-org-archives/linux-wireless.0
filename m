Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpo-eml01.kpnxchange.com ([213.75.38.150]:56187 "EHLO
	cpsmtpo-eml01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750951AbYJCWUD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2008 18:20:03 -0400
Message-ID: <48E69A8F.1060001@kpnplanet.nl> (sfid-20081004_002012_891946_D4015308)
Date: Sat, 04 Oct 2008 00:19:59 +0200
From: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"mcgrof@gmail.com" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Regulatory Framework & rt2x00.
References: <48E52D07.8050900@kpnplanet.nl> <20081002193357.GP5960@tesla> <48E67E78.8040807@kpnplanet.nl> <20081003143239.GI5964@tesla>
In-Reply-To: <20081003143239.GI5964@tesla>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Fri, Oct 03, 2008 at 01:20:08PM -0700, Gertjan van Wingerde wrote:
>    
>> My tests on the Ralink devices I have show that indeed the PCI devices
>> do not contain a region indication in EEPROM. However, all the USB
>> devices I have do contain such an indication (or one indication per band).
>>      
>
> Even if they have one if the docs say to ignore it then I'd ignore it.
>    

Unfortunately we don't have the EEPROM docs for the other chipsets (most 
notably USB-chipsets). I've asked Ralink whether they can share these 
with us.
I'll also study the Ralink provided driver in more detail. Maybe it 
gives some hints on how that driver uses the EEPROM information.

>
>> OK. I guess that depends on what model we want to have with Linux. For
>> me, the user should always have the possibility to override the HW
>> settings on region, as he might have taken the HW he bought in one
>> region of the world to another.
>>      
>
> This should only be possible if the devices were designed to world roam.
> Remember that world roaming is part of the IEEE-802.11 specs, and by
> default devices should be assumed to not be capable of it.
>
> For example iwl3945 or iwlagn driveres are not capable of world roaming
> because as of right now these devices are not designed to allow the
> driver to *add* new channels.
>
> Also keep in mind vendors tend to want to respect the EEPROM
> map of the regulatory domain. This is to deal with two issues:
>
> 1. Rogue APs sending sending a strange channels for an alpha2 through
>     a Country IE
>
> 2. Vendor's customers tend to like to stick sometimes to frequency
>     ranges which may be old in terms of regulatory rules because
>     although the device is capable of other frequencies the customer
>     may not have tested the device or certified it under the other
>     channels even adding a new channel may be seen as a feature.
>
> So it really depends. The answer to these questions *are* really
> vendor dependant and I what I would *highly* recommend is to take
> a conservative approach unless you have the vendor's blessing
> to do things differently, even if the vendor is not being
> cooeperative. Keep in mind though that doing this requires
> developer effort though so I can see why we won't have all drivers
> using regulatory_hint() and a reg_notifier() for example. But
> developers are forthcoming to write this then great -- if you
> don't get vendor support to enhance this then its really up us
> to decide what is best.
>    

Hmm, interesting. I would have assumed that in this era whether people 
are traveling round the world that vendors would create some more robust 
HW that is capable of coping with that. For instance, for my real-life 
job I do travel round the world a lot, and I'm using the built-in (as 
well as the Ralink PC-card I have) basically everywhere.

>
>> I'm not entirely sure yet. The basic question I have is that if I have a
>> device with has in EEPROM a region setting of US for the 5GHz band and
>> EU for the 2GHz band, what do I pass to the regulatory_hint function?
>>      
>
> Think about this for a second -- does this make any sense? I don't see
> how. Perhaps this is why its not recommended you rely on it. In the end,
> you won't know unless you ask the vendor.
>    

Yep, that's exactly the issue I had with this. It doesn't make sense to 
me to have multiple (potentially) different region codes programmed in 
EEPROM. Note that the example I gave is a real-life example. The EEPROM 
of my rt73usb device contain exactly these EEPROM settings for the 
region information :-(

---
Gertjan.
