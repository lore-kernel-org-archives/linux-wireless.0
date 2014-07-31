Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:53898 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbaGaUek convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2014 16:34:40 -0400
Received: by mail-oi0-f42.google.com with SMTP id a3so2197650oib.29
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jul 2014 13:34:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53DAA5DD.7050608@hauke-m.de>
References: <1406836788-23704-1-git-send-email-zajec5@gmail.com>
 <1406836788-23704-4-git-send-email-zajec5@gmail.com> <53DAA5DD.7050608@hauke-m.de>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu, 31 Jul 2014 13:34:00 -0700
Message-ID: <CAGVrzcZGUGJ6H_DTLC3owrsRdWDRYjzLJHzTL9nd59ghsEi6dg@mail.gmail.com> (sfid-20140731_223444_684510_1B63721C)
Subject: Re: [PATCH 3.18 3/7] b43: flush some writes on Broadcom MIPS SoCs
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"open list:ATHEROS ATH5K WIR..." <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014-07-31 13:23 GMT-07:00 Hauke Mehrtens <hauke@hauke-m.de>:
> On 07/31/2014 09:59 PM, Rafał Miłecki wrote:
>> Access to PHY and radio registers is indirect on Broadcom hardware and
>> it seems that addressing on MIPS SoCs may require flushing. Broadcom
>> code does that unconditionally on MIPS, so let's do the same to make
>> sure hardware won't miss anything important.
>>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>>  drivers/net/wireless/b43/b43.h        |  8 ++++++++
>>  drivers/net/wireless/b43/main.c       | 17 ++++++++---------
>>  drivers/net/wireless/b43/phy_a.c      |  4 ++--
>>  drivers/net/wireless/b43/phy_common.c |  4 ++--
>>  drivers/net/wireless/b43/phy_g.c      |  8 ++++----
>>  drivers/net/wireless/b43/phy_ht.c     |  6 +++---
>>  drivers/net/wireless/b43/phy_lcn.c    |  6 +++---
>>  drivers/net/wireless/b43/phy_lp.c     |  6 +++---
>>  drivers/net/wireless/b43/phy_n.c      |  6 +++---
>>  9 files changed, 36 insertions(+), 29 deletions(-)
>>
>
> A comment in brcmsmac says this is only needed to work around a bug in
> the host pcie controller of 4717, 4718 and 4706. I haven't noticed this
> problem with BCM4706, so it could be that it is already fixed in the
> shipped version of bcm4706.

I don't think we have ever needed it on BCM63xx as well.

>
> The comment says the following:
> bcm4716 (which includes 4717 & 4718), plus 4706 on PCIe can reorder
> transactions. As a fix, a read after write is performed on certain
> places in the code. Older chips and the newer 5357 family don't require
> this fix.

The fix in brcmsmac is covering a lot more chips with a __mips__ that
it needs to. Maybe we should have a helper function that returns the
SoC ID so we can selectively apply this write then read flush
workaround?

>
> This commit did the cleanup:
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=6a9a25eec0b55ea45e22710a9bcaf9690cb42fe6
>
-- 
Florian
