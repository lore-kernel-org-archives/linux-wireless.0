Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38598 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbYBMMIy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2008 07:08:54 -0500
Subject: Re: [PATCH RFT/RFC] b43: Add QOS support
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
In-Reply-To: <200802122205.42799.mb@bu3sch.de>
References: <200802122205.42799.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vvp0K2gpi0rhR9EhebhT"
Date: Wed, 13 Feb 2008 13:07:53 +0100
Message-Id: <1202904473.8931.31.camel@johannes.berg> (sfid-20080213_120856_547667_02AE4ABC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vvp0K2gpi0rhR9EhebhT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	if (queue >=3D ARRAY_SIZE(wl->qos_params)) {
> +		/* Queue not available or don't support setting
> +		 * params on this queue. Return success to not
> +		 * confuse mac80211. */
> +		return 0;
> +	}

Is that really necessary? If so, I'll probably remove it when doing the
QoS rework, it shouldn't be, imho you should return an error if mac80211
tries to configure a queue >=3D hw.queues.

johannes

--=-vvp0K2gpi0rhR9EhebhT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7LdmKVg1VMiehFYAQJ5eRAAwIKUcgyYEpQFeasiG6PqaTzsFDLsdrQn
7+4eTKiuIME0wkzVGPby1FrF30aJVUa80F7bnQQesZ7hhn1Z7Depn5FwRAY//83H
+RKHEMA4qb3v0MQsxadgloiaQO7+Iju2uho/g5XNa+1oby1Pyh8XDA/zgUpuDFVN
cmAAsTzwpuJpK+umlZype+OxONimlbX1zlKqrJutIIHdKnR0QsjxbqKPH51ECWfs
VNwKD23Xg4oJv65HTgfOadW7nRx9ZKb+VYjAHqRHOEQ/I6kJCNJc+gfNmWYtk0Vm
+h/JrBMWUwPCDHaK58iNHZrx7s0l4kuwDWfltRWEdJ3EQEq+mtAKyMkflc8UvNnM
2NOiR8KBQYTe9PVoAeDZwBkD5DG6HCPcuEvvrHaKBJQ6Af7lrfyQ41RPPf1Bhr4C
a4DAVsDelxe7AnSUpaG28oZjefyFr7u0HptmfO1EbBRXgXOUD/WVbop+eHPz6YlX
wcQNlNBm5GwORCCjNF9Xe0dOEJVjDzx+XTpVtmFS9s6G8QKKIbpO09VJ+XMmN2xt
HWGZEBbWtUB3w0+C9LmGxMYGncEGqJnY4tfWEtuYLh0opOC9Ubb/XokGdylt9zqv
LDSGpvRpl/p20+6O96gvSoF0YjXxr28Bcy0VSFwfBe6AfPS0P+uJ72N0Cx5mkBwP
XiT36MrB5ms=
=7G+o
-----END PGP SIGNATURE-----

--=-vvp0K2gpi0rhR9EhebhT--

