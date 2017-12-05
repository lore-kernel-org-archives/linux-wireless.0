Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:36897 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752482AbdLEJQH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Dec 2017 04:16:07 -0500
Received: by mail-qt0-f180.google.com with SMTP id f2so4237545qtj.4
        for <linux-wireless@vger.kernel.org>; Tue, 05 Dec 2017 01:16:07 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: akolli@codeaurora.org
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Peter Oh <peter.oh@bowerswilkins.com>,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        ath10k@lists.infradead.org,
        Anilkumar Kolli <akolli@qti.qualcomm.com>,
        linux-wireless@vger.kernel.org
Subject: Re: ath10k: Fix reported HT MCS rates with NSS > 1
Date: Tue, 05 Dec 2017 10:16:03 +0100
Message-ID: <1552472.kPg8TR0KAa@bentobox> (sfid-20171205_101624_113578_4A12913C)
In-Reply-To: <bcebd30e279840a62b53043865d4db29@codeaurora.org>
References: <20170511090930.18205-1-sven.eckelmann@openmesh.com> <87po8df8wc.fsf@kamboji.qca.qualcomm.com> <bcebd30e279840a62b53043865d4db29@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart6304754.KrjaKBfTbQ"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart6304754.KrjaKBfTbQ
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Dienstag, 21. November 2017 11:43:36 CET akolli@codeaurora.org wrote:
[...]
> > I think we should add a special case to not print the warning if mcs ==
> > 15 until we figure out what it means.
> 
> Fix identified in Firmware and will push ASAP.

Is it known when this will be released and for which firmware/HW versions? And 
will this also fix the legacy rate reports? At least in the moment, 
ath10k_htt_fetch_peer_stats seems to generate following on QCA4019 for some 
clients:

    [ 1627.720177] ath10k_ahb a800000.wifi: Invalid legacy rate 26 peer stats
    [ 1632.010290] ath10k_ahb a800000.wifi: Invalid legacy rate 26 peer stats

Kind regards,
	Sven
--nextPart6304754.KrjaKBfTbQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAlomY9MACgkQXYcKB8Em
e0bojA/+K+sp8iJSyLYy0+MpYzijwgMCFoJg7+pzWwhpvj1LdHMa4BBVqkom9BSm
zAclOSW9cA5YLcwDYJnKYfOeUqqO3Pc8DJePyRdhS86cB0FXbPAQzn2dbWNoBb9b
xL2nuSCEnfEjSgA/qPx5Xi1EwOk6Bjnqu5oVDIjsUA1K0f8A0FooAQZup37Ti0jO
CttpwCAq+d6CeaijojzSuvujveW8wWXmhaBV+odnmBJzNNpLUfWeN5shHoKPTFrr
yy4wqpTt3TFfuNH8LNT3lTkDbsxXu7In/P0tNxLfG2oOQC5cZ2a/kMhtX5WJ0fkz
5Dw9++KEZF4FvAYtEeMPTCtZYVakvjmLPf1W212H8JV7o0TX9+nEyHkXjr5MrNhA
NFz8ilsbLIVP/i+Bbi7VX4BiEDVDNy9V9W5Gqv8PAg4HsbjO0AFfS8gHVE4cYliE
UYDDwTiLWzxsji/QidswSNZNhQnU7WiTY/vV+J5+Oqa3HN4ke9cGsBceVtygsPrw
Ym7dqUGtE8Rg84JANoRzubr/w/C+2UCEZ+A8yYHMHNoZDJ8Idi1GbDXStP6OJX19
P126n9TXZOQPHiwVFMT42Zt9erhdvBLdDhOdY83+eS9z0c/fros51lI/dZLiDUgz
UrwklfveyuYhP2PRcUco6d5aVDJqqjEwl9s7FXYWRlsYK/lylPc=
=5WIL
-----END PGP SIGNATURE-----

--nextPart6304754.KrjaKBfTbQ--
