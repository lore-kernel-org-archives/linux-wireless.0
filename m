Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39320 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842Ab2HJMXm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 08:23:42 -0400
Message-ID: <5024FD42.6070307@hauke-m.de> (sfid-20120810_142346_488874_679F5B8E)
Date: Fri, 10 Aug 2012 14:23:30 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH wireless?] bcma: keep info about parallel flash presentence
References: <1344544690-11280-1-git-send-email-zajec5@gmail.com> <5024CE29.5030500@broadcom.com> <CACna6rzxb4jtFWOQcRvPxPE0KhTXP5P8fckaN-KaZMCyvq0Lhw@mail.gmail.com>
In-Reply-To: <CACna6rzxb4jtFWOQcRvPxPE0KhTXP5P8fckaN-KaZMCyvq0Lhw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/10/2012 11:32 AM, Rafał Miłecki wrote:
> 2012/8/10 Arend van Spriel <arend@broadcom.com>:
>> On 08/09/2012 10:38 PM, Rafał Miłecki wrote:
>>> This allows drivers to access flash conditionally and stop crashing some
>>> devices.
>>>
>>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>>> Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
>>> ---
>>> John: I suggest taking it for wirelesss, AKA fix
>>
>> Maybe you could mentioned devices and/or drivers crashes without this patch?
> 
> Yes, sure! The problematic one for me is arch/mips/bcm47xx/nvram.c.
> Right now it assumes every BCMA board has pflash. I'll submit fix for
> mips tree when this patch hits it.

Letting this patches get merged into the wireless tree and an other
patches which depends on this one into the mips tree will cause
problems, because the wireless tree only gets merged into the mips tree
indirectly round about the rc1 release in form of the rc1 release done
by Linus.

The patch to arch/mips/bcm47xx/nvram.c will depend on this one and you
should submit them to the same tree.

Hauke

