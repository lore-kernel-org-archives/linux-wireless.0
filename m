Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f13.google.com ([209.85.217.13]:43166 "EHLO
	mail-gx0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069AbZAFWRZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 17:17:25 -0500
Received: by gxk6 with SMTP id 6so6412959gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2009 14:17:23 -0800 (PST)
Message-ID: <43e72e890901061417l26085dc0g61a88629650456b7@mail.gmail.com> (sfid-20090106_231744_208211_000232AE)
Date: Tue, 6 Jan 2009 14:17:23 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Gertjan van Wingerde" <gwingerde@kpnplanet.nl>
Subject: Re: [PATCH] rt2x00: Provide regulatory hint with rt2500pci/usb
Cc: "Ivo van Doorn" <ivdoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rt2400-devel@lists.sourceforge.net"
	<rt2400-devel@lists.sourceforge.net>
In-Reply-To: <4963D5FB.60409@kpnplanet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200901042021.10904.IvDoorn@gmail.com>
	 <200901052321.46422.IvDoorn@gmail.com> <4963BC6F.7030201@kpnplanet.nl>
	 <200901062252.15677.IvDoorn@gmail.com> <4963D5FB.60409@kpnplanet.nl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 6, 2009 at 2:06 PM, Gertjan van Wingerde
<gwingerde@kpnplanet.nl> wrote:
> On 01/06/09 22:52, Ivo van Doorn wrote:
>>>>
>>>>
>>>>>
>>>>> The problem isn't there for the bits that Ivo sent, as the rt2500
>>>>> devices don't support the a band.
>>>>>
>>>>>
>>>>
>>>> For rt2500pci and rt2500usb there are chipsets which support 5GHz (they
>>>> are rare, but they do exist),
>>>> comments for the Ralink drivers indicate they simply didn't add the
>>>> regulatory domain definitions yet.
>>>>
>>>>
>>>
>>> OK. But the EEPROM definitions I got from Ralink on the Country
>>> information indicate that there is only a single indication in the
>>> EEPROM.
>>>
>>
>> That is right, like I said the comments already indicates there the legacy
>> code didn't contain the
>> definitions (yet). ;)
>>
>>
>>>>
>>>> GertJan, some comments about your patch:
>>>>
>>>>
>>>>
>>>>>
>>>>> diff --git a/drivers/net/wireless/rt2x00/rt2400pci.h
>>>>> b/drivers/net/wireless/rt2x00/rt2400pci.h
>>>>> index 9aefda4..986e428 100644
>>>>> --- a/drivers/net/wireless/rt2x00/rt2400pci.h
>>>>> +++ b/drivers/net/wireless/rt2x00/rt2400pci.h
>>>>> @@ -806,6 +806,13 @@
>>>>>   #define EEPROM_TXPOWER_2             FIELD16(0xff00)
>>>>>
>>>>>   /*
>>>>> + * EEPROM geography.
>>>>> + * GEO: Default geography setting for device.
>>>>> + */
>>>>> +#define EEPROM_GEOGRAPHY               0x17
>>>>> +#define EEPROM_GEOGRAPHY_GEO           FIELD16(0xff00)
>>>>>
>>>>>
>>>>
>>>> Where did you find this definition? I couldn't find it in the legacy
>>>> driver or the specsheets.
>>>>
>>>>
>>>
>>> I got an excerpt from the EEPROM definition for the rt2460 chip (which I
>>> received with the help of Luis). It's defined in there.
>>>
>>
>> I assume you mean the file RT2460_DS_P1.3.pdf, could you point me to the
>> right pagenumber?
>>
>>
>
> No, I meant RT2460_EEPROM_Channels.pdf, which was sent by Ralink a couple of
> months ago. You were copied on the email; let me know if you can't find
> them. Note that these were only small excerpts from the entire EEPROM
> definitions, only the parts on geography information.

BTW we received permission from Ralink to put these up so they are also here:

http://wireless.kernel.org/en/developers/Documentation/specs#Ralinkdocumentation

  Luis
