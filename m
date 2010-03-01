Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from home.einfach.org ([80.86.92.145]:47578 "EHLO home.einfach.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696Ab0CAIsq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 03:48:46 -0500
From: Bruno Randolf <br1@einfach.org>
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
Subject: Re: [PATCH] mac80211: fix rates setup on IBSS merge
Date: Mon, 1 Mar 2010 17:24:35 +0900
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
References: <20100223095113.25360.75291.stgit@void> <43e72e891002231128w45c357a6v157dc4f7ddf3bbae@mail.gmail.com> <4B85BCB8.1000006@free.fr>
In-Reply-To: <4B85BCB8.1000006@free.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201003011724.36089.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 25 February 2010 08:56:40 Benoit PAPILLAULT wrote:
> Luis R. Rodriguez a écrit :
> > On Tue, Feb 23, 2010 at 1:51 AM, Bruno Randolf <br1@einfach.org> wrote:
> >> when an IBSS merge happened, the supported rates for the newly added
> >> station were left empty, causing the rate control module to be
> >> initialized with only the basic rates.
> >> 
> >> also the section of the ibss code which deals with updating supported
> >> rates for an already existing station fails to inform the rate control
> >> module about the new rates. as i don't know how to fix this (minstrel
> >> does not have an update function), i have just added a comment for now.
> >> 
> >> Signed-off-by: Bruno Randolf <br1@einfach.org>
> > 
> > This seems like a stable fix, if it applies can you please resend with a
> > 
> > Cc: stable@kernel.org
> > 
> > on the commit log entry right below your own SOB.
> > 
> >   Luis
> 
> Hi Bruno,
> 
> I think the root cause is that IBSS neighbor entries are added whenever
> we received any packet from a neighbor. However, the supported rates are
> only available in the beacon/probe responses. I think one fix is to only
> add IBSS neighbors on beacon/probe response reception (and moreover,
> beacon/probe responses contains the timestamp that is needed for IBSS
> merge).
> 
> Basically, I removed the call to ieee80211_ibss_add_sta in
> net/mac80211/rx.c.

i think we need to keep that.

it can happen in normal IBSS operation, that we get a data packet from a node 
which we did not yet receive a beacon from. for example: he might be part of 
the IBSS, correctly merged and all, but have deferred from sending a beacon 
the last couple of beacon intervals because some other node sent a beacon 
first. or we might have missed his beacons due to interference. nevertheless 
we should try to be able to communicate with him.

also there are many broken implementation out there (prominent example: 
madwifi) which fail to send beacons at some times. in order to communicate 
with then we also need to add stations on receiving data packets.

so i think the proper way is to add an update function to the rate control 
module. (i will try to do that and send in another patch.)

bruno
