Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f52.google.com ([209.85.212.52]:46577 "EHLO
	mail-vw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab1IMHDP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 03:03:15 -0400
Received: by vws16 with SMTP id 16so516631vws.11
        for <linux-wireless@vger.kernel.org>; Tue, 13 Sep 2011 00:03:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6rwQ60viPGssWzBzgtVGBq1xu+AOxb0fqfRq4NaJFcmP=w@mail.gmail.com>
References: <CAC9WiBj0A54_R3NszGBEhzMAiZzL0NBmickE88avp0NDGHyjpg@mail.gmail.com>
	<CACna6rwQ60viPGssWzBzgtVGBq1xu+AOxb0fqfRq4NaJFcmP=w@mail.gmail.com>
Date: Tue, 13 Sep 2011 09:03:13 +0200
Message-ID: <CAC9WiBi5L7uV=OzYBKs=sdjRr4Xykcd2USQPtPhCsSBLdpW-6g@mail.gmail.com> (sfid-20110913_090318_442773_2B5DC986)
Subject: Re: About the patch: "staging: brcm80211: only enable brcmsmac if
 bcma is not set"
From: Francis Moreau <francis.moro@gmail.com>
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

2011/9/12 Rafał Miłecki <zajec5@gmail.com>:
> 2011/9/8 Francis Moreau <francis.moro@gmail.com>:
>> Hello,
>>
>> I have a question regarding the following patch:
>> http://permalink.gmane.org/gmane.linux.kernel.wireless.general/75638
>>
>> The commit message says:
>>
>>   brcmsmac doesn't yet use bcma, but both drivers attempt to claim the same
>>   device.  For now, turn of brcmsmac if bcma is enabled.
>>
>> I think it's not quite complete:  both driver claim the same devices
>> (actually that's not entirely true since b43/bcma can drive on more
>> card) but in the case of b43/bcma not all cards are actually working.
>> For example I'm using BCM4313 card with an unsupported phy
>> (B43_PHYTYPE_LCN) so it's basically not supported by b43/bcma.
>>
>> So I'm wondering if b43/bcma should be simply disabled until it got
>> the same level of support as brcmsmac ?
>
> I'm working on LCN support in b43 (BCM4313), static initialization is
> already done. Should see more results soon.
>
> The problem is that brcmsmac duplicates code present in the bcma
> driver. It doesn't use bcma bus architecture.
>
> The real solution is to add bcma driver support in brcmsmac and ssb
> driver support in brcmfmac. Then you can always use bcma and:
> 1) If b43 will load and detect unsupported PHY, it will release the BCMA's core
> 2) brcmsmac will be loaded to let it support the core
>

Thanks for the description.

But what should be done for the time being (3.1-rc5) ?

-- 
Francis
