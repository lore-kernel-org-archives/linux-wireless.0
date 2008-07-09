Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43546 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083AbYGIWMM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 18:12:12 -0400
Subject: iwlwifi workaround for mac80211 sequence number bug
From: Johannes Berg <johannes@sipsolutions.net>
To: tomasw <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ron Rindjunksi <ron.rindjunski@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-S666sQoqzc26HC/IHhxH"
Date: Thu, 10 Jul 2008 00:11:25 +0200
Message-Id: <1215641485.3246.72.camel@johannes.berg> (sfid-20080710_001234_329965_EFB06AD3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-S666sQoqzc26HC/IHhxH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Ok, so I'm frustrated. I spent a few hours today chasing docs, trying to
understand sequence numbering from the specs, how we implement it in
mac80211 for TX and RX, how hardware/firmware implements it. Finally, I
figure out that mac80211 is buggy, and come up with a buggy (now I know)
patch.

Then, now, I find out that iwlwifi contains a workaround for the
mac80211 sequence numbering, so you've known all along!

Why don't you tell anyone about the problems you find? It can't be that
hard. Are there any other lurking issues like that?

Here's the code from iwlwifi:

        if (ieee80211_is_data_qos(fc)) {
                qc =3D ieee80211_get_qos_ctl(hdr);
                tid =3D qc[0] & 0xf;
                seq_number =3D priv->stations[sta_id].tid[tid].seq_number &
                                IEEE80211_SCTL_SEQ;
                hdr->seq_ctrl =3D cpu_to_le16(seq_number) |
                        (hdr->seq_ctrl &
                                __constant_cpu_to_le16(IEEE80211_SCTL_FRAG)=
);
                seq_number +=3D 0x10;
                /* aggregation is on for this <sta,tid> */
                if (info->flags & IEEE80211_TX_CTL_AMPDU)
                        txq_id =3D priv->stations[sta_id].tid[tid].agg.txq_=
id;
                priv->stations[sta_id].tid[tid].tfds_in_queue++;
        }

We can implement that trivially in mac80211 and make it do the right
thing for all drivers instead of having iwlwifi work around the bug in
mac80211.

Additionally, we can then remove the ssn argument to the ampdu_action
callback.

johannes

--=-S666sQoqzc26HC/IHhxH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIdTeDAAoJEKVg1VMiehFY5BYQAImprwVdBE+TPZJLSiQxkYEs
83TjyDRSx43E/qTeENRXeMgYZnadKFGs88Yfm7O9Tq/ciZaEdW2j8vmKQFZCyI3v
JB6rGhMfC054DpOxCX1nxNonzxhJ4deJyD9MxNCx0euOrHwQnmn9GYtS0NtPDXal
UyL0+4/XJsTkn5ZbJbTgNUjNFb1zqGDsiNv8lr/BTKZRh7Ckhl+Kp0S/ctEHEkaw
5eYKrzPQbFoLs9hegNcqY5yVwGMfW9GCDp7rLfQyY18FRbmV4hawdtAlmbqPPzJd
/Df5K9MrzUBTrlIcHEK0qnj0Q5ea+Www4T87L+f3O7FzTniUZZxOBdqTc5khxL4/
hBD5N8pli9J+T8onFEMmyvhAsxOgsFGCfJlYxCFWiql6JiZVgSrKoXO7+Q1Ww4IV
4WySHBgo5BN0w4htF4C+6WM9K6GTQ8jrn1bdaTXJtQgC86Gn/t4Y3yDBrw/2qb8T
4c0laU/2KblGBiUCcdO8lT/yujg4uuNTuMFMaxsNpt4B0je5f6vTy7k5vazfjIzA
dKmjFbgHSotju2rYBh1Ru8Uw7hCcmkyQd8S3o7GwtGsFjMAyfuFeWyxkSAukpdQK
9i2OERcdWjpX54j8x4tMmCa/YSDCKrwn96j73ezaXzxTwNYxx0NsoWxKb9xGsNgT
z6c9VUaogH2etv4L2dFX
=agyu
-----END PGP SIGNATURE-----

--=-S666sQoqzc26HC/IHhxH--

