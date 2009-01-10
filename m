Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41246 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbZAJJ1M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jan 2009 04:27:12 -0500
Subject: Re: [PATCH v2 0/3] mac80211 suspend/resume
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	Dan Williams <dcbw@redhat.com>,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org, mabbaswireless@gmail.com
In-Reply-To: <1ba2fa240901091553s387c1a95k3576ce6a82015434@mail.gmail.com> (sfid-20090110_005429_845681_92931D77)
References: <1229313039-5544-1-git-send-email-me@bobcopeland.com>
	 <20081217174244.M36761@bobcopeland.com>
	 <1230064216.31228.46.camel@johannes> <20081224054951.GA32398@hash.localnet>
	 <1230102989.16960.14.camel@californication>
	 <1231260306.14565.21.camel@localhost.localdomain>
	 <1231261937.5246.16.camel@californication>
	 <1231267979.14565.34.camel@localhost.localdomain>
	 <1231270575.14901.6.camel@californication>
	 <1231272326.3767.2.camel@johannes>
	 <1ba2fa240901091553s387c1a95k3576ce6a82015434@mail.gmail.com>
	 (sfid-20090110_005429_845681_92931D77)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tkf0bdjBaQ90CuHyh+4N"
Date: Sat, 10 Jan 2009 10:27:59 +0100
Message-Id: <1231579679.3685.10.camel@johannes> (sfid-20090110_102718_907310_7589EF3B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tkf0bdjBaQ90CuHyh+4N
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-01-10 at 01:53 +0200, Tomas Winkler wrote:

> I second this by stressing another issue. in the point that
> suspend/resume events shell be present to user space regardless of
> mac80211 specific talk with wpa_supplicant. Not only Wifi but also in
> my knowledge BT and other coms need user space application
> to close gracefully connection before kernel shuts in down.

But userspace is usually the one _invoking_ the suspend, so what I was
trying to say is that we don't care what userspace did right before
invoking suspend.

> Even sometime leavening shutting down interface managing application
> may reduce the crosstalk so that driver doesn't have go guess when
> application has finished it's shutdown. rtnl is probably not enough as
> there is still race who grabs it first.

No, the rtnl definitely is enough right now since userspace will do
whatever it needs to _before_ invoking the kernel suspend.

I say we should just put these patches in as they are.

johannes

--=-tkf0bdjBaQ90CuHyh+4N
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJaGocAAoJEKVg1VMiehFYN24P/R/cxmA0UemTBmVi/cnSt9dN
6WElHl4f6yY0Ud0gCSyliSpAwSgBPfWqa2+jxa8DsVipnaVuwcHZB9016Q1EsvAl
pwFSTNeiBHaWANAiJ0A1x7+x6uInsUrpuFyXrYu3jqyysJKBuKByt6Fo+MWXNSz6
3ULphfp68CbkkP18vR/EErFbMP2swliqb3r4eLu4a+kF7AK4zU0TrulCjLiQbgy+
AvGtT8czeCWeXrEsgaeFmrJCA009bIwaPJczYrYYwONTSCV7QFOfODs6n1YXK9Fs
tZkR96fbuKzFxSWXsLj4tV2DkBiDua1rUGRDQ6DWQ4069CB1t+rRJKcmtC5oP62I
LTuWZu85LC7lrsATnG72RSGjaA8uhz7RJ4x//Y8UaBsrpxwO7r1C1gx4RzO0cUQ7
2J0QGRAq2jmuFhta+owxA6he+gZ//HBQqfSP72MIwH+aYu0+qR6mgC+Z20c/qF80
Zvo4XSMdmJIWZAsRhtoZcazrntOLDDUBafyUTIisatO7MWozC+TKXKnbkiMcVHa1
CybTKEbGds1cJ/qCdLrSsQzyEP3c2HnWSNWfAh7o9W+x+ZJ/RjL1Cnld6+715Eii
93aVhNAuadjCxk2onFrukGXQFqgRY8qavDwGQQXAx21lvK3zHVpZYl+xViA5eKfD
bTs/P33TJXlGsgQaeRHf
=wNCp
-----END PGP SIGNATURE-----

--=-tkf0bdjBaQ90CuHyh+4N--

