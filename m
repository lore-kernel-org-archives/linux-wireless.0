Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39127 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab1FTPaA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 11:30:00 -0400
Subject: Re: [PATCH 2/2] mac80211: Fixing Races for skipping tailroom
 reservation
From: Johannes Berg <johannes@sipsolutions.net>
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Andreas Hartmann <andihartmann@01019freenet.de>
In-Reply-To: <20110620143051.GA31035@hertz.marvell.com>
References: <20110616102138.GA24447@hertz.marvell.com>
	 <20110616102707.GB24458@hertz.marvell.com>
	 <d38dc36c1ab9a4bd819b9bcbbda181da@secure.sipsolutions.net>
	 <20110617132527.GA27436@hertz.marvell.com>
	 <1308331485.7329.2.camel@Nokia-N900-51-1>
	 <20110620143051.GA31035@hertz.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Jun 2011 17:29:59 +0200
Message-ID: <1308583799.4322.9.camel@jlt3.sipsolutions.net> (sfid-20110620_173006_016244_227BAF36)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-06-20 at 20:00 +0530, Yogesh Ashok Powar wrote:
> On Fri, Jun 17, 2011 at 10:24:45AM -0700, Johannes Berg wrote:
> > > Using spinlocks in TX/RX path is not allowed because spinlocks will make
> > > TX/RX path to block and its illegal to block while in an RCU read-side
> > > critical section. I think, I got the joke here :(.
> > 
> > No, that'd be allowed, but you can't spinlock all the TX path because of performance.
> > 
> > I think the way to solve it would be to use synchronize_net() somehow maybe; not really sure.
> 
> Following patch avoids tailroom skip check for RCU readside
> critical sections that begin inside the synchronize_rcu's grace
> period, without grabbing any lock in the TX patch and there by avoiding
> the race conditions.
> 
> I will request Andreas to test this patch on his testbed if the changes
> are fine with you.

No, they're not, the mutex trickery seems completely pointless, and the
conditional (on _is_locked no less) locking is horrible.

johannes

