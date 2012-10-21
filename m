Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:48841 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492Ab2JUT6z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Oct 2012 15:58:55 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	hch@lst.de, s.L-H@gmx.de
Subject: Re: [PATCH 2/4] ar5523: Add driver header file
References: <1349985702-21322-1-git-send-email-pontus.fuchs@gmail.com>
	<1349985702-21322-3-git-send-email-pontus.fuchs@gmail.com>
	<87626f0vzw.fsf@purkki.adurom.net> <50793F05.7030604@gmail.com>
Date: Sun, 21 Oct 2012 22:58:53 +0300
In-Reply-To: <50793F05.7030604@gmail.com> (Pontus Fuchs's message of "Sat, 13
	Oct 2012 12:14:29 +0200")
Message-ID: <87hapnzjeq.fsf@purkki.adurom.net> (sfid-20121021_215857_881631_FF634861)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pontus Fuchs <pontus.fuchs@gmail.com> writes:

> On 2012-10-13 07:41, Kalle Valo wrote:
>> Pontus Fuchs <pontus.fuchs@gmail.com> writes:
>>
>>> +#define ar5523_err(ar, format, arg...) \
>>> +do { \
>>> +	if (!test_bit(AR5523_USB_DISCONNECTED, &ar->flags)) { \
>>> +		dev_err(&(ar)->dev->dev, format, ## arg); \
>>> +	} \
>>> +} while (0)
>> This looks suspicious and might hide something important. It's better to
>> fix the real cause than to workaround it in the error log printer. Do
>> you know why this was added?
>
> Yes. The purpose is to hide all the USB errors that happens when you
> hot-unplug the dongle. There can be quite a few URBs in flight and
> all of them will fail with -ENODEV or -ESHUTDOWN. Instead of checking
> for these errors in all the usb submissions and callbacks I added this
> flag. Do you still a problem with this approach?

IMHO it's bad style to hide that inside a logging macro and might hide
some other bugs. It's better to check the state explicitly in the
callback.

But again this isn't anything important, just something I noticed while
reviewing the code. Do what you think is best.

-- 
Kalle Valo
