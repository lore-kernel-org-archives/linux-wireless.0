Received: from mail-43167.protonmail.ch (mail-43167.protonmail.ch [185.70.43.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D3650276;
	Sun, 19 Jul 2026 02:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784427280; cv=none; b=c44cdDPGfaRv0Fm1rIf+RtGIdMupyjKqVSmvOe7dZYvH9dR0KPRyTjZ3GwYdT+x3oNxvZdtFZaNMc2ulMkrHvngZYVRR+ghpxfeLxA9YZnbyEn3Shp4OuA0ptwDkJwTNIXURRs80yQNcaZgEpFpuf7eVLnjyN01mbxIH9bJV3B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784427280; c=relaxed/simple;
	bh=mmKUIcX71QbCufun6ejdI8H8kOSdvWd6hEhZEK5kyTc=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=EBNfoTbMACUGPm+5osGQX3r9h1i6mUMyZEye7GaivaMOtrflnrv1jcWxQ02n7z9TK2HmXDQPWRKADKu0zNjE5IfmAhfJ2rCLxsrF0cDrHsOtCE+0tikSdciY5e/KnQYB4LWUF4mrfCbGwFkPPb5J+GerCY5E0/0q/w652gOmPTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=p16gr+jg; arc=none smtp.client-ip=185.70.43.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="p16gr+jg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1784427269; x=1784686469;
	bh=yBjAaTvVK2MAeuR8nn6R746ihPtr83agaW7aplO+tzc=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=p16gr+jg41+XZbVVxShV/guTrsEbRhkDMDpW48sod8U1WPgHibn8ZChXIIF/r2FZI
	 z7HE/TtCFZk5bcvenMNQ24H6P8PLlrfx8MqWIa2hKRxl8yOSICOL6CUMsDVSdY+9NO
	 rmxIL6tOtY5X+UArbnqq4OvehrJvCEMv6G6rQQWqd1XhDGCn66A2N7b+wuyjBm3LyN
	 O228ctlf00+Rr2qd16XBsV2OQdZafytuOF8KixiRXEePhP2Y55/khcxA1UJ/fbAqRJ
	 7ioe+TbgkFnxdlms2tJxpb3fiYPRGXvywQzkQvAFq9F/BoXEsxy9zusNmm4MrL/izi
	 xiQqyfBGYJKkw==
Date: Sun, 19 Jul 2026 02:14:19 +0000
To: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, Matthias Brugger <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
From: Ryan Leung <untilscour@protonmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, Ryan Leung <untilscour@protonmail.com>
Subject: [PATCH RESEND mt76 v2] wifi: mt76: mt7915: add thermal zone device registration
Message-ID: <20260719-mt7915-thermal-zone-device-registration-v2-1-0eac68c2741e@protonmail.com>
Feedback-ID: 184418679:user:proton
X-Pm-Message-ID: 480d21824b61b802ac8d168e8bd15d29554584de
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Register the mt7915 phy as a thermal zone sensor using
devm_thermal_of_zone_register() so that device tree thermal-zones
nodes can reference the Wi-Fi chip as a temperature source. This
allows the kernel thermal governor to control external cooling
devices such as PWM fans based on Wi-Fi chip temperature.

Registration is non-fatal: -ENODEV is returned when no
thermal-sensors DT property references this device, which is the
expected case on platforms without a thermal zone configured.

Signed-off-by: Ryan Leung <untilscour@protonmail.com>
---
v2: Use phy->mt76->band_idx instead of hardcoded 0 as sensor ID
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   | 30 ++++++++++++++++++=
++++
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |  1 +
 2 files changed, 31 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net=
/wireless/mediatek/mt76/mt7915/init.c
index 250c2d2479b0..6568d7b6bc0a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -177,6 +177,25 @@ static const struct thermal_cooling_device_ops mt7915_=
thermal_ops =3D {
 =09.set_cur_state =3D mt7915_thermal_set_cur_throttle_state,
 };
=20
+static int mt7915_thermal_get_temp(struct thermal_zone_device *tz, int *te=
mp)
+{
+=09struct mt7915_phy *phy =3D thermal_zone_device_priv(tz);
+=09int val;
+
+=09mutex_lock(&phy->dev->mt76.mutex);
+=09val =3D mt7915_mcu_get_temperature(phy);
+=09mutex_unlock(&phy->dev->mt76.mutex);
+=09if (val < 0)
+=09=09return val;
+
+=09*temp =3D val * 1000;
+=09return 0;
+}
+
+static const struct thermal_zone_device_ops mt7915_tz_ops =3D {
+=09.get_temp =3D mt7915_thermal_get_temp,
+};
+
 static void mt7915_unregister_thermal(struct mt7915_phy *phy)
 {
 =09struct wiphy *wiphy =3D phy->mt76->hw->wiphy;
@@ -213,6 +232,17 @@ static int mt7915_thermal_init(struct mt7915_phy *phy)
 =09phy->throttle_temp[MT7915_CRIT_TEMP_IDX] =3D MT7915_CRIT_TEMP;
 =09phy->throttle_temp[MT7915_MAX_TEMP_IDX] =3D MT7915_MAX_TEMP;
=20
+=09phy->tzone =3D devm_thermal_of_zone_register(phy->dev->mt76.dev,
+=09=09=09=09=09=09   phy->mt76->band_idx, phy,
+=09=09=09=09=09=09   &mt7915_tz_ops);
+=09if (IS_ERR(phy->tzone)) {
+=09=09if (PTR_ERR(phy->tzone) !=3D -ENODEV)
+=09=09=09dev_warn(phy->dev->mt76.dev,
+=09=09=09=09 "failed to register thermal zone: %ld\n",
+=09=09=09=09 PTR_ERR(phy->tzone));
+=09=09phy->tzone =3D NULL;
+=09}
+
 =09if (!IS_REACHABLE(CONFIG_HWMON))
 =09=09return 0;
=20
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h b/drivers/n=
et/wireless/mediatek/mt76/mt7915/mt7915.h
index bf1d915a3ca2..92e0f9f0169c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
@@ -205,6 +205,7 @@ struct mt7915_phy {
=20
 =09struct ieee80211_vif *monitor_vif;
=20
+=09struct thermal_zone_device *tzone;
 =09struct thermal_cooling_device *cdev;
 =09u8 cdev_state;
 =09u8 throttle_state;

---
base-commit: ac798f757d6475dc6fee2ec899980d6740714596
change-id: 20260718-mt7915-thermal-zone-device-registration-e6d7bdc80aa5

Best regards,
-- =20
Ryan Leung <untilscour@protonmail.com>


