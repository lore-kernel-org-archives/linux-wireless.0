Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:61113 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbaBNMBC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Feb 2014 07:01:02 -0500
Received: by mail-oa0-f54.google.com with SMTP id i4so14546842oah.27
        for <linux-wireless@vger.kernel.org>; Fri, 14 Feb 2014 04:01:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52FD569F.1070408@hauke-m.de>
References: <1392311186-7805-1-git-send-email-zajec5@gmail.com>
	<52FD569F.1070408@hauke-m.de>
Date: Fri, 14 Feb 2014 13:01:00 +0100
Message-ID: <CACna6rzAC1Z91TGRffuTcqV-tLpGwE52hzAXOgMstn4mZnLTbg@mail.gmail.com> (sfid-20140214_130106_839924_17AD224F)
Subject: Re: [3.14 FIX][PATCH] bcma: gpio: register all 32 GPIOs
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014-02-14 0:34 GMT+01:00 Hauke Mehrtens <hauke@hauke-m.de>:
> On 02/13/2014 06:06 PM, Rafał Miłecki wrote:
>> Broadcom boards have 32 GPIOs (not 16) and these higher ones are
>> actually used on some devices (for buttons, reset of WiFi devices).
>>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>> Similar patch may be needed for ssb, however I didn't meet any ssb SoC
>> with GPIOs 16-31 connected to anything.
>> This is so trivial I hope it can go as a fix for 3.14. It allows support
>> for some devices that use these higher GPIOs.
>> ---
>>  drivers/bcma/driver_gpio.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
> Are you sure all the bcma SoC have 32 GPIO lines or is there no problem
> when they do not? For at least some ssb based SoCs I know that they only
> have 16 GPIO lines.

Damn, I'm afraid you may be right. I didn't think about that.

I was able to find references to GPIOs 16-31 on BCM5357 based boards only.

-- 
Rafał
