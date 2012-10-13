Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52119 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab2JMKOd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Oct 2012 06:14:33 -0400
Received: by mail-lb0-f174.google.com with SMTP id n3so2545591lbo.19
        for <linux-wireless@vger.kernel.org>; Sat, 13 Oct 2012 03:14:31 -0700 (PDT)
Message-ID: <50793F05.7030604@gmail.com> (sfid-20121013_121437_451445_95C3EEBB)
Date: Sat, 13 Oct 2012 12:14:29 +0200
From: Pontus Fuchs <pontus.fuchs@gmail.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	hch@lst.de, s.L-H@gmx.de
Subject: Re: [PATCH 2/4] ar5523: Add driver header file
References: <1349985702-21322-1-git-send-email-pontus.fuchs@gmail.com> <1349985702-21322-3-git-send-email-pontus.fuchs@gmail.com> <87626f0vzw.fsf@purkki.adurom.net>
In-Reply-To: <87626f0vzw.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-10-13 07:41, Kalle Valo wrote:
> Pontus Fuchs <pontus.fuchs@gmail.com> writes:
>
>> +#define ar5523_err(ar, format, arg...) \
>> +do { \
>> +	if (!test_bit(AR5523_USB_DISCONNECTED, &ar->flags)) { \
>> +		dev_err(&(ar)->dev->dev, format, ## arg); \
>> +	} \
>> +} while (0)
> This looks suspicious and might hide something important. It's better to
> fix the real cause than to workaround it in the error log printer. Do
> you know why this was added?
Yes. The purpose is to hide all the USB errors that happens when you
hot-unplug the dongle. There can be quite a few URBs in flight and
all of them will fail with -ENODEV or -ESHUTDOWN. Instead of checking
for these errors in all the usb submissions and callbacks I added this
flag. Do you still a problem with this approach?

Cheers,

Pontus

