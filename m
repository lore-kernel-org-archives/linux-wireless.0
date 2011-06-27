Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57806 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab1F0OLo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 10:11:44 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTintpOOnu-DCGkvOYPizu9ZigHfbVg@mail.gmail.com>
References: <alpine.DEB.2.00.1106261016100.25900@ayla.of.borg>
	<BANLkTikSLx6FKvF518s99Q8eRU_WF+cn9A@mail.gmail.com>
	<BANLkTintpOOnu-DCGkvOYPizu9ZigHfbVg@mail.gmail.com>
Date: Mon, 27 Jun 2011 16:11:44 +0200
Message-ID: <BANLkTikB5n0a2QyW1ZCTvWYcAJ+yRLD4zg@mail.gmail.com> (sfid-20110627_161150_042799_AA820BDC)
Subject: Re: [PATCH -next] bcma: main.c needs to include <linux/slab.h>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-wireless@vger.kernel.org, linux-next@vger.kernel.org,
	Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 27 czerwca 2011 16:09 użytkownik Geert Uytterhoeven
<geert@linux-m68k.org> napisał:
> 2011/6/27 Rafał Miłecki <zajec5@gmail.com>:
>> 2011/6/26 Geert Uytterhoeven <geert@linux-m68k.org>:
>>> m68k allmodconfig:
>>>
>>> drivers/bcma/main.c: In function ‘bcma_release_core_dev’:
>>> drivers/bcma/main.c:68: error: implicit declaration of function ‘kfree’
>>
>> We already include slab.h in:
>> host_pci.c
>> scan.c
>> sprom.c
>>
>> Maybe we can just include this in bcma.h as a better solution? We
>> could drop other includes then.
>> Can you submit patch for this?
>
> If bcma.h doesn't use linux/slab.h, IMHO it should not include linux/slab.h.

I guess you want to avoid auto(chain)-including linux/slab.h by bcma
drivers? OK, just use bcma_private.h instead.

-- 
Rafał
