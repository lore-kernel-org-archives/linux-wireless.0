Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8AABC282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 15:36:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94A95217FA
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 15:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbfBLPg2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 10:36:28 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48536 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726238AbfBLPg2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 10:36:28 -0500
Received: from ben by shadbolt.decadent.org.uk with local (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1gta6j-0006Xa-2S; Tue, 12 Feb 2019 15:36:26 +0000
Date:   Tue, 12 Feb 2019 15:36:24 +0000
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc:     linux-wireless@vger.kernel.org
Message-ID: <20190212153624.u6x5dqvmixq63div@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4ontilymfijhsakq"
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH] mt76: Use the correct hweight8() function
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--4ontilymfijhsakq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

mt76_init_stream_cap() and mt76_get_txpower() call __sw_hweight8()
directly, but that's only defined if CONFIG_GENERIC_HWEIGHT is
enabled.  The function that works on all architectures is hweight8().

Fixes: 551e1ef4d291 ("mt76: add mt76_init_stream_cap routine")
Fixes: 9313faacbb4e ("mt76: move mt76x02_get_txpower to mt76 core")
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wi=
reless/mediatek/mt76/mac80211.c
index 484d3ac3a206..7c3a24cc9c77 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -124,7 +124,7 @@ static void mt76_init_stream_cap(struct mt76_dev *dev,
 				 bool vht)
 {
 	struct ieee80211_sta_ht_cap *ht_cap =3D &sband->ht_cap;
-	int i, nstream =3D __sw_hweight8(dev->antenna_mask);
+	int i, nstream =3D hweight8(dev->antenna_mask);
 	struct ieee80211_sta_vht_cap *vht_cap;
 	u16 mcs_map =3D 0;
=20
@@ -714,7 +714,7 @@ int mt76_get_txpower(struct ieee80211_hw *hw, struct ie=
ee80211_vif *vif,
 		     int *dbm)
 {
 	struct mt76_dev *dev =3D hw->priv;
-	int n_chains =3D __sw_hweight8(dev->antenna_mask);
+	int n_chains =3D hweight8(dev->antenna_mask);
=20
 	*dbm =3D dev->txpower_cur / 2;
=20

--4ontilymfijhsakq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAlxi5/gACgkQ57/I7JWG
EQkpLw/7BFPuEh4/iKL8ENwPPV9ELqBP9+ujri5GrNSy+lL5YHShty84W2hNGWVq
Yn0pvd5tqaUMGxWswdAHMt3Nq1e+V7NaoTG9JMg3BXxe7C2+hHcT/k3ulDcZiaIY
1FBT5yYU8AfC2g1OF21tB9mOuaxcftcDx/IFJaJ8vGGw37gkOFMQzpPY8262HggP
txT2S/hh2uaaOU7JXThSSSx/Ty/pbVQ2eDkbH+1jEGuhIfsnFYWcPbnWQSz8oits
uEgpvCybyehPWysr94evJo4q5MjG1Db329aTLvLFWDSsG29eVcDgJ9exD0O9u+BP
5/fEIKlKG1WR3tmiJGNMDQRBhpB8V1JYVk+5F+VCqCdUTexqYqTiJ1fJfSCNdA42
6LRDGzrkLYgtKr7g4i6CxK9tZokBWS1q+J/GHe3Jd1X48oP9q141BH4wrzklI/q2
o3WvbVYYvP/bsAd7HVXhYdTBK/4zV2hFbGQ769YMdDRDYEXd/9x8U0CcXC11vEsi
HS4JnRomIAVCqJC+quQJ5KrM/K6Fm9uSEtEy5qx71DM+P1hU6xsmuGGmITjDXvDc
Vi4hNFATrZiuPg8PczEp17qY0sa+JyKtTlE+9G0yRRv2l+vSN6+8+iji+rZ2gb0K
6zOqbXmzWie49gmRlOVqXSUtGXegPdDgJp3qG0/dmmuhChSYC9Y=
=oV2P
-----END PGP SIGNATURE-----

--4ontilymfijhsakq--
