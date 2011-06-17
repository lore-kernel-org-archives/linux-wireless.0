Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:57626 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab1FQNen (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2011 09:34:43 -0400
Date: Fri, 17 Jun 2011 18:55:29 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Andreas Hartmann <andihartmann@01019freenet.de>
Subject: Re: [PATCH 2/2] mac80211: Fixing Races for skipping tailroom
 reservation
Message-ID: <20110617132527.GA27436@hertz.marvell.com> (sfid-20110617_153446_707799_34FEFA87)
References: <20110616102138.GA24447@hertz.marvell.com>
 <20110616102707.GB24458@hertz.marvell.com>
 <d38dc36c1ab9a4bd819b9bcbbda181da@secure.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d38dc36c1ab9a4bd819b9bcbbda181da@secure.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 16, 2011 at 08:36:24AM -0700, Johannes Berg wrote:
> On Thu, 16 Jun 2011 15:57:08 +0530, Yogesh Ashok Powar wrote:
> > Following warning was observed after the commit
> > aac6af5534fade2b18682a0b9efad1a6c04c34c6
> >
> >>WARNING: at net/mac80211/wpa.c:397 ccmp_encrypt_skb+0xc4/0x1f0
> >
> > Consider a scenario where reserving skb tailroom is skipped
> > because software encryption is not enabled. SW encryption
> > can be disabled because of a) All the keys are hardware
> > planted b) No key has been created.  But, before actual
> > transmit if hardware encryption is disabled or software
> > encryption is started, there will not be enough tailroom
> > space to accommodate the sw crypto's MMIC or IV and
> > WARN_ON will be hit.
> >
> > This race between updations of hw keys and skipping & using
> > tailroom, is fixed by protecting critical regions (code
> > accessing crypto_tx_tailroom_needed_cnt and code from
> > tailroom skipping to skb_put for IV or MMIC) with the
> > spinlock.


> Haha, good joke. You've got to be kidding. NACK. No inserting spinlocks 
> into the TX/RX paths.
Using spinlocks in TX/RX path is not allowed because spinlocks will make
TX/RX path to block and its illegal to block while in an RCU read-side
critical section. I think, I got the joke here :(.


In my opinion, following should be the fix for the races explained above

a) The call synchronize_rcu() should be present before enabling sw
encryption :
	This will make pre-existing RCU readers in RCU readside critical
	section to complete. Or, SKBs which have already skipped
	tailroom to xmit before the end of synchronize_rcu's grace
	period.

b) Avoid tailroom skip check for RCU readside critical sections that begin
inside the grace period :
	This will make new entrants to mandatory allocating tailroom
	space irrespective of sw encryption (or hw encryption with
	generate IV/MMIC flags set) and hence avoid the WARN_ON.


Implementing first part is straight forward.
For later part, RCU readers must be aware of on going grace period. I am
currently not sure of any way to implement this. May be iff atomic read
is allowed inside RCU read-side critical sections, then before entering
the grace period, updater can set a atomic flag and unset it once done;
and RCU reader can check this atomic flag to avoid the
__tailroom skip check__.


Please suggest your opinion.

Thanks
Yogesh


