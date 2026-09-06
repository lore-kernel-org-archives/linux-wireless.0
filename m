Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8862F37A836;
	Sun,  6 Sep 2026 21:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788730933; cv=none; b=Pv9DzqlWeGXDx02J+ICMEfcrjl11TvcShJ3rfUg6LCS4IHjzH0xz0pVn2eKJrr+Qjdr3VoCMDZMbzRYFppa6NrTstj8pY/qv7jhg5w3S+EHl5EHLZqu/GETi09x3cadv8cpq2dGVN2UCjkCrWbb/X5JJeXm/EPy4h0qHOEJ6w80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788730933; c=relaxed/simple;
	bh=VDyD8iz27wa8NflmbwW9hSRSzq083qvoKr4XfLGVGsI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=swKLonwGcJnlsDOVNL0BoCK90zJqC+YWbyLdsgEbHKxs8vAbBY0SioA36l2HvsbZRV/GgDJOf306Wkvm/dqH3pFAnxFxam4iPBsz+mcImlSoKD9dELgCB/ESRbC7z8Q5qvBYxsr1bl7ZghgyHW/FaOKoJw8aATRZ+XaPJCmArzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HQ/eXign; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HQ/eXign"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 93B42C2BCB8;
	Sun,  6 Sep 2026 21:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788730932;
	bh=VDyD8iz27wa8NflmbwW9hSRSzq083qvoKr4XfLGVGsI=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=HQ/eXign/Grhh0PdGupiqE1shMHQ839pzqGbBb+OehVwes9/jQa4DQYYcfYsduwh4
	 fFY34HYh7XmYBvjitzo3DQxcK0vdc4A4hNI6VffPNyFthUtYBhIh7ujhkbRA9BLwqX
	 kminqD97H5sydabRSwtiErTWLx92IFmCYRF0Wo3RL+BlwfvEIlRbqHBfHPxsuoLiXg
	 zLHBNAb2q8sJmXrWHrXeFu1yL20lzxHqdzpk+lsBsDlkZcEvk+uQazkcEc/j5rJARa
	 +aJztckUeA0M53W0ooV2vZRa3mt4HzAzqBOTMPQxh7dgKSR24rHrwdwCDwxPVVGTBe
	 snEzGBJE4XIBw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CBF7C79F8C;
	Sun,  6 Sep 2026 21:42:12 +0000 (UTC)
From: Ryan Leung via B4 Relay <devnull+untilscour.protonmail.com@kernel.org>
Date: Sun, 06 Sep 2026 21:42:06 +0000
Subject: [PATCH mt76 v3] wifi: mt76: mt7915: fix thermal zone
 use-after-free and cooling device leak
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260906-mt7915-unregister-thermal-v3-1-efb2d06e61f4@protonmail.com>
X-B4-Tracking: v=1; b=H4sIAC3enWoC/42OQQ6DIBBFr2JYlwawIHbVezRdII5Ko2AATRvj3
 Yu6bNJ0+Sf/vzcLCuANBHTNFuRhNsE4m0J+ypDulG0BmzplxAgTRJISD7EoKceT9dCaEMHj2IE
 fVI8lA0m4FlQqgdJ+9NCY186+ozQT6HFcw1Q9QccNu/W6hHH+vb8w07192Cj5YZsppliLmhfVR
 Ve5kLfRu+jsoEx/1m7YZTP7G8cSjinScKrqhovmC7eu6wdbFVLDLgEAAA==
X-Change-ID: 20260809-mt7915-unregister-thermal-82e805c618a6
To: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, 
 Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, 
 Sean Wang <sean.wang@mediatek.com>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
 Ryan Leung <untilscour@protonmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788730934; l=3446;
 i=untilscour@protonmail.com; s=20260906; h=from:subject:message-id;
 bh=jg+VrZXwazJVrct69E59ekan8eJXBrNoBIRKgj68l10=;
 b=x0FHS3zeNHr8A2J5GkukmZc+dv0Tf0y/xb73NXQoLHXl+rMbmkLv3Ip73CTp8uRdJ87MOUzDI
 6LOHGLHUKcRBQjZ36TG1u1kk3G9PC4jq4R2mfU36LyzCQZS0BvQnaVt
