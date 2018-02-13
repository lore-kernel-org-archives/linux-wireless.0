Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:35872 "EHLO v3-1039.vlinux.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933468AbeBMHwb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Feb 2018 02:52:31 -0500
From: Sven Eckelmann <sven@narfation.org>
To: Ali Abedi <a2abedi@uwaterloo.ca>
Cc: linux-wireless@vger.kernel.org
Subject: Re: 802.11ac devices that use Minstrel_HT
Date: Tue, 13 Feb 2018 08:52:26 +0100
Message-ID: <4674890.5ipQsmKAE1@bentobox> (sfid-20180213_085235_185775_5225680D)
In-Reply-To: <769da6f9-bca3-48bd-32e6-009dd82f3c96@mailservices.uwaterloo.ca>
References: <769da6f9-bca3-48bd-32e6-009dd82f3c96@mailservices.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1724221.IJv3unj4a9"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1724221.IJv3unj4a9
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Montag, 12. Februar 2018 14:05:36 CET Ali Abedi wrote:
> Hello,
> 
> It seems that Minstrel_ht rate adaptation algorithm supports 802.11ac 
> VHT rates.
> Can you refer me to some 802.11ac devices that use this rate adaptation 
> algorithm?
> I need to modify the rate adaptation algorithm however all 802.11ac 
> devices that I know have moved this functionality to (closed) firmware.

Following files use IEEE80211_TX_RC_VHT_MCS in drivers/net/wireless:

* intel/iwlwifi/mvm/tx.c
* mac80211_hwsim.c
* mediatek/mt76/mt76x2_mac.c
* mediatek/mt76/mt76x2_tx.c
* realtek/rtlwifi/base.c
* realtek/rtlwifi/rc.c

Following files from the candidates are providing their own rate_control_ops:

* realtek/rtlwifi/
* intel/iwlwifi/mvm/rs.c
* intel/iwlwifi/dvm/rs.c

So I would currently bet on hwsim (only useful when you only want to have some 
simulations) or mt76. Afaik mt76 was also the one which was used to test the 
VHT rate injection code for monitor interfaces and is therefore quite 
flexible.

Kind regards,	
	Sven
--nextPart1724221.IJv3unj4a9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAlqCmToACgkQXYcKB8Em
e0Z05RAAhGR8CoFc3Ltq0YAuv1+fAJQ18dKCvEi9LGE0X+2M37EhY0dx7ra0T3Qk
CHuTc62Tsd85TSz18rqqfKvfioYJxVr0XAfdhtza6iUMyX2a7JzQ8MAfhFKv8UTx
QrPQ8ZgPlaAUwTV6vYASaNFzYrWKMYNhKBqcuFNZjVdlxXNU+QgwUrhWCBkbQE67
cJ8e2u2HJAEgQ35eAKd1hgxWwXPtFv9F2OdrUjigsup2X+AC39HZfe8Hl43gIYoo
owk3rGAhIY4vy/t1ESJeUs6/d21VGvJtmi/C3be+QC1W/6ZLhtAh6ktLky4AMqaq
Fz4aPGV+opq2L30Zj1DbelrpBvcJQetdwWGC7Aos75OMYO13lBv1ZR8KcHMycGFw
emJog0LwCFYmgFr93tPHOJZeI2k5PHWKkAobAlKBtHmDm7Ww1aVAcL5POzTzp4w3
kPm6T2lVTyRi/21Umq+sNgkMKjb2JcPWg6+RSgZHtdCVCHaev6VpOuOAhzt1+20/
1YFc7PSlBbtdblmex2ma3/f0wp3mQB3NhwElWD3aL+ENVuvTAFIbABzzMSaM07fq
MKNHUd1kj/t3qP3Te4PYTeRorhdkRmJBWFHwU2JItDBWEIEtgvO0LIjWhq8F1OWJ
b0eXYdmyXaI1gxosLFBCtdE9rslyre0Qpd48R6VeDIqRdb9jWuw=
=tLE/
-----END PGP SIGNATURE-----

--nextPart1724221.IJv3unj4a9--
