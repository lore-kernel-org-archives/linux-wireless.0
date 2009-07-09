Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:34105 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380AbZGIMkF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 08:40:05 -0400
MIME-Version: 1.0
In-Reply-To: <4A55D123.5090802@gmail.com>
References: <4A54FB81.30302@gmail.com>
	 <3ace41890907081449m3ad6c4fdt55781848eedaec1e@mail.gmail.com>
	 <4A551B43.3020104@gmail.com>
	 <3ace41890907082118h52764c98i7ebd9365bcd69b2c@mail.gmail.com>
	 <4A5575C1.8090403@lwfinger.net>
	 <3ace41890907090347m1f337731rb09b90327664ed5@mail.gmail.com>
	 <4A55D123.5090802@gmail.com>
Date: Thu, 9 Jul 2009 13:40:02 +0100
Message-ID: <3ace41890907090540v6895e2bay8128c0d565a7a55f@mail.gmail.com>
Subject: Re: [PATCH] wireless: fix supported cards for rtl8187
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Linux wireless <linux-wireless@vger.kernel.org>,
	Przemyslaw Kulczycki <azrael@autocom.pl>,
	LKML <linux-kernel@vger.kernel.org>,
	=?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/7/9 Marcin Slusarz <marcin.slusarz@gmail.com>:
> Hin-Tak Leung pisze:
>> 2009/7/9 Larry Finger <Larry.Finger@lwfinger.net>:
>>> Hin-Tak Leung wrote:
>>>> if they are not labelled v1/v2/v3 as such, it may be more
>>>> useful/informative to change to
>>>>
>>>>     [some variant of ] ... [(other variants are supported by the
>>>> rt2070/rt3070 modules)]
>>>>
>>>> instead of just adding [v2] to the end.
>>> I don't know about the box as I bought mine used on Ebay, but the
>>> label on the device clearly states that it is a WG111v2.
>>>
>>> Larry
>>>
>>>
>>
>> But that's  a Netgear WG111v2 ? We are talking about Linksys
>> WUSB54GC-EU and its v1/v2/v3 . I am just thinking that if it is for
>> informative purposes (for those who actually selectively build their
>> kernel modules), adding a bit more info, such as suggesting to use
>> rt73usb/rt2070/rt3070 modules, won't hurt.
>>
>> Incidentally I like to know a bit more about this patch - presumably
>> Marcin has such a device? I am also a little curious, as this commit
>> should be accompanied by a corresponding update in another Kconfig
>> which supports the device? I am not trying to be picky, but for an
>> informative (non-code-changing) patch, it can be more informative.
>
> I have a v3 device and this driver does not support it.
> Below is the commit which added the string my patch corrects.
> I've sent yesterday another patch which adds support for WUSB54GC v3
> to the rt3070 driver.

Here is some info from Gabor (shouldn't this be reply-all rather than just me):
------------------
The v1 and v2 look identical (though the label on the device indicates
the revision). The v3 looks completely different. They all have
different USB IDs (v1 is stock RT73, v2 has a custom ID, while v3 is
AFAIK stock RT2070).
------------------

I guess to be informative, may I suggest adding '(for v1  see rt73usb,
and v3 see rt3070)' or something similiar to the 'v2' change?
It is fair customary in Kconfig to mention even alternative/competing
drivers for the same device. And when you add v3 support to the rt3070
driver, a reverse mention may be appropriate. (I guess I am spending
far too long on this discussion - but I reckon, the purpose of a
non-code-changing change is meant to be informative, so one might want
to be as informative as appropriate without being too wordy...)

>
> commit aeeab4ff06b8e29cfe2fe730ba626f7e2487ba03
> Author: John W. Linville <linville@tuxdriver.com>
> Date:   Wed May 27 09:21:57 2009 +0200
>
>    rtl8187: add USB ID for Linksys WUSB54GC-EU v2 USB wifi dongle
>
>    http://bugzilla.kernel.org/show_bug.cgi?id=13383
>
>    Reported-by: Przemyslaw Kulczycki <azrael@autocom.pl>
>    Signed-off-by: John W. Linville <linville@tuxdriver.com>
>
> diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
> index 8a08235..3d94e7d 100644
> --- a/drivers/net/wireless/Kconfig
> +++ b/drivers/net/wireless/Kconfig
> @@ -430,6 +430,7 @@ config RTL8187
>          ASUS P5B Deluxe
>          Toshiba Satellite Pro series of laptops
>          Asus Wireless Link
> +         Linksys WUSB54GC-EU
>
>          Thanks to Realtek for their support!
>
> diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
> index bac6cfb..d51ba0a 100644
> --- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
> +++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
> @@ -71,6 +71,8 @@ static struct usb_device_id rtl8187_table[] __devinitdata = {
>        {USB_DEVICE(0x18E8, 0x6232), .driver_info = DEVICE_RTL8187},
>        /* AirLive */
>        {USB_DEVICE(0x1b75, 0x8187), .driver_info = DEVICE_RTL8187},
> +       /* Linksys */
> +       {USB_DEVICE(0x1737, 0x0073), .driver_info = DEVICE_RTL8187B},
>        {}
>  };
>
>
>
>
