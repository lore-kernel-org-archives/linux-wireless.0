Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:53483 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754506AbZCXAgA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 20:36:00 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 23 Mar 2009 17:35:59 -0700
Date: Mon, 23 Mar 2009 16:35:22 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Christian Lamparter <chunkeey@web.de>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 5/5] ar9170: update Makefile, Kconfig and MAINTAINERS
Message-ID: <20090323233522.GM5740@tesla> (sfid-20090324_013605_075105_8E8751D6)
References: <200903212311.49348.chunkeey@web.de> <1237818551.6147.15.camel@johannes.local> <200903240126.12692.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <200903240126.12692.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 23, 2009 at 05:26:12PM -0700, Christian Lamparter wrote:
> On Monday 23 March 2009 15:29:11 Johannes Berg wrote:
> >
> > I think it would make sense to link them into the same module as long as
> > we don't have a second user of the common code. I actually doubt we will
> > see a second user of the common code at all, even if it is in theory
> > possible with the hardware design.
> Shh, there's a secret plan, see ar9170/main.c
> 
> /*
>  * BIG FAT TODO:
>  *
>  * By the looks of things: these devices share a lot of things like
>  * EEPROM layout/design and PHY code with other Atheros WIFI products.
>  * So this driver/library will eventually become ath9k code... or vice versa ;-)
>  */

The MACs are completely different so if there is some code sharing possible
it may be difficult to find but it would certainly be welcomed!

> And the ath5k<->ath9k merge could provide some "helper" function for this
> driver as well... (wishful thinking, but anyway...)

Yeah we'll see.

> Meanwhile, what about a config option that can be enabled to
> integrate everything into the front-end module (ar9170usb)?
> ( However, I don't think this config solution will stand a chance ;-)
>   and we all come to the same "all-in-one works best" conclusion.  )

Future Atheros 11n USB devices will use a different MAC and therefore expect
them to be different. I am not sure if in the future we can share but
I won't know for sure for a little while.

Its your driver though so your call. I also just don't see where things
can be immediately shared right now but do welcome the work to do so.

  Luis
