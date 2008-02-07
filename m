Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42048 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872AbYBGKg1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2008 05:36:27 -0500
Subject: Re: [PATCH 05/13] o11s: added mesh.h, mesh function and data
	structures definitions
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47a78274.12025a0a.0fb8.67db@mx.google.com> (sfid-20080204_212415_776178_13DE2F2C)
References: <47a78274.12025a0a.0fb8.67db@mx.google.com>
	 (sfid-20080204_212415_776178_13DE2F2C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oMga4PKLtRjcDBtXrATd"
Date: Thu, 07 Feb 2008 01:25:19 +0100
Message-Id: <1202343919.9965.57.camel@johannes.berg> (sfid-20080207_103646_097893_8985CA16)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oMga4PKLtRjcDBtXrATd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> +/* plink is short for peer link */
> +struct mesh_plink {
> +	u8 ha[ETH_ALEN];	/* Hardware address */
> +	__le16 llid;		/* Local link ID */
> +	__le16 plid;		/* Peer link ID */
> +	__le16 reason;		/* Buffer for cancel reason on HOLDING state */
> +	u8 retries;		/* Retries in establishment */
> +	enum plink_state state;
> +	u32 timeout;
> +	struct timer_list timer;
> +	bool ignore_timer;
> +	spinlock_t state_lock;	/* For peer_state reads / updates and other
> +				   updates in the structure. Ensures robust
> +				   trasitions for the peerlink FSM */

typo: transitions, what does FSM mean? Also, using kernel-doc instead of
inline comments would be appreciated for when I get around to writing
documentation again.

> +#define MESH_PATH_ACTIVE	1
> +#define MESH_PATH_RESOLVING	2
> +#define MESH_PATH_DSN_VALID	4
> +#define MESH_PATH_FIXED		8
> +#define MESH_PATH_DELETE	16
> +#define MESH_PATH_RESOLVED	32

You could use an enum and kernel-doc to explain these, also the BIT()
might make sense.

> +struct mesh_path {

> +struct mesh_table {

> +struct rmc_entry {

Similarly, kernel-doc would be nice.

johannes

--=-oMga4PKLtRjcDBtXrATd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6pP7qVg1VMiehFYAQJ62A//ew5R/aXdsgot4NYo0Aj01wYtYnjcsN9Z
Lf3SyCsJ8nrWKVzI65cfNRtrYKt+yw23913gGqKekeLiogIZYQYccLF7npngbsdX
eF9Kb/L/JQFFVViuLvfoz00BnZmzI94ilokXsn7eyN4IOvv3x9ra50vFRGLrRXE8
nyXx8hGWDNY1jd4cZZlkTt5oWvP+WSLmfu7FY3DLkbd+gJu6JYIyZXg5bYme/sMe
lx38SrwneQfwigAd2W8JGSjxe/AqBmrwH21FlBQ2eKgaLbh22g9cXP4IzsDRBLRU
xbGCyMZEDNfW4l8XtMgF+WPUy9V5jcjMkEajzIGtBaZuvL14GXhlmERXkv8KX3cN
2XK/ELtFYYUDexbl7SJvdYbVgaUf5nff6FJRPh5Qk0s1n/Rfa8/oK3HGJidqvUOF
2x2vPkFAa3a4BzDETkosasnhfsMbIhZY/VSAuW/2t8mMN3qkh3TIbOB1JCoBLJOd
igiXCEDVmkYM1fdQi48Y6WxWi1+h5nlJcdxIXTJfNn4hmnjW1FaSie+JP23RsjE0
US9cVwtw8y6OXzXpwpLtdRqZruWXK5dm38fldEnzR4nM3EXcAOJBrYLH/asyZ0ym
qtZgUAud9asFQiLvJjqSShWuoV0YRvZ7kRgau+t22wCgD53y9Cx4lgVVG7edmJQL
2ABQOcJ3Wkc=
=Ry+r
-----END PGP SIGNATURE-----

--=-oMga4PKLtRjcDBtXrATd--

