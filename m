Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40483 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644AbYHGMX6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 08:23:58 -0400
Subject: mac80211 aggregation (was: iwlwifi aggregation info)
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Friedrich.Beckmann@infineon.com, linux-wireless@vger.kernel.org,
	j@w1.fi
In-Reply-To: <1ba2fa240808061531i9b71df5l21475455d8115f3f@mail.gmail.com> (sfid-20080807_003152_933183_1A6EF13B)
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217431179.10489.134.camel@johannes.berg>
	 <1ba2fa240807300908x5489e3f8g54ff83e7e5912c0b@mail.gmail.com>
	 <1217509511.10489.140.camel@johannes.berg>
	 <1ba2fa240807311114t3e1b4fb3oe6643fbe28f2c2ac@mail.gmail.com>
	 <1217528597.10489.150.camel@johannes.berg>
	 <1ba2fa240807311216u1a45cf22j219046ab357b0910@mail.gmail.com>
	 <1217592554.8621.23.camel@johannes.berg>
	 <1ba2fa240808010540g660cdaa9p1158a27061e3fcd@mail.gmail.com>
	 <1217595279.8621.38.camel@johannes.berg>
	 <1ba2fa240808061531i9b71df5l21475455d8115f3f@mail.gmail.com>
	 (sfid-20080807_003152_933183_1A6EF13B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-K2AoOZH7dEQAoCzwuDOS"
Date: Thu, 07 Aug 2008 13:13:48 +0200
Message-Id: <1218107628.23048.130.camel@johannes.berg> (sfid-20080807_142746_671506_CD7410B0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-K2AoOZH7dEQAoCzwuDOS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-08-07 at 01:31 +0300, Tomas Winkler wrote:
> On Fri, Aug 1, 2008 at 3:54 PM, Johannes Berg <johannes@sipsolutions.net>=
 wrote:
> > On Fri, 2008-08-01 at 15:40 +0300, Tomas Winkler wrote:
> >> > Right. So why are you saying we should have a separate qdisc for it?
> >>
> >> I need a sw queue for it.
> >
> > Sure, you need to buffer packets, but that's a whole different beast.
>=20
> So this is the most important point of this conversation... What do
> you call this beast!

Ok I see where we're going. You're thinking of "struct
sk_buff_head" (which is part of most qdiscs) while I always thought you
actually wanted a qdisc.

> What I'm trying to say all the way along I don't need qdisc per se I
> need like 80% of it.

Right.

> So it was already implemented in qdisc so it was utilized.
> I'm not aware of anything else that is already implemented but you can
> always open my eyes and I'm not trying to be cynical.

Well there's struct sk_buff_head that allows you to queue up frames
anywhere you want them to be, we use it for example for PS-buffered
frames. Of course that means we need to implement it ourselves.

> This is really theoretical question. Wireless has defined 4 AC stream
> for simplicity
> so you map 2 TIDs out of 8 into 4 AC stream. One possible view
> of aggregation you don't map TID into AC stream but run it along to
> get more fine grained.
> Otherwise why don't we do <AC, RA> but <TID,RA> . Just a possible
> view. after all it's mapped back to AC.

Well 802.11 isn't really clear about this, it talks about QSTAs having
no more than one frame per <TID,RA,SA> outstanding at a time. I don't
have access to wi-fi documents but I suspect they add further
constraints because it's not feasible to have that many packets buffered
on the hardware.

> >> Not scheduling mean not string to prioritize streams in SW. I guess it=
 means RR.
> >
> > But that's entirely user dependent if we allow actual qdiscs.
>=20
> True but there is s always some sane default.

So we should disallow changing qdiscs? I'm not entirely against that,
but I think if we go that way we should force it in the code.

> I suggest to start at some more productive point.
> So what is important is that we agree on one thing that we need sw
> queue/buffer (forget qdisc for now) for aggregation queue and the
> question is how to implement it efficiently  and how to resolve
> cleanly the lack of requeueing in the new MQ. .

Well we can clearly do requeuing as much as we like, but we lose the
skb->cb over it. In fact, the master_start_xmit now makes that explicit
by memsetting it to 0.

I've looked into the Atheros driver, they way the implement it is that
when frames for an aggregation session are passed to the ->tx() call
they simply buffer them in software and when they have enough they
enqueue all of them to the hardware queue for the particular AC they map
into. This scales much better, with 16 TIDs and many stations you can
that way possibly support a lot of concurrent aggregation sessions.

Anyway, I'm confident you can work it out, I don't have time any more
for it right now, as I'll announce in a separate email. I had a patch
that mostly went the "just have queues per AC" route, but it was
incomplete, if anybody wants to take a look it's at
http://johannes.sipsolutions.net/patches/kernel/all/2008-08-04-12%3a26/006-=
fix-skb-cb-agg.patch

Here's a recap of the current issues that I'm aware of:

      * select_queue cannot really look into any state because due to
        the lack of a single TX lock there's nothing to prevent it
        racing against the code starting/stopping the aggregation
      * you cannot re-queue and assume that skb->cb will be left intact,
        but that's codified now by clearing skb->cb on master_start_xmit
      * the current implementation of ieee80211_requeue is racy against
        select_queue, select_queue is called under RCU lock though so
        you can use synchronize_rcu to avoid the race, this requires
        moving ieee80211_requeue into process context though

johannes

--=-K2AoOZH7dEQAoCzwuDOS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImtjoAAoJEKVg1VMiehFYHcsQAL1b08QpVP8pw1NayQDISgGo
W++b7AXLoWce6+ujqjbTw/fB7Ta8HeK18He5uJ1QdCxIdtxFVIjAzyWdzdAjaosE
g/mVyOUTvzGubRWUFpoGBjOFeWe5CRgcWPxahGnksd9FRbelEwjFoL0wHYyBWmiF
+/frQ8HVtJcS2GGuvHcb1wJqI05xjkXCLvRa9gDtph2pqNA+4SUihnWQIPa10GMF
QL+3KktGEK21jRZw88ilCrs/4sPutQk37K7KSiV4C+9fdyWJ+wzzWx6P+8lAuwBg
uOjQjlVkYia5afzcvyvQXG7sEFyLd4cAw/EJSGH8OYYanNGkwmxcDtq6/O4m/TaB
qM952V0ZB2d27Pu9znsxaExkTRwN49EBpXgf2bHlkVKVFSSGdLAZpdi8jBdWNDsX
dNc6THqFsRrkKjIx7ObI21ZjQgczEJLhbBGLgV60JtZf01BWwHqqDfc1vynge4mU
Uo+mOIuF1nLgkOlzaUhHEE0iqZb3myyHUfVbY2jWqV2bcJp6aSngBQDpIYXYzIrv
3CmiJc5cSXuscob9F9UHs2OWzGSL9AZA4/QGBdFLxr5BpzVCPzDjJxrhDXKy0fF6
qHbXRZVGz0d4vUaXX/uooQGlHq77kPckBedoYbQN3mbbEEwy0Ot3xJ+HNquCIxTk
+ISwNv8ZOa0DxJEQvoFy
=2tXG
-----END PGP SIGNATURE-----

--=-K2AoOZH7dEQAoCzwuDOS--

