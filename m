Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40897 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbXFKIZD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 04:25:03 -0400
Subject: Re: [PATCH 2/3] mac80211: IEEE802.11e/WMM TS management and DLS  support
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <1181535089.3042.72.camel@debian.sh.intel.com>
References: <20070606082223.GA28658@mail.intel.com>
	 <1181157532.3398.20.camel@johannes.berg>
	 <1181535089.3042.72.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SWbRmdQuh5tq55ifLLbt"
Date: Mon, 11 Jun 2007 10:25:29 +0200
Message-Id: <1181550329.3566.43.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SWbRmdQuh5tq55ifLLbt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-06-11 at 12:11 +0800, Zhu Yi wrote:

> > > +					case WIFI_OUI_STYPE_WMM_TSPEC:
> > > +						if (elen !=3D 61) {
> > > +							printk(KERN_ERR "Wrong "
> > > +							       "TSPEC size.\n");
> > > +							break;
> >=20
> > That printk should be rate limited.
>=20
> Umm, I followed the same way as other MLME parsing functions ie.
> ieee80211_rx_mgmt_assoc_resp. It seems they also didn't rate limit these
> cases. This only happens on broken APs. Do you think we really need to
> rate limit here?

Ok, wrt. all the rate limiting I thought of. You rightfully pointed out
that the current code is just as broken, hence I'm ok with adding these
like this and I'll go through and fix them later. My rationale with many
of these is that somebody could inject random packets appearing to come
from our AP and cause us to write a log line for every packet they
inject by intentionally injecting malformed packets. We should protect
against that.

> I got a lot of this message during my testing. The APs use some
> (private) OUIs we don't support now. I guess there will be quite a lot
> messages even if we rate limit here.

Oh right, like those Broadcom IEs they use for a-mpdu even on .11G...

> Yes we can do this. But free it here helps to shrink the hash table
> size. The problem is: the original sta_info doesn't a status -- if a
> sta_info appears in the hash table, it is active; otherwise it is not.
> But since DLS requires setup stage, I added the status code to
> distinguish setuping and active. But for inactive state, we can either
> set the DLS status to inactive or remove the sta_info completely. Since
> normally a DLS connection won't be setup and teardown that often, I
> select to free the sta_info to indicate it as inactive.

Makes sense. I thought we had a sta info item for each peer we ever
discovered but I guess that isn't true.

johannes

--=-SWbRmdQuh5tq55ifLLbt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGbQb5/ETPhpq3jKURAueZAJ4pywzeNFusZ3JGLpNfmCRfnQMYPQCgrvnf
cAl7aPllaLKcYPNRhaJgo88=
=b+6z
-----END PGP SIGNATURE-----

--=-SWbRmdQuh5tq55ifLLbt--

