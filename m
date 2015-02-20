Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755172AbbBTTFY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2015 14:05:24 -0500
Message-ID: <1424459121.20313.27.camel@redhat.com> (sfid-20150220_200527_696384_8ED6E35B)
Subject: Re: General question about Broadcom b43 driver and its source.
From: Dan Williams <dcbw@redhat.com>
To: Tom Cipollone <minertom11551@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 20 Feb 2015 13:05:21 -0600
In-Reply-To: <CAACrVkg-_CZsS_znKEscnmAMOSbSmkVLmR3ezLDKhCoKx2xxHg@mail.gmail.com>
References: <CAACrVkg-_CZsS_znKEscnmAMOSbSmkVLmR3ezLDKhCoKx2xxHg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-02-20 at 09:36 -0800, Tom Cipollone wrote:
> Hello. I am new to this forum but have been designing hardware for 33
> years. I am new, however, to wireless software. I have designed
> modem/residential gateway boards with BCM63138 and others but not the
> software so please forgive what may seem like simpleton questions.
> 
> My question concerns the b43 driver. The documentation claims that it
> was reverse engineered from the BCM4306 component. I expect that the
> 4306 documentation is very proprietary because I was not able to find
> it even though I have customer access to Broadcom customer support.
> 
> 1) I have a RT-N16 router, with a BCM4718 WiFi. I expect that the
> BCM4718 is backwards compatible with the BCM4306?

I wouldn't necessarily expect so; the 4306 is a really old 802.11g part
from 2003, while the 4718 is a newer 802.11n dual-band part from 2009.
There are a ton of different parts, and 6 years is a *lot* of time.
Don't expect they'll be compatible in any way; any compatibility they do
have is a gift.

But there's already b43 (and brcmsmac) support for the 4718 (via the
4716 of which it's based) in the upstream kernel, AFAICT.

> 2) Where can I find the reverse engineered source code for the b43
> driver? I have OpenWrt loaded and have compiled it before loading the
> .trx file onto my RT-N16. I have been looking on liinux-wireless but
> was referred to kernel-backports.

In the Linux kernel:

(4718)
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/net/wireless/b43

(4306)
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/net/wireless/b43legacy

Dan

