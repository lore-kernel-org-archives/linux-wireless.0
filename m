Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:63314 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751380AbXFNHTw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2007 03:19:52 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: andy@warmcat.com
Subject: Re: [PATCH Try#12 0/3] Radiotap injection for Monitor Mode
Date: Thu, 14 Jun 2007 00:18:28 -0700
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>,
	Johannes Berg <johannes@sipsolutions.net>
References: <20070613093732.535166329@warmcat.com>
In-Reply-To: <20070613093732.535166329@warmcat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2191711.z4GJzKFsGr";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706140018.41188.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2191711.z4GJzKFsGr
Content-Type: multipart/mixed;
  boundary="Boundary-01=_FvOcG/+8+n86HNh"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_FvOcG/+8+n86HNh
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 13 June 2007 02:37, andy@warmcat.com wrote:
> These patches add the ability to inject packets down a monitor mode
> interface for transmission according to a prepended radiotap header.
>
I've attached a patch to address remaining issues found by git, sparse, and=
=20
checkpatch.pl. With that, ACK.

Thanks,
=2DMichael Wu

--Boundary-01=_FvOcG/+8+n86HNh
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="04-rt-fixes.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="04-rt-fixes.diff"

mac80211: radiotap injection code sparse/style fixes

=46rom: Michael Wu <flamingice@sourmilk.net>

This fixes the remaining issues in the radiotap code found by git, sparse,
and checkpatch.pl. (and one last space between * and variable name found
by myself.)

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 Documentation/networking/radiotap-headers.txt |    2 +-
 net/mac80211/ieee80211.c                      |   12 +++++++-----
 net/wireless/radiotap.c                       |    6 ++----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/Documentation/networking/radiotap-headers.txt b/Documentation/=
networking/radiotap-headers.txt
index 5148075..bd846de 100644
=2D-- a/Documentation/networking/radiotap-headers.txt
+++ b/Documentation/networking/radiotap-headers.txt
@@ -95,7 +95,7 @@ int MyFunction(u8 * buf, int buflen)
=20
 	while (!ret) {
=20
=2D	 	ret =3D ieee80211_radiotap_iterator_next(&iterator);
+		ret =3D ieee80211_radiotap_iterator_next(&iterator);
=20
 		if (ret)
 			continue;
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 5f2bf3e..023aa18 100644
=2D-- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -1164,7 +1164,7 @@ __ieee80211_parse_tx_radiotap(
 	while (!ret) {
 		int i, target_rate;
=20
=2D	 	ret =3D ieee80211_radiotap_iterator_next(&iterator);
+		ret =3D ieee80211_radiotap_iterator_next(&iterator);
=20
 		if (ret)
 			continue;
@@ -1694,8 +1694,9 @@ static int ieee80211_subif_start_xmit(struct sk_buff =
*skb,
 	}
=20
 	if (unlikely(sdata->type =3D=3D IEEE80211_IF_TYPE_MNTR)) {
=2D		struct ieee80211_radiotap_header * prthdr =3D
+		struct ieee80211_radiotap_header *prthdr =3D
 			(struct ieee80211_radiotap_header *)skb->data;
+		u16 len;
=20
 		/*
 		 * there must be a radiotap header at the
@@ -1723,9 +1724,10 @@ static int ieee80211_subif_start_xmit(struct sk_buff=
 *skb,
 		 * a precooked IEEE80211 header so no need for
 		 * normal processing
 		 */
=2D		skb_set_mac_header(skb, prthdr->it_len);
=2D		skb_set_network_header(skb, prthdr->it_len + sizeof(hdr));
=2D		skb_set_transport_header(skb, prthdr->it_len + sizeof(hdr));
+		len =3D le16_to_cpu(prthdr->it_len);
+		skb_set_mac_header(skb, len);
+		skb_set_network_header(skb, len + sizeof(hdr));
+		skb_set_transport_header(skb, len + sizeof(hdr));
=20
 		/*
 		 * pass the radiotap header up to
diff --git a/net/wireless/radiotap.c b/net/wireless/radiotap.c
index 1b4a7be..091f234 100644
=2D-- a/net/wireless/radiotap.c
+++ b/net/wireless/radiotap.c
@@ -60,12 +60,12 @@ int ieee80211_radiotap_iterator_init(
 	iterator->arg_index =3D 0;
 	iterator->bitmap_shifter =3D le32_to_cpu(radiotap_header->it_present);
 	iterator->arg =3D (u8 *)radiotap_header + sizeof(*radiotap_header);
=2D	iterator->this_arg =3D 0;
+	iterator->this_arg =3D NULL;
=20
 	/* find payload start allowing for extended bitmap(s) */
=20
 	if (unlikely(iterator->bitmap_shifter & (1<<IEEE80211_RADIOTAP_EXT))) {
=2D		while (le32_to_cpu(*(u32 *)iterator->arg) &
+		while (le32_to_cpu(*(__le32 *)iterator->arg) &
 				   (1<<IEEE80211_RADIOTAP_EXT)) {
 			iterator->arg +=3D sizeof(u32);
=20
@@ -93,7 +93,6 @@ int ieee80211_radiotap_iterator_init(
=20
 	return 0;
 }
=2D
 EXPORT_SYMBOL(ieee80211_radiotap_iterator_init);
=20
=20
@@ -239,5 +238,4 @@ int ieee80211_radiotap_iterator_next(
 	/* we don't know how to handle any more args, we're done */
 	return -ENOENT;
 }
=2D
 EXPORT_SYMBOL(ieee80211_radiotap_iterator_next);

--Boundary-01=_FvOcG/+8+n86HNh--

--nextPart2191711.z4GJzKFsGr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGcOvRT3Oqt9AH4aERAul5AJ42GpA9cUFjQnIMEwnYiAo/D+ehegCfc9qG
fWsidmka4PsergUb26n5Olg=
=gKNR
-----END PGP SIGNATURE-----

--nextPart2191711.z4GJzKFsGr--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
