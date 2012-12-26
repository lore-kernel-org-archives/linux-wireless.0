Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:40905 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232Ab2LZKq5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Dec 2012 05:46:57 -0500
Received: by mail-we0-f173.google.com with SMTP id z2so3792989wey.4
        for <linux-wireless@vger.kernel.org>; Wed, 26 Dec 2012 02:46:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50DAD374.1090305@hauke-m.de>
References: <1356459816-2214-1-git-send-email-zajec5@gmail.com>
	<50DAD374.1090305@hauke-m.de>
Date: Wed, 26 Dec 2012 11:46:56 +0100
Message-ID: <CACna6rw00D+pVHPoYPgN9OoiQpHGumTw7oCXSmj+ECsqTVzR9Q@mail.gmail.com> (sfid-20121226_114701_354092_F0ABF58B)
Subject: Re: [RFC][PATCH] ssb: add place for serial flash driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/12/26 Hauke Mehrtens <hauke@hauke-m.de>:
> On 12/25/2012 07:23 PM, Rafał Miłecki wrote:
>> +#ifdef CONFIG_SSB_SFLASH
>> +struct ssb_sflash {
>> +     bool present;
>> +};
>> +#endif
>
> I assume you want to share some of the code for the serial flash driver
> between bcma and ssb. You should create a file with the structure in
> include/linux/platform_data/ and share that between bcma and ssb.

It's a small struct having about 5 trivial fields. We don't share
sturcts for any other drivers (chipcommon/mips/pcie) so I think they
should stay separated here as well.

Plus the mtd driver will have to implement bus abstraction anyway.

-- 
Rafał
