Received: from mail-24430.protonmail.ch (mail-24430.protonmail.ch [109.224.244.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F8C3A9870
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 09:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786355900; cv=none; b=PfLgpHDqNA5ZE0eqj1Np5Ma6IigKbX/wcioQT4tLC6SCcQokQKGFOSkgFAe9Vy3COBkt+/6rZYP+76MmZCGBsedQly6Qaao0Qi7ak8YgmaELuTrTaqL4JSB/xR4Dr0GxxbUeq3E5nniuyfA/+skfDzLaqPaP4/hR3wyA7IacTy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786355900; c=relaxed/simple;
	bh=FjkEHMV8CZWrCpqrknnBFBiHfGfqn8UHNDmsIRcjvwo=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=AI5agKb3Y/FTy9wU4a1IYZ8Ph1g/TKTFwORwlDc9jTKdtTtBQ8ayqv0G9CJar/G3o0pG+i/ncYaAxo+V1ihmeBTcJUHCaYl3jT4vc0yUS8inWeO6C2ihjOhAo1DCN/qU+iezl+XSsjWA9hMBYTmdl57fCO+3Ji4w9KUaZAU7dTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=urbdkUTW; arc=none smtp.client-ip=109.224.244.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="urbdkUTW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1786355887; x=1786615087;
	bh=FjkEHMV8CZWrCpqrknnBFBiHfGfqn8UHNDmsIRcjvwo=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=urbdkUTWmyojU0WvGdgllvJ/SVQwOK61hFZoP8bbC19X70dBFjdjWugF8iHp/Mi6m
	 Ee60bY9W1HbrO3wFPVxdnicc8QCB9ZKPKXBSDNDAc+G2wbIRi/zt9iRwnCuV4ukzck
	 fF9/mePf8GUG815kQ9Cs8PSutuJPqvgQEWe6owB89RH/h/WNZGfrnkN3FXT3ixJr/a
	 3swPhzBSpLE/dhDzPu56CDeINjQQPN/V2S47GnCjEOMz87RzV5AqB4Uv1Ohdv7FivS
	 EfyExTT8TnzztP14RJjAklD8RBPxN5GaX++Al3pTyPzbBGbq7NnJrGDzMIqwr4DJx1
	 Vn8aFNm9rRm7A==
Date: Mon, 10 Aug 2026 09:57:59 +0000
To: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, Matthias Brugger <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
From: Ryan Leung <untilscour@protonmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, Ryan Leung <untilscour@protonmail.com>
Subject: [PATCH mt76] wifi: mt76: mt7915: fix thermal zone use-after-free on unregister
Message-ID: <20260810-mt7915-unregister-thermal-v1-1-c6d57b4cb368@protonmail.com>
Feedback-ID: 184418679:user:proton
X-Pm-Message-ID: bdfc05f714111930a08a7bf935deca3457c14f2a
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

phy->tzone is registered with devm_thermal_of_zone_register() against
the parent device, so its cleanup runs only after .remove() returns.
But mt7915_unregister_thermal() never unregisters it, while the phy
memory is freed earlier via mt76_free_device()/ieee80211_free_hw()
in that same .remove() path, leaving a use-after-free window.

Explicitly unregister it with devm_thermal_of_zone_unregister()
in mt7915_unregister_thermal() before the phy is freed.

While at it, include phy->mt76->band_idx in the dev_warn() message
emitted when devm_thermal_of_zone_register() fails, to help identify
which band's thermal zone registration failed on multi-band chips.

Fixes: 313f1a27ebcb ("wifi: mt76: mt7915: add thermal zone device registrat=
ion")
Signed-off-by: Ryan Leung <untilscour@protonmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net=
/wireless/mediatek/mt76/mt7915/init.c
index ca46a203aa48..e0376da79dda 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -200,6 +200,9 @@ static void mt7915_unregister_thermal(struct mt7915_phy=
 *phy)
 {
 =09struct wiphy *wiphy =3D phy->mt76->hw->wiphy;
=20
+=09if (phy->tzone)
+=09=09devm_thermal_of_zone_unregister(phy->dev->mt76.dev, phy->tzone);
+
 =09if (!phy->cdev)
 =09=09return;
=20
@@ -238,8 +241,8 @@ static int mt7915_thermal_init(struct mt7915_phy *phy)
 =09if (IS_ERR(phy->tzone)) {
 =09=09if (PTR_ERR(phy->tzone) !=3D -ENODEV)
 =09=09=09dev_warn(phy->dev->mt76.dev,
-=09=09=09=09 "failed to register thermal zone: %ld\n",
-=09=09=09=09 PTR_ERR(phy->tzone));
+=09=09=09=09 "failed to register thermal zone %d: %ld\n",
+=09=09=09=09 phy->mt76->band_idx, PTR_ERR(phy->tzone));
 =09=09phy->tzone =3D NULL;
 =09}
=20

---
base-commit: ca800a9302764c445de0da0e84d2252400a770ee
change-id: 20260809-mt7915-unregister-thermal-82e805c618a6

Best regards,
-- =20
Ryan Leung <untilscour@protonmail.com>


