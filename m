Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f44.google.com ([209.85.221.44]:35125 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751000AbeGJGz3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jul 2018 02:55:29 -0400
Received: by mail-wr1-f44.google.com with SMTP id a3-v6so4086419wrt.2
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2018 23:55:28 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: Toke =?ISO-8859-1?Q?H=F8iland=2DJ=F8rgensen?= <toke@toke.dk>
Cc: simon.wunderlich@openmesh.com,
        Daniel Bailey <daniel.bailey@openmesh.com>,
        Shashidhar Lakkavalli <shashidhar.lakkavalli@openmesh.com>,
        linux-wireless@vger.kernel.org
Subject: Re: mac80211: AQM and block_tx
Date: Tue, 10 Jul 2018 08:55:26 +0200
Message-ID: <4554238.GrJkgPgAWi@bentobox> (sfid-20180710_085538_143124_DD81616F)
In-Reply-To: <2846230.fHgAC8qB8Q@bentobox>
References: <2846230.fHgAC8qB8Q@bentobox>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2470059.a5NIe2yBfq"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2470059.a5NIe2yBfq
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Donnerstag, 5. Juli 2018 10:47:11 CEST Sven Eckelmann wrote:
> Hi Toke,
> 
> we are currently testing DFS with ath10k and noticed that AQM seems to ignore 
> cfg80211_csa_settings->block_tx. Problem is now that the channel switch is 
> started on a detected radar
> 
>   echo 1 >/sys/kernel/debug/ieee80211/phy1/ath10k/dfs_simulate_radar
> 
> NL80211_ATTR_CH_SWITCH_BLOCK_TX is set for the channel switch by hostapd but 
> the AP still sends QoS data to the client.
> 
> Was there a fix for such a problem which I might have missed? I've just worked 
> around that by setting wake_tx_queue TO NULL in ath10k. This still must be 
> verified but at least I didn't see any packets anymore on a monitor interface.


Just as information, the ath10k Dakota devices went through DFS certification 
but the AQM had to be disabled. Otherwise we would have had problems with the 
FCC closing time.

Kind regards,
	Sven
--nextPart2470059.a5NIe2yBfq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAltEWF4ACgkQXYcKB8Em
e0ZrshAAlfcze8rsFRYWlAD2WX4xZ2jD1Ozi7ZtlZAop8oOOWB5ic6W6WZ7ubzVu
ofX5M0JTp46TXx6BT6en0OGKXDINYmwR5DpLEpfCHlfK4WGx5Fid79vNOYGI6uaa
QhjR7jr61e3WQFkIAQeGMNAAWXC+EePjDeePgi1yMr8I4DUWXL4nnEUZkQTzq2ur
mM7zBDCZWZ5RJ+UQnhNBwSbeOH6LviQsY4dl+Doa6TgGQwpyqgliXu4weDG/sRhM
tcObUAdqYm+41jFLV4HsEmw741VL+Oxod+VX89+D1yxZtuBQmYBTYwI9Dz8fJnyL
bHd0YHX/SOC3BNGU6fNChNoD5OvM26yc6IISaQusudp+u2oTVTOsJleGPVnnfRQb
ey8olS1T789Pofp/+mpmyyMzgriv7sBnKVyQbt6o5xNibZ+Qtn9u+LaiAEfMF3mT
Qxi3arERm6ZYPGYL8PXxhlfypJHD3UqOcYEsWjXsyZnwEUqL7vUvrnCFGoR/zyV1
RD9IlB4o3PyZggokkQLrxrDeOe+oZf554dFYYPmW0b5PAQYCFr75ja/qo7rtKPhu
o1E5B+EfhAxuxSSj8iqcn+pK3kz5gmMAmx9MRO/JhsewdMcuXlHJdhGvUAYQx623
3gNGNBnHYqIKs1JfnypHMHX2/bRK065p8GDAJTkd7M1sjht0jWs=
=ysXv
-----END PGP SIGNATURE-----

--nextPart2470059.a5NIe2yBfq--
