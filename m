Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:50928 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701Ab2JMPph (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Oct 2012 11:45:37 -0400
Date: Sat, 13 Oct 2012 17:45:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: Kalle Valo <kvalo@adurom.com>, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org, hch@lst.de, s.L-H@gmx.de
Subject: Re: [PATCH 2/4] ar5523: Add driver header file
Message-ID: <20121013154537.GC25810@lst.de> (sfid-20121013_174541_155728_21D6A905)
References: <1349985702-21322-1-git-send-email-pontus.fuchs@gmail.com> <1349985702-21322-3-git-send-email-pontus.fuchs@gmail.com> <87626f0vzw.fsf@purkki.adurom.net> <50793F05.7030604@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50793F05.7030604@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 13, 2012 at 12:14:29PM +0200, Pontus Fuchs wrote:
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
> Yes. The purpose is to hide all the USB errors that happens when you
> hot-unplug the dongle. There can be quite a few URBs in flight and
> all of them will fail with -ENODEV or -ESHUTDOWN. Instead of checking
> for these errors in all the usb submissions and callbacks I added this
> flag. Do you still a problem with this approach?

I think it's fine, but it needs a comment explaining it with basically
the same information you just wrote above.

