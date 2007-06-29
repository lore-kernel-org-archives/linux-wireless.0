Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:33447 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751196AbXF2FrJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2007 01:47:09 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: separate monitor/subif_start_xmit
Date: Thu, 28 Jun 2007 22:47:26 -0700
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Andy Green <andy@warmcat.com>
References: <1182433144.21939.6.camel@johannes.berg> <200706282235.46522.flamingice@sourmilk.net> <200706282239.21844.flamingice@sourmilk.net>
In-Reply-To: <200706282239.21844.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6070411.JexX3OdMet";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706282247.26957.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart6070411.JexX3OdMet
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 28 June 2007 22:39, Michael Wu wrote:
> On Thursday 28 June 2007 22:35, Michael Wu wrote:
> > On Thursday 21 June 2007 06:39, Johannes Berg wrote:
> > > +	skb_set_network_header(skb, len + sizeof(struct ieee80211_hdr));
> > > +	skb_set_transport_header(skb, len + sizeof(struct ieee80211_hdr));
> > > +
> >
> > Hm, just noticed a potential problem with this. sizeof(struct
> > ieee80211_hdr) can't be used since ieee80211 headers are variable sized
> > and the smallest frames can end up being smaller than the 4 addr header.
>
> And the other code in subif_xmit does this too.. hrm.
>
Uh, nevermind, the subif_start_xmit code is fine. Read the wrong part..

-Michael Wu

--nextPart6070411.JexX3OdMet
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGhJzuT3Oqt9AH4aERAojWAJ4yPoghRcHJYzZvZORmgZ+s/0m0AwCeMlfI
dHirl203gmVgVHLbcgbtz0E=
=Og/Y
-----END PGP SIGNATURE-----

--nextPart6070411.JexX3OdMet--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
