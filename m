Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42485 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab0BIMOH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2010 07:14:07 -0500
Subject: Re: [PATCH v6] mac80211: Retry null data frame for power save.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1265707228-4813-1-git-send-email-vnatarajan@atheros.com>
References: <1265707228-4813-1-git-send-email-vnatarajan@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Ks3+TlUHASNyrSnU8s+v"
Date: Tue, 09 Feb 2010 13:13:54 +0100
Message-ID: <1265717634.3783.35.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ks3+TlUHASNyrSnU8s+v
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-02-09 at 14:50 +0530, Vivek Natarajan wrote:
> Even if the null data frame is not acked by the AP, mac80211
> goes into power save. This might lead to loss of frames
> from the AP.
> Prevent this by restarting dynamic_ps_timer when ack is not
> received for null data frames.

Looks good to me, but I have a final question: what happens if the frame
is lost without a status report? It'll just stay out of PS for a while
longer, right?

johannes

--=-Ks3+TlUHASNyrSnU8s+v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLcVF7AAoJEODzc/N7+QmaujQP/3x3I4HUStF9U1+cWaRhiFp0
gd/rkLodzolDq+tO6OCFOJKysPv3JYvXLRmCBk0o+FL3RIiolkKgctrAzjMitmwI
J3OYZ2ZiofFFCAITyCMqhl1SMaOiMtFvrmyXA8hw5PAng/Mz8jtJsOVdC7oadlKr
NkmDD5F+JSw66jol6SDdT64jyt+SCFFOE+l4e3ECdahhRjYoYwwQqbx0hBAN2k79
e6JYDPD5nR6IgnlKe1+IAEasBhVdUIZKXQOMRCHJVdLBHwvuSe1BOrrRQQmStL6l
O8sa/riMezXMCKHnvCNYV77uCN7L0VVC8H1b4J7RNQ30Uo5r5/lzeBD0Kl7XIh+W
PS9kKl7thg5/rCtHbExZ94MmgYWDEWidBAH5yeHzeKf+o3aouC6SoDdUiKAtF53J
8FPffe5wI6k5BaKQ4+ggG3IysaDQbjNNgjfG91zWXdDdn1uYRxw71hIehMndYFfG
6P+AfIIlU7r06jXQt15qGcwo2a6SI08ogdb0XkfRYl1iizn71EGKXj/cAMEl7knK
pCr98qciqW1PL5bODpMu69FWhLgLkN2p+lWtdINYtNPAS4PjiT3/uJHa9R8g5ZA7
eD65gv1x4WMStLXI/oGd96b/2ngl9xgwgjUwfz6U6zko6B11MfycdCDoO0cHnu5h
iFIc6u1F4nqDD7lBzAVd
=H9VX
-----END PGP SIGNATURE-----

--=-Ks3+TlUHASNyrSnU8s+v--

