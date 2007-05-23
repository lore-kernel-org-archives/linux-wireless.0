Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:23931 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758332AbXEWBHm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2007 21:07:42 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: James Ketrenos <jketreno@linux.intel.com>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers
Date: Tue, 22 May 2007 18:06:02 -0700
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <464B7B7C.5080800@linux.intel.com> <200705162151.32910.flamingice@sourmilk.net> <46534172.5040106@linux.intel.com>
In-Reply-To: <46534172.5040106@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1840989.tycNgW2dOK";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705221806.07696.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1840989.tycNgW2dOK
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 22 May 2007 12:16, James Ketrenos wrote:
> > - Read and set the MAC address before calling ieee80211_register_hw.
>
> We're calling SET_IEEE80211_PERM_ADDR before we call ieee80211_register_h=
w.
>  Is there something else we should be doing?
>
Well, after jumping through a few hoops to find ieee80211_register_hw, it=20
appears you're right.

However, I don't like it. Bringing the hardware up should be deferred as mu=
ch=20
as possible to when the user actually brings the interface up. ipw2200 can=
=20
defer firmware loading to interface open time while still reading the mac=20
address from the eeprom.. why not ipw3945? (the ipw2200 driver doesn't=20
actually do this, but it should. I know it can.)

Also, the code doesn't appear to support changing the mac address at all. T=
he=20
mac address given by conf->mac_addr should be the address that your driver=
=20
uses.

> That said -- if the driver can execute in parallel to the stack for some
> operations, shouldn't they remain on their own workqueues so the work can
> be divided up vs. having *everything* routed through one singlethread
> workqueue?
>
Your choice. mac80211 needs a workqueue regardless so it's made available t=
o=20
drivers. Many callbacks are called on this workqueue so drivers don't need =
to=20
defer work to their own workqueue (and can actually return error values).

> > - Why are probe requests being dropped in adhoc mode? (assuming hardware
> > handles it.. but the message output for that doesn't sound like it)
>
> It only drops them if the adapter is not in the associated state (the card
> is configured with the RXON_FLAG_ASSOC_MSK bit clear)
>
I think this decision making belongs in mac80211.

=2DMichael Wu

--nextPart1840989.tycNgW2dOK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGU5N/T3Oqt9AH4aERAlVLAJ49jLe9Fzden8hNfnOHRBglz91LuACgtRoN
6s7775DVc6UXPZdvYagm4Oo=
=3HUP
-----END PGP SIGNATURE-----

--nextPart1840989.tycNgW2dOK--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
