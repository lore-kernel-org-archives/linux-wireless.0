Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52849 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbYGJKwa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 06:52:30 -0400
Subject: Re: sparse warnings on iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240807100345n15c5ff84mb47267fe547a545@mail.gmail.com> (sfid-20080710_124533_279364_D3E6E16C)
References: <1215681008.3932.5.camel@johannes.berg>
	 <1ba2fa240807100345n15c5ff84mb47267fe547a545@mail.gmail.com>
	 (sfid-20080710_124533_279364_D3E6E16C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-de0blkYcHlMHgObI9Q1c"
Date: Thu, 10 Jul 2008 12:51:44 +0200
Message-Id: <1215687104.3483.14.camel@johannes.berg> (sfid-20080710_125233_873590_73629B6B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-de0blkYcHlMHgObI9Q1c
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-07-10 at 13:45 +0300, Tomas Winkler wrote:
> On Thu, Jul 10, 2008 at 12:10 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > Was just running sparse for something unrelated and noticed these:
> >
> > drivers/net/wireless/iwlwifi/iwl-rx.c:832:2: warning: cast truncates bi=
ts from constant value (1c00 becomes 0)
> > drivers/net/wireless/iwlwifi/iwl-rx.c:836:2: warning: cast truncates bi=
ts from constant value (6f080000 becomes 0)
> > drivers/net/wireless/iwlwifi/iwl-rx.c:836:2: warning: cast truncates bi=
ts from constant value (6f080000 becomes 0)
> > drivers/net/wireless/iwlwifi/iwl-rx.c:856:3: warning: cast truncates bi=
ts from constant value (4001 becomes 1)
> > drivers/net/wireless/iwlwifi/iwl-rx.c:860:3: warning: cast truncates bi=
ts from constant value (a000 becomes 0)
> > drivers/net/wireless/iwlwifi/iwl-rx.c:864:3: warning: cast truncates bi=
ts from constant value (c000 becomes 0)
>=20
> Yeah I've actually wanted to ask someone how to solve. This comes from
> radio tap code, frankly currently very low priority on my list.
> Not sure why but only calling directly to put_unalinged_le32 fixes
> this warning. In general put_unaligned should be expanded to this
> macro.

Yeah I was also just looking at it and couldn't make sense of it. It
seems sparse gets confused about the pointer type or something.

> I will submit patch that solves this.

Cool, thanks.

johannes

--=-de0blkYcHlMHgObI9Q1c
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIdem9AAoJEKVg1VMiehFYdo0P/1/9jg9JkHbWfzPKg4IjnIV0
cdCEdxiWjyzLuvc+xXug/QKDmW5QCP4GhoQ3E7C06hX69PB1GsIdPJCdaP29WWER
S0d8EAhifdvKNY5bFmAov9NMRPCWbkdJU1If8ENZLO3MMK1lNFKrdaKCwVmIg6CN
E5xGi9K9QplRq3A5QAPp4z2IWT+hBSU3rVvZZoGO2O9s5jWeUr0KaNuVsMuWas7u
xv9TQ30JIth9EKfdWbyAAJxMIgVKxpcw7mAQAqWnL24dbwZFnQigLCMNWpSbclE7
GsZ2RiYw/VsiAwm6K+hue8QlkFz0MROoblbFLcLl30E9YIdsN1Hydi7zwjTMh4x2
QO6PKtI+AlioPbvXdwAflDELjM47EI9CBFABM8UcXvDG6jgYG/AEOpKmbkJhu0OO
tkse/BuEhajYAV0SBa7KbDrupFK6irJpEzQxMifG9jTJtaN5dGZHPeOzmUGlQNIs
0HtwZGkwOi+ewoN5XrMvBNC86Jk9xSLcdmPaQp2dKWDNCo/jQs3XF/tG/CFi0lAj
8/BzbNidJAV/oDhKAC7iylYkbHs933L3ecaaWnnhfiOpRuxerK0zHzxTEBz1FFEO
9/UfiSvFcTet3DIXyFiEdDXw0ydsNKRdPg2g5LBYiY5hK38RGMdWbmmEhavl3JgV
Sr0tL437qfE0d7rTDBci
=kb/g
-----END PGP SIGNATURE-----

--=-de0blkYcHlMHgObI9Q1c--

