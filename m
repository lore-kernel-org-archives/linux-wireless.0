Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:46030 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaANErR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 23:47:17 -0500
Received: by mail-ea0-f171.google.com with SMTP id h10so3639193eak.2
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 20:47:16 -0800 (PST)
Received: from [192.168.1.109] (89-139-17-131.bb.netvision.net.il. [89.139.17.131])
        by mx.google.com with ESMTPSA id v1sm45179862eef.9.2014.01.13.20.47.14
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 13 Jan 2014 20:47:15 -0800 (PST)
Message-ID: <52D4C14E.2090805@gmail.com> (sfid-20140114_054720_951233_FAC98505)
Date: Tue, 14 Jan 2014 06:47:10 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi-next 2014_1_12
References: <52D44A46.4000805@gmail.com>
In-Reply-To: <52D44A46.4000805@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="uL8X4MQOaE5gp6jXlXAhUuabtXuNAAjGs"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uL8X4MQOaE5gp6jXlXAhUuabtXuNAAjGs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Somehow - this didn't make it to the list...

On 01/13/2014 10:19 PM, Emmanuel Grumbach wrote:
> Hi John,
>=20
> This is the last pull request for 3.14 - (exact same beginning as my
> last pull request :)).
> I have here a bunch of things that accumulated since my last pull reque=
st.
>=20
> Besides a few trivial patches, I have an important workaround for a HW
> issue that has kept me busy for a long time. Along with it, a fix that
> prevents an error from being printed.
> Eyal fixes our behavior against SISO APs and Ilan fixes an issue with
> multiple interface scenarios.
> Eliad fixes an error path in our init flow.
> We also have a few "static analyzers" fix.
>=20
> I want to hope that this makes it to 3.14 through net-next.git. If not,=

> I'll have to sent a few of them to net.git which is not a big disaster.=

>=20
> The following changes since commit 14648d6534477952633ee3ecadb31cf22741=
4f13:
>=20
>   iwlwifi: mvm: fix coccinelle warnings (2013-12-31 19:03:53 +0200)
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.gi=
t
> for-john
>=20
> for you to fetch changes up to cf38e4f756d6396657c76f72ef42b6f47c523f97=
:
>=20
>   iwlwifi: mvm: don't use highest rate in VHT MCS Set (2014-01-13
> 22:17:22 +0200)
>=20
> ----------------------------------------------------------------
> David Spinadel (1):
>       iwlwifi: mvm: add REPLY_SF_CFG_CMD to cmd strings
>=20
> Eliad Peller (2):
>       iwlwifi: mvm: fix missing cleanup in .start() error path
>       iwlwifi: mvm: fix tx seq_ctrl debug print
>=20
> Emmanuel Grumbach (6):
>       iwlwifi: mvm: don't set the drain bit when we flush the AP statio=
n
>       iwlwifi: pcie: enable oscillator for L1 exit
>       iwlwifi: mvm: send all the NVM sections to the NIC
>       iwlwifi: mvm: fix SRAM dump debugfs handler
>       iwlwifi: mvm: remove unused flags from add station command
>       iwlwifi: mvm: reset Thermal Throttling's SMPS request upon
> disassociation
>=20
> Eyal Shapira (4):
>       iwlwifi: mvm: rs: fix handling of column switch error
>       iwlwifi: mvm: rs: fix a theoretical out of bounds access
>       iwlwifi: change beamformee STS cap
>       iwlwifi: mvm: don't use highest rate in VHT MCS Set
>=20
> Eytan Lifshitz (1):
>       iwlwifi: mvm: fix theoretical uninitialized function return value=

>=20
> Ilan Peer (2):
>       iwlwifi: mvm: clear ap_ibss_active in case of failure
>       iwlwifi: mvm: update power after binding in start_ap_ibss()
>=20
> Johannes Berg (2):
>       iwlwifi: mvm: use array indexing instead of treating it as a poin=
ter
>       iwlwifi: add inline helper for packet lengths
>=20
>  drivers/net/wireless/iwlwifi/dvm/mac80211.c   |    3 +--
>  drivers/net/wireless/iwlwifi/dvm/rx.c         |    7 ++-----
>  drivers/net/wireless/iwlwifi/dvm/ucode.c      |    7 +------
>  drivers/net/wireless/iwlwifi/iwl-nvm-parse.c  |    9 +-------
>  drivers/net/wireless/iwlwifi/iwl-prph.h       |    4 ++++
>  drivers/net/wireless/iwlwifi/iwl-trans.h      |   10 +++++++++
>  drivers/net/wireless/iwlwifi/mvm/d3.c         |   15 ++++++-------
>  drivers/net/wireless/iwlwifi/mvm/debugfs.c    |    2 +-
>  drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h |    3 ---
>  drivers/net/wireless/iwlwifi/mvm/mac80211.c   |   28
> +++++++++++++++++++------
>  drivers/net/wireless/iwlwifi/mvm/nvm.c        |   13 ++++++------
>  drivers/net/wireless/iwlwifi/mvm/ops.c        |    2 ++
>  drivers/net/wireless/iwlwifi/mvm/rs.c         |   13 ++++++------
>  drivers/net/wireless/iwlwifi/mvm/time-event.c |    4 ++--
>  drivers/net/wireless/iwlwifi/mvm/tx.c         |    9 ++++----
>  drivers/net/wireless/iwlwifi/mvm/utils.c      |    4 ++--
>  drivers/net/wireless/iwlwifi/pcie/rx.c        |    2 +-
>  drivers/net/wireless/iwlwifi/pcie/trans.c     |   22 +++++++++++++++++=
++
>  18 files changed, 94 insertions(+), 63 deletions(-)
>=20


--uL8X4MQOaE5gp6jXlXAhUuabtXuNAAjGs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJS1MFRAAoJEC0Llv5uNjIBOxgP/iCODnawSlMRlmaoniCgS+Lr
H1vglUtvc3vR1M5V8oVNHiHnvEORjp92P7bmU4QETQJWjRSiA0b4Js0G0jpQVFjS
WVlvVUlDBdzw/xhhTiD3hYYGG5dPcgQkb1hgea3ZHKmKxviX9iy8dXXJmYlLlBK0
BN4vi6czzSyD5IVnEldbJMOXyMB80P42xLI9aBbJhw1KQR5Q4/4j4FIAE6VgJy+l
GM/zpTyvG+1gkeMqgfoQtsxYJ7Z42/Zd6QwmOlFRQQYanHNzq0HkHwT7Uz3hIIsl
Rv2h5fRm7Foc/WdBW/dN8t4mAb4J8VaZxlQ22YQO6j9WXL+5/+yYJ5/TaegrUraC
4L4nT/DxAlYAb9juj/OJiqo8CMso+ye9ij0NQtQfAZyYLtlp79fCgORsEMaojWPp
DA4w0mjOy1Fj6G68uae5BB1SDm0eEJOEcRUMSyqTvVwGvQFQT+NJ50OLX/7wyOmf
FLdP4mu8GPJAz4OEVu8JTkaBh1eRk22Y3XE1+N/buczqHdm6v1K27Dnmp+uSEizc
DnC7i2OVwHgN0neEyrmWa1CAKYGM8eejq192pscGFpWI/Rk/GJcgaVqKA3y67EsS
FgXAs8eDZGyrOdv0D8GZmHXXk0Pq69OJCs427g50AlAlv4Acf6tCgDV2vD31QL3Z
PMFCSOatDqTf/9Wn0sqD
=dkt8
-----END PGP SIGNATURE-----

--uL8X4MQOaE5gp6jXlXAhUuabtXuNAAjGs--
