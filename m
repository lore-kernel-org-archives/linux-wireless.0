Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39965 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042Ab0BLSpg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Feb 2010 13:45:36 -0500
Date: Fri, 12 Feb 2010 13:33:09 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>,
	Dan Tian <Dan.Tian@atheros.com>,
	Kevin Hayes <kevin@atheros.com>
Subject: Re: Coordinating development for Bluetooth 3.0 between 802.11 and
	BT trees
Message-ID: <20100212183309.GB4983@tuxdriver.com>
References: <43e72e891002111210l55d6a802pc5a1384e3535c845@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e891002111210l55d6a802pc5a1384e3535c845@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 11, 2010 at 12:10:24PM -0800, Luis R. Rodriguez wrote:

> we are reviewing possibilities of working on Bluetooth 3.0. With
> Bluetooth 3.0 you essentially will switch to transmitting large data
> over your 802.11 device instead of the BT device. One of the first
> questions we need to address first is how we would go about
> coordinating development between wireless-testing and
> bluetooth-testing. First I'll note that I know squat of bluetooth so
> bare with me if I'm not being 100% accurate here. From what I gather
> on the mac80211 side the biggest piece will be the PAL implementation
> which should translate HCI commands to respective 802.11 frames where
> needed. It seems this would likely be the first thing tackled. Prior
> to working on 802.11 though we realize that at some point we'll need
> to synchronize the 802.11 and Bluetooth trees though so work done on
> wireless-testing for a PAL is reasonable but then the
> bluetooth-testing won't have the respective updates.
> 
> Using linux-next is one possibility but using linux-next proves a pain
> due to the fact that every single update on breaks updates, so the
> only way to update is:
> 
> git fetch
> git reset --hard origin
> 
> Wanted to get your feedback on what you think would be the best
> approach to take for focus on development for Bluetooth 3.0 support.
> Hoping there is a better solution than using linux-next.

I'm sure Marcel and Johannes are way ahead of us on this. :-)

I think you covered the basics, but you did leave-out the possibility
of using net-next-2.6 for bleeding-edge development of bluetooth 3.
Since both Marcel and I feed Dave's tree and Dave endeavours to
keep the history of that tree stable then this would seem like your
best bet.

In any case, I was under the impression that at least the initial
parts of the 802.11 AMP implementation could happen independently
from any bluetooth stack changes...?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
