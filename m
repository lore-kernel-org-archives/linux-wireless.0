Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061Ab2FLTSJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 15:18:09 -0400
Message-ID: <1339528734.14638.14.camel@dcbw.foobar.com> (sfid-20120612_211813_445395_72207AF4)
Subject: Re: poor performance with W2CBW003 (Marvell 8686)
From: Dan Williams <dcbw@redhat.com>
To: Andreas Kemnade <andreas@kemnade.info>
Cc: dsd@laptop.org, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Date: Tue, 12 Jun 2012 14:18:54 -0500
In-Reply-To: <1339247007.5895.373.camel@localhost>
References: <1339247007.5895.373.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-06-09 at 15:03 +0200, Andreas Kemnade wrote:
> Hi,
> 
> on the GTA04 (www.gta04.org) 
> which has a W2CBW003 chip for wifi connected to a DM3730CBP CPU. data
> rates are quite low using the libertas driver from kernel 3.2-3.4 
> (https://github.com/neilbrown/gta04/branches)
> even near an accesspoint. That seems not depend on the encryption
> settings. Rates are around 100KByte/s. iwconfig shows 5.5Mb/s if it is
> not connected to an accesspoint with specially configured rates (but
> still the throughput is low).
> 
> In contrary data rates are high (>1MByte/s) with a kernel based on
> the 2.6.32  BeagleBoard XM hw-validation kernel
> https://github.com/goldelico/gta04-kernel
> That behaviour was reported by several people.
> 
> I tried also the libertas-tf driver with kernel 3.2 using the
> instructions here:
> http://corysohrakoff.wordpress.com/2011/09/13/enabling-wifi-ap-mode-on-a-gumstix-overo/
> That was also slow.
> 
> Any hints?

GSPI or SDIO?  What SD host controller?  Does the controller support
4-bit mode correctly?  What block sizes does it support?  Most often the
issue is with crappy  host controllers that need workarounds or quirks
to correctly support the higher speeds that the driver can do.  The
benchmark I always used was that on a laptop with a Ricoh SD controller,
I could easily pull megabits per second even 15 feet away.

(that's not to say there aren't inefficiencies in the driver, just that
we know that given a good SDHC and a good SDHC driver, that the libertas
driver itself is not the bottleneck).

Dan

