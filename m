Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48462 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbXJXIhe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2007 04:37:34 -0400
Subject: Re: [ipw3945-devel] iwl3945/mac80211 cannot connect to dynamic wep
	network
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Zhu Yi <yi.zhu@intel.com>, dragoran <drago01@gmail.com>,
	linux-wireless@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>, Jean Tourrilhes <jt@hpl.hp.com>
In-Reply-To: <1193148453.8648.20.camel@localhost.localdomain> (sfid-20071023_150810_118446_E87EE8F5)
References: <f6ca9fed0710230054i2b2849bfpc79c6090627b8625@mail.gmail.com>
	 <1193127280.3069.261.camel@debian.sh.intel.com>
	 <1193148453.8648.20.camel@localhost.localdomain>
	 (sfid-20071023_150810_118446_E87EE8F5)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FeNzNM67JP+WLXtBR7KX"
Date: Tue, 23 Oct 2007 19:37:14 +0200
Message-Id: <1193161034.7733.38.camel@johannes.berg> (sfid-20071024_093751_640850_B7123F51)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FeNzNM67JP+WLXtBR7KX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-10-23 at 10:07 -0400, Dan Williams wrote:

> Was there ever a conclusion to this patch?  ISTR it went through a
> couple comments and was more or less rejected as the wrong approach.
> Can anyone comment as to what the _right_ approach is?  Not being able
> to connect to dynamic WEP networks is not acceptable, what needs to be
> done to make this work?

My take on it is that it's a wpa_supplicant/wext bug.

See, the log says:
eth1: privacy configuration mismatch and mixed-cell disabled - disassociate

So that means ieee80211_privacy_mismatch() returned non-zero. However,
ieee80211_privacy_mismatch() will return 0 instantly when key management
is enabled, which is obviously true with dynamic WEP.

Hence, IMHO wpa_supplicant should be telling us that it enabled key
management. But the wext interface is crappy enough to not have a
definition for dynamic WEP which probably means that in the
wpa_driver_wext_keymgmt2wext() function in wpa_supplicant's
driver_wext.c 0 is returned, while we take anything but zero to be "key
management is enabled".

The proper fix would be to
 (a) remove the crap about IW_AUTH_KEY_MGMT values from wext,
     no drivers except mac80211 care and that cares only about
     enabled/disabled
 (b) make the parameter to IW_AUTH_KEY_MGMT a boolean
     (no code changes required, only comment updates, since no driver
     cares one bit except mac80211 which treats it as a bool already)
 (c) update wpa_supplicant's wpa_driver_wext_keymgmt2wext function to
     return 0 for KEY_MGMT_NONE and 1 for everything else

I'm not going to do it though. Dynamic WEP is just too uninteresting to
me.

johannes

--=-FeNzNM67JP+WLXtBR7KX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARx4xSaVg1VMiehFYAQL5LA//W1WzabpPcfruTLUJnK2PKWnnmip5ygbm
hEmYej6GDa/dWQgOMuGabC5Aq4HD6Tp64MGpnswRZaoWxO0Cgl5RPE+ttNPXMiJz
7lj/Bi2FcJ7duxmEw1GcSbQWlUpCvpWxfODlLNOie3YtrEeIl9ArCEmVFxMynUpZ
XORBEg7HdVSCP5tQ7Abb96u5DZH//MTGsbFFdAYaPDQQ0UPktpdn9S0qASmoYycf
JzN5BNbWl8WCxK6TQu124BfP+3wEOlKrJ6BV3HXz5qKmAI7XsbcsGdQBOogRHMPh
aNVf8aR3ukDzi7zWVJZIF+JDhfPO2eTOxf96edNmdQjOiS6AAnvgXY4QG81YYnHy
9EGYBLcTG4t59QPHIJjqJBAi+49MI2bvhtdDzXN5b00s1df9bqXUlvNU+acn7yRA
d0Ki8Mo/vkGBHi2sT14++vJMpsb94ztzdf/iE+PhF7HOoAxEwaCDcTjDUHfVB/uE
6gpb6w2rb5oF1FTXEMwx2biB941uDC0nb1p4mpj1Y8fT0uh2egL1HGytB+7Irh8U
PWnHDFu2Up2RH90LXXKInizp6J9aUUdU7F95ch+d1Px7HqYRNQS44cOWBuKEcdbK
Ij2/BMo+9+4oYZW06uCVZOFw/qT+3tUbQLfyYgJNAzFRNJ7xfeGvHFKZdq9B8xEs
Ww0JXJcclqI=
=75WC
-----END PGP SIGNATURE-----

--=-FeNzNM67JP+WLXtBR7KX--

