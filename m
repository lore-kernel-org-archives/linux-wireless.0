Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA18370D79
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 07:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791703629; cv=none; b=pb7K0cOypAXJR4YhjX2uIeV5QejSPzuF0jAdXIrzn8x3T/M1KR1XSJturgC7r6eG/X+A65sBAhn8wtwDk2Y1f4kFhMTmOaMgkSCoMUcm/chB7XYzEcPFoSHlemS+/bKLAwMdodoOvyoXuSr0CFZZs/aTInVCq/aZmBMLhjMbKnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791703629; c=relaxed/simple;
	bh=UOfbUFof7bQELrXKlpIQigvZddXrnhkVeOF5d0Q2m5M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Bw5gAKUx30B73pt8HXvmQFJQmauZEHisRS8WcTmPBAZBX3QI5TGoZU7wf2+JRBqQUtsgcyS5ykvdZ4vXM7Ga9g+3yAyZBaHZqDtmH2D158uYbcFUX6vee/cY3iWGYDXKOqWAGoyazH9mHhaHzTJNVlOfccQpfScW8ERLwgJwRZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IvCSefCS; arc=none smtp.client-ip=74.125.82.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IvCSefCS"
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-35829219da8so882785eec.0
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 00:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791703627; x=1792308427; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zZL4B0ufB7ImjZOyPaceFQVkCDsgKxc3VmJ2EdFwwkA=;
        b=IvCSefCSMqd4Co5pmdFnGDIpRVkl5uV3bzJ2+vsLb13i+7bltUANnjvdrc5AmGMyBL
         J6pwTH/oTGklrzpPW4TfduoyyaOo86sOH5I+NfalhPj46OzR6Mh4xnm95600N9Fp1KSu
         96JA1ykPVbeRkxuthYFzgwZO9KycJ0OLcQhxNy7TGnY4OW95WKu4E6x0+c6Zppgc0206
         Wa8GiPedjUsuvY0Cy9hZm1Gm7kuOJTUkPshTB36xgXevpIM9ut0FunTNlF2wZOZCDJj3
         zitqfzuT9dwaxczPZtcuy5I39VOYrNlfG/6DbqkJhAFUsEs4a9VnOMJb2tvBvL+GDBtN
         8fTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791703627; x=1792308427;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zZL4B0ufB7ImjZOyPaceFQVkCDsgKxc3VmJ2EdFwwkA=;
        b=aQyNENaOpEwmIZHQ60H0a5XhJ6TR3icicTTzl6MqvMJENNfv+JJJkcXRuOvJ/cqEj9
         8ieKscS0sNvXKj/gbDK8bXN1peugbxr9yt8o+A7XBredsqTKz/er3CDVprF9fHDoDRIK
         N43v9rXxaX54EwLgtOiA+Z33flVrqfy6NvXSkbF1hBhcbZ37Zx0UNjJPVPpN46GKTLj6
         qscurJNQevnW1NWO2mpAU6tKSADRAXopGS3ZEbBPTqYXBtzzuQuZgdUcCtqr/Bg6cvqE
         iBBYmbVXrahefk4jYzG6uEGy4Bn7fMyv2pH+QtzRQ2Lt1me0IKF9kd4cn6Ub4Yq7Ujzn
         M50A==
X-Gm-Message-State: AFq9FYKILdFw6kWGKwcMx/qfkmHGhfuoklgEpzxyRx4J2gCqru3lgBUJ
	oLRKEqnaPZk5x3ArJvYTAJfCZPgU+xALyD1Pjzj2u2+I/8/NDEiiZu4WYcIr0Kab
X-Gm-Gg: AYBFou22aqB8CJznOXS7dgWALbNdS4I/xaBEaSIuHDWcfs7VKe3XmorAr3qCsJ4guus
	oNIMp45vXR17wejgiCeAIfJhiWO67MOb29ICh8G6+d7wkAPZDJSwAkfUxUwjOqxCLb5iFmHpnuV
	zM4yflbcJhDDSDthqt0C9sAAOISTOIqgJtmtRqajCAuoOlO9yrufLKVlw3siDN3gJfmACDDo3U0
	IGNK0KUa9mqjGdPaeKXUY2dI69T8R0DGFDpYRFNy6ZO8Y3s2BiXh+DsqE+7oIsfKa2pRlaCifWc
	zFRKh9ZFztM8kJgIqLnqBDdMnegrzPUmeQ2qQvHqJClmhNUl4OtwT0OwFNrehLkd7NJieUMVvGy
	syujwnbkomtu3BM8CH2XA8PAgH5QV5PQGTlLKka3/Dpk1qXPRqEL6cYKIQHqm2B+45ZbGR/4Tm0
	eqnkCWrzFfE8pEgg5zNWCxHRliNcG1rQaiDtoqfJgtGGQq69VZkWtK8UdPu0YRCk3X7SOGa1K01
	b0WiUxD8Ngig1JrvSJRkhTIKEQW67XQf0jxmUSueA==
