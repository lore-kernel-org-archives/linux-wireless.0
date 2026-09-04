Received: from layka.disroot.org (layka.disroot.org [178.21.23.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341D54E80AD;
	Fri,  4 Sep 2026 16:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.21.23.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788538746; cv=none; b=tE866Iqt7Fz03pL12mErQHxFhEwe9Ms/6OGPehOsHnsGaI+DxUnTrCGhCnp7CZDT8M/y2JmwS9UrbEcWOk8akVm4gy3Idrz6eV3JFAr3O+36nHjk94VPpDmP9NScNux93BlSOOrNV0dUigfR8nkcoQzrYgt1P1lDf3fKFlyrs+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788538746; c=relaxed/simple;
	bh=ohmGjWMsL6vjjMGZNVQu0SWcvRVkChE4rzh6U1/QCRY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kwT5SqVW4ahtbhMcUpcemlqN46AIg/cczZCXu4+C/3kxDQnMFlaWrBuWSE/WuffxkobkTMTNkuOyApjZimusX0B0epyELbuTvv8zGSFWAbR4kWScV6CpguPSAYX15Iaj42Yl2NAAiKtHaVkqzhJF7PW+etZuRqzRkaF8hTFostc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=disroot.org; spf=pass smtp.mailfrom=disroot.org; dkim=pass (2048-bit key) header.d=disroot.org header.i=@disroot.org header.b=EQ6zgXuw; arc=none smtp.client-ip=178.21.23.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=disroot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=disroot.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=disroot.org header.i=@disroot.org header.b="EQ6zgXuw"
Received: from mail01.layka.lan (localhost [127.0.0.1])
	by disroot.org (Postfix) with ESMTP id 30F9A88311;
	Fri, 04 Sep 2026 18:18:59 +0200 (CEST)
X-Virus-Scanned: SPAM Filter at disroot.org
Received: from layka.disroot.org ([127.0.0.1])
 by localhost (disroot.org [127.0.0.1]) (amavis, port 10024) with ESMTP
 id xyTBsbdPNoGd; Fri,  4 Sep 2026 18:18:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=disroot.org; s=mail;
	t=1788538738; bh=ohmGjWMsL6vjjMGZNVQu0SWcvRVkChE4rzh6U1/QCRY=;
	h=From:To:Cc:Subject:Date;
	b=EQ6zgXuwTQ82wOiZyQ6E8i6DqlzRPu//W/nf4fuT4brwPHkAwylddVIMOLB3IKeel
	 vTHBwNrx1ZTZQ0VgDlVsvivyoi651tUxon2upp04NTfzdUa1/BBeSkhE/QUiCHzolV
	 Et9Mapzd8nbCEetQ3IO3zoWKvvWATAJaB04Uo0BJ2BYl7S5U8lFMqj4rEvq+gKj5zL
	 WIC6bF55tcaQ29gdERCoYVhdvUgF/aNAqdUUZUPfnP4BPVhxeLclLvqO3kJ7ocib0v
	 tC8itd+PuePdghA0DYAKXXGNMkWFrkgdLSYrziPdZkNIAAcnRbIzphRmAdiIUaoREw
	 x1zIQFkK68pqw==
From: Marco Scardovi <scardracs@disroot.org>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Marco Scardovi <scardracs@disroot.org>
Subject: [PATCH] wifi: mt76: mt792x: fix NULL pointer dereference in mt792x_init_acpi_sar_power
Date: Fri,  4 Sep 2026 18:18:26 +0200
Message-ID: <20260904161826.5638-1-scardracs@disroot.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In mt792x_init_acpi_sar_power(), capa is obtained from
phy->mt76->hw->wiphy->sar_capa. On systems where ACPI SAR tables exist
(such as ASUS ROG laptops) but wiphy->sar_capa has not yet been
initialized (for instance, when a regulatory notifier triggers
mt7921_set_tx_sar_pwr() before the asynchronous dev->init_work
completes mt76_register_device()), capa is NULL.

Attempting to read capa->num_freq_ranges leads to a NULL pointer
dereference at offset 0x04:

  BUG: kernel NULL pointer dereference, address: 0000000000000004
  RIP: 0010:mt792x_init_acpi_sar_power+0x40/0x1ef [mt792x_lib]
  Call Trace:
   <TASK>
   mt792x_init_acpi_sar_power+0x40/0x1ef [mt792x_lib]
   mt7921_set_tx_sar_pwr+0x3b/0x70 [mt7921_common]
   mt7921_regd_notifier_work+0x1b/0x30 [mt7921_common]
   ...

Add a check for !capa and !phy->mt76->frp before dereferencing,
matching the existing defensive pattern in mt76/mac80211.c.

Fixes: f965333e491e ("mt76: mt7921: introduce ACPI SAR support")
Signed-off-by: Marco Scardovi <scardracs@disroot.org>
---
 drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
index 946dd7956e4a..fbc2f9706dd4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
@@ -326,6 +326,9 @@ int mt792x_init_acpi_sar_power(struct mt792x_phy *phy, bool set_default)
 	if (!phy->acpisar || !((struct mt792x_acpi_sar *)phy->acpisar)->dyn)
 		return 0;
 
+	if (!capa || !phy->mt76->frp)
+		return 0;
+
 	/* When ACPI SAR enabled in HW, we should apply rules for .frp
 	 * 1. w/o .sar_specs : set ACPI SAR power as the defatul value
 	 * 2. w/  .sar_specs : set power with min(.sar_specs, ACPI_SAR)
-- 
2.55.0
