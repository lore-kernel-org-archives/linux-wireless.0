Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55302 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501AbYEZOmA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2008 10:42:00 -0400
Subject: Re: [PATCH 1/1] mac80211: fix deadlock in sta->lock
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <1ba2fa240805260732g4c5942b2qec443dfc6d6339a7@mail.gmail.com> (sfid-20080526_163222_125143_AA39847E)
References: <1211810958-23095-1-git-send-email-tomas.winkler@intel.com>
	 <1211811554.4843.4.camel@johannes.berg>
	 <1ba2fa240805260732g4c5942b2qec443dfc6d6339a7@mail.gmail.com>
	 (sfid-20080526_163222_125143_AA39847E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tykr27Mvzrcw0J+3wizm"
Date: Mon, 26 May 2008 16:40:53 +0200
Message-Id: <1211812853.4843.7.camel@johannes.berg> (sfid-20080526_164217_674148_B60C9963)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tykr27Mvzrcw0J+3wizm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-05-26 at 17:32 +0300, Tomas Winkler wrote:
> On Mon, May 26, 2008 at 5:19 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Mon, 2008-05-26 at 17:09 +0300, Tomas Winkler wrote:
> >> From: Ron Rindjunsky <ron.rindjunsky@intel.com>
> >>
> >> This patch fixes a deadlock of sta->lock use, occuring while changing
> >> tx aggregation states, as dev_queue_xmit end up in new function
> >> test_and_clear_sta_flags that uses that lock thus leading to deadlock
> >
> > Oh, good catch, thanks. Reminds me to debug the other deadlock I saw
> > (not mac80211 related though)
> >
> very encouraging :) . Can you send me details I also experience some
> lockups on rc2

Well when I resume my machine it locks up right after printing "eth0:
resuming" or something like that, *iff* eth0 was down when suspending. I
fixed a bug like that (NAPI related) a while ago, but w/o sungem changes
it has re-appeared, or so it seems.

johannes

--=-tykr27Mvzrcw0J+3wizm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDrL9KVg1VMiehFYAQImTw//Wr1JFRDx24wUcQ0hSZzWdS7i2K63Ofyo
y0g8ftryVAShimV2FdrK3Y2/gJE3P0OUcYnPecRM5u0DvwzJ/BjC8cwr5NPbJciO
B0+p5KGGgCNdT7sGbF3TMxIVtAvuoqKg6sOqqVyIJFZYEZfJQNunZjHVGyFyvEe1
hplAZtN/S+NNfnB3Ks89g2DkKdQPo2jvhcPelEbrfvqU493Q0RyosXL8YTBuHy5e
ZHYqOmZq3dFmZomZvOrzxOfvGj0+dIvF7H59UDXRd+sQCaMew0BS7w+3gUnuEnOR
sh175kuMoSbj2cZDjVNaiYcVWNrQJi4/1HOprSnsuPljdBf0SDPMVt1Ef3Ib3wNI
aOAgKLsJS5ytc/VFLccpbcZaACn9EsWOgMmWZJ5SPEu+csv9Y08hThJUg0ZkOanY
IsUAo1uJeBJ0wqsWjVYXgif7JxOTEgMqCbRjfYocf/9OurYWoQzc9C4Bm0VANUKN
i5Lp7lBoaojVJIlI9edKqGfu9e+uGS0YxBKxDHAtKr+mjHt9LJrGx25pr6CRQiQW
99y1FLb5+YtdV+HjUD63SsqdGzRYa5bwRxjNS3kWcKsVvdixZ9UTswbXa/Gjqql2
IfGt98/AGto7ebE4Q529dDo0Ivy66nKrj1ro/y7afybYba2xCcypTWpI6VH4G/dl
O/epSTqSnZA=
=1NA2
-----END PGP SIGNATURE-----

--=-tykr27Mvzrcw0J+3wizm--

