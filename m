Received: from mail-24430.protonmail.ch (mail-24430.protonmail.ch [109.224.244.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1745A3DD51C;
	Mon, 10 Aug 2026 13:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786366909; cv=none; b=buLlAKL3eDK/e+OK/suzgVMmKiHvLmHE6qud0y2OeYFtBq0KtPIEelIKT3NgQq3sGyvOcxkCd9ItyR4ncJxcAvowOg1orv6K0QmOZshMCzu8mfubFoRFi1hoJJA9y0TUf/JlxfYGlLM5BL6aDoBjzFH+2BitjVX4Wsu76FnTdYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786366909; c=relaxed/simple;
	bh=UYOe76FyAW08a4EgxOUKKhfLGG/nEcCLfc7wtlHNqis=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=GBw0Bt6H948U6+kUjS0a0iy6iztnrvew4x8Mk4TUWrQwtJLpzzRB33AKmqAb1CwXwiZBUBvEJAaBGdPXxz0nLh9SFV8U2b4eMrt8b50mear5PqsBxJxnzSRlLzoqGWFvMto9VzSY33qRc0g+ck23EKNmOUIjKlxI5MlDi1KUuZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=a75mMLVq; arc=none smtp.client-ip=109.224.244.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="a75mMLVq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1786366900; x=1786626100;
	bh=H0a1CQIGg5sXxmGkEd9IVGyS3yp2N3ok/AxA3NteMO0=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=a75mMLVq8pW1ulubCNe2hWY5yRfUkPWQPJbq5Mxi+r8nmnaLoUWIyWjf5mfDr1OM2
	 3nlqC+LWE1DCFwDai0fhsPeD+2EEU1fcRoMzWHwrzpzKIfvj+iGpjqLWUgQAGwosoe
	 nlv7nmm+SE/fVJPEIsFVHcrLbUlJcjx37yAhX0lnwB7z4HT5gMNNedFjMGuWLqQCyS
	 zWwat40JwsWOY4qi5TC+7MEV510IwS7ZUjh2G7RH07v8a1tP23aeLyFtXqb9JAzGoF
	 D7qCR5Wm4260J0SnJcrfMLAg+DnaEM6lO8P+lv3pHLI14e5yhPeMiaLMGAjqmbF0tG
	 bSGRh4EVPRFLw==
Date: Mon, 10 Aug 2026 13:01:35 +0000
To: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, Matthias Brugger <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
From: Ryan Leung <untilscour@protonmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, Ryan Leung <untilscour@protonmail.com>
Subject: [PATCH mt76 v2] wifi: mt76: mt7915: fix thermal zone use-after-free and cooling device leak
Message-ID: <20260810-mt7915-unregister-thermal-v2-1-2a0f51adf56f@protonmail.com>
Feedback-ID: 184418679:user:proton
X-Pm-Message-ID: 6a9c3b37ed443ec86e6a41c1e1036b5137affe13
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

The thermal zone registered against the parent device is never torn
down when the phy is unregistered, so it can still be dereferenced
by the thermal core after the phy is freed. The thermal zone and
cooling device are also left registered if a later hwmon
registration step fails during init, leaking both.

Unregister the thermal zone alongside the cooling device on both the
regular unregister path and the init failure path.

While at it, include the band index in the thermal zone registration
warning to help identify which band failed on multi-band chips.

Fixes: 313f1a27ebcb ("wifi: mt76: mt7915: add thermal zone device registrat=
ion")
Signed-off-by: Ryan Leung <untilscour@protonmail.com>
---
Changes in v2:
- Unwind cdev/tzone registration in mt7996_thermal_init() on hwmon registra=
tion failure.
- Link to v1: https://patch.msgid.link/20260810-mt7915-unregister-thermal-v=
1-1-c6d57b4cb368@protonmail.com
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net=
/wireless/mediatek/mt76/mt7915/init.c
index ca46a203aa48..5fe70dc822eb 100644
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
@@ -213,6 +216,7 @@ static int mt7915_thermal_init(struct mt7915_phy *phy)
 =09struct thermal_cooling_device *cdev;
 =09struct device *hwmon;
 =09const char *name;
+=09int ret;
=20
 =09name =3D devm_kasprintf(&wiphy->dev, GFP_KERNEL, "mt7915_%s",
 =09=09=09      wiphy_name(wiphy));
@@ -238,8 +242,8 @@ static int mt7915_thermal_init(struct mt7915_phy *phy)
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
@@ -248,7 +252,11 @@ static int mt7915_thermal_init(struct mt7915_phy *phy)
=20
 =09hwmon =3D devm_hwmon_device_register_with_groups(&wiphy->dev, name, phy=
,
 =09=09=09=09=09=09       mt7915_hwmon_groups);
-=09return PTR_ERR_OR_ZERO(hwmon);
+=09ret =3D PTR_ERR_OR_ZERO(hwmon);
+=09if (ret)
+=09=09mt7915_unregister_thermal(phy);
+
+=09return ret;
 }
=20
 static void mt7915_led_set_config(struct led_classdev *led_cdev,

---
base-commit: ca800a9302764c445de0da0e84d2252400a770ee
change-id: 20260809-mt7915-unregister-thermal-82e805c618a6

Best regards,
-- =20
Ryan Leung <untilscour@protonmail.com>


