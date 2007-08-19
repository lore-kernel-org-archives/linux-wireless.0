Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from betty.cbit.net.au ([202.55.154.10]:37808 "EHLO mail.cbit.net.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754054AbXHSCp5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Aug 2007 22:45:57 -0400
Date: Sun, 19 Aug 2007 12:45:52 +1000
From: Paul TBBle Hampson <Paul.Hampson@Pobox.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org, jbenc@suse.cz,
	Michael Buesch <mb@bu3sch.de>, Daniel Drake <dsd@gentoo.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Bcm43xx-dev@lists.berlios.de,
	Larry Finger <larry.finger@lwfinger.net>
Subject: Re: mac80211 IPv6 problems
Message-ID: <20070819024552.GA10836@keitarou>
References: <46b1fde0.b+weBDN75J0SPe2a%Larry.Finger@lwfinger.net> <1186094778.6701.6.camel@shinybook.infradead.org> <20070803005517.GA4261@tuxdriver.com> <200708030102.17358.flamingice@sourmilk.net> <20070806170500.GE6442@tuxdriver.com> <1187311977.23489.93.camel@johannes.berg> <20070817134941.GB6090@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
In-Reply-To: <20070817134941.GB6090@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 17, 2007 at 09:49:41AM -0400, John W. Linville wrote:
> On Fri, Aug 17, 2007 at 02:52:56AM +0200, Johannes Berg wrote:
>> On Mon, 2007-08-06 at 13:05 -0400, John W. Linville wrote:
>>=20
> >> --- a/net/mac80211/ieee80211.c
> >> +++ b/net/mac80211/ieee80211.c
> >> @@ -3030,9 +3030,10 @@ ieee80211_rx_h_data(struct ieee80211_txrx_data =
*rx)
> >>  		memcpy(dst, hdr->addr1, ETH_ALEN);
> >>  		memcpy(src, hdr->addr3, ETH_ALEN);
> >> =20
> >> -		if (sdata->type !=3D IEEE80211_IF_TYPE_STA) {
> >> +		if (sdata->type !=3D IEEE80211_IF_TYPE_STA ||
> >> +		    (is_multicast_ether_addr(dst) &&
> >> +		     !compare_ether_addr(src, dev->dev_addr)))
> >>  			return TXRX_DROP;

>> I can confirm that this works (applies if you s/ieee80211.c/rx.c/) for
>> IPv6 link local addresses, and it's definitely the right thing to do
>> here.

> Yes, seems so.  FWIW, this patch is in later Fedora kernels.

> Unfortunately (due to the ieee80211.c -> rx.c issue you mentioned)
> applying this to 2.6.23 conflicts with patches already queued for
> 2.6.24.  Since my experiments show that git doesn't help much in this
> instance, I'll need to work something out with Dave M. if we are to
> get this into 2.6.23.

> If nothing else, I suppose we can just wait for 2.6.23 and send this
> patch to -stable.  Would that burn anyone's biscuits?

Suits me. The only machine this is currently relevant to is tracking
wireless-dev#evertything for the moment.

--=20
-----------------------------------------------------------
Paul "TBBle" Hampson, B.Sc, LPI, MCSE
Very-later-year Asian Studies student, ANU
The Boss, Bubblesworth Pty Ltd (ABN: 51 095 284 361)
Paul.Hampson@Pobox.com

Of course Pacman didn't influence us as kids. If it did,
we'd be running around in darkened rooms, popping pills and
listening to repetitive music.
 -- Kristian Wilson, Nintendo, Inc, 1989

License: http://creativecommons.org/licenses/by/2.1/au/
-----------------------------------------------------------

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGx67gexDuohKLFuARAoooAJ9TZKgeyj2JrL/B8gfg+6UCuYayoQCgsDpP
dxOGtAPa4i4EospPC64v3Y4=
=HMz9
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
