Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41961 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbYCELPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 06:15:08 -0500
Subject: Re: [PATCH 05/11] mac80211: adding mac80211_tx_control_flags andHT
	flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <rindjon@googlemail.com>
Cc: "Winkler, Tomas" <tomas.winkler@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <c85cb4470803050301p63b3568epe989ef042f9b11f5@mail.gmail.com> (sfid-20080305_110114_218069_3C27E392)
References: <1204682972-26004-1-git-send-email-reinette.chatre@intel.com>
	 <1204682972-26004-3-git-send-email-reinette.chatre@intel.com>
	 <1204682972-26004-4-git-send-email-reinette.chatre@intel.com>
	 <1204682972-26004-5-git-send-email-reinette.chatre@intel.com>
	 <1204682972-26004-6-git-send-email-reinette.chatre@intel.com>
	 <1204710116.25502.48.camel@johannes.berg>
	 <c85cb4470803050200w6d981525w11688f0921867d5a@mail.gmail.com>
	 <1204711417.25502.59.camel@johannes.berg>
	 <C07C4589BE74A34981C3C3525EE1F8010378F341@hasmsx412.ger.corp.intel.com>
	 <1204713755.25502.62.camel@johannes.berg>
	 <c85cb4470803050301p63b3568epe989ef042f9b11f5@mail.gmail.com>
	 (sfid-20080305_110114_218069_3C27E392)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NJqFCKZATLz0bZM+z/QM"
Date: Wed, 05 Mar 2008 12:14:45 +0100
Message-Id: <1204715685.25502.66.camel@johannes.berg> (sfid-20080305_111513_933592_969725FB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NJqFCKZATLz0bZM+z/QM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Wed, 2008-03-05 at 13:01 +0200, Ron Rindjunsky wrote:
> > > >What, for example, is OFDM_HT? What happens when you select a bitrat=
e
> > > >of, say, 11MBit and have the 40_MHZ_WIDTH flag set?
> > >
> > > HT doesn't work on CCK modulations, so this flag just basically says
> > > it's HT rate and not legacy rate.
> >
> > Ok, so what does it mean to set the flag along with a 54MBit rate?
> >
> > It seems to me that these flags aren't entirely orthogonal to the
> > bitrates?
>=20
> no, they are all orthogonal to each other. the example you gave will
> give us 108MBit. all flags can be used, as long they match the spec,
> and that's the algorithm responsibility to check and determine.
> I guess that the flag that is more confusing is OFDM_HT. since 11n
> supports (theoretically...) n streams of data, using flags like SISO /
> MIMO / MIMO_3_ANT / MIMO_... seemed the wrong way. in stead, once you
> know OFDM_HT is up, a check to antenna_sel_tx will determine the Tx
> expected method.

Ahh! Ok, thanks for the explanation. Is antenna_sel_tx really the right
thing though? Tomas mentioned that you can have three antennas and only
two chains so should that rather be a chain selection?

> It may be good to add this to the file's documentation.

Indeed. Or to a DOC: section somewhere so it can be added to an 11n
chapter of the mac80211 book (since the patch is merged I'm
automatically generating it nightly at
http://linuxwireless.org/mac80211book/)

johannes

--=-NJqFCKZATLz0bZM+z/QM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR86ApKVg1VMiehFYAQJ5wg//b4RAwXHkjHop9VSKHsVxVckEKJVXwF0R
mKSYBWhuwNfrVJAntvZ1jcfY6DXWaZtNYIONeuQZAEu0IxW9SkJP3GdniS87J83H
wS7mAMipSR0qqNUV2/gA8aqZFU4w6ELnIfR9c707PVXHiKBDYNMY+LHxiIM8RukL
MkzBwHwAaNGW6blNFup9C5iayusGbEsQq84ECefmH3TQ1v443sE7f5JuASlopm6y
Kdoc4HVIFjW8rb0eJPRbVQg294hFpmayZ2pIP+qOdG2pxdW+4gcyfQBeMQksOI4T
S+I4WLpigPQlQmB1VMGZFN2e/VyW9tU1qiwbRhAr0fjZ/Aw1hsCoLZBr2pYeHHJG
PkoajQJxyYmUrVA9I6Ned1ZT8qRBH6O8SkEyFDhpJwDfZ5AtF9wr3kIhsUDTzqFc
V2pbN0mrAVnBWUu2AcgynS0Z4B0QQaFuJ/wTJNYJ+ljgixxpZoGkdlUTROIwxuu1
XXFts+RFzzF7NRbSXMe4zGxRonggIums1peMScZLBfxDO58t9B6L61p+QYi2Juf4
f+jbMnTwSN0D8/qC6O3UZxmn5vyPsiVHItCV5eZEbN+LVW5VawC5V451PCFK3t1w
uXtxcaMrtM7j27ZD3YnlCeuyDsxXIgGoqznfKXG/Mp5pZoWj8fDMRr68jKY/vYMZ
yqFypbr8kVU=
=6hX1
-----END PGP SIGNATURE-----

--=-NJqFCKZATLz0bZM+z/QM--

