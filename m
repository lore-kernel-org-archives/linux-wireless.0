Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:49334 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbZLEMES convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Dec 2009 07:04:18 -0500
Received: by fxm5 with SMTP id 5so3352108fxm.28
        for <linux-wireless@vger.kernel.org>; Sat, 05 Dec 2009 04:04:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1260007083.31590.935.camel@peura.elisa-laajakaista.fi>
References: <1259756709.31590.62.camel@peura.elisa-laajakaista.fi>
	 <4B169608.3010902@lwfinger.net>
	 <1259822699.31590.914.camel@peura.elisa-laajakaista.fi>
	 <4B198081.2090901@lwfinger.net>
	 <1260007083.31590.935.camel@peura.elisa-laajakaista.fi>
Date: Sat, 5 Dec 2009 12:04:23 +0000
Message-ID: <3ace41890912050404h1385a962w42d708af33d5958b@mail.gmail.com>
Subject: Re: New rtl8187 rfkill support blocks my wlan for good.
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: =?ISO-8859-1?Q?Antti_Kaijanm=E4ki?= <antti@kaijanmaki.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/12/5 Antti Kaijanmäki <antti@kaijanmaki.net>:
> pe, 2009-12-04 kello 15:34 -0600, Larry Finger kirjoitti:
..
>> I will get the same info
>> from Hin-Tak to see if we can differentiate your two devices.
>
> See the attached lsusb_v.txt

The only difference between yours and mine is just the USB id (8197 vs
8198). There is no other difference. (But it is probably unsafe to
base any change on product id alone - there are about 5-6 variants
even among the 3 ids
8187/8189 and 8197).

> I looked through the reference driver and found out that indeed the GPIO
> pin is different for some devices, mine included (0x8198).

There are differences between devices even with the same id - has
always been the case - see comment above.

> r8187_core.c:L4359
>
>        if((idProduct == 0x8197) || (idProduct == 0x8198))      {
>                priv->EEPROMSelectNewGPIO =((u8)((eprom_read(dev,EPROM_SELECT_GPIO) & 0xff00) >> 8)) ? true : false;
>                DMESG("EPROM_SELECT_GPIO:%d", priv->EEPROMSelectNewGPIO);
>        } else {
>                priv->EEPROMSelectNewGPIO = false;
>        }
>
>
>
> Here's the begining of the RFKILL code (see, 0x2 vs. 0x4!)
>
> r8187_core.c:L6258
>
>                        tmp1byte = read_nic_byte(dev,GPE);
>                        if(priv->EEPROMSelectNewGPIO == true)
>                                tmp1byte &= ~BIT2;
>                        else
>                                tmp1byte &= ~BIT1;
>
>                        write_nic_byte(dev,GPE,tmp1byte);

I'll have a look at what this does when I find the time. What version
of the vendor driver have you got? The last one we have is
26.1036.0708.2008 (mostly you just look at the 1036 part which is the
version, and 0708.2008 is the release date). If you have a more recent
version, you should share it with me, Larry and Herton - our e-mails
are in the MAINTAINERS file, but you already found me and Larry, just
Herton hasn't comment yet(?). (as I wrote, for some reason Realtek
doesn't put it up publicly for download but seems to be happy to
e-mail to people when they ask, so I think it is appropriate to behave
along similiar lines).

> I would like to prepare a proper patch, but I'm afraid I do not have the
> time right now and someone else can probably do it a lot faster. The
> current rfkill code is now in 2.6.32 and some people are going to find
> out that their wlan no longer is accessible because of insufficient
> rfkill detection so this puts this somewhat higher priority.

It is not as dramatic or gloomy as you wrote - my laptop is less than
2 years old, from the same menufacturer, so it just seems that Toshiba
chose to change and/or bought in a batch of newer Realtek chips which
behave somewhat differently. I assume yours is newer than mine. Nobody
knows how many Toshiba laptops out there behaves like mine (which was
where the rfkill code ended up in 2.6.32 was tested, successfully)
instead of like yours (which is affected adversely by the rfkill
code). And we want to fix this before major distros start to ship
2.6.32. That's probably going to be April with Ubuntu and Fedora. We
probably have a few months before it affects too many end users.

Hin-Tak
