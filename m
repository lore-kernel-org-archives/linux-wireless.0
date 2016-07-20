Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:33147 "EHLO
	mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbcGTQky (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2016 12:40:54 -0400
Received: by mail-qk0-f176.google.com with SMTP id p74so50386871qka.0
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jul 2016 09:40:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AE1C82FB3D0EC64DB1F752C81CBD110139208B47@DFRE01.ent.ti.com>
References: <CAEFj987X26u59K32Mt-bKBSTmy3cWvOiNNBG7K4wbdQBAdR97Q@mail.gmail.com>
 <20160719124456.GD11996@localhost> <AE1C82FB3D0EC64DB1F752C81CBD110139206115@DFRE01.ent.ti.com>
 <20160719134355.GA1833@localhost> <CAEFj987V0r3aVn+JhQOX-40bheKyEJdrppF75OCaLXhU=skmNw@mail.gmail.com>
 <AE1C82FB3D0EC64DB1F752C81CBD110139206BD6@DFRE01.ent.ti.com>
 <CAEFj986LZ8zjBtyJrRL4GX3S-yTGxL-MJs3S18ze-NNw544OPQ@mail.gmail.com> <AE1C82FB3D0EC64DB1F752C81CBD110139208B47@DFRE01.ent.ti.com>
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Date: Thu, 21 Jul 2016 00:40:53 +0800
Message-ID: <CAEFj986FX=Gyyadj4n5S6VrYx_D61jJFKjc2GajAVHbXbsVD+Q@mail.gmail.com> (sfid-20160720_184059_019252_C0770457)
Subject: Re: [PATCH v2 2/3] mac80211: mesh: improve path resolving time
To: "Machani, Yaniv" <yanivma@ti.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Hahn, Maital" <maitalm@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 20, 2016 at 8:15 PM, Machani, Yaniv <yanivma@ti.com> wrote:
>
> On Wed, Jul 20, 2016 at 09:45:16, Yeoh Chun-Yeow wrote:
> > Johannes Berg
> > Subject: Re: [PATCH v2 2/3] mac80211: mesh: improve path resolving
> > time
> >
> > On Wed, Jul 20, 2016 at 4:01 AM, Machani, Yaniv <yanivma@ti.com> wrote:
> > > On Tue, Jul 19, 2016 at 19:01:54, Yeoh Chun-Yeow wrote:
> > >> Johannes Berg
> > >> Subject: Re: [PATCH v2 2/3] mac80211: mesh: improve path resolving
> > >> time
> > >>
> > >> On Tue, Jul 19, 2016 at 9:43 PM, Bob Copeland <me@bobcopeland.com>
> > >> wrote:
> > >> > On Tue, Jul 19, 2016 at 01:02:13PM +0000, Machani, Yaniv wrote:
> > >> >> On Tue, Jul 19, 2016 at 15:44:56, Bob Copeland wrote:
> > >> >
> > >> > This wording seems to indicate that it is not per path.  Perhaps
> > >> > this should be clarified in the standard.  (If the intent turns
> > >> > out to be per path, then I guess we should fix it by storing
> > >> > last_preq per path
> > >> > instead.)
> > >> >
> > >> >
> > >> > Ignoring the standard for a second, let's explore this: can you
> > >> > give some idea on how many stations are in your target network,
> > >> > how frequently a given pair of nodes unpeer, what sort of
> > >> > improvements you see with the patch?  It should then be pretty
> > >> > easy to run some simulations to see the scenarios where this helps and where it hurts.
> > >> >
> > >>
> > >
> > > Bob, Chun-Yeow,
> > > Thanks for your inputs.
> > >
> > > Let take a simple scenario, where you have a,b,c,d nodes connected
> > > to each
> > other as shown below.
> > >
> > > A~ ~ ~~~~C- - - D
> > >    \          /
> > >       \     /
> > >          B
> > >
> > > A would like to pass data to D.
> > > A-C matric is worse than A-B-C, so path is constructed via B.
> > > We are in idle state, and PREQ are sent every
> > dot11MeshHWMPpreqMinInterval.
> > > Now, node B have been disconnected (ran out of battery/shut
> > > down/suddenly went out of range) As A has a path to D via B, he
> > > cleans up his
> > path table.
> > > Now he needs to build a new path, in the WCS, he have just sent a PREQ.
> > > And now he needs to wait dot11MeshHWMPpreqMinInterval seconds, until
> > he can rebuild the path.
> >
> > Did you reduce the dot11MeshHWMPactivePathTimeout to see whether it
> > produces positive impact to your network? Once the path to A - C - D
> > has established, it needs to wait till the active path timer to expire
> > before establishing a new path. This active path time is default to
> > 5000 TUs (or 5s).
> >
>
> We did tried it as well, but again, this will cause us sending PREQ more frequently.
>
> > > As we wouldn't like to flood the network with PREQ, we can assume
> > > that the
> > dot11MeshHWMPpreqMinInterval is few seconds, for us, it seemed un-
> > acceptable.
> > >
> >
> > But your patch is indeed generating "more" PREQ frame.
> >
> Well, we are sending more, but just in a specific scenario where it's needed ASAP to establish a path.
>
> > > In cases where you need to have a reliable data link, passing
> > > audio/video you
> > usually can't afford few seconds w/o traffic.
> > >
> > >> In addition to Bob's comment, you probably can try to reduce the
> > >> dot11MeshHWMPpreqMinInterval to 1 TU (1ms) instead of sticking to
> > >> default value 10 TUs. Besides, you can also reduce the
> > >> mesh_path_refresh_time which is currently default to 1000 ms and
> > >> check whether you can improve on your network scenarios.
> > >>
> > >
> > > We did tried to play with these values, but again, we don't want to
> > > flood the
> > network.
> > > We just want to recover ASAP.
> > >
> > >> When you mentioned "next hop peer disconnect", it could also be the
> > >> time taken to re-established the mesh peering before your mesh STA
> > >> can transmit the data to your peer mesh STA.
> > >>
> > >
> > > Link establishment takes no more than few 100s of ms usually, And in
> > > the example above, there is no new link establishment, just path generation.
> > >
> >
> > Suggest that you simulate your scenario and validate the improvement first.
> >
>
> We have made many lab tests, with 10s of nodes in open air and in a controlled environment.
> This patch is just one of the improvements we saw necessary for performance, we have multiple others for the metric calculation, and more.
> We understand that the HWMP and the general mesh implementation is more sensor network related, where there is no need for stable high throughput 100% of the time.
> You can also have a look in our white paper, describing small parts of the tests we have made in the last section - http://www.ti.com/lit/wp/swry024/swry024.pdf
>

In case that you have additional 1 node with 3 paths toward the
destination (instead of 2 paths like you illustrated), forcing
additional PREQ doesn't guarantee that you will switch to the fixed
path in your "next" attempt.

I just take another look on your patch:

@@ -1110,7 +1117,7 @@ int mesh_nexthop_resolve(struct
ieee80211_sub_if_data *sdata,
}

if (!(mpath->flags & MESH_PATH_RESOLVING))
- mesh_queue_preq(mpath, PREQ_Q_F_START);
+ mesh_queue_preq(mpath, PREQ_Q_F_START, true);

if (skb_queue_len(&mpath->frame_queue) >= MESH_FRAME_QUEUE_LEN)
skb_to_free = skb_dequeue(&mpath->frame_queue);

You modification is intended to add this "immediate" PREQ generation
whenever the data frame is transmitted. In case the current path is
indeed the best one, the PREQ will still generate without waiting for
dot11MeshHWMPpreqMinInterval. The network is unnecessary flooded with
PREQ.

---

Chun-Yeow
