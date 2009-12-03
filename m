Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:46951 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbZLCNdu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2009 08:33:50 -0500
Received: by yxe17 with SMTP id 17so1118722yxe.33
        for <linux-wireless@vger.kernel.org>; Thu, 03 Dec 2009 05:33:56 -0800 (PST)
Message-ID: <4B17BE42.8040407@lwfinger.net>
Date: Thu, 03 Dec 2009 07:33:54 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: =?ISO-8859-1?Q?Antti_Kaijanm=E4ki?= <antti@kaijanmaki.net>,
	linux-wireless@vger.kernel.org
Subject: Re: New rtl8187 rfkill support blocks my wlan for good.
References: <1259756709.31590.62.camel@peura.elisa-laajakaista.fi>	 <4B169608.3010902@lwfinger.net>	 <1259822699.31590.914.camel@peura.elisa-laajakaista.fi> <3ace41890912030401k7cb41386rc134e167a8e4bea6@mail.gmail.com>
In-Reply-To: <3ace41890912030401k7cb41386rc134e167a8e4bea6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/03/2009 06:01 AM, Hin-Tak Leung wrote:
> 2009/12/3 Antti Kaijanmäki <antti@kaijanmaki.net>:
>> It's a Toshiba Satellite Pro L300.
> 
> I have a Toshiba A210; the Realtek hardware is the same, but I am a
> little surprised that there is no similiarity to the mac address
> (AFAIK part of the mac address is the manufacturer's identity). In any
> case, the rkill code works here
> (up to date fedora 12 + compat-wireless from yesterday or the day before).
> 
>> I contacted Realtek again and this morning I had data sheets for
>> RTL8187B and RTL8187L chipsets in my inbox, yay!. I didn't have time to
>> look deeply in to them just yet, but at quick glance the data sheets
>> didn't talk anything about rfkill. My fear is that the rfkill features
>> are laptop vendor specific by being implemented using the General
>> Purpose IO pins, but this speculation is still premature.
> 
> Yes, I think the gpio pins are OEM-specific.
> 
> --- rtl8187_rfkill.c.orig       2009-12-02 14:12:34.646597569 +0200
> +++ rtl8187_rfkill.c    2009-12-02 14:10:09.474593370 +0200
> @@ -28,7 +28,7 @@ static bool rtl8187_is_radio_enabled(str
>        rtl818x_iowrite8(priv, &priv->map->GPIO0, gpio & ~0x02);
>        gpio = rtl818x_ioread8(priv, &priv->map->GPIO1);
> 
> -       return gpio & 0x02;
> +       return gpio & 0x04;
> 
>  }
> 
> Your patch is probably wrong - all you are doing is get some random
> bits off the chip and lie to the rest of the system about being radio
> is enabled.
> 
> That leads to my next question - what *is the rest* of your system?
> Back in F11 I had a funny problem for a few days when I was trying
> out/testing the then-new rtl8187 rfkill code Larry and Herton came up
> with: I can switch off the radio and it is effective for about 1
> minute - then NetworkManager decides to turn the wireless chip back
> on. It turned out that hal (at least on F11, and also then, a few
> months ago) needed to be taught to honour the state of the rkill
> switch and be aware of it. Maybe you have the reverse problem - the
> rest of your system needs to be taught not to switch it off.
> 
> As for the datasheet - no, there aren't any obvious rfkill info (or I
> haven't read carefully - Larry will correct me). Realtek doesn't seem
> to have a problem with e-mailing it to individuals, so a few of us has
> it as well; but since they don't have it available for public download
> on their web site, I assume it was sent on good faith for private
> viewing pleasure.... and the terms of (re-)distribution is probably to
> people who show interests in improving the driver. (instead of, say,
> to competitors trying to poke holes in their hardware...).

Hin-Tak,

What does your system report as the cut label and the customer ID? If
the OEM gets to choose how the GPIO pins are wired, perhaps we can use
that info to differentiate between a value of 0x2 vs 0x4.

If anyone else has a built-in RTL8187L with a radio-kill switch, I
would appreciate getting information regarding your system. The 2
lines are as follows:

phy0: hwaddr XX:XX:XX:XX:XX:XX, RTL8187BvE V0 + rtl8225z2
rtl8187: Customer ID is 0x04

Thanks,

Larry

