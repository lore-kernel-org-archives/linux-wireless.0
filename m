Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:59344 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751104AbZA1SFb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 13:05:31 -0500
Date: Wed, 28 Jan 2009 20:04:25 +0200
From: Jouni Malinen <j@w1.fi>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net, Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] ath9k: Set TSF fix
Message-ID: <20090128180425.GA5069@jm.kir.nu> (sfid-20090128_190535_392928_AE387F8D)
References: <20090124081542.50450@gmx.net> <1232806972.4036.10.camel@johannes.local> <1232807356.2870.23.camel@localhost.localdomain> <20090124215322.259390@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090124215322.259390@gmx.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 24, 2009 at 10:53:22PM +0100, Alina Friedrichsen wrote:
> Hallo Dan!

Uhm.. Dan was not on To: or Cc: field.. Anyway..

> The old version I have taken from an several years old madwifi patch. It works only with old ath5k hardware. With my new Atheros-Cards the lower 32 bits of the TSF are only set to zero, not set to the new value. The new code does work with all my ath5k and ath9k cards.

The proposed ath9k change looks fine. The AR_TSF_L32 write does not
actually change TSF and hardware will just store the value temporarily.
The actual change is started by writing the AR_TSF_U32.

It looks like there are some corner cases where the TSF may not actually
change if it is being updated (e.g., a Beacon is received) or we are
waking up from sleep mode etc., but I would hope they do not matter too
much with this debugging need.

-- 
Jouni Malinen                                            PGP id EFC895FA
