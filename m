Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53749 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbaFVOKy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jun 2014 10:10:54 -0400
Message-ID: <53A6E3E1.3090501@openwrt.org> (sfid-20140622_161058_137976_CBAEF64B)
Date: Sun, 22 Jun 2014 16:10:41 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: [PATCH 1/2] b43: remove leftover code from old devices support
References: <1403277721-25302-1-git-send-email-zajec5@gmail.com>	<53A6C8A2.4000202@openwrt.org> <CACna6ryCRraViALRp5fMfmJzYDTQ+6OUuJnRGRj5i5v36Ntw4A@mail.gmail.com>
In-Reply-To: <CACna6ryCRraViALRp5fMfmJzYDTQ+6OUuJnRGRj5i5v36Ntw4A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-06-22 16:07, Rafał Miłecki wrote:
> On 22 June 2014 14:14, Felix Fietkau <nbd@openwrt.org> wrote:
>> On 2014-06-20 17:22, Rafał Miłecki wrote:
>>> Old devices (A-PHY or B-PHY) are supposed to be supported by b43legacy.
>>> We keep phy_a.c as it's needed for G-PHY which shares some design.
>>>
>>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> Wouldn't it make sense to move the relevant pieces of phy_a.c to phy_g.c
>> and then remove phy_a.c entirely?
>>
>> There are pieces in phy_a.c which can be removed entirely, e.g.
>> b43_phyops_a and things only used by this struct.
> 
> Absolutely, however it needs some effort and time. I'm currently quite
> busy with other things in b43.
> 
> One could remove b43_phyops_a, then remove newly-unused functions.
> Then see what code is not used by G-PHY. However you should keep in
> mind, that 5 GHz support for G-PHY may need some functions that are
> not called at this moment. So I'd suggest looking at 5 GHz support in
> G-PHY first to avoid removing sth that may be needed in the future.
Makes sense.

- Felix

