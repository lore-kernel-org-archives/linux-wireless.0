Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:40496 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751395AbeCWIJz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Mar 2018 04:09:55 -0400
Received: by mail-qk0-f196.google.com with SMTP id o64so12042098qkl.7
        for <linux-wireless@vger.kernel.org>; Fri, 23 Mar 2018 01:09:55 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: ath10k@lists.infradead.org
Cc: Anilkumar Kolli <akolli@codeaurora.org>,
        linux-wireless@vger.kernel.org, Antonio Quartulli <a@unstable.cc>,
        Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: Re: [PATCH] ath10k: Implement get_expected_throughput callback
Date: Fri, 23 Mar 2018 09:09:48 +0100
Message-ID: <2667699.TbZPxW0hJB@bentobox> (sfid-20180323_090959_886867_E7A9AD1C)
In-Reply-To: <1521790620-12267-1-git-send-email-akolli@codeaurora.org>
References: <1521790620-12267-1-git-send-email-akolli@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4071528.lBNJH1k9ki"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4071528.lBNJH1k9ki
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Freitag, 23. M=E4rz 2018 13:07:00 CET Anilkumar Kolli wrote:
[...]
> +static u32 ath10k_get_expected_throughput(struct ieee80211_hw *hw,
> +                                         struct ieee80211_sta *sta)
> +{
> +       struct ath10k_sta *arsta =3D (struct ath10k_sta *)sta->drv_priv;
> +       u32 tx_bitrate;
> +
> +       tx_bitrate =3D cfg80211_calculate_bitrate(&arsta->txrate);
> +       ewma_sta_txrate_add(&arsta->ave_sta_txrate, tx_bitrate);
> +
> +       return ewma_sta_txrate_read(&arsta->ave_sta_txrate);
>  }

Antonio and Felix, please correct me when this statement is incorrect.

The expected_throughput as initially implemented for minstrel(_ht) is not=20
about the raw physical bitrate but about the throughput which is expected f=
or=20
things running on top of the wifi link. See=20
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3Dcca674d47e59665630f3005291b61bb883015fc5=20
for more details

when I interpret your change correctly then your it doesn't get the=20
information about packet loss or aggregation and doesn't do anything convert
from=20raw physical rate to something the user could get see. It will just=20
overestimate the throughput for ath10k links and thus give wrong informatio=
n=20
to routing algorithms. This could for example cause them to prefer links ov=
er=20
ath10k based hw when mt76 would actually provide a significant better=20
throughput.

Beside that - why is the ave_sta_txrate only filled when with new informati=
on=20
when someone requests the current expected_throughput via=20
get_expected_throughput. I would have expected that it is filled everytime =
you=20
get new information about the current rate from the firmware=20
(ath10k_sta_statistics).

> @@ -7686,6 +7686,22 @@ static void ath10k_sta_statistics(struct ieee80211=
_hw *hw,
>         }
>         sinfo->txrate.flags =3D arsta->txrate.flags;
>         sinfo->filled |=3D 1ULL << NL80211_STA_INFO_TX_BITRATE;
> +
> +       sinfo->expected_throughput =3D
> +                               ewma_sta_txrate_read(&arsta->ave_sta_txra=
te);
> +       sinfo->filled |=3D BIT(NL80211_STA_INFO_EXPECTED_THROUGHPUT);
> +}

This brings me directly to the next point. Why are you changing these value=
s=20
here? Isn't sta_set_sinfo is expected to do that? This is at least what we
expect how it works when we call cfg80211_get_station() in batman-adv.

Kind regards,
	Sven
--nextPart4071528.lBNJH1k9ki
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAlq0tkwACgkQXYcKB8Em
e0YCuA//fyJqSprnik/Qx0+tw1M7r6+FCWVM0yUT8m8tw3JOZH/C9I8mavQ+72lk
evs+2gDjPAKfXBUc/gDOfFcaFRn6sLzwBcd8+Yw2JNQDxjNH2mEZVAccrH1wVUTX
4UIZaInz9vsNwSzUZE0vtfKKithWJSkYQ2Q3VlEYqo7rMddsGNEJNKPsf8iYd92S
aJp+eYEonyGxKOKiDcs8Vi0itGQSFQ+/TAfxJY0NiXrwyJUBH4mM1jfouTS7qM+j
i0eGudiRbYkxlrsmSELmM+PQJu+HaxVjLkb/iHsUQt8DoZzxOPRpwikLwSe7GILr
xThSgm1PNy/3wMFG8FlYfGdJPRrTYb6V5CxUvdtVyV+j8CV4gcDWI5GEBRyDF6IJ
XSUhZ26Wa4xounu1U8ELCNmL9k5VpxHpLP0SsBkdy2ONmTuke/HTxLvnvnKple0I
AP4XAS+X0JrwwxVvmwVL0eZkXLAMXCVvd0mZ0ytuKSdskIixgeJ/TNsy00qF29hW
MeYU6AN+DNjOxFgrL3nDuyCVD0LLvHTKyGyt8xMafW2v2k/riof23UjzevKxQLq8
pX5VM6tjB1OeT1xRhR5HQUXd6ei+7k/N1SktvWZI9M2KCRUtJtRVbAwnqNPs501o
MpBulnmHn+wdKaisWAy4zF5AkD5PoqB4kZPA8mFDXFMThOxb3gY=
=cHjY
-----END PGP SIGNATURE-----

--nextPart4071528.lBNJH1k9ki--
