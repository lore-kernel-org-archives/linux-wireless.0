Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f198.google.com ([209.85.211.198]:48495 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbZLERIx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Dec 2009 12:08:53 -0500
Received: by ywh36 with SMTP id 36so3110294ywh.15
        for <linux-wireless@vger.kernel.org>; Sat, 05 Dec 2009 09:08:59 -0800 (PST)
Message-ID: <4B1A93A9.8080009@lwfinger.net>
Date: Sat, 05 Dec 2009 11:08:57 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?QW50dGkgS2FpamFubcOka2k=?= <antti@kaijanmaki.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: New rtl8187 rfkill support blocks my wlan for good.
References: <1259756709.31590.62.camel@peura.elisa-laajakaista.fi>	 <4B169608.3010902@lwfinger.net>	 <1259822699.31590.914.camel@peura.elisa-laajakaista.fi>	 <4B198081.2090901@lwfinger.net> <1260007083.31590.935.camel@peura.elisa-laajakaista.fi>
In-Reply-To: <1260007083.31590.935.camel@peura.elisa-laajakaista.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/05/2009 03:58 AM, Antti Kaijanmäki wrote:
> pe, 2009-12-04 kello 15:34 -0600, Larry Finger kirjoitti:
>> Antti,
>>
>> From our private tests, you can see my problem with making a change in
>> the rfkill handling. Most of the devices in the hands of the
>> developers do not honor the rfkill switch; however, the one that does
>> works with the current code. This code also matches the latest version
>> of the vendor drivers for the RTL8187L
>> (rtl8187L_linux_26.1038.0626.2009.release) and RTL8187B
>> (rtl8187B_linux_26.1036.0708.2008). If you have newer drivers from
>> Realtek, I would be interested in seeing them.
> 
> I attached the one I received.
> 
> 
>> To make a special case for your system, we need to be able to
>> differentiate it from all other systems. We know that the chip has the
>> same cut (RTL8187BvE V0) as Hin-Tak's, and the same vendor ID (0x04).
>> We do have devices that require parsing additional USB data to get the
>> setup properly initialized. Please send me the full output of the
>> 'lsusb -v' command for the rtl8187 device. I will get the same info
>> from Hin-Tak to see if we can differentiate your two devices.
> 
> See the attached lsusb_v.txt
> 
> 
> I had now some time to look in to this. First of all I was sad to
> discover that the specifications from Realtek have incomplete EEPROM
> register descriptions and they are no use to figure this problem out.
> But at least they describe the functionality so that it's easier to find
> out what's going on with the drivers.
> 
> I looked through the reference driver and found out that indeed the GPIO
> pin is different for some devices, mine included (0x8198).
> 
> r8187_core.c:L4359
> 
>         if((idProduct == 0x8197) || (idProduct == 0x8198))      {
>                 priv->EEPROMSelectNewGPIO =((u8)((eprom_read(dev,EPROM_SELECT_GPIO) & 0xff00) >> 8)) ? true : false;
>                 DMESG("EPROM_SELECT_GPIO:%d", priv->EEPROMSelectNewGPIO);
>         } else {
>                 priv->EEPROMSelectNewGPIO = false;
>         }
> 
> 
> 
> Here's the begining of the RFKILL code (see, 0x2 vs. 0x4!)
> 
> r8187_core.c:L6258
> 
>                         tmp1byte = read_nic_byte(dev,GPE);
>                         if(priv->EEPROMSelectNewGPIO == true)
>                                 tmp1byte &= ~BIT2;
>                         else
>                                 tmp1byte &= ~BIT1;
> 
>                         write_nic_byte(dev,GPE,tmp1byte);
> 
> 
> I would like to prepare a proper patch, but I'm afraid I do not have the
> time right now and someone else can probably do it a lot faster. The
> current rfkill code is now in 2.6.32 and some people are going to find
> out that their wlan no longer is accessible because of insufficient
> rfkill detection so this puts this somewhat higher priority.

Thanks for this info. Your reference driver is indeed newer than the
one that I had. With the info from it, I will prepare a patch for you,
Hin-Tak, and anyone else to test. It should be ready yet today.

Larry
