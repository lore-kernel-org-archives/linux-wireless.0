Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42850 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab0FZPpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jun 2010 11:45:13 -0400
Date: Sat, 26 Jun 2010 11:32:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: rt2x00 & mac80211: correct usage of ieee80211_beacon_get_tim?
Message-ID: <20100626153245.GA6807@tuxdriver.com>
References: <201006241521.47623.helmut.schaa@googlemail.com>
 <1277394714.3870.8.camel@jlt3.sipsolutions.net>
 <201006251801.06209.helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201006251801.06209.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 25, 2010 at 06:01:06PM +0200, Helmut Schaa wrote:
> Am Donnerstag 24 Juni 2010 schrieb Johannes Berg:
> >  b) You need to get a new beacon frame from mac80211 only when it
> >     changes. You can do this from set_tim(). HOWEVER: since you're not
> >     getting a new one from mac80211 all the time anyway, you NEED to
> >     have the driver or firmware overwrite the DTIM count, like b43's
> >     firmware for example will do.
> 
> And the broad- and multicast buffering also needs to be done in the driver
> (when the fw/hw cannot handle it) as mac80211 uses its own DTIM count for
> deciding when to "release" buffered frames to the driver.

That seems a bit...yucky...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
