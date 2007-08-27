Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36384 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662AbXH0KqC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2007 06:46:02 -0400
Subject: Re: port of my recent patches to net-2.6.24
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>, Jouni Malinen <j@w1.fi>,
	Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <200708270029.35845.flamingice@sourmilk.net>
References: <1188027470.9529.5.camel@johannes.berg>
	 <200708270029.35845.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ms2DU7uJrWJE01WFQDmT"
Date: Mon, 27 Aug 2007 12:46:52 +0200
Message-Id: <1188211612.6756.8.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ms2DU7uJrWJE01WFQDmT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-27 at 00:29 -0400, Michael Wu wrote:

> Patch 10:
> +	/*
> +	 * No point in finding a key if the frame is neither
> +	 * addressed to us nor a multicast frame.
> +	 */
> +	if (!rx->u.rx.ra_match)
> +		return TXRX_DROP;

> If you really want to drop the frame, it should be done elsewhere. It doe=
sn't=20
> seem appropriate here. TXRX_CONTINUE instead should be okay.

Hmm. I wasn't sure what would happen if I let it pass further up and we
won't be able to decrypt it (unless it's WEP etc... but then we don't
want the frame either) so the only thing we can possibly do is drop it.
It seemed appropriate to do it here.

> +		/*
> +		 * The device doesn't give us the IV so won't be
> +		 * able to look up the key. That's ok though, we
> +		 * don't need to decrypt the frame, we just won't
> +		 * be able to keep statistics accurate.
> +		 * Except for key threshold notifications, should
> +		 * we somehow allow the driver to tell us which key
> +		 * the hardware used if this flag is set?
> +		 */
> Who won't be able to look up the key?

"we" aka mac80211. Not sure where that got lost.

> Second sentence seems a bit sketchy too but as long as I can understand i=
t on=20
> the first try.. ;)

Heh.

> +		if (rx->skb->len < 8 + hdrlen)
> +			/* COUNT THIS? */
> +			return TXRX_DROP;
> For comments like these, I try to put the comment on the same line since =
I=20
> expect to see code immediately following an if/for/while/etc. statement t=
hat=20
> doesn't have curly braces. No problem if you prefer this style, however..

Oh, I see what you mean. Don't think it matters much to me though I tend
to then decide "ah, remove the comment" and not update the braces.

> -	if (rx->fc & IEEE80211_FCTL_PROTECTED && rx->key && rx->u.rx.ra_match) =
{
> +	if (rx->key && rx->u.rx.ra_match) {
> There's no way rx->u.rx.ra_match can be 0 now, can it?

Heh, no.

> I think the goto find_by_index can be avoided easily by testing for=20
> (!is_multicast_ether_addr(hdr->addr1) && rx->sta) instead.

Like this:

if (!is_multicast_ether_addr(...) && rx->sta && rx->sta->key) {
} else {
	trying_wep =3D rx->sta && !rx->sta->key;
}

or something like that. But the whole !rx->sta semantics aren't quite
clear, and I thought this was easier to understand. I can change it if
you prefer.

> Patch 11: Well, okay. I'll probably add something like this back in the f=
uture=20
> for improved rate control but it's not being used now so it should be=20
> removed. ACK

Could be, but should a be per-sta setting in nl80211. I'm trying to
reduce baggage here.

> Patch 12:
> -	int allow_broadcast_always; /* whether to allow TX of broadcast frames
> -				     * even when there are no associated STAs
> -				     */
> -
> Hmm.. that seems useful.. yet nothing is using it? What happen here?

It's "used" in wireless-dev in ioctls, but talking to Jouni he seemed to
have a better idea instead so was OK with removing it.

> Patch 15:
> +	/*
> +	 * TODO: re-add support for sending MIC failure indication
> +	 * with all info via nl80211
> +	 */
> Re-add? Don't think nl80211 ever had support for MIC failure event report=
ing,=20
> but I guess I'm reading this differently. ACK

(re-add support for sending ...) (with all info [and] via nl80211)

> Patch 17 (by Jiri Slaby):
> +	pkt_data->flags &=3D ~(IEEE80211_TXPD_REQ_TX_STATUS |
> +		IEEE80211_TXPD_DO_NOT_ENCRYPT | IEEE80211_TXPD_REQUEUE |
> +		IEEE80211_TXPD_MGMT_IFACE);
> Or set it to 0?

Not my patch :P
I think he just made the patch so it's semantically identical to before,
but I guess that this actually touched all existing flags so 0 would
probably be appropriate here.

Thanks,
johannes

--=-ms2DU7uJrWJE01WFQDmT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG0quc/ETPhpq3jKURAvV+AJ0cv5uARzaYeIaUDSrRz3RCsdxveQCfQi7g
do6fFteqN/IbgE71q8Wsz1g=
=5BM6
-----END PGP SIGNATURE-----

--=-ms2DU7uJrWJE01WFQDmT--

