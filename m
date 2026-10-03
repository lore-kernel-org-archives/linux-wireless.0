Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8A32FE07D;
	Sat,  3 Oct 2026 04:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791000077; cv=none; b=XmcGNdJ3Y2jHCQJnilxROyTpcvxrX491zmyew+TYnHTDIfMeM8jVWIam81zTlKYHuFzelxsjqsSHuMxvjTun2F2d9hSbye8yoqCk7idXEoOfNqahgnZsEBqkP4w0HGg6jo0ZZmeOff847fpt80VxVL67iLWWJjyLnAP0rvIKQKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791000077; c=relaxed/simple;
	bh=f5h6+uE//hPuyiaEYnN+lMXschfoTE+xy8vqFBa4O5g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=i4eh7ewVRq3NfK7SeSDKKDWqNAS0pR5G9Y5cloHQ4X+DbmSVQy7YRkZGrHWitRBvFPHQQU8UTa8upF4h2kT6/PyHbKb4jecZWkaYB/8HmfO1RcEhprJP2erLt0nDQzXfRxsCEP/xHQ+ORXOBr8+2SqrJy4k7IHzHN2PNjQRFm0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UUQvAwtp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UUQvAwtp"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6AE36C2BCB9;
	Sat,  3 Oct 2026 04:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791000077;
	bh=f5h6+uE//hPuyiaEYnN+lMXschfoTE+xy8vqFBa4O5g=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=UUQvAwtpZ67DrttWtT8aFsfJ3MSvBzkqi/NY8s8ra9IBzztXJeRXqgmANUJGFLqiJ
	 J1tzPqRtbTkcVSBFTSeSAGeVTE8m16Mk6pmo7YZZvLlYU5+5HOFUWwRsCF1NP6gJgw
	 6HTKoF3PTG/F4/825sWPA7kyIBlAq0fq4xmhROowSY6lD61C08FjrWFG6DipHTqGLW
	 aUdl5uhuiG12D9HvHpDpyl/Nm9BBBzZ03qL18iiGWiuChDuiX9sioLB2z88H87UlpR
	 Zvv/YvN4kmwd8BX+3sW5SfaMGKiuJqsHdZyJOEVFbfug5IudQl1qTn7QhVFxVICN33
	 ZE1xosRNVH+ZQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 553D8CA5FE3;
	Sat,  3 Oct 2026 04:01:17 +0000 (UTC)
From: Ryan Leung via B4 Relay <devnull+untilscour.protonmail.com@kernel.org>
Date: Sat, 03 Oct 2026 04:01:04 +0000
Subject: [PATCH mt76 v4] wifi: mt76: mt7915: fix thermal zone
 use-after-free
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-mt7915-unregister-thermal-v4-1-8ed55f6f5535@protonmail.com>
X-B4-Tracking: v=1; b=H4sIAP99wGoC/43OQQ7CIBAF0KsY1mKAlpG68h7GBaWDxdhiABtN0
 7tL68KFxricyfz3ZyQRg8NIdquRBBxcdL7PQ7leEdPq/oTUNXkmgglgilW0S9uKS3rrA55cTBh
 oajF0+kKVQMWkAa40kJy/BrTuvtgHkmNAjq9tvNVnNGlm57s2Mz48lhcGvly/2jj70TZwyqmBR
 m7r0tQFqP01+OT7TrvLxvhuKRvE35zInNDMSq4bK8F+5Yo3VzH4xRWZQ1uLhgECt+UHN03TE9o
 kqjF9AQAA
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791000078; l=3169;
 i=untilscour@protonmail.com; s=20260906; h=from:subject:message-id;
 bh=GpWxbqGcv8Ae741uGW3yrEwKs0Hqc32weJvR+Cw/Ptw=;
 b=Yz0bH8whhpFsbkVm/I35YXyLgLMvRcSrLMcj2NqZlsRJ2e4NG1sVSXkkZjL5bfU2O/yIjAk8U
 r1jBTk14M7NC5iAySPa195W2H6E2GgIu2Bdmk/qIiMR9j1b2SATFUzd
X-Developer-Key: i=untilscour@protonmail.com; a=ed25519;
 pk=eCaNcoQNRWYKZ9D7KbOGKvQVK2YFguJXZxglTtAR7Xk=
X-Endpoint-Received: by B4 Relay for untilscour@protonmail.com/20260906
 with auth_id=1011
X-Original-From: Ryan Leung <untilscour@protonmail.com>
Reply-To: untilscour@protonmail.com

From: Ryan Leung <untilscour@protonmail.com>

The thermal zone registered via devm_thermal_of_zone_register() on the
parent device is never torn down when the phy is unregistered, so the
thermal core can still dereference it after the phy is freed.

Unregister the thermal zone alongside the cooling device in
mt7915_unregister_thermal(). Also clear phy->tzone and phy->cdev after
unregistering so the function is safe to call when only a subset of
the objects were registered, e.g. after a partially failed
mt7915_thermal_init().

While at it, include the band index in the thermal zone registration
warning to help identify which band failed on multi-band chips.

Fixes: 313f1a27ebcb ("wifi: mt76: mt7915: add thermal zone device registration")
Signed-off-by: Ryan Leung <untilscour@protonmail.com>
---
Changes in v4:
- Drop the mt7915_unregister_thermal() call on the hwmon failure path
  which was added in commit
  https://github.com/nbd168/wireless/commit/0438f51a9af4b5138d1d7117fa8343bbe6fa32f0
  ("wifi: mt76: mt7915: unregister thermal cooling device on hwmon failure")
- Update commit message: remove the now-fixed hwmon failure leak
  description and reword accordingly.
- Link to v3: https://patch.msgid.link/20260906-mt7915-unregister-thermal-v3-1-efb2d06e61f4@protonmail.com

Changes in v3:
- Clear phy->tzone/phy->cdev in mt7915_unregister_thermal() after
  unregistering, making it idempotent.
- Link to v2: https://patch.msgid.link/20260810-mt7915-unregister-thermal-v2-1-2a0f51adf56f@protonmail.com

Changes in v2:
- Unwind cdev/tzone registration in mt7915_thermal_init() on hwmon registration failure.
- Link to v1: https://patch.msgid.link/20260810-mt7915-unregister-thermal-v1-1-c6d57b4cb368@protonmail.com
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index ca46a203aa48..1f1f0c109c83 100644
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
@@ -238,8 +244,8 @@ static int mt7915_thermal_init(struct mt7915_phy *phy)
 	if (IS_ERR(phy->tzone)) {
 		if (PTR_ERR(phy->tzone) != -ENODEV)
 			dev_warn(phy->dev->mt76.dev,
-				 "failed to register thermal zone: %ld\n",
-				 PTR_ERR(phy->tzone));
+				 "failed to register thermal zone %d: %ld\n",
+				 phy->mt76->band_idx, PTR_ERR(phy->tzone));
 		phy->tzone = NULL;
 	}
 

---
base-commit: f49defea7668d8c68ec19fa085ef3da6075561c7
change-id: 20260809-mt7915-unregister-thermal-82e805c618a6

Best regards,
--  
Ryan Leung <untilscour@protonmail.com>