X-Received: by 2002:a05:701b:454f:10b0:14e:5e6b:e6e2 with SMTP id a92af1059eb24-16a13a7b96emr8442345c88.18.1791703627110;
        Sun, 11 Oct 2026 00:27:07 -0700 (PDT)
Received: from DESKTOP-1E7V4GR.lan ([190.177.187.3])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a32eb7ebsm22855431c88.12.2026.10.11.00.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 00:27:06 -0700 (PDT)
From: Cristian Papa <pcristian292@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com,
	shayne.chen@mediatek.com,
	sean.wang@mediatek.com,
	linux-mediatek@lists.infradead.org
Subject: [PATCH] wifi: mt76: mt76x02: sync the group key PN before a restart
Date: Sun, 11 Oct 2026 04:27:02 -0300
Message-ID: <20261011072702.2535-1-pcristian292@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt76x02_key_sync() skips keys without a station, including the GTK of
an AP. The hardware advances its TX packet number without updating
key->tx_pn. When mac80211 reinstalls the key after a watchdog restart,
mt76x02_mac_wcid_set_key() writes that stale software value back to the
hardware IV table. Peers retaining the GTK can then reject group frames
as replays.

On an MT7612E AP, saved snapshots show the hardware PN of the same active
CCMP GTK falling from 6412 to 0 across two watchdog restarts, while its
software PN remained zero. The PMF pairwise keys continued to advance
their software counters.

Use the interface's group WCID for keys without a station. Keep the
key-index check so that, when two GTKs are installed, only the key
programmed into that WCID is synchronized. Also retain the sw_iv check
to avoid overwriting software-generated packet numbers, including those
used by PMF pairwise keys.

Fixes: 004960423fe1 ("mt76: mt76x2: implement full device restart on watchdog reset")
Assisted-by: LLM
Signed-off-by: Cristian Papa <pcristian292@gmail.com>

---
Reproduction: MT7612E in AP mode on an XR500v, using a locally patched
OpenWrt kernel 6.18.44 and mac80211 backports 7.2. The key-sync callback
has the same omission in the upstream base used here.

Validation:
- MIPS build against that kernel/backports: W=1 and the mt76 Makefile's
  -Werror, 11 modules built, no warnings or errors.
- Host tests compile the actual key-sync, key-install and PN helpers
  with emulated registers under ASan/UBSan. The baseline fails the
  captured 6412-PN regression; the candidate passes it and 12 test
  groups with 363 assertions, including two GTKs, PMF, two interfaces,
  repeated resets and rekey.
- On the router, with this change on top of the board's local patches,
  three watchdog restarts kept the hardware PN of the active GTK
  increasing (404 before, then 418, 421, 443 and 544 afterwards), and
  after the first restart the client still answered a ping to ff02::1
  without reconnecting. Without the change, the same PN went from 6412
  to 0, and no associated client answered ff02::1 until it reconnected,
  while unicast pings went through.
- After the third restart the client did stop receiving, for another
  reason: mac80211 kept it marked as asleep (WLAN_STA_PS_STA) and
  buffered its frames while it kept transmitting. That is a separate
  problem in the restart path and is not addressed here.

This change only includes the group key in the existing PN snapshot.
It does not change the watchdog's snapshot-before-MAC-stop ordering;
whether hardware can still advance PN in that interval is a separate
follow-up. It also does not change group-key selection or power save.

AI assistance was used to review the captures and source, draft the
change and message, and develop the host regression tests. No key
material or raw packet payload is included.

 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index dc7c03d2..ce4e0086 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -377,12 +377,13 @@ static void mt76x02_key_sync(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			     struct ieee80211_key_conf *key, void *data)
 {
 	struct mt76x02_dev *dev = hw->priv;
+	struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
 	struct mt76_wcid *wcid;
 
-	if (!sta)
-		return;
-
-	wcid = (struct mt76_wcid *)sta->drv_priv;
+	if (sta)
+		wcid = (struct mt76_wcid *)sta->drv_priv;
+	else
+		wcid = &mvif->group_wcid;
 
 	if (wcid->hw_key_idx != key->keyidx || wcid->sw_iv)
 		return;

base-commit: 2e6968e9286f3573016b9f804d4945373a21c489
-- 
2.47.3

