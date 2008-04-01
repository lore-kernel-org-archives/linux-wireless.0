Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40263 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbYDANQW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 09:16:22 -0400
Subject: Re: mac80211 MLME scanning - BSS list trouble
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	Javier Cardona <javier@cozybit.com>, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	Bill Moss <bmoss@CLEMSON.EDU>, Daniel Drake <dsd@gentoo.org>,
	Dan Williams <dcbw@redhat.com>, Vladimir Koutny <vlado@ksp.sk>,
	Tomas Winkler <tomasw@gmail.com>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <20080331150423.GQ14333@jm.kir.nu>
References: <1206865999.22530.187.camel@johannes.berg>
	 <20080331150423.GQ14333@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OhD5NG6e8GgWdvrJ0YYF"
Date: Tue, 01 Apr 2008 15:16:13 +0200
Message-Id: <1207055773.5143.91.camel@johannes.berg> (sfid-20080401_141631_388040_031C4C34)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OhD5NG6e8GgWdvrJ0YYF
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


On Mon, 2008-03-31 at 18:04 +0300, Jouni Malinen wrote:
> On Sun, Mar 30, 2008 at 10:33:19AM +0200, Johannes Berg wrote:
>=20
> > After having two bug reports about the BSS list/probe_resp variable in
> > mac80211 and a very detailed analysis of the problem from Bill Moss, I
> > think I've understood the problem now but I'm not sure how to proceed
> > because I do not understand the reason for "Do not allow beacons to
> > override data from probe responses".
>=20
> The main (and only) reason for this is support for multi-SSID
> configurations (hidden SSID and/or multiple SSIDs with the same BSSID,
> but with different security parameters). Only the Probe Response frames
> are guaranteed to include correct information for <BSSID,SSID> pair in
> these cases and because of that, Beacon frames are not allowed to update
> things like SSID or WPA/RSN IE.

Right. But in that case, a beacon frame we receive will update the
<BSSID,""> BSS structure, not the <BSSID,actual SSID> structure because
the update code will find only the former since the SSID is hidden.
TheBSS structure w/o SSID won't actually be used.

> One example of information that should not be overridden by Beacon
> frames is WPA and RSN IE since these could differ based on the SSID in
> multi-SSID configurations. An example of information that must be
> updated from every Beacon frame would be ERP IE. Finally, there are also
> more complex cases, like the Capability Information, which should
> probably be handled separately for each subfield (e.g., Privacy could be
> per-SSID and Short Slot Time for every SSID of the BSSID).

Right. But wouldn't that be covered by operating on different BSS
structs?

> > The only thing I'm not sure about is whether that will introduce
> > regressions because probe responses can contain better information than
> > beacons. The only reason I can find for this would be an AP that has
> > multiple SSIDs with different security settings on each and announces
> > those only in the probe responses (and otherwise uses a hidden SSID),
> > but we only handle that now, much later than the code there that was
> > already present.
>=20
> I'm not sure whether the current code is correct for all information
> from Beacon/ProbeResp (i.e., some parts might need to be moved to be
> before/after this check), but changes to WPA/RSN IE are after this
> return-on-Beacon for a reason and removing that check would break some
> multi-SSID networks.

Ok, I think the HT for example should be moved in front.

> > However, that actually seems to have another bug, if you have such an A=
P
> > will you find two BSSes, one with a hidden and one with a visible SSID?
>=20
> That is by design.

Right, ok.

> I think that we will need to evaluate whether the current implementation
> is updating all pieces of information in correct place and still
> maintain possibility of not using Beacon frames to update some fields.

=EF=BB=BFRight. Show of hands who wants to do this? :) Bill sent me a patch
privately, I've asked him to post it here on the list for comments. I
really don't have time right now to investigate all this.

> There might be cases where the old information from ProbeResp should
> expire (though, if we are still associated with that BSSID,SSID pair, we
> should use Probe Request to update this information instead of just
> blindly throughing it away).

Yeah, sure.

> Any information that has to be same for all SSIDs in multi-SSID (single
> BSSID) configuration can be updated based on Beacon frames since the
> SSIDs for a specific SSID would not contain any different information
> for these parts. However, fields that can be configured per-SSID, must
> be handled separately in order to be able to support multi-SSID
> configuration with different security policies per SSID. This would
> mainly included Privacy flag in the capability field and security
> related IEs (WPA IE, RSN IE), but there may be something else that would
> benefit of similar handling.

It might help if there was code in hostapd to actually do run this
scenario. *hint* *hint* :)

johannes

--=-OhD5NG6e8GgWdvrJ0YYF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/I1nKVg1VMiehFYAQLvDxAAhVk9i2UOW4JGTr2ewFS+fNkJkjBLSs4M
/w5CRc6PQFH/KoU9cRYbc8tRb3MbKCpc6x/YOfDd0uLUiTl3yK6qnDz+gzxwrLcF
+mmYyUMr0sqwveZjRo0B21I2CVtImH/DMoV5UhXalAJk31CBsmGVPJlIiFOm3Kn4
hhWMllzTfkpax7FnNR7YYveU/pOQWThpjf/UmuUjy8Ji2CE0YBmzvY1mjoJ+x1xD
ayuen9E+qYEUA6/g0IfX/BdIemREdywETByZjxm6xob5EQHpvkgSoA/0KWr9ZaBj
lGtmLHiPg3cNj0pwxU0z10rmJ1VFIPrKG0+VuIojcyfGS/Ix/4SugaJOvxrnrLDN
duneT28yDaEad98GgSDsB4oCLwjtI26KdemGnBVgCaTkOT2m2WtjzeCeHdkPj3K7
1JFiGLKi3Uz+6NVpB/sm9JfrCg30quRgvcAe4UuIDyRpXTwk7rCNziu/ngo+MK/g
LlypUjJNsBYCpJl18PgDH+zBk4Va3ujjQUHXp4JxHZXN3uqyaHsIQT8p8AUyz6Cy
KlAyq1F5NOURFk5nTUlNEltClP+jd8AqTMB9oF9GZoqE1zJH9o5Oudm92/pm0gFE
b3Uikk8bGKCE8z2KGVtXNOTJHE0893mcZcRazOB0xLY90qoRWNtXtjgKMiBWkumD
7miW9Fm6rOU=
=jRK0
-----END PGP SIGNATURE-----

--=-OhD5NG6e8GgWdvrJ0YYF--

