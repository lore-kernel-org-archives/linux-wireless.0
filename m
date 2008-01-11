Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42131 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757522AbYAKLj1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 06:39:27 -0500
Subject: A-MSDU reception vs. IP alignment
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aNdZoE93N5fpRURtpx2A"
Date: Fri, 11 Jan 2008 02:12:20 +0100
Message-Id: <1200013940.3861.142.camel@johannes.berg> (sfid-20080111_113932_178890_124DBB8D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aNdZoE93N5fpRURtpx2A
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Ron,

Even when we align the packet as indicated in the patch I just sent, we
can still copy the payload of an A-MSDU packet to a badly aligned place.

Could you maybe look into fixing that? Basically, I think all we need is
change

                        skb_reserve(frame, local->hw.extra_tx_headroom +
                                    sizeof(struct ethhdr));

to something like

		resv =3D ETH_HLEN + extra_tx_headroom;
		if (resv % 4 !=3D 2)
			resv +=3D 2 + (resv % 2);
		skb_reserve(frame, resv);

(allocating an appropriately sized skb of course)

On the other hand, I also wrote in a note with that warn-on patch that
we can probably save the copying completely by simply doing a clone and
adjusting the length/offset properly. We already make a copy of the
frame in ieee80211_deliver_skb() when we pass it back for sending to the
wireless medium so that should be safe. And it'd be much more efficient
than copying all frames. I'd appreciate if you could look into it.

Thanks,
johannes

--=-aNdZoE93N5fpRURtpx2A
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4bCc6Vg1VMiehFYAQIC6RAArFTVXFwQpWscPUlOBnO9lrmSm+s9v/MR
dcGV446awxy3Mdk4ksQTtrJINft0xSjY8RSBkY+/VASl40HwXgZqFWSn5OCrVYrU
K6mzvr6zAsxi40jvvQXslQ9Xoeu0TN3RLek1TTotb2nOYjtWuHhdoEqOjB22npvW
EFLhvzllKrp27oQd5Fc2nShvKuEKjbk2VOY1zrNgflUaMkfE0Nc9Nrcjo02W8DW7
orFR5ld/3cI6X8mG1EHME9QotSrLflrg3fiLi25bSNCpDTdZuT9HP4sF/cs9nhAx
QtgiE2jTLS7AespHlAxIF7Hve4P5JAa8o5RUHSYNTQZWufcdDmkAbG2ha+PCwS7Q
qyYgth1AzS3PFeHD6Nw7zmhjJrdT2M6BMKN+qDm7N0Toy1UzTDwB9LSaBT+dW7wG
uQgvwHaZ5ipkQUhJmpqE5Efj6QZ7MpbwZpWz0eP5tLJrCEhYnz50C4IUkcNejO6P
eRc+XcmAAX7RwlaRURIjqKkJnkfSQrc4rQXEPeoUPDSdl/u3hia6HjJJjrv4r/6Z
bs9WuGa1odosj6vo79nVL21l9T9rgFUmA9yvJobkyri7fgegSE3HmDFzywrwzhJv
kFifn7d797HtwmfWYgFp665rfhMRxji2/mVlPXtLfVHgExVbZ6Ih/sxQPdiWFJHp
dmgSc71ROv4=
=7tfl
-----END PGP SIGNATURE-----

--=-aNdZoE93N5fpRURtpx2A--

