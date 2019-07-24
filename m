Return-Path: <SRS0=rB3s=VV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1E5EC7618B
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Jul 2019 09:50:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AC8C2070B
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Jul 2019 09:50:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbfGXJuT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Jul 2019 05:50:19 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49665 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfGXJuT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jul 2019 05:50:19 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id CE01D8026A; Wed, 24 Jul 2019 11:50:04 +0200 (CEST)
Date:   Wed, 24 Jul 2019 11:50:15 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     amitkarwar@gmail.com, nishants@marvell.com, gbhat@marvell.com,
        huxinming820@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] marvell wireless: cleanup -- make error values consistent
Message-ID: <20190724095015.GA6592@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Surrounding code uses -ERRNO as a result, so don't pass plain -1.

Signed-off-by: Pavel Machek <pavel@denx.de>

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wire=
less/marvell/mwifiex/scan.c
index 0d6d417..ddf75a5 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -1243,7 +1243,7 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_ad=
apter *adapter,
 			mwifiex_dbg(adapter, ERROR,
 				    "err: InterpretIE: in processing\t"
 				    "IE, bytes left < IE length\n");
-			return -1;
+			return -EINVAL;
 		}
 		switch (element_id) {
 		case WLAN_EID_SSID:

   =20
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl04KdcACgkQMOfwapXb+vK11wCguU0JHbiXyg3ZXNo7SjMF7VAB
xQEAnAjRS3KcZwuWAd/nB0femwXZ+VJh
=QJB8
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
