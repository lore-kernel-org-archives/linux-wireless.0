Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36580 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbZBMGyN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 01:54:13 -0500
Subject: Re: [PATCH 4/6] cfg80211: add assert_cfg80211_lock() to ensure
	proper protection
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1234503363-11014-5-git-send-email-lrodriguez@atheros.com>
References: <1234503363-11014-1-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-2-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-3-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-4-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-5-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-q1yxlkN6bveuY95wtraM"
Date: Fri, 13 Feb 2009 07:54:08 +0100
Message-Id: <1234508048.1327.17.camel@johannes.local> (sfid-20090213_075416_745381_6813298E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-q1yxlkN6bveuY95wtraM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-02-12 at 21:36 -0800, Luis R. Rodriguez wrote:

> +static inline void assert_cfg80211_lock(void)
> +{
> +	BUG_ON(!mutex_is_locked(&cfg80211_mutex));
> +}

That's a little heavy-handed for a small development mistake, can we
have a WARN_ON instead?

johannes

--=-q1yxlkN6bveuY95wtraM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJlRkOAAoJEKVg1VMiehFYmYUQAJs8tZCQ4+EIS11gGMFZD7IJ
FSew88CrqFYFFS+q5bWc+ibhWZTdwiZC2RMcvP3pA+rS9XBJL1Vxpyf6yCVkOVj5
ljaMFLVhEuw6fgndTRcst3lILx/CSmFc8L6VoxTgVWVJiAi3l5YC3h1wuduj2RJX
NbXmDbWheWRNxxDAlYvH9BychFN7f8CMnYNviZ/a3Oo2jyq0RcY4o/Od0Evi41Uk
hymWpBBx04ytalgNa+NMyyQZ/Ttk4XjCgWljrj7PwVXYp0Uv1oW/tVLpuW6tQBgC
ufgxKjlnh2EAX5krMdV94sVGdGtDz8+79KG5kp+gq9+bIeVrf3jZgzn+kmbQdU6c
CmIgwXoxs/x3VB2C0D9SUslBdiBCYR37OStB/aR46vxHoosHtiq/FGPBI5HmDC27
I6VU0EKhdsYVU3NbduocqNPvhgGQXjl02XxY10ggu/d2ZB9VW4I772tF6i47xzVf
LOWyZk33Ivs1Ex2ctVa+SYtPE3PSMYUEjUU19rQOnicKEXMLiF7Os/dY2qLUXkP3
uTIvVp425eh+lqTl+amPd3N9PYuvOW71GtNngm72wfVyAbMeosDZ6OEN4/sDJb2w
jyFxuiAPsXltWDfmTfjHmfdXUC12c6zAstfiKa2G28CnXngGcLeQEHyTLPBiWBGX
EtnAoOe0Sej32VFW6WkQ
=hzmj
-----END PGP SIGNATURE-----

--=-q1yxlkN6bveuY95wtraM--

