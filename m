Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:43963 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbZKIWYc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 17:24:32 -0500
Received: by ewy3 with SMTP id 3so3650680ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 14:24:36 -0800 (PST)
Message-ID: <4AF896A1.1000909@gmail.com>
Date: Mon, 09 Nov 2009 23:24:33 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Hauke Mehrtens <hauke@hauke-m.de>, IvDoorn@gmail.com,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH] rt2x00: fix build of rt2800lib
References: <1257682021-23810-1-git-send-email-hauke@hauke-m.de> <200911081325.23424.bzolnier@gmail.com> <4AF6C74A.4020208@hauke-m.de> <200911081831.43381.bzolnier@gmail.com>
In-Reply-To: <200911081831.43381.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/08/09 18:31, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 08 November 2009 14:27:38 Hauke Mehrtens wrote:
>> Hi,
>>
>> I am building recent wireless-testing. Without my patch I get the
>> following error while compiling it with CONFIG_RT2800USB=y with
>> CONFIG_RT2800USB=m it compiles fine without any modifications. Looks
>> like there is an other problem and my patch does not fix the real problem.
> 
> I've reproduced it here and your patch is fine but it would be better
> if rt2x00usb.h would include <linux/usb.h> itself instead of depending on
> its users (device drivers) but I'll leave this decision up to Ivo/Gartjan.
> 
> I've fixed the issue in the patch introducing the problem ("rt2800: add
> rt2800lib (part three)") to preserve bisectability of rt2800usb driver.
> 

Actually, including <linux/usb.h> from rt2x00usb.h would be more appropriate.
I'll send a patch for it.

---
Gertjan.