X-Developer-Key: i=untilscour@protonmail.com; a=ed25519;
 pk=eCaNcoQNRWYKZ9D7KbOGKvQVK2YFguJXZxglTtAR7Xk=
X-Endpoint-Received: by B4 Relay for untilscour@protonmail.com/20260906
 with auth_id=1011
X-Original-From: Ryan Leung <untilscour@protonmail.com>
Reply-To: untilscour@protonmail.com

From: Ryan Leung <untilscour@protonmail.com>

The thermal zone registered against the parent device is never torn
down when the phy is unregistered, so it can still be dereferenced
by the thermal core after the phy is freed. The thermal zone and
cooling device are also left registered if a later hwmon
registration step fails during init, leaking both.

Unregister the thermal zone alongside the cooling device on both the
regular unregister path and the init failure path. Also clear
phy->tzone and phy->cdev after unregistering so that a future caller
invoking the function twice doesn't unregister already-freed objects.

While at it, include the band index in the thermal zone registration
warning to help identify which band failed on multi-band chips.

Fixes: 313f1a27ebcb ("wifi: mt76: mt7915: add thermal zone device registration")
Signed-off-by: Ryan Leung <untilscour@protonmail.com>
---
Changes in v3:
- Clear phy->tzone/phy->cdev in mt7915_unregister_thermal() after
  unregistering, making it idempotent.
- Link to v2: https://patch.msgid.link/20260810-mt7915-unregister-thermal-v2-1-2a0f51adf56f@protonmail.com

Changes in v2:
- Unwind cdev/tzone registration in mt7915_thermal_init() on hwmon registration failure.
- Link to v1: https://patch.msgid.link/20260810-mt7915-unregister-thermal-v1-1-c6d57b4cb368@protonmail.com
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index ca46a203aa48..e5285d1a1f9d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -200,11 +200,17 @@ static void mt7915_unregister_thermal(struct mt7915_phy *phy)
 {
 	struct wiphy *wiphy = phy->mt76->hw->wiphy;
 
+	if (phy->tzone) {
+		devm_thermal_of_zone_unregister(phy->dev->mt76.dev, phy->tzone);
+		phy->tzone = NULL;
+	}
+
 	if (!phy->cdev)
 		return;
 
 	sysfs_remove_link(&wiphy->dev.kobj, "cooling_device");
 	thermal_cooling_device_unregister(phy->cdev);
+	phy->cdev = NULL;
 }
 
 static int mt7915_thermal_init(struct mt7915_phy *phy)
@@ -213,6 +219,7 @@ static int mt7915_thermal_init(struct mt7915_phy *phy)
 	struct thermal_cooling_device *cdev;
 	struct device *hwmon;
 	const char *name;
+	int ret;
 
 	name = devm_kasprintf(&wiphy->dev, GFP_KERNEL, "mt7915_%s",
 			      wiphy_name(wiphy));
@@ -238,8 +245,8 @@ static int mt7915_thermal_init(struct mt7915_phy *phy)
 	if (IS_ERR(phy->tzone)) {
 		if (PTR_ERR(phy->tzone) != -ENODEV)
 			dev_warn(phy->dev->mt76.dev,
-				 "failed to register thermal zone: %ld\n",
-				 PTR_ERR(phy->tzone));
+				 "failed to register thermal zone %d: %ld\n",
+				 phy->mt76->band_idx, PTR_ERR(phy->tzone));
 		phy->tzone = NULL;
 	}
 
@@ -248,7 +255,11 @@ static int mt7915_thermal_init(struct mt7915_phy *phy)
 
 	hwmon = devm_hwmon_device_register_with_groups(&wiphy->dev, name, phy,
 						       mt7915_hwmon_groups);
-	return PTR_ERR_OR_ZERO(hwmon);
+	ret = PTR_ERR_OR_ZERO(hwmon);
+	if (ret)
+		mt7915_unregister_thermal(phy);
+
+	return ret;
 }
 
 static void mt7915_led_set_config(struct led_classdev *led_cdev,

---
base-commit: 1b60ed34f712e9f606d80951f1586f4274ebadf1
change-id: 20260809-mt7915-unregister-thermal-82e805c618a6

Best regards,
--  
Ryan Leung <untilscour@protonmail.com>


