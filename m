Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f42.google.com ([209.85.212.42]:45576 "EHLO
	mail-vw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab1INHAN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 03:00:13 -0400
Received: by vwl1 with SMTP id 1so2173474vwl.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Sep 2011 00:00:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6ryHL1K-1E7aZz_-5XzQZST5bzM4Fh99HbcmQDXvjn4ooA@mail.gmail.com>
References: <CAC9WiBj0A54_R3NszGBEhzMAiZzL0NBmickE88avp0NDGHyjpg@mail.gmail.com>
	<CACna6rwQ60viPGssWzBzgtVGBq1xu+AOxb0fqfRq4NaJFcmP=w@mail.gmail.com>
	<CAC9WiBi5L7uV=OzYBKs=sdjRr4Xykcd2USQPtPhCsSBLdpW-6g@mail.gmail.com>
	<20110913132844.GB11772@tuxdriver.com>
	<CACna6ryHL1K-1E7aZz_-5XzQZST5bzM4Fh99HbcmQDXvjn4ooA@mail.gmail.com>
Date: Wed, 14 Sep 2011 08:53:39 +0200
Message-ID: <CAC9WiBhNf3S7kFQC3+Br=h9sk7h9HyM45cN7tn0sMDTdaTs4ZA@mail.gmail.com> (sfid-20110914_090018_128689_D6D73F56)
Subject: Re: About the patch: "staging: brcm80211: only enable brcmsmac if
 bcma is not set"
From: Francis Moreau <francis.moro@gmail.com>
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/9/13 Rafał Miłecki <zajec5@gmail.com>:
> 2011/9/13 John W. Linville <linville@tuxdriver.com>:
>> On Tue, Sep 13, 2011 at 09:03:13AM +0200, Francis Moreau wrote:
>>> 2011/9/12 Rafał Miłecki <zajec5@gmail.com>:
>>
>>> > The real solution is to add bcma driver support in brcmsmac and ssb
>>> > driver support in brcmfmac. Then you can always use bcma and:
>>> > 1) If b43 will load and detect unsupported PHY, it will release the BCMA's core
>>> > 2) brcmsmac will be loaded to let it support the core
>>> >
>>>
>>> Thanks for the description.
>>>
>>> But what should be done for the time being (3.1-rc5) ?
>>
>> Turn-off CONFIG_B43_BCMA.
>
> Well, that won't prevent bcma from loading and taking the (PCI)
> device. brcmsmac still won't be able to grab that device.
> CONFIG_B43_BCMA doesn't affect bcma bus driver.
>
> There are 2 drivers requesting for the same PCI ids: bcma and
> brcmsmac. You may want to just blacklist bcma if you're going to use
> brcmsmac.
>

Will it work if bcma is builtin in the kernel (not configured as module) ?

Thanks
-- 
Francis
