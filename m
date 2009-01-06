Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpo-eml03.KPNXCHANGE.COM ([213.75.38.152]:8296 "EHLO
	cpsmtpo-eml03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751572AbZAFWGy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 17:06:54 -0500
Message-ID: <4963D5FB.60409@kpnplanet.nl> (sfid-20090106_230705_743902_FDBBB762)
Date: Tue, 06 Jan 2009 23:06:51 +0100
From: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rt2400-devel@lists.sourceforge.net"
	<rt2400-devel@lists.sourceforge.net>
Subject: Re: [PATCH] rt2x00: Provide regulatory hint with rt2500pci/usb
References: <200901042021.10904.IvDoorn@gmail.com> <200901052321.46422.IvDoorn@gmail.com> <4963BC6F.7030201@kpnplanet.nl> <200901062252.15677.IvDoorn@gmail.com>
In-Reply-To: <200901062252.15677.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/06/09 22:52, Ivo van Doorn wrote:
>>>
>>>        
>>>> The problem isn't there for the bits that Ivo sent, as the rt2500 devices don't support the a band.
>>>>
>>>>          
>>> For rt2500pci and rt2500usb there are chipsets which support 5GHz (they are rare, but they do exist),
>>> comments for the Ralink drivers indicate they simply didn't add the regulatory domain definitions yet.
>>>
>>>        
>> OK. But the EEPROM definitions I got from Ralink on the Country
>> information indicate that there is only a single indication in the EEPROM.
>>      
>
> That is right, like I said the comments already indicates there the legacy code didn't contain the
> definitions (yet). ;)
>
>    
>>> GertJan, some comments about your patch:
>>>
>>>
>>>        
>>>> diff --git a/drivers/net/wireless/rt2x00/rt2400pci.h b/drivers/net/wireless/rt2x00/rt2400pci.h
>>>> index 9aefda4..986e428 100644
>>>> --- a/drivers/net/wireless/rt2x00/rt2400pci.h
>>>> +++ b/drivers/net/wireless/rt2x00/rt2400pci.h
>>>> @@ -806,6 +806,13 @@
>>>>    #define EEPROM_TXPOWER_2		FIELD16(0xff00)
>>>>
>>>>    /*
>>>> + * EEPROM geography.
>>>> + * GEO: Default geography setting for device.
>>>> + */
>>>> +#define EEPROM_GEOGRAPHY		0x17
>>>> +#define EEPROM_GEOGRAPHY_GEO		FIELD16(0xff00)
>>>>
>>>>          
>>> Where did you find this definition? I couldn't find it in the legacy driver or the specsheets.
>>>
>>>        
>> I got an excerpt from the EEPROM definition for the rt2460 chip (which I
>> received with the help of Luis). It's defined in there.
>>      
>
> I assume you mean the file RT2460_DS_P1.3.pdf, could you point me to the right pagenumber?
>
>    
No, I meant RT2460_EEPROM_Channels.pdf, which was sent by Ralink a 
couple of months ago. You were copied on the email; let me know if you 
can't find them. Note that these were only small excerpts from the 
entire EEPROM definitions, only the parts on geography information.

---
Gertjan.
