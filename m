Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpo-eml02.KPNXCHANGE.COM ([213.75.38.151]:46363 "EHLO
	cpsmtpo-eml02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751562AbZAFUcu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 15:32:50 -0500
Message-ID: <4963BFEF.2090006@kpnplanet.nl> (sfid-20090106_213253_182030_D2948A9B)
Date: Tue, 06 Jan 2009 21:32:47 +0100
From: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Ivo van Doorn <ivdoorn@gmail.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rt2400-devel@lists.sourceforge.net"
	<rt2400-devel@lists.sourceforge.net>
Subject: Re: [PATCH] rt2x00: Provide regulatory hint with rt2500pci/usb
References: <200901042021.10904.IvDoorn@gmail.com> <20090105200809.GH6834@tesla> <49627BCB.4020200@kpnplanet.nl> <200901052321.46422.IvDoorn@gmail.com> <20090105234546.GK6834@tesla>
In-Reply-To: <20090105234546.GK6834@tesla>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/06/09 00:45, Luis R. Rodriguez wrote:
> On Mon, Jan 05, 2009 at 02:21:46PM -0800, Ivo van Doorn wrote:
>    
>> On Monday 05 January 2009, Gertjan van Wingerde wrote:
>>      
>>> On 01/05/09 21:08, Luis R. Rodriguez wrote:
>>>        
>>> The problem isn't there for the bits that Ivo sent, as the rt2500 devices don't support the a band.
>>>        
>> For rt2500pci and rt2500usb there are chipsets which support 5GHz (they are rare, but they do exist),
>> comments for the Ralink drivers indicate they simply didn't add the regulatory domain definitions yet.
>>      
>
> Based on the documentation from the EEPROM for all devices I read that its recommended
> that the EEPROM *not be relied on for the regulatory domain*, instead it recommends the
> windows registry be used.
>
> Based on tests for the devices with only one band, do are you seeing an actual regulatory
> domain in the EEPROM?
>
> To deal with the issue of having two separate EEPROM values for a regulatory domain
> and since the documentation indicates to not rely on it I would advise to allow users
> to be compliant by selecting the country they are in. wpa_supplicant has support for
> selecting country now, and so does iw. Eventually I see Network Manager letting users
> select the country. But you guys are the maintainers and developers so you will know
> better.
>    

My tests indicate that there are devices out there that have this 
information set in the EEPROM. Based on tests with my own patch, and my 
own devices, I have been able to determine the following:

1. rt2400pci --> don't know, don't own a rt2400pci device.
2. rt2500pci --> don't know, don't own a rt2500pci device anymore.
3. rt2500usb --> my e-tech device (not sure which type; the device 
doesn't say it) has an actual domain set for the bg band.
4. rt61pci --> my Sitecom WL151 device does not contain actual domain 
information.
5. rt73usb --> my Sitecom WL113-002 device does contain actual domain 
information, and the codes for the bg band and a band are the same.
6. rt2800pci --> my Sitecom WL182 device does contain actual domain 
information, and the codes for the bg band and a band are the same.
7. rt2800usb --> my Sitecom WL181 device does contain actual domain 
information, and the codes for the bg band and a band are the same.

So, there are devices out there that do contain "meaningful" regulatory 
information.

Luis, the definitions for the a-band EEPROM codes only give the channel 
numbers, it doesn't indicate a real "country". Is there any way we can 
check whether these sets of channels are actually consistent with the 
regulations of specific countries?

---
Gertjan.
