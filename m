Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:51709 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643AbaKNJwJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2014 04:52:09 -0500
Message-ID: <5465D09C.3040809@rempel-privat.de> (sfid-20141114_105217_645561_DB84523C)
Date: Fri, 14 Nov 2014 10:51:24 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org, Adrian Chadd <adrian@freebsd.org>
Subject: Re: [PATCH] ath9k_htc: turn on software mgmt crypto for secured mesh
References: <1415941631-24140-1-git-send-email-yeohchunyeow@gmail.com>	<5465C333.7030704@rempel-privat.de>	<CAEFj987ng6Jxa4u3+Z+0oGFX7LUnkLPP96bBrCSnSetjU+YjpQ@mail.gmail.com> <CAEFj984+StN9RzwOdM5O=4ycku8smLqvp3S+Tq2jkQ_U+=P2Tw@mail.gmail.com>
In-Reply-To: <CAEFj984+StN9RzwOdM5O=4ycku8smLqvp3S+Tq2jkQ_U+=P2Tw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QQFkaLmJaO1Jt6Na240ODh0THB2c0wWQD"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QQFkaLmJaO1Jt6Na240ODh0THB2c0wWQD
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 14.11.2014 um 10:18 schrieb Yeoh Chun-Yeow:
> Hi, Oleksij Rpel
>=20
> If we do it in ath9k_hw_init_mfp, these MAC version are related to USB =
devices:
>=20
> AR_SREV_VERSION_9271
> AR_SREV_VERSION_9280
> AR_SREV_VERSION_9287
>=20
> Right?

yes. ar9271 with usb interface. ar9280 and ar9287 are pcie attached to
ar7010 cpu.

> ----
> ChunYeow
>=20
> On Fri, Nov 14, 2014 at 5:06 PM, Yeoh Chun-Yeow <yeohchunyeow@gmail.com=
> wrote:
>> On Fri, Nov 14, 2014 at 4:54 PM, Oleksij Rempel <linux@rempel-privat.d=
e> wrote:
>>> Am 14.11.2014 um 06:07 schrieb Chun-Yeow Yeoh:
>>>> Secured mesh encrypts the unicast mgmt frame using the same
>>>> key that used for encrypting the unicast data frame. The patch
>>>> "ath9k_htc_firmware: fix the offset of CCMP header for mesh
>>>> data frame" applied to open-ath9k-htc-firmware allows the
>>>> ath9k_htc to be loaded without "nohwcrypt=3D1". Unfortunately,
>>>> this is not working and we still need CCMP encryption of
>>>> management frames to be done in software. Fix this.
>>>>
>>>> This patch is tested with the following hardwares:
>>>> - TP-Link TL-WN821N v3 802.11n [Atheros AR7010+AR9287]
>>>> - AR9271 802.11n
>>>>
>>>> and managed to work with peer mesh STA equipped with ath9k.
>>>>
>>>> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
>>>> ---
>>>>  drivers/net/wireless/ath/ath9k/htc_drv_main.c | 3 ++-
>>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers=
/net/wireless/ath/ath9k/htc_drv_main.c
>>>> index 689ac99..d3f65a2 100644
>>>> --- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
>>>> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
>>>> @@ -1447,7 +1447,8 @@ static int ath9k_htc_set_key(struct ieee80211_=
hw *hw,
>>>>                       key->flags |=3D IEEE80211_KEY_FLAG_GENERATE_IV=
;
>>>>                       if (key->cipher =3D=3D WLAN_CIPHER_SUITE_TKIP)=

>>>>                               key->flags |=3D IEEE80211_KEY_FLAG_GEN=
ERATE_MMIC;
>>>> -                     if (priv->ah->sw_mgmt_crypto &&
>>>> +                     if ((vif->type =3D=3D NL80211_IFTYPE_MESH_POIN=
T ||
>>>> +                          priv->ah->sw_mgmt_crypto) &&
>>>>                           key->cipher =3D=3D WLAN_CIPHER_SUITE_CCMP)=

>>>>                               key->flags |=3D IEEE80211_KEY_FLAG_SW_=
MGMT_TX;
>>>>                       ret =3D 0;
>>>>
>>>
>>>
>>> Hmm.. may be we should generally do it here:
>>>         if ((vif->type =3D=3D NL80211_IFTYPE_ADHOC ||
>>>              vif->type =3D=3D NL80211_IFTYPE_MESH_POINT) &&
>>>             (key->cipher =3D=3D WLAN_CIPHER_SUITE_TKIP ||
>>>              key->cipher =3D=3D WLAN_CIPHER_SUITE_CCMP) &&
>>>             !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
>>>
>>
>> Not so sure doing here is correctly. It is a pairwise key for unicast
>> management frame, right?
>>
>>> or probably set "sw_mgmt_crypto =3D true" in ath9k_hw_init_mfp() for =
all
>>> usb devices?
>>
>> All ath9k USB devices don't have MFP support?
>>
>> ---
>> ChunYeow


--=20
Regards,
Oleksij


--QQFkaLmJaO1Jt6Na240ODh0THB2c0wWQD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlRl0JwACgkQHwImuRkmbWmjDQD8DF7kaeK5UwN957eQemaoWM/z
MtT+/Fhzhf042hsf0RYA/RQWMKn68ym4xqSbOQAw/M2orEQOgY7Ogt8hYknYbh16
=OCFW
-----END PGP SIGNATURE-----

--QQFkaLmJaO1Jt6Na240ODh0THB2c0wWQD--
