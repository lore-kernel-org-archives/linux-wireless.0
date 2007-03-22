Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:63498 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932975AbXCVXTd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Mar 2007 19:19:33 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/4] mac80211: Add radiotap support for Monitor mode RX
Date: Thu, 22 Mar 2007 19:18:21 -0400
Cc: andy@warmcat.com, linux-wireless@vger.kernel.org
References: <20070320103955.600509703@warmcat.com> <20070320104104.318699229@warmcat.com> <1174503091.3944.42.camel@johannes.berg>
In-Reply-To: <1174503091.3944.42.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5685658.RJviMaEanf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703221918.22256.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart5685658.RJviMaEanf
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 21 March 2007 14:51, Johannes Berg wrote:
> > +	/* Driver supports radiotap. */
> > +#define IEEE80211_HW_RADIOTAP_SUPPORTED (1<<10)
> >
> > +	if (local->monitors &&
> > +	    local->hw.flags & IEEE80211_HW_RADIOTAP_SUPPORTED) {
> > +		radiotap_len =3D ieee80211_get_radiotap_len(skb);
> > +		skb_pull(skb, radiotap_len);
> > +	}
>
> I don't think that can work.
>
>  1) it needs a lot more documentation on what a driver needs to do for
>     this (for example that it should only add radiotap headers if a
>     monitor interface was added)
>
Lack of documentation makes code not work?

>  2) afaik local->monitors is increased even for soft monitor interfaces,
>     thus this will really fall on its nose when the driver supports
>     radiotap but not monitor during operation.
>
Yes. I noted that in December when the patch was first posted. This will be=
=20
fixed when I post a radiotap RX patch that's actually signed off. No sign o=
ff=20
from me means it's not done and probably not tested enough if at all.

=2DMichael Wu

--nextPart5685658.RJviMaEanf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGAw6+T3Oqt9AH4aERAsQoAKCKqxjgk8zXiM7JBmdjslMEs1/ejQCfdIAV
mvFCRO1uLYbXutRQU7PW9UY=
=UEWQ
-----END PGP SIGNATURE-----

--nextPart5685658.RJviMaEanf--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
