Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44091 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287AbZGGBkx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 21:40:53 -0400
Subject: Re: [PATCH v2] Fix regression in mesh forwarding path.
From: Johannes Berg <johannes@sipsolutions.net>
To: javier@cozybit.com
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Andrey Yurovsky <andrey@cozybit.com>
In-Reply-To: <1246929954-15282-1-git-send-email-javier@cozybit.com>
References: <1246928780.4652.10.camel@johannes.local>
	 <1246929954-15282-1-git-send-email-javier@cozybit.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Zp126mAf5W2newuoC/k1"
Date: Tue, 07 Jul 2009 03:40:56 +0200
Message-Id: <1246930856.4652.11.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Zp126mAf5W2newuoC/k1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-06 at 18:25 -0700, javier@cozybit.com wrote:
>=20
>         while ((skb =3D skb_dequeue(&mpath->frame_queue)) &&
>                         (mpath->flags & MESH_PATH_ACTIVE))
> -               dev_queue_xmit(skb);
> +               ieee80211_add_pending_skb(mpath->sdata->local, skb);
>  }

?

Hmm, now I'm confused, why not just do

if (mpath->flags & MESH_PATH_ACTIVE)
	ieee80211_add_pending_skbs(mpath->sdata->local,
				   &mpath->frame_queue);
?

johannes

--=-Zp126mAf5W2newuoC/k1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKUqekAAoJEODzc/N7+QmaBYMQALOXA7rHrnHiotOm2OpQ9UB6
GoU8H3Di9Tk/yAkmlLNZ+VzrsDfZzJM7QEwTG5Lg8lbqEGze700A7i/0sSdkKDTs
EDsWHqKHUpQcwDAhj3rDYf6ChvLI0wS68DBQm2qGiWza9L6rZ/QAjinT0WD8LTRY
2BjTyhxDaGAUPVAOP7LybkTAg8M8xVS//lWACbTdMNCIBrDV+bDg1AFfy5Fjazpz
6eQFW4fiU5FHXdPEd49b53/7CHD08JnzGnoUa7s4kDlnjjlxY9yT26FBw9tMMTJY
xvoiqKHb/HOyLe7Me+Zfc8oARJLEkckZwCtdGOQ15Y0lRYDT4TYbJlmItb/fl7zR
IJ1PZcol9sXvemIILhBIRF+1mpFKOSsh0QoGpp/fb/nBkq8M8FIHMTPiEC9NDLo6
7PurH21vXOLtWxYhM4d/mhDcfd9gOBqfC4f8ag6iXIDmeEDMBHLb6TF2oknAp2dp
QTMl6CcB0W4YuomPm+jAIdXQ3WslMMVikeKOl57dl4XZv8L34W3WZoON5wc/HoxC
n2oapiBhEICy52Z/fSNHqeuoUcygN7HYViCtrSrJEdt+EcDkYdhuXQGzzpgoK5W0
S14QytNGaVgJkiSt645U7suW/N5FxLZrq9oBiJXS9JSFzrlPOGWaEpD4r9rrxtOl
ZVBWHI/+tJKDcVJtlVbY
=TFQO
-----END PGP SIGNATURE-----

--=-Zp126mAf5W2newuoC/k1--

