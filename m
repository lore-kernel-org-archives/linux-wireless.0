Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:50254 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbaCBH1M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Mar 2014 02:27:12 -0500
Received: from [192.168.1.221] ([93.218.100.117]) by mail.gmx.com (mrgmx002)
 with ESMTPSA (Nemesis) id 0LpcBS-1WpCgv2uaE-00fQkE for
 <linux-wireless@vger.kernel.org>; Sun, 02 Mar 2014 08:27:11 +0100
Message-ID: <5312DD46.3030800@rempel-privat.de> (sfid-20140302_082718_240204_B8FC23C5)
Date: Sun, 02 Mar 2014 08:27:02 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH 00/23] ath9k|ath9k_htc: move dups to common-beacon
References: <1393704966-13985-1-git-send-email-linux@rempel-privat.de> <21266.37896.937680.416439@gargle.gargle.HOWL>
In-Reply-To: <21266.37896.937680.416439@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xbFRwI082caNH39qndxc9JCbXlBXN0Vh5"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xbFRwI082caNH39qndxc9JCbXlBXN0Vh5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 02.03.2014 03:14, schrieb Sujith Manoharan:
> Hi,
>=20
> Lots of code churn. :)
>=20
> Maybe reusing ath9k entirely and just writing a USB layer can
> be a better approach ?

I was thinking about it too, but suddenly i don't have enough time and
experience to do it. Beside, there is no need to write usb layer. It is
clean and separate from other part of the driver. But the HTC/WMI
interface is not completely separate.
In this case ath9k driver will need some rework too. For example
beacon.c code works directly with DMA queues, see "struct ath_beacon".
May be it is still better to add needed changes in ath9k by keeping
ath9k_htc functional.

Now about bigger picture. Right now i work only on ath9k<>ath9k_htc
dups. But there are lots of dup code in ath9k itself. For example
*_phy.c, *_initvals.h. Here are some examples:

[-] 281 lines matched in 2 locations
        ath/ath9k/ar9002_initvals.h(954)
        ath/ath9k/ar9002_initvals.h(2486)
[-] 214 lines matched in 2 locations
        ath/ath9k/ar9565_1p0_initvals.h(495)
        ath/ath9k/ar9565_1p0_initvals.h(775)
[-] 164 lines matched in 2 locations
        ath/ath10k/wmi.h(1205)
        ath/ath10k/wmi.h(1390)
[-] 163 lines matched in 5 locations
        ath/ath9k/ar9003_eeprom.c(462)
        ath/ath9k/ar9003_eeprom.c(1040)
        ath/ath9k/ar9003_eeprom.c(1619)
        ath/ath9k/ar9003_eeprom.c(2198)
        ath/ath9k/ar9003_eeprom.c(2776)
[-] 132 lines matched in 2 locations
        ath/ath9k/ar9462_2p0_initvals.h(809)
        ath/ath9k/ar9462_2p1_initvals.h(63)
[-] 129 lines matched in 2 locations
        ath/ath9k/ar9002_phy.c(291)
        ath/ath9k/ar5008_phy.c(327)
[-] 79 lines matched in 2 locations
        ath/ath6kl/target.h(220)
        ath/ath10k/targaddrs.h(107)
[-] 41 lines matched in 2 locations
        ath/ath9k/ar9003_phy.c(889)
        ath/ath9k/ar5008_phy.c(818)
[-] 36 lines matched in 2 locations
        ath/ath9k/eeprom.c(191)
        ath/ath9k/eeprom.c(245)
[-] 28 lines matched in 2 locations
        ath/ath9k/init.c(246)
        ath/ath9k/init.c(277)
[-] 28 lines matched in 2 locations
        ath/ath9k/eeprom_4k.c(498)
        ath/ath9k/eeprom_def.c(1030)
[-] 26 lines matched in 2 locations
        ath/ath9k/ar9003_phy.c(1338)
        ath/ath9k/ar5008_phy.c(1257)
[-] 23 lines matched in 3 locations
        ath/ath9k/eeprom_4k.c(248)
        ath/ath9k/eeprom_def.c(324)
        ath/ath9k/eeprom_9287.c(235)
[-] 23 lines matched in 2 locations
        ath/ath9k/htc_drv_debug.c(465)
        ath/ath9k/debug.c(103)
and so on...

If some one can take care of it, it will be great :)

The programm i use (scitools Understand), found 14851 lines of
Duplicated code in wireless/ath. Probably there are some false positive
and code which was not found because of some cosmetic changes.

