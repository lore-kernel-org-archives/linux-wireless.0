Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dev-nolb.cloudtrax.com ([54.203.245.161]:37747 "EHLO
	dev-nolb.cloudtrax.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaLRNJN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 08:09:13 -0500
Message-ID: <5492CFF5.9060107@open-mesh.com> (sfid-20141218_140917_820975_11B9E352)
Date: Thu, 18 Dec 2014 14:00:37 +0100
From: Antonio Quartulli <antonio@open-mesh.com>
MIME-Version: 1.0
To: ath10k@lists.infradead.org
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: ath10k: fw_stats not reporting peer_stats with 10.2
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bS7EkeGDAcAross6cLnKQx8giw7XjxjC3"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bS7EkeGDAcAross6cLnKQx8giw7XjxjC3
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello,

I have a device equipped with a ath10k driven wifi card, specifically:

qca988x hw2.0 (0x4100016c, 0x043202ff) fw 10.2-00082-4-2 api 3 htt 2.1
wmi 65.109.0.0 cal file


(line grabbed from dmesg at boot time)

On my device I have configured 2 AP vifs and for each of them I would
like to read the last TX rate of the associated stations.

As I've read on wireless.kernel.org this is not possible through the
standard nl/cfg80211 interface and therefore I have been trying to read
/sys/kernel/debug/ieee80211/phy1/ath10k/fw_stats  , but this file always
reports "ath10k PEER stats (0)" (no peers..).

I tried printing some debug messages here and there and the only useful
information I got is that in "ath10k_wmi_10x_pull_fw_stats()" the value
of "ev->num_peer_stats" is always 0.

Is this yet another fw limitation?


I also realized that upon station connection ath10k receives the
WMI_10_2_PEER_RATECODE_LIST_EVENTID event but it is not handled as no
handler is implemented. Might it be related with my problem ?


Thanks a lot for any information you would be able to provide :)

Cheers,


--=20
Antonio Quartulli


--bS7EkeGDAcAross6cLnKQx8giw7XjxjC3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUks/9AAoJEJgn97Bh2u9e+kAP/1ASFZyzq8XdIsDloG1fO7mK
N0iRlIXosIkQZeoyRXOB7NuMJHaz0krdYvVs999dngiswRXnfPodJKpobaDRVoI8
fndz0eKunLO3Ap51D2OZQ85iI+C0mMO2HWm7QlJJxpG03pAB1aE6rxEhpkq0Wq9m
c+LWU85ADwKiQEfCX8D1DmV3aQ22eGc/Mt/7n0vw7SSG/WdNkS6enqd/HBHcrCVc
GZ6wGtehuUnIhPIyHN8nCSXmyFmic86xsAy2neYE/y557VNAOCV6Klje8AqjsbGQ
KgNrQYl7Ur+ejpYMUagFp8zQOPZNhZtEqQGWGX7vleYqrC8/DeWIrlV+XXRvflUS
EAaW2YdqvxDv6VAMaVXhReAshmhwgjCf2tVLRlJf3vsBpPPW5otlqHfNqcDoePGE
ZuVc7fN9g7COAg8sYxecnuyDunHT7ZJaDzVd7AN6EKBWbDKHJQkNHae/6SAm2cWJ
TZ4tp1m1Bd+DwMVNs/eLnq0uz0evcxt4IKGKD3DMfYEfRC4lf0LD9eQq/3KRwg2E
g/Blq+sATvk6fGC3uMZf2uhIZXIsgsCoweFXJb+z+rEpaFsFeao0RV0a5R8eFRfh
bqnpfvt8MJPOam/sGQXkeh37/+N2BRKtzFS+lZJs80Lv8knJPyHAY36rZSxt1cvP
Xr5XGDHn0lkF6C+i+OyK
=TtAC
-----END PGP SIGNATURE-----

--bS7EkeGDAcAross6cLnKQx8giw7XjxjC3--
