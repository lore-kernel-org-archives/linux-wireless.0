Received: from mta1.migadu.com (out-9.mta1.migadu.com [95.215.58.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3891A353A86
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 18:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787681842; cv=none; b=DUAsyK0zoKHT8TY5NwmR4xYuw+4HOZu6eusSkyaJRTOQPUAeAxnwpk7HkltdDtnqVSgZ89LtIl3Pdf6Lt4OI02caZlDjT1oe5haKdYmVgWNE5ruBHwsEJtQL4LaNw5scvg9dHvwhJPLg47O0d2qZ0i4UXOE5sF/KxVAmYJgC1j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787681842; c=relaxed/simple;
	bh=pKWQSQwhloU3UCIEHsjSAI70zbgmQD2DReSgXVQRLss=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g0ir6pb6ANypk00wAs+mn/i8sN2vsB/b11R/CnMytOLTYDtDgkYDEmzPeH8BLTakBs3WNbAlQpUpX3TGvFkslu9Xp/zEMgkYxmSQOrCB31QxVt7pPReDOSYw7FTzpVizMqfUy5kExgp8XSNEdKdkAVgS8binTp4HIknj2xG0Ens=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=EJ/mOqoZ; arc=none smtp.client-ip=95.215.58.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="EJ/mOqoZ"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=pKWQSQwhloU3UCIEHsjSAI70zbgmQD2DReSgXVQRLss=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787681836; v=1; x=1788286636;
 b=EJ/mOqoZ+3MOkD16zga+8Vp/045+ISk8lKiwywgT2lvax744TV/6PjPdxT70FPnL61gPofM2
 iboyQMF+4T36bLBFEfCpvKxR6MH2hD39JfikYHbih/8yH8s+6yjNrW6PzCkTGzOiHINVPe3oxga
 6rFBXSxPZrBdVeYWeGWZxzePEn0gPDi0mQ+Oiq+nRAAmL9eRXKy+PLpgAeYHcEWPGCUOQCq2Lje
 GdhXSjnp0f/Dnn4u/MHljGWlIe5paNbIVH90OLFNHw00qGO1Tf1EGx1vgXnMOmxXuaZfz20dQfv
 mhCDAtjzr23pFgoF+ge2vERKlH+XAbuEd0BEoXNfI0duA==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from fedora (2001:569:be59:c500:b340:3f2c:4486:21c1)
	by smtp.migadu.com with ESMTPS id c14991048ca0b0d5;
	Tue, 25 Aug 2026 18:17:16 +0000
X-Mizu-Trace-ID: c14991048ca0b0d5
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: Klara Modin <klarasmodin@gmail.com>,
	Charlie-cy Wu <Charlie-cy.Wu@mediatek.com>,
	JB Tsai <jb.tsai@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	regressions@lists.linux.dev
Subject: [PATCH wireless] wifi: mt76: mt792x: fix NULL dereference in ACPI SAR init during probe
Date: Tue, 25 Aug 2026 11:17:12 -0700
Message-ID: <20260825181712.28548-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some laptops carry a MediaTek power table in their firmware, and the
driver reads it to set a transmit limit for each frequency range. It
only fills in the ranges themselves when it registers the device.

The startup step that does this existed already, but it never programmed
anything. These two commits made it run a regulatory update instead,
which sets the limits on the way through, long before registration. So on
a machine that has the table the driver reads through an empty pointer
and the interface never appears:

  BUG: kernel NULL pointer dereference, address: 0000000000000004
  RIP: 0010:mt792x_init_acpi_sar_power
  Call Trace:
   mt7921_set_tx_sar_pwr
   mt7921_mcu_regd_update
   mt7921_regd_update
   mt7921_run_firmware
   mt7921e_mcu_init
   mt7921_init_work

Skip it when the ranges are missing. They are applied again once the
device is up, which is where they came from before.

Reported-by: Klara Modin <klarasmodin@gmail.com>
Closes: https://lore.kernel.org/linux-wireless/aoyxqHYvSuaBeubf@soda.int.kasm.eu/
Fixes: 9b80bd9cab40 ("wifi: mt76: mt7921: add regulatory wiphy self manager support")
Fixes: e9f3f1cc133f ("wifi: mt76: mt7925: add regulatory wiphy self manager support")
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---

Reproduced on both chips before sending, an MT7922 and an MT7925, and the
fix clears both. Neither machine here ships a vendor power table, so I
supplied one through an ACPI override in the initrd. It also wants recent
firmware. The June builds do not turn on self-managed regulatory and
nothing happens; the builds now in linux-firmware do, and then it dies
exactly as reported with no interface at all. Patched, both come up and
scan normally, and the injected limits still show through in the power
table afterwards, so the skip does not lose them.

With that table still in place and the fix absent, backing out the mt7921
commit on its own also boots clean, so the table is not what causes this.

 drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
index 946dd7956e4a..b468051fbe68 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
@@ -323,7 +323,8 @@ int mt792x_init_acpi_sar_power(struct mt792x_phy *phy, bool set_default)
 	const struct cfg80211_sar_capa *capa = phy->mt76->hw->wiphy->sar_capa;
 	int i;
 
-	if (!phy->acpisar || !((struct mt792x_acpi_sar *)phy->acpisar)->dyn)
+	if (!capa || !phy->acpisar ||
+	    !((struct mt792x_acpi_sar *)phy->acpisar)->dyn)
 		return 0;
 
 	/* When ACPI SAR enabled in HW, we should apply rules for .frp
-- 
2.55.0

