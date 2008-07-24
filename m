Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40711 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757867AbYGXOqa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 10:46:30 -0400
Subject: Re: Another fragmentation multiqueue kludge
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: David Miller <davem@davemloft.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Guy Cohen <guy.cohen@intel.com>,
	"Rindjunsky, Ron" <ron.rindjunsky@intel.com>
In-Reply-To: <1ba2fa240807240737lf649fc8m3c4236329e02288@mail.gmail.com> (sfid-20080724_163702_761474_58DA06D5)
References: <1ba2fa240807231441u7b870a15rb525771e364f65f3@mail.gmail.com>
	 <1ba2fa240807240601o2c083347rf5f1b6507e0abe7c@mail.gmail.com>
	 <1216908973.13587.65.camel@johannes.berg>
	 <1ba2fa240807240737lf649fc8m3c4236329e02288@mail.gmail.com>
	 (sfid-20080724_163702_761474_58DA06D5)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gVoMbukZoBmgskCWIApa"
Date: Thu, 24 Jul 2008 16:46:16 +0200
Message-Id: <1216910776.13587.74.camel@johannes.berg> (sfid-20080724_164652_585829_48DF9110)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gVoMbukZoBmgskCWIApa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-07-24 at 17:37 +0300, Tomas Winkler wrote:

> >> -       struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
> >> +       struct ieee80211_tx_info *info;
> >>         int ret, i;
> >>
> >> -       if (netif_subqueue_stopped(local->mdev, skb))
> >> -               return IEEE80211_TX_AGAIN;
> >>
> >>         if (skb) {
> >> +               if (netif_subqueue_stopped(local->mdev, skb))
> >> +                       return IEEE80211_TX_AGAIN;
> >> +               info =3D IEEE80211_SKB_CB(skb);
> >> +
> >
> > This isn't right. It means that if you have a stopped queue and pending
> > fragments, you still transmit them, which is not something the driver
> > should have to expect.
>=20
> This logic was wrong you cannot access skb and then ask if'ts not
> NULL. (it actually creates nice panic in fragmentation)

Oh, indeed, and since the same check is actually in the if
(tx->extra_frag) part, this is fine.

> >>         if (test_bit(queue, local->queues_pending)) {
> >> +               /* don't call scheduler just open the queue */
> >> +               if (ieee80211_is_multiqueue(local)) {
> >> +                       netif_start_subqueue(local->mdev, queue);
> >> +               } else {
> >> +                       WARN_ON(queue !=3D 0);
> >> +                       netif_start_queue(local->mdev);
> >> +               }
> >>                 tasklet_schedule(&local->tx_pending_tasklet);
> >>         } else {
> >>                 if (ieee80211_is_multiqueue(local)) {
> >
> > That's not right either, if you have pending fragments/packets then you
> > cannot start the queue.
>=20
> Exactly this what I wrote are my concern on the other hand
> that's the kludge because the __ieee80211_tx checks whether the queue
> is started so there is no way
> the pending packet is transmitted if you don't start the queue. I have
> new version of the patch that starts
> the queue only in the tasklet. Tasklet is locks tx so the next packet
> will come only after the pending packet is transmitted.

What happens if you just invert the
                if (__netif_subqueue_stopped(local->mdev, i))
                        continue;

check in ieee80211_tx_pending to read
                if (!__netif_subqueue_stopped(local->mdev, i))
                        continue;

as I suggested yesterday?

> I actually can do. I can leave extra 16 TFDs (4 bits for frag num)  in
> the queue that wouldn't be a problem, I'm just not sure that iwlwifi
> is the only driers that does it.  I didn't encountered such scenario
> but this code looks like also non fragments can be put to pending. Am
> I wrong?

non-fragments can only be put in there if your driver is buggy, because
if you don't have fragmentation turned on then you should know when your
queue is filling up and be able to stop it before you get another frame.

The problem with fragmentation is that mac80211 creates multiple frames
from a single one, while if you don't have fragmentation that doesn't
happen since once you stop the queue there are no pending packets.

If we require drivers to always keep space for 8 or 9 fragments then we
can remove all this requeuing stuff, the only trouble with that may be
in adm8211 since that has to send frames one by one, but we can fix it
in that driver, it only has a single queue so it's much easier.

johannes

--=-gVoMbukZoBmgskCWIApa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIiJW1AAoJEKVg1VMiehFY828P/Rbme8zWd+EO/AetALlJn2Gv
WAyV5yhn7L/6KbUApme8yWeG+51rTcGvBWW0whPgNm4EgG2dKZe5e5WSn+AAkNnj
QdKAxMnGC4kzkWdL7eF6NRD66f/v1ceOD/iGpDYAJLaXrocivD57HSwoRRJgrrii
BSIThsjMVisx/XTQxmyRz4MkvkIeR38lbBnCY6IZmIFv2A2p3gIhOWxm3HPknwIW
UV7tOwW6niIf8PW/7w+L86bD9KSK/ULrWy8cld5qRF7FI5NFX9xF0SaHowHMULGY
2CHAJWwmHSfFCjMc+wZoc/u2N3FlYt/jFekc6TY+Vao7evR7en6UnxoCqLDluAPV
xQ82xdaY3HkNtgX0cApcq0QFIsTXuyhWHajCoAI6XOQrPKYAL3oadhfBQakM3CDz
w6U+GT/sI0hOBczTY+LJS29EZay/71pvN2+smOP4/hoIQrqRNte01KGNwHyCEU6+
9nFZnu26BwNUfXolQlI4yzdXasTc7P6rgCRf8vSGsbwDseb7XPU7d7uqqlD98HRc
nA98nQLgiBnGiOiWwTn5j1gaiiS6ZG312XxyI6q1lWWHE8+gxzyd0Z0g0QPDFnEt
KGxI+29c6MBa32eK5+cYAWJ64wrKDLlSUnoYzpg/MGM292l2URKWTRtfACbfpF1Q
8VSdi+pPqiNlCR1PF7IB
=rUla
-----END PGP SIGNATURE-----

--=-gVoMbukZoBmgskCWIApa--

