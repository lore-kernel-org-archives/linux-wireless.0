Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:44799 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbZFRRjL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 13:39:11 -0400
Received: by bwz9 with SMTP id 9so1260815bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2009 10:39:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <69e28c910906181036j36fb7ad9lb9997c0920756c69@mail.gmail.com>
References: <1245340443-13214-1-git-send-email-pterjan@mandriva.com>
	<69e28c910906181036j36fb7ad9lb9997c0920756c69@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 18 Jun 2009 19:38:52 +0200
Message-ID: <69e28c910906181038w7cc662a6u2d4f0f321a7b1c43@mail.gmail.com>
Subject: Re: [PATCH] 07b8:6001 is a ZD1211B
To: Pascal Terjan <pterjan@mandriva.com>
Cc: Daniel Drake <dsd@gentoo.org>, kune@deine-taler.de,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Forgot to CC the list, sorry. (What happened to "Default Reply to All"?)

2009/6/18 Gábor Stefanik <netrolller.3d@gmail.com>:
> This appears to be the same as
> http://osdir.com/ml/network.wireless.zd1211.devel/2007-07/msg00038.html
>
> However, I can't actually find any trace of non-B ZD1211s with this ID.
>
> On Thu, Jun 18, 2009 at 5:54 PM, Pascal Terjan<pterjan@mandriva.com> wrote:
>> On a shuttle machine here we got 07b8:6001 device, handled by zd1211rw, which does not work.
>> Scanning is OK but association does not work, we get "direct probe to AP xxx timed out"
>>
>> It appears that this simple patch makes the device work perfectly.
>>
>> This id was already there in initial import of the driver so I don't know if it has ever been
>> working as ZD1211 (which would mean they changed it and kept the id :( ).
>>
>> Signed-off-by: Pascal Terjan <pterjan@mandriva.com>
>> ---
>>  drivers/net/wireless/zd1211rw/zd_usb.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
>> index f0e5e94..d04a69d 100644
>> --- a/drivers/net/wireless/zd1211rw/zd_usb.c
>> +++ b/drivers/net/wireless/zd1211rw/zd_usb.c
>> @@ -38,7 +38,6 @@ static struct usb_device_id usb_ids[] = {
>>        /* ZD1211 */
>>        { USB_DEVICE(0x0ace, 0x1211), .driver_info = DEVICE_ZD1211 },
>>        { USB_DEVICE(0x0ace, 0xa211), .driver_info = DEVICE_ZD1211 },
>> -       { USB_DEVICE(0x07b8, 0x6001), .driver_info = DEVICE_ZD1211 },
>>        { USB_DEVICE(0x126f, 0xa006), .driver_info = DEVICE_ZD1211 },
>>        { USB_DEVICE(0x6891, 0xa727), .driver_info = DEVICE_ZD1211 },
>>        { USB_DEVICE(0x0df6, 0x9071), .driver_info = DEVICE_ZD1211 },
>> @@ -86,6 +85,7 @@ static struct usb_device_id usb_ids[] = {
>>        { USB_DEVICE(0x0471, 0x1237), .driver_info = DEVICE_ZD1211B },
>>        { USB_DEVICE(0x07fa, 0x1196), .driver_info = DEVICE_ZD1211B },
>>        { USB_DEVICE(0x0df6, 0x0036), .driver_info = DEVICE_ZD1211B },
>> +       { USB_DEVICE(0x07b8, 0x6001), .driver_info = DEVICE_ZD1211B },
>>        /* "Driverless" devices that need ejecting */
>>        { USB_DEVICE(0x0ace, 0x2011), .driver_info = DEVICE_INSTALLER },
>>        { USB_DEVICE(0x0ace, 0x20ff), .driver_info = DEVICE_INSTALLER },
>> --
>> 1.6.2.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
