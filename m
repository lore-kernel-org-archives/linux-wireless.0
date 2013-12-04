Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522Ab3LDIF5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Dec 2013 03:05:57 -0500
Message-ID: <1386144347.1621.36.camel@adam.happyassassin.net> (sfid-20131204_090600_971538_539FD551)
Subject: Re: Support for Atheros chipset with SDIO ID 0271:0418 ?
From: Adam Williamson <awilliam@redhat.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Date: Wed, 04 Dec 2013 00:05:47 -0800
In-Reply-To: <CAJ-Vmona5j5AFLzOxSBbx0KcZteSiGph8scMZjqtw9ZacP=aAQ@mail.gmail.com>
References: <1385838681.2566.6.camel@adam.happyassassin.net>
	 <529A3F9B.6070306@rempel-privat.de>
	 <CAJ-Vmona5j5AFLzOxSBbx0KcZteSiGph8scMZjqtw9ZacP=aAQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-11-30 at 11:48 -0800, Adrian Chadd wrote:
> Well, the problem is twofold:
> 
> * what weird variants are required, command wise, and
> * what firmware/patches are required for the unit?
> 
> I'll ask Kalle when he's back.

In the meantime, I tried the most obvious hack - patch the ID 0418 -
into the driver, to no effect at all. modinfo confirms it has an alias
for the ID 0271:0418 after my patch, but the module isn't loaded on
boot, and if I load it manually, I get the usual "Calling CRDA to update
world regulatory domain" and nothing else at all. It's as if the kernel
actually isn't seeing the hardware at all, so there may be something
that needs to be solved at a lower level before this can work...
-- 
Adam Williamson
Fedora QA Community Monkey
IRC: adamw | Twitter: AdamW_Fedora | XMPP: adamw AT happyassassin . net
http://www.happyassassin.net

