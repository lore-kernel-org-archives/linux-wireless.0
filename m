Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpo-eml01.KPNXCHANGE.COM ([213.75.38.150]:37994 "EHLO
	cpsmtpo-eml01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757994AbZAFW0d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 17:26:33 -0500
Message-ID: <4963D704.5030502@kpnplanet.nl> (sfid-20090106_232650_452481_1C821245)
Date: Tue, 06 Jan 2009 23:11:16 +0100
From: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rt2400-devel@lists.sourceforge.net"
	<rt2400-devel@lists.sourceforge.net>
Subject: Re: [PATCH] rt2x00: Provide regulatory hint with rt2500pci/usb
References: <200901042021.10904.IvDoorn@gmail.com> <4963C186.2070408@kpnplanet.nl> <20090106204923.GC21980@tesla> <200901062251.28850.IvDoorn@gmail.com>
In-Reply-To: <200901062251.28850.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/06/09 22:51, Ivo van Doorn wrote:
> On Tuesday 06 January 2009, Luis R. Rodriguez wrote:
>    
>> On Tue, Jan 06, 2009 at 12:39:34PM -0800, Gertjan van Wingerde wrote:
>>      
>>> On 01/06/09 18:47, Ivo van Doorn wrote:
>>>        
>>>> On Tuesday 06 January 2009, Luis R. Rodriguez wrote:
>>>>
>>>>          
>>>>> On Tue, Jan 06, 2009 at 09:32:20AM -0800, Ivo van Doorn wrote:
>>>>>
>>>>>            
>>>>>>>>> 2. I'm still puzzled how to handle the two different values that the EEPROM has, namely one for the bg band and one for the a band. I've handled it by registering the one associated with the configured band, but that seems to be unlikely to be correct. I still haven't found a better way to handle this.
>>>>>>>>>
>>>>>>>>>                    
>>>>>>>> Because of this I hadn't looked very deep into rt61 and rt73 yet.
>>>>>>>>
>>>>>>>>
>>>>>>>>                  
>>>>>>>>> The problem isn't there for the bits that Ivo sent, as the rt2500 devices don't support the a band.
>>>>>>>>>
>>>>>>>>>                    
>>>>>>>> For rt2500pci and rt2500usb there are chipsets which support 5GHz (they are rare, but they do exist),
>>>>>>>> comments for the Ralink drivers indicate they simply didn't add the regulatory domain definitions yet.
>>>>>>>>
>>>>>>>>                  
>>>>>>> Based on the documentation from the EEPROM for all devices I read that its recommended
>>>>>>> that the EEPROM *not be relied on for the regulatory domain*, instead it recommends the
>>>>>>> windows registry be used.
>>>>>>>
>>>>>>> Based on tests for the devices with only one band, do are you seeing an actual regulatory
>>>>>>> domain in the EEPROM?
>>>>>>>
>>>>>>>                
>>>>>> I have to check, but I don't think I have any hardware with valid domain values.
>>>>>>
>>>>>>
>>>>>>              
>>>>>>> To deal with the issue of having two separate EEPROM values for a regulatory domain
>>>>>>> and since the documentation indicates to not rely on it I would advise to allow users
>>>>>>> to be compliant by selecting the country they are in. wpa_supplicant has support for
>>>>>>> selecting country now, and so does iw. Eventually I see Network Manager letting users
>>>>>>> select the country. But you guys are the maintainers and developers so you will know
>>>>>>> better.
>>>>>>>
>>>>>>>                
>>>>>> Well it is fine with me,  understood from earlier discussion that it was advised that drivers
>>>>>> attempted to set the domain if they could. Hence the reason I had added reading the EEPROM
>>>>>> for domain values to the TODO list. But it is true that it is quite rare that there are valid values
>>>>>> for it. So it would be fine with me by letting the user handle it completely.
>>>>>>
>>>>>>              
>>>>> I see -- well if there are *some* cards that do have valid EEPROM values then it seems worth it
>>>>> to do the actual regulatory_hint(), for dual band cards you can probably just not support it. But
>>>>> its up to you guys. Just my advice based on the documentation I have read so far.
>>>>>
>>>>>            
>>>> Ok.
>>>>
>>>> Gertjan, do you know if there is any hardware with valid GEO data in the EEPROM?
>>>>
>>>>          
>>> As mentioned in my previous email, I do have devices that have valid GEO
>>> data in the EEPROM. So, we should be able to use that.
>>> Also, for the dual band cards, it does seem that at least the numerical
>>> values are similar for both bands (although I'm not sure that same
>>> numerical values means same regulatory domain). This is at least the
>>> case on all the cards that I own.
>>>        
>> If that's the case and since dual band cards will most likely have 2ghz support
>> why not just provide regulatory_hint() based on the 2ghz band all the time?
>>      
>
> Sounds like the most reasonable solution to me as well.

I had a *slightly* more sophisticated model in mind: Check for dual-band 
devices whether the EEPROM values match. If they do, provide the 
regulatory_hint(), if they don't then just log an error, stating that 
the EEPROM cannot make up its mind in which geography it belongs. Just 
to prevent some unexpected behavior for devices that don't have sane 
EEPROM values.

However, that is all based on the assumption that we can match the 
numerical values of the two band geography domains. So far I haven't 
been able to establish that, and, moreover, the a-band field allows for 
values 0-10 where the bg-band field allows for values 0-7. So, we have 
to start matching these values against their defined allowed channels, 
and against the regulatory definitions, to see if we can actually match 
the values.

---
Gertjan
