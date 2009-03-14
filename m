Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41645 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbZCNP77 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 11:59:59 -0400
Subject: Re: [PATCH] iwlagn: default to MAX_UCODE_BEACON_INTERVAL in
	iwl_adjust_beacon_interval
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@nokia.com>
In-Reply-To: <20090225014454.GA3577@tuxdriver.com>
References: <154E55ADF9629D4E8D13F08BF92ABEB629C9D28B8D@PDSMSX501.ccr.corp.intel.com>
	 <20090220145223.GA15006@tuxdriver.com> <1235155966.5860.44.camel@rc-desk>
	 <20090220194306.GA4051@tuxdriver.com> <20090221003013.GA3890@tuxdriver.com>
	 <20090221003133.GB3890@tuxdriver.com>
	 <1235443093.4455.77.camel@johannes.local>
	 <20090225014454.GA3577@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oxxmR+tDC9Uh1BoGabt8"
Date: Sat, 14 Mar 2009 16:59:48 +0100
Message-Id: <1237046388.5235.82.camel@johannes.local> (sfid-20090314_170011_179754_8AED8D0E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oxxmR+tDC9Uh1BoGabt8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

John,

> > I suspect that some memory is getting overwritten or something. The
> > embedded struct thing was a bit of a hack.
> >=20
> > Also please put a printk into the iwlwifi code and into
> > net/mac80211/mlme.c where it assigns
> > 	sdata->vif.bss_conf.beacon_int =3D bss->cbss.beacon_interval;
> >=20
> > so that I can see the order this happening.
>=20
> I have applied the patch attached as "debug.patch".  I booted F10,
> logged-in, and allowed NetworkManager to establish a connection.
> The resulting dmesg output is attached as "dmesg.txt".
>=20
> Hth!  Let me know if you want more...

Sorry for the delay. Reinette made me aware that I'd missed to work on
this! Unfortunately, I don't see anything going wrong.

The problem is in this sequence:

> net/wireless/scan.c 244
> ffff88006ed59de0

here we find the BSS to use

> wlan0: authenticate with AP 00:18:84:80:c6:b1

and authenticate with it

> net/wireless/scan.c 244
> (null)

but now it has expired (I can only guess where this is called from)

> wlan0: authenticated
> wlan0: associate with AP 00:18:84:80:c6:b1

we associate

> net/wireless/scan.c 244
> (null)
> net/wireless/scan.c 244
> (null)

not sure

> wlan0: RX AssocResp from 00:18:84:80:c6:b1 (capab=3D0x421 status=3D0 aid=
=3D1)
> wlan0: associated
> net/wireless/scan.c 244
> (null)

this is this code:

        bss_info_changed |=3D BSS_CHANGED_ASSOC;
        ifmgd->flags |=3D IEEE80211_STA_ASSOCIATED;

        bss =3D ieee80211_rx_bss_get(local, ifmgd->bssid,
                                   conf->channel->center_freq,
                                   ifmgd->ssid, ifmgd->ssid_len);
        if (bss) {
                /* set timing information */

in ieee80211_set_associated

> drivers/net/wireless/iwlwifi/iwl-agn.c 643
> 0

because "bss" is NULL, we don't actually set the timing information, and
thus iwlwifi gets a 0 value here. For some reason now your
wpa_supplicant decides to disassoc, and on the second try it's all fine:


> net/wireless/scan.c 244
> ffff88006ed5b4b0
> wlan0: authenticate with AP 00:18:39:5b:82:ca
> net/wireless/scan.c 244
> ffff88006ed5b4b0
> wlan0: authenticated
> wlan0: associate with AP 00:18:39:5b:82:ca
> net/wireless/scan.c 244
> ffff88006ed5b4b0
> net/wireless/scan.c 244
> ffff88006ed5b4b0
> wlan0: RX AssocResp from 00:18:39:5b:82:ca (capab=3D0x411 status=3D0 aid=
=3D6)
> wlan0: associated
> net/wireless/scan.c 244
> ffff88006ed5b4b0
> net/mac80211/mlme.c 641
> 100
> drivers/net/wireless/iwlwifi/iwl-agn.c 643
> 100

note the extra "mlme.c 641 / 100" lines, these are in the "if (bss)"
part.


Now, thinking a little about why this happens...

Before using cfg80211's BSS structs, we *never* expired any BSS structs.
We just hid them from userspace. This was a bug, we would forever
accumulate BSSes and use loads of memory. However, what happened above
could never happen: that a BSS struct went away while we were trying to
use it!! Oddly, this isn't supposed to happen, since we only expire
structs after 10 seconds and we continually receive beacons this
shouldn't happen.

To make completely sure, can you, in addition to this debug patch, add a
printk into net/wireless/scan.c:cfg80211_bss_expire and print out the
pointer for any expired BSS? I suspect we'd have seen ffff88006ed59de0
there.


In any case, the proper solution here would be to internally keep a
reference in mac80211 to the "current BSS" struct, and hang on to it
(ie. increase the refcount, and never use the lookup function but the
pointer we have gotten)...

Another thing we should do is to not overwrite in cfg80211_bss_update by
replacing the node, but by reallocating the node with the new
information. This needs some per-node locking though, I suspect.

Kalle, I suspect that your beacon offload will require something like
holding on to BSS structs too, is that correct?

johannes

--=-oxxmR+tDC9Uh1BoGabt8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJu9RxAAoJEKVg1VMiehFYY8EP/jlyjyvjP8oSE3QzEYQlQCW5
A2NlIb8tKgmuOcKN4ehBuufLyHK4J5DSJn4RGV625u1cYywiWp500AKs/4RGKiQy
VMSrT6jFkHkMM+KTG+/VTzuE51K3aDlDsik8j9FqSbgaDJFxnkLk0A2vOIfYH5kG
tDbP0aCnBIc8us3EDLGE4rRTx+m6Ck7iZr0MIox3lGLicRMntpkQsy6q7TMJ8c98
pc4rX/am9R0oMesFeN0j3x1Fh6Qdjmtu/CgVVNdTC1d+PlwDDIVI18G4Z5K5y84C
i6FpqCOiJpr3AjjxDUWFHdG1Ii/hDLAqKBREnpGbF5iMRIbXwIm+5obqUVZSq1tz
tA5HbQFr1ujCpfvffo16Cvx1B3HTdI7F2XKovTmFBvrswfSd99qgEnbjigLWi5lK
+1yb7urkNoanivvpcQWv1Tqd13qDxqnF1a04t/nrYeud1OMov77BTixidi1R85Jc
cYZTJ8meT8pQlMzrzOTBGhbj600GZSDSzCifh22LZZow9RR1a32GtQ81Foh99zQN
hLb/fOj88s1e6IaL/xEXRm6opmF54f7TrtTKqEvzVsyBqQNreDj5f3aOJS37PLNq
e96ka3vM7nX97ArikzS82IGGsohjOKOqhODO41xsWalgftNt6PislfN0j4KD96I9
DbqiPKrs4QMJQwwVxYqs
=i857
-----END PGP SIGNATURE-----

--=-oxxmR+tDC9Uh1BoGabt8--

