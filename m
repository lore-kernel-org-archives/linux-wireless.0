Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36428 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbYIHIaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 04:30:12 -0400
Subject: Re: [RFC PATCH 0/3] mac80211 dissasociation
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240809080118p26b4d984k57ce0b20a5d2c36a@mail.gmail.com> (sfid-20080908_101843_062010_878B2F97)
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
	 <1220794765.31304.8.camel@johannes.berg>
	 <1ba2fa240809070724n362d5850t653ca5746b87eb48@mail.gmail.com>
	 <1220798432.31304.13.camel@johannes.berg>
	 <1ba2fa240809070750k1683f410icf2a82be0f533b4f@mail.gmail.com>
	 <1ba2fa240809071614v66235658w1768e31d31c2d0f8@mail.gmail.com>
	 <1220860709.31304.19.camel@johannes.berg>
	 <1ba2fa240809080118p26b4d984k57ce0b20a5d2c36a@mail.gmail.com>
	 (sfid-20080908_101843_062010_878B2F97)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0GQC3/oMOPZAgFABamXn"
Date: Mon, 08 Sep 2008 10:30:04 +0200
Message-Id: <1220862604.31304.27.camel@johannes.berg> (sfid-20080908_103017_215937_0F16C34A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0GQC3/oMOPZAgFABamXn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-08 at 11:18 +0300, Tomas Winkler wrote:
> On Mon, Sep 8, 2008 at 10:58 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Mon, 2008-09-08 at 02:14 +0300, Tomas Winkler wrote:
> >
> >> why I'm hitting unathorized prot messag for subif_start_xmit.
> >> Shouldn't carrier_off(stada->dev) stop the queue?  I haven't seen this
> >
> > and no, netif_carrier_off() doesn't immediately stop the queues, it jus=
t
> > schedules the link watch which will _eventually_ remove the qdiscs and
> > attach the noop qdisc.
>=20
> So what you are saying this is expected behavior?

Sort of, yes.

> Please remember I'm testing the disassociation
> 1. AP is should down
> 2. Switching to another AP -> Legacy <-> HT
> 3. WPA supplicnat (it uses ieee80211_ioctl_siwmlme)
> 4. The BA tear down will be unfortunately untested, for now

When you shut down the AP, it probably sends you a deauth. Frames we
want to send out for it might still be pending in our queue. Since
you're removing the sta_info for it right away and not stopping queues,
you get the "unauthorized port" message because there's no sta_info
struct.

The reason you haven't seen that before is that the sta_info wasn't
deleted, so we could still send out a few frames before
netif_carrier_down took effect.

To fix it, we probably want to simply stop the queue for that subif too.

johannes

--=-0GQC3/oMOPZAgFABamXn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIxOKJAAoJEKVg1VMiehFYndQP/j1vMERmp4ylU5v57dgt3M2j
IBoPqN6JqBGRHtUTE3ugwNoxhZ//FQ9RaDyg6+DdC4Xp3N3qkYXiIp5ia0K/k+ij
gZb/XgzA4tQF43NvRuIVBpkpW/njT+H2TzslP9Y7vHqRy9Swjwn1CVPjUyaAf+7/
mpKKtX3rd3wo701OVkeu5EIKjfm9YJby5FPeFuVD4JNpYMI49bRpfAVKsjHsckBR
sNekLeQOu3kB4o066SDn349MsOGGsGXiN+rm9yACbs9dBer+sVdwi7tS8v41cFXn
KAaxUwA+gACkSguMbC1S5W+7p8A02fbTtNRe8XanJJEZm7NbEDGJIulbZWsdgWgg
SoY7derpZR7baQk76hZRVHLKZ+QQrQ1nfHjNBin4K2ogTeV0ya4nG82WzyiPVZvu
imyq8gySpuF1PzAIiWCK8Q3k8ny+ttjA/E9ujljIoNJgb5k74yy4huFnobs53Z9u
Ez3vvTGtCmZy2kqJzdkheqQMHxdk5rUbMwl6K4jGSzMWDHtit2JjvnpDH92uxpSf
XwpfU29DvGLh0+oFk+vxBGF80tIgboq6emaaU/NrsCuYHZAo32LBo8/v4DDHW5hc
jxoNX3mrRAE48FCvHGLEq6QhnIgjGaHq+rLrw4uT5TCnTThfTUqspd58U+kLFAYa
zAmzuHVYt3e/iROGlQR5
=472g
-----END PGP SIGNATURE-----

--=-0GQC3/oMOPZAgFABamXn--

