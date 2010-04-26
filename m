Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:2920 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751787Ab0DZTwb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 15:52:31 -0400
Message-ID: <4BD5EEFC.6050003@gmail.com>
Date: Mon, 26 Apr 2010 21:52:28 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Luis Correia <luis.f.correia@gmail.com>
Subject: Re: [PATCH 6/9] rt2x00: Finish rt3070 support in rt2800 register
 initialization.
References: <1270989075-2267-1-git-send-email-gwingerde@gmail.com> <1270989075-2267-7-git-send-email-gwingerde@gmail.com> <201004261302.14682.helmut.schaa@googlemail.com>
In-Reply-To: <201004261302.14682.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/26/10 13:02, Helmut Schaa wrote:
> Am Sonntag 11 April 2010 schrieb Gertjan van Wingerde:
>> rt2x00 had preliminary support for RT3070 based devices, but the support was
>> incomplete.
>> Update the RT3070 register initialization to be similar to the latest Ralink
>> vendor driver.
>>
>> With this patch my rt3070 based devices start showing a sign of life.
> 
> Gertjan, this patch breaks rx on my 305x SoC device. See inline comments for
> more details.
> 
> [...]
> 
>> @@ -1643,18 +1653,12 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>>  {
>>  	u8 rfcsr;
>>  	u8 bbp;
>> +	u32 reg;
>> +	u16 eeprom;
>>  
>> -	if (rt2x00_is_usb(rt2x00dev) &&
>> -	    !rt2x00_rt_rev(rt2x00dev, RT3070, REV_RT3070E))
>> +	if (!rt2x00_rt(rt2x00dev, RT3070))
>>  		return 0;
>>  
>> -	if (rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev)) {
>> -		if (!rt2x00_rf(rt2x00dev, RF3020) &&
>> -		    !rt2x00_rf(rt2x00dev, RF3021) &&
>> -		    !rt2x00_rf(rt2x00dev, RF3022))
>> -			return 0;
>> -	}
> 
> Any reason why you've removed this part? The following code was executed on
> pci and soc devices when they had an 3020, 3021 or 3022 rf.

I removed it because the Ralink driver only checks for RT chipset type, not for
the RF chipset type. Looks like that in the conversion the unmentioned RT2872
got lost.

> 
>>  	/*
>>  	 * Init RF calibration.
>>  	 */
>> @@ -1665,13 +1669,13 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>>  	rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 0);
>>  	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
>>  
>> -	if (rt2x00_is_usb(rt2x00dev)) {
>> +	if (rt2x00_rt(rt2x00dev, RT3070)) {
>>  		rt2800_rfcsr_write(rt2x00dev, 4, 0x40);
>>  		rt2800_rfcsr_write(rt2x00dev, 5, 0x03);
>>  		rt2800_rfcsr_write(rt2x00dev, 6, 0x02);
>>  		rt2800_rfcsr_write(rt2x00dev, 7, 0x70);
>>  		rt2800_rfcsr_write(rt2x00dev, 9, 0x0f);
>> -		rt2800_rfcsr_write(rt2x00dev, 10, 0x71);
>> +		rt2800_rfcsr_write(rt2x00dev, 10, 0x41);
>>  		rt2800_rfcsr_write(rt2x00dev, 11, 0x21);
>>  		rt2800_rfcsr_write(rt2x00dev, 12, 0x7b);
>>  		rt2800_rfcsr_write(rt2x00dev, 14, 0x90);
>> @@ -1684,48 +1688,25 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>>  		rt2800_rfcsr_write(rt2x00dev, 21, 0xdb);
>>  		rt2800_rfcsr_write(rt2x00dev, 24, 0x16);
>>  		rt2800_rfcsr_write(rt2x00dev, 25, 0x01);
>> -		rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
>>  		rt2800_rfcsr_write(rt2x00dev, 29, 0x1f);
>> -	} else if (rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev)) {
>> -		rt2800_rfcsr_write(rt2x00dev, 0, 0x50);
>> -		rt2800_rfcsr_write(rt2x00dev, 1, 0x01);
>> -		rt2800_rfcsr_write(rt2x00dev, 2, 0xf7);
>> -		rt2800_rfcsr_write(rt2x00dev, 3, 0x75);
>> -		rt2800_rfcsr_write(rt2x00dev, 4, 0x40);
>> -		rt2800_rfcsr_write(rt2x00dev, 5, 0x03);
>> -		rt2800_rfcsr_write(rt2x00dev, 6, 0x02);
>> -		rt2800_rfcsr_write(rt2x00dev, 7, 0x50);
>> -		rt2800_rfcsr_write(rt2x00dev, 8, 0x39);
>> -		rt2800_rfcsr_write(rt2x00dev, 9, 0x0f);
>> -		rt2800_rfcsr_write(rt2x00dev, 10, 0x60);
>> -		rt2800_rfcsr_write(rt2x00dev, 11, 0x21);
>> -		rt2800_rfcsr_write(rt2x00dev, 12, 0x75);
>> -		rt2800_rfcsr_write(rt2x00dev, 13, 0x75);
>> -		rt2800_rfcsr_write(rt2x00dev, 14, 0x90);
>> -		rt2800_rfcsr_write(rt2x00dev, 15, 0x58);
>> -		rt2800_rfcsr_write(rt2x00dev, 16, 0xb3);
>> -		rt2800_rfcsr_write(rt2x00dev, 17, 0x92);
>> -		rt2800_rfcsr_write(rt2x00dev, 18, 0x2c);
>> -		rt2800_rfcsr_write(rt2x00dev, 19, 0x02);
>> -		rt2800_rfcsr_write(rt2x00dev, 20, 0xba);
>> -		rt2800_rfcsr_write(rt2x00dev, 21, 0xdb);
>> -		rt2800_rfcsr_write(rt2x00dev, 22, 0x00);
>> -		rt2800_rfcsr_write(rt2x00dev, 23, 0x31);
>> -		rt2800_rfcsr_write(rt2x00dev, 24, 0x08);
>> -		rt2800_rfcsr_write(rt2x00dev, 25, 0x01);
>> -		rt2800_rfcsr_write(rt2x00dev, 26, 0x25);
>> -		rt2800_rfcsr_write(rt2x00dev, 27, 0x23);
>> -		rt2800_rfcsr_write(rt2x00dev, 28, 0x13);
>> -		rt2800_rfcsr_write(rt2x00dev, 29, 0x83);
> 
> This part is actually needed for getting rx to work on the SoC devices.

Hmm, interesting, as I don't know where this code actually came from. It isn't needed for
PCI devices in general (at least not the PCI devices I've checked), so it may be specific to SoC.

> 
> Should I post a patch that adds this code again and is only executed on SoC
> devices with rf3020, 3021 and 3022?
> 

OK. I have just checked the two RT2872 based devices I have (one PCI one and one USB one),
and both of them act very strangely.

I'll check against the Ralink SoC driver code that I've got as to how the initialization should actually
be.

---
Gertjan.
