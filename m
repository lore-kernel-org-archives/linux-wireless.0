Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:59245 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753518AbcLVTxT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Dec 2016 14:53:19 -0500
Subject: Re: Question: Packet drop criterion
To: Ferran Quer i Guerrero <ferran.quer@i2cat.net>,
        linux-wireless@vger.kernel.org
References: <f4e6b348-fafb-1546-57cd-4623299b0abb@i2cat.net>
From: Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <4af7f019-7212-f52b-0ecb-cc385b841bd5@rempel-privat.de> (sfid-20161222_205322_642744_A17C8091)
Date: Thu, 22 Dec 2016 20:52:51 +0100
MIME-Version: 1.0
In-Reply-To: <f4e6b348-fafb-1546-57cd-4623299b0abb@i2cat.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SdImdrlSmXo5KIGejBwT2mgRKM22GSmTG"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SdImdrlSmXo5KIGejBwT2mgRKM22GSmTG
Content-Type: multipart/mixed; boundary="LMTCnHF69LohIbi9he4RaXkNjeWLAVEae";
 protected-headers="v1"
From: Oleksij Rempel <linux@rempel-privat.de>
To: Ferran Quer i Guerrero <ferran.quer@i2cat.net>,
 linux-wireless@vger.kernel.org
Message-ID: <4af7f019-7212-f52b-0ecb-cc385b841bd5@rempel-privat.de>
Subject: Re: Question: Packet drop criterion
References: <f4e6b348-fafb-1546-57cd-4623299b0abb@i2cat.net>
In-Reply-To: <f4e6b348-fafb-1546-57cd-4623299b0abb@i2cat.net>

--LMTCnHF69LohIbi9he4RaXkNjeWLAVEae
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 22.12.2016 um 13:34 schrieb Ferran Quer i Guerrero:
> Hello everyone,
>=20
> I would like to modify the retry threshold for dropping a packet using
> mesh mode. I tried with iw
>=20
>     iw phy <phyname> set retry [short <limit>] [long <limit>]
>=20
> with short and long limits equal to 10 first and later 5, but I couldn'=
t
> tell any effect. I'm checking by adding a printk in `status.c` and
> manually shutting down (ifdown) the mesh-peered interface to cause
> packet retries. It turns out that the tx report only appears when
> `retry_count` is 28 (after many continued drops, it also appears at 23,=

> 24, 25 or retries).=20
>=20
>     void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *s=
kb)
>     {
>         /* ... */
>                 if (info->flags & IEEE80211_TX_STAT_TX_FILTERED) {
>                         ieee80211_handle_filtered_frame(local, sta, skb=
);
>                         rcu_read_unlock();
>                         return;
>                 } else {
>                         if (!acked)
>                                 sta->tx_retry_failed++;
>                         sta->tx_retry_count +=3D retry_count;
>                         /* Dirty debugging */
>                         printk("Packet dropped. Retry count: %d",
> retry_count);
>                 }
>=20
>                 rate_control_tx_status(local, sband, sta, skb);
>                 if (ieee80211_vif_is_mesh(&sta->sdata->vif))
>                         ieee80211s_update_metric(local, sta, skb);
>         /* ... */
>     }
>=20
> I'm using linux backports v3.12.8, ath9k wifi dongles, and interfaces o=
n
> mesh point mode.

are you talking about usb dongles? If yes, then it is not ath9k


--=20
Regards,
Oleksij


--LMTCnHF69LohIbi9he4RaXkNjeWLAVEae--

--SdImdrlSmXo5KIGejBwT2mgRKM22GSmTG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlhcLxkACgkQHwImuRkmbWkVxQEAg7FdAJ4acFHH1rBAhxu5plCW
9yRIqPOX/rBuicgkXn8BAIXzBPn/Fe01pf09VkpY0FZyAcdQlAAuEAuwu7IKphG+
=Z4v0
-----END PGP SIGNATURE-----

--SdImdrlSmXo5KIGejBwT2mgRKM22GSmTG--
