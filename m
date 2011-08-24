Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46652 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab1HXTpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 15:45:11 -0400
Date: Wed, 24 Aug 2011 15:32:25 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: refactor skb copy to failq in
 mesh_path_move_to_queue
Message-ID: <20110824193224.GL9770@tuxdriver.com> (sfid-20110824_214526_835734_3AED56DD)
References: <1314213161-8871-1-git-send-email-linville@tuxdriver.com>
 <CAG6hwVNvLREnnZQ0t8UaKZ7Q1nn-4kx=z_1nPzVG89a5NMWFpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAG6hwVNvLREnnZQ0t8UaKZ7Q1nn-4kx=z_1nPzVG89a5NMWFpg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 24, 2011 at 12:27:29PM -0700, Thomas Pedersen wrote:
> On Wed, Aug 24, 2011 at 12:12 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > This seems a bit less awkward, and avoids the following warning:
> >
> >  CC [M]  net/mac80211/mesh_pathtbl.o
> > net/mac80211/mesh_pathtbl.c: In function ‘mesh_path_move_to_queue’:
> > net/mac80211/mesh_pathtbl.c:291:24: warning: ‘cp_skb’ may be used uninitialized in this function
> 
> cp_skb was initialized to NULL in v2 of "mac80211:  mesh gate implementation'
> 
> >
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > ---
> > Does it matter if the copy ends-up on the failq before the original goes
> > to the gateq?
> >
> >  net/mac80211/mesh_pathtbl.c |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
> > index 75e4b60..b5caf5b 100644
> > --- a/net/mac80211/mesh_pathtbl.c
> > +++ b/net/mac80211/mesh_pathtbl.c
> > @@ -307,14 +307,14 @@ static void mesh_path_move_to_queue(struct mesh_path *gate_mpath,
> >
> >        while (num_skbs--) {
> >                skb = __skb_dequeue(&failq);
> > -               if (copy)
> > +               if (copy) {
> >                        cp_skb = skb_copy(skb, GFP_ATOMIC);
> > +                       if (cp_skb)
> > +                               __skb_queue_tail(&failq, cp_skb);
> > +               }
> >
> >                prepare_for_gate(skb, gate_mpath->dst, gate_mpath);
> >                __skb_queue_tail(&gateq, skb);
> > -
> > -               if (copy && cp_skb)
> > -                       __skb_queue_tail(&failq, cp_skb);
> >        }
> 
> However, this does look nicer. Please be sure to apply the version
> submitted on 11 August.

You just told me yesterday to apply the 9 August version???

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
