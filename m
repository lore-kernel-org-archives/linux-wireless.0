Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:61006 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506Ab1IMUZ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 16:25:58 -0400
Received: by qyk30 with SMTP id 30so3056689qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Sep 2011 13:25:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110913132844.GB11772@tuxdriver.com>
References: <CAC9WiBj0A54_R3NszGBEhzMAiZzL0NBmickE88avp0NDGHyjpg@mail.gmail.com>
	<CACna6rwQ60viPGssWzBzgtVGBq1xu+AOxb0fqfRq4NaJFcmP=w@mail.gmail.com>
	<CAC9WiBi5L7uV=OzYBKs=sdjRr4Xykcd2USQPtPhCsSBLdpW-6g@mail.gmail.com>
	<20110913132844.GB11772@tuxdriver.com>
Date: Tue, 13 Sep 2011 22:25:57 +0200
Message-ID: <CACna6ryHL1K-1E7aZz_-5XzQZST5bzM4Fh99HbcmQDXvjn4ooA@mail.gmail.com> (sfid-20110913_222601_867216_2709F996)
Subject: Re: About the patch: "staging: brcm80211: only enable brcmsmac if
 bcma is not set"
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Francis Moreau <francis.moro@gmail.com>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/9/13 John W. Linville <linville@tuxdriver.com>:
> On Tue, Sep 13, 2011 at 09:03:13AM +0200, Francis Moreau wrote:
>> 2011/9/12 Rafał Miłecki <zajec5@gmail.com>:
>
>> > The real solution is to add bcma driver support in brcmsmac and ssb
>> > driver support in brcmfmac. Then you can always use bcma and:
>> > 1) If b43 will load and detect unsupported PHY, it will release the BCMA's core
>> > 2) brcmsmac will be loaded to let it support the core
>> >
>>
>> Thanks for the description.
>>
>> But what should be done for the time being (3.1-rc5) ?
>
> Turn-off CONFIG_B43_BCMA.

Well, that won't prevent bcma from loading and taking the (PCI)
device. brcmsmac still won't be able to grab that device.
CONFIG_B43_BCMA doesn't affect bcma bus driver.

There are 2 drivers requesting for the same PCI ids: bcma and
brcmsmac. You may want to just blacklist bcma if you're going to use
brcmsmac.

-- 
Rafał
