Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.nanl.de ([217.115.11.12]:52915 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754682Ab3DOHxL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 03:53:11 -0400
Date: Mon, 15 Apr 2013 09:53:00 +0200
From: Jonas Gorski <jogo@openwrt.org>
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Adrian Chadd <adrian@freebsd.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH] mwl8k: remove nonstandard rate 72 Mbps
Message-ID: <20130415095300.000003d2@unknown> (sfid-20130415_095328_522491_C4404152)
In-Reply-To: <20130415063838.GB801@markyou.marvell.com>
References: <1365849071-2389-1-git-send-email-jogo@openwrt.org>
	<1365941518-4963-1-git-send-email-jogo@openwrt.org>
	<20130415063838.GB801@markyou.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 15 Apr 2013 12:08:38 +0530
Yogesh Ashok Powar <yogeshp@marvell.com> wrote:

> On Sun, Apr 14, 2013 at 05:11:58AM -0700, Jonas Gorski wrote:
> > This rate causes an overflow in the extended rates IE's data rate
> > field, with the overflowing bit setting the Basic Rate Set
> > membership. This results in a bogus 8 Mpbs basic rate, making
> > clients checking them refuse association.
> > 
> > Since the rate is likely unused anyway (HT will yield better rates
> > between supporting chips), we can just remove it.
> > 
> > This fixes association from wpa_supplicant and Android 4.x and
> > newer.
> 
> Hi Jonas,
> 
> If you are using hostapd, have you tried using 'supported_rates'
> and/or 'basic_rates' being set to correct rates in the hostapd.conf.

Not sure if that helps. The main problem is that this rate is
unadvertisable in Beacons, as (Extended) Supported Rates (802.11-2012
8.4.2.3) encodes the rates as u8, with seven bits for the rate in units
of 500 kb/s, which isn't enough for 72 Mbps; the maximum is 63.5 Mbps.
The result is that it spills into the MSB, marking it as a "Basic Rate"
even though it isn't marked as such by hostapd. It's just that 72 Mbps
=> 0x90 => "8 Mbps, Basic Rate".
This is partially a bug in hostapd, it should probably reject rates not
encodable.
So AFAICT the only way to use it in hostapd is to not use it.

Which makes me wonder how or if this rate is usable at all in 802.11
context, without a proprietary way of telling the other end that this
rate is available, and therefore if it even makes sense to keep.


Jonas
