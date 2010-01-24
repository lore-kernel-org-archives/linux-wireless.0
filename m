Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43245 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab0AXK45 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2010 05:56:57 -0500
Subject: Re: mac80211: Breakage in software encryption (iwl3945)
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1264277460.13250.10.camel@maxim-laptop>
References: <1264277460.13250.10.camel@maxim-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+veI7JIqYkD9sRhUikKD"
Date: Sun, 24 Jan 2010 11:56:53 +0100
Message-ID: <1264330613.23766.17.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+veI7JIqYkD9sRhUikKD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Maxim,

Your mail is confusing me.

On Sat, 2010-01-23 at 22:10 +0200, Maxim Levitsky wrote:
> I updated the kernel and lost connection to my WPA2
> AP. Strangely the WPA handshake completes, but DHCP not.

What did you upgrade to?

> I also unfortunately found that all that time I was using software
> encryption (this is iwl3945 loaded with swcrypto=3D1).
> Hardware encryption doesn't work ether and didn't work in the slightly
> older kernel (but it did work once, I sure)

That must be a different problem, surely?

> Now, the commit a6bae9e7ab19876a157c91019852395539e4f20e breaks software
> encryption, with behaviour like described above.

And how did you arrive at that conclusion? Have you reverted the patch
and it works again? I really don't see how this particular patch could
break it since afaict it's entirely correct, there are exactly two tests
for IEEE80211_TX_INTFL_DONT_ENCRYPT in mac80211, both of which execute
before the code I removed.

johannes

--=-+veI7JIqYkD9sRhUikKD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLXCdxAAoJEODzc/N7+QmaoX8P/AlUsn19ir1XLaBfwbz1wFxL
bGCwvHxSbP0HzycDGgxsWLUlqBVVBAhgaB+rdpfbj/fzaxXmbwoEoU6C4CLamPa4
G64qkKkS+UH1AHrwo4o901xC4eUZjzB0jbIV2Z4Tw+cV8wdLl8BKXqKBAJqIhFtx
NeGxXBmpTm5YOTl8qZcXj0YHIq2QnsVHviVlw180N4SndyiDvGj83+TgJLjcM1kH
73RwrIuWqo8tvUlMYH2K1L4kZ9CqisQvBxa+vzqI7K9tTAYO0JHFiz+Sv91mthlJ
dyfuc/FfCZ9PBzN62pFq8JCFRmOcbifv2bgqicNCHaErbP++OGIbMlmFg0EpAwlT
JhFCzMlw4A3ML093R8tiMQ/fdRPaXYRF7ep/uqWc1DZaQ/S79aQzNpgsbmhtADCj
gbWEgkj+yZ8B995KWy/ZLztQbMkejHVYp+gi9pb26P0PFkNG3VmR/ddc2ZKgMp/X
gJbzXF0rgc5R/WbcjHaCGF5paqUJ9TNYylp8pSHy7QpANMrc/oNRp0W8Iy6B8NAn
WhEzu089yIw8mqTY6NQ4H3bYtmQ7cKKp0oRFjpBQcea0HTtkGv2PKI7fiAI0Dgc2
gTJtSbP0QHVItbg+6cvEOBnY4+D2OSUJlByMLC1/Ve2ZTZ51+ubHd6bBPuw9AMQJ
vGwtbc2qeNQeU0NKbzSS
=dXz5
-----END PGP SIGNATURE-----

--=-+veI7JIqYkD9sRhUikKD--