I assume that usb code can be reused can be same on ar5523, carl9170,
ath9k_htc. And some WMI code at least on ath10k and ath9k_htc.


> Sujith
>=20
> Oleksij Rempel wrote:
>> Next patch set. It removes only easy duplicats of beacon code. Other p=
arts of
>> need deeper rework to make it compatible with ath9k.
>>
>> Oleksij Rempel (23):
>>   ath9k: move struct ath_beacon_config to common
>>   ath9k_htc: use common ath_beacon_config
>>   ath9k_htc: move beaconq to struct htc_beacon
>>   ath9k_htc: use ath_beacon_conf.enable_beacon
>>   ath9k: move sc_flags to ath_common
>>   ath9k_htc: use common->op_flags
>>   ath9k_htc: add ATH_OP_PRIM_STA_VIF
>>   ath9k: remove unused bc_tstamp
>>   ath9k_htc: sync beacon slot code with ath9k
>>   ath9k: remove unused beacon_qi
>>   ath9k|ath9k_htc: move IEEE80211_MS_TO_TU to common
>>   ath9k-common: add nexttbtt and intval to ath_beacon_config
>>   ath9k: move ath9k_beacon_config_sta to common-beacon
>>   ath9k_htc: use ath9k_cmn_beacon_config_sta
>>   ath9k: move ath9k_beacon_config_adhoc to common
>>   ath9k_htc: add ath9k_htc_beacon_init (but not use it)
>>   ath9k_htc: use ath9k_htc_beacon_init in ath9k_htc_beacon_config_ap
>>   ath9k_htc: use ath9k_htc_beacon_init in ath9k_htc_beacon_config_adho=
c
>>   ath9k_htc: use ath9k_cmn_beacon_config_adhoc
>>   ath9k: move ath9k_beacon_config_ap common
>>   ath9k: remove unused ath9k_get_next_tbtt
>>   ath9k_htc: use ath9k_cmn_beacon_config_ap
>>   ath9k_htc: move DEFAULT_SWBA_RESPONSE check to ath9k_htc_beacon_init=

>>
>>  drivers/net/wireless/ath/ath.h                  |  10 +
>>  drivers/net/wireless/ath/ath9k/Makefile         |   3 +-
>>  drivers/net/wireless/ath/ath9k/ahb.c            |   7 +-
>>  drivers/net/wireless/ath/ath9k/ath9k.h          |  22 ---
>>  drivers/net/wireless/ath/ath9k/beacon.c         | 165 ++-------------=
-
>>  drivers/net/wireless/ath/ath9k/common-beacon.c  | 180 +++++++++++++++=
++
>>  drivers/net/wireless/ath/ath9k/common-beacon.h  |  26 +++
>>  drivers/net/wireless/ath/ath9k/common.h         |  14 ++
>>  drivers/net/wireless/ath/ath9k/debug.c          |   2 +-
>>  drivers/net/wireless/ath/ath9k/htc.h            |  25 +--
>>  drivers/net/wireless/ath/ath9k/htc_drv_beacon.c | 252 ++++++---------=
---------
>>  drivers/net/wireless/ath/ath9k/htc_drv_init.c   |  10 +-
>>  drivers/net/wireless/ath/ath9k/htc_drv_main.c   |  53 +++--
>>  drivers/net/wireless/ath/ath9k/htc_drv_txrx.c   |   3 +-
>>  drivers/net/wireless/ath/ath9k/link.c           |  16 +-
>>  drivers/net/wireless/ath/ath9k/main.c           |  45 +++--
>>  drivers/net/wireless/ath/ath9k/mci.c            |   2 +-
>>  drivers/net/wireless/ath/ath9k/pci.c            |   8 +-
>>  drivers/net/wireless/ath/ath9k/xmit.c           |   9 +-
>>  19 files changed, 413 insertions(+), 439 deletions(-)
>>  create mode 100644 drivers/net/wireless/ath/ath9k/common-beacon.c
>>  create mode 100644 drivers/net/wireless/ath/ath9k/common-beacon.h
>>
>> --=20
>> 1.9.0
>>


--=20
Regards,
Oleksij


--xbFRwI082caNH39qndxc9JCbXlBXN0Vh5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlMS3UoACgkQHwImuRkmbWk5jwD+JmUT8dYGCzfvufQRFeWhHIZE
i/I4c3DaxmFW/H0vg9MA/jCmxKCO4JxIALYmuaC357sO2jVwf9TBY5wRYnGtzs8S
=cXmf
-----END PGP SIGNATURE-----

--xbFRwI082caNH39qndxc9JCbXlBXN0Vh5--
