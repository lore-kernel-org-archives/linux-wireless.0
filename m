Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57434 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757915AbZGJW4Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 18:56:24 -0400
Subject: Re: ieee80211_tx_status() on injected packets
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1247265159.6399.31.camel@mj>
References: <1247265159.6399.31.camel@mj>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8x/2tYW/ZPZ7gyof4Dos"
Date: Sat, 11 Jul 2009 00:56:19 +0200
Message-Id: <1247266579.30647.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8x/2tYW/ZPZ7gyof4Dos
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-10 at 18:32 -0400, Pavel Roskin wrote:

> /* Original radiotap header, but the length should be 0e, not 18 */
> 00 00 18 00 03 00 00 00 00 02 6c 09 a0 00

Heh.

> /* mac80211 treats this as part of the radiotap header */
> 08 03 00 00 01 0c cc 00 00 00
> /* frame control */
> 00 11
> /* duration */
> 6b 39
> /* addr1 */
> 40 19 11 04 28 00
> /* addr2 */
> 00 00 10 00 00 00
> /* addr3 - incomplete */
> 00 00 00 00
> /* sequence control - beyond the skb end */
>=20
> I'm using rt73usb to inject.  ieee80211_tx_status() is scheduled by
> ieee80211_tx_status_irqsafe(), which is called in rt2x00dev.c.
>=20
> If we allow to inject malformed packets, we shouldn't assume them to be
> valid 802.11 packets unless we can verify it.  And even then, maybe it's
> better to bypass ieee80211_tx_status() for injected packets, as it can
> influence statistics and rate control algorithms in unpredictable ways.

Yeah, we should verify the length. I don't think we can skip the
processing since these packets might actually be sent by hostapd which
wants the processing -- if you fuck up your connection by injecting
random junk that seems to be your own fault, but I agree we should fix
the bug.

It would probably be useful to take the code in ieee80211_tx_status up
to (but not including) the skb_orphan() call, stick it into a separate
function and call it only when at least the frame the header is valid
(i.e. skb->len >=3D hdrlen).

johannes

--=-8x/2tYW/ZPZ7gyof4Dos
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKV8cNAAoJEODzc/N7+QmaWaUQANIYRjiuyYBYD45MKYRjKtP6
xT0aLgziCAek9ZAL5ETYJFgyBWfTeCnD43UwUq9iF/ws7VfZI1Qp/ayuPQ43P8sn
RdsdkMh0d5Jv6U8zm5WO+TwX+eqPKbtE05o/1/3PBaurZxwTTpxUscxil9LJok2p
kGISFFHKjpG/dLeWea6ufjkOVATBhBlL9YAZDbKaYr4tk4PW3fWsBPuPKNCjgCVf
GnH6I6psiNfuvOzN10vHda9KJu2EHfd8969R4EDIEahqxIQCRuILJkWkKfbT85GW
Qk5jexguPeqRKobLKNv49JnllsnVVv8vigbAYPGrQ9VEyoU+rZjv4JhEG+roeVZg
5e1OVNiXjTTpOJmvsRpIlSCod6lsknHsBMibsXw9CWXaHN/KFAA1oC+5EM5HIJce
+icNi9JbPmsEQXSV19LT6muog13zRKTcUUs0YRR5G/AUvbCc/It9XiMIqlAAumc+
063DkBJ+fUHZzGvIgfs5i3Jsw4OV7I1oBBPcb/rVvhASYONwleSUURLU11QqeNlE
s9sJ/bow2nYP0LwlR2qYuR2E6cvHztC0MC4MNKEpB2QDldQ2+pAh+Z4KJxJcKO/D
QbV34Fj0egC8p7tBgpVbaHO2fz1tYr0LXccESawWOR22V4o6X5H05AzqCrlmNXVt
GbsGfo9RqUD/LKuq62YJ
=PEht
-----END PGP SIGNATURE-----

--=-8x/2tYW/ZPZ7gyof4Dos--

