Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13A9441027;
	Tue, 28 Jul 2026 13:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785245701; cv=none; b=J2n96NW0Do6gQCebsq+R1MtM3U2irGi7u1X+B8n23X/Ct/K7biwBgyGqvHZ4i0M4pet+9rMZPAeLrn7tKSE+L6Zs00FpA8yFXYmgBvYOuJUXcnWSOyvZQOVTVwx1c82eNyls9yJ1Fj5fNFpo6NSVsy5UUNK4pIqpSq+QOdurafo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785245701; c=relaxed/simple;
	bh=a2S6vCE3iDAwe+kDTjY4Keao1IQoTBvTut2bSpMqDYA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l+l4hrdrgQ8dys1SuUDVZETt37I/BNFO/Lv/YPwUmTIhPlgI9WxG0WuroelOIic2thEoOvsLTsaXKOSyw2t/f80GEoeqCc/5lq0mjWcTkqfVjzUGR1/TVstfE2I8N6TldDeQepbd8KbP0A/hQ6geyfhD1k/LMOn7OPW2lgOXo5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=DLK7nH0O; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="DLK7nH0O"
Received: from LAPTOP-99KJFSET (unknown [58.241.16.34])
	by smtp.qiye.163.com (Hmail) with ESMTP id 47e1eefc9;
	Tue, 28 Jul 2026 21:34:48 +0800 (GMT+08:00)
From: Hongyan Xu <getshell@seu.edu.cn>
To: toke@toke.dk,
	afaerber@suse.de,
	mani@kernel.org
Cc: Hongyan Xu <getshell@seu.edu.cn>,
	linux-wireless@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-actions@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn
Subject: [PATCH RESEND] wifi: ath9k: stop using owl context after completion
Date: Tue, 28 Jul 2026 21:34:46 +0800
Message-ID: <20260728133446.692-1-getshell@seu.edu.cn>
X-Mailer: git-send-email 2.50.1.windows.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9fa8ef5fb103a1kunmeb964764f0b67
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDThpIVhhOGEhNTkJOGBhPH1YeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlOQ1VJT0pVSk1VSE9ZV1kWGg8SFR0UWUFZT0tIVUpLSUhOQ0
	NVSktLVUtZBg++
DKIM-Signature: a=rsa-sha256;
	b=DLK7nH0O0y1856fXuyimwMP3ntkX0q1we0WWMtzcvbSIfzrg6lIIz5GFLFI2YToPaIv61MzW8NH4iZ7rpvr29j7qX12AvJpjgzgSH2TMSzn8uZO/XuORxeya+8fLp17YLsEApGjZWCgrf+o0jMnSDklU1tFg84oTDPMgNnE4xhE=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=utXp4zcDsQfyziyaB24hBkxQ5Nu1E6Nzja5yWjMT/7w=;
	h=date:mime-version:subject:message-id:from;

owl_remove() waits for eeprom_load, but both owl_fw_cb() and
owl_nvmem_work() completed it before their last uses of ctx. The
devm-allocated context can therefore be freed while the async path still
dereferences it.

Take a pci_dev reference and copy ctx-owned pointers while ctx is still
protected. Complete only after ctx is no longer needed.
Keep the completion before owl_rescan(). Rescan can remove the device
synchronously.

This issue was found by a static analysis tool.

Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
---
Resend with Manivannan's current address. No code changes.

 .../wireless/ath/ath9k/ath9k_pci_owl_loader.c | 31 ++++++++++++-------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k_pci_owl_loader.c b/drivers/net/wireless/ath/ath9k/ath9k_pci_owl_loader.c
index fe1013a3a..1aefe21d2 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k_pci_owl_loader.c
+++ b/drivers/net/wireless/ath/ath9k/ath9k_pci_owl_loader.c
@@ -125,16 +125,19 @@ static void owl_rescan(struct pci_dev *pdev)
 static void owl_fw_cb(const struct firmware *fw, void *context)
 {
 	struct owl_ctx *ctx = context;
-
-	complete(&ctx->eeprom_load);
+	struct pci_dev *pdev = pci_dev_get(ctx->pdev);
 
 	if (fw) {
-		ath9k_pci_fixup(ctx->pdev, (const u16 *)fw->data, fw->size);
-		owl_rescan(ctx->pdev);
+		ath9k_pci_fixup(pdev, (const u16 *)fw->data, fw->size);
+		release_firmware(fw);
+		complete(&ctx->eeprom_load);
+		owl_rescan(pdev);
 	} else {
-		dev_err(&ctx->pdev->dev, "no eeprom data received.\n");
+		dev_err(&pdev->dev, "no eeprom data received.\n");
+		complete(&ctx->eeprom_load);
 	}
-	release_firmware(fw);
+
+	pci_dev_put(pdev);
 }
 
 static const char *owl_get_eeprom_name(struct pci_dev *pdev)
@@ -158,19 +161,23 @@ static const char *owl_get_eeprom_name(struct pci_dev *pdev)
 static void owl_nvmem_work(struct work_struct *work)
 {
 	struct owl_ctx *ctx = container_of(work, struct owl_ctx, work);
+	struct pci_dev *pdev = pci_dev_get(ctx->pdev);
+	struct nvmem_cell *cell = ctx->cell;
 	void *buf;
 	size_t len;
 
-	complete(&ctx->eeprom_load);
-
-	buf = nvmem_cell_read(ctx->cell, &len);
+	buf = nvmem_cell_read(cell, &len);
 	if (!IS_ERR(buf)) {
-		ath9k_pci_fixup(ctx->pdev, buf, len);
+		ath9k_pci_fixup(pdev, buf, len);
 		kfree(buf);
-		owl_rescan(ctx->pdev);
+		complete(&ctx->eeprom_load);
+		owl_rescan(pdev);
 	} else {
-		dev_err(&ctx->pdev->dev, "no nvmem data received.\n");
+		dev_err(&pdev->dev, "no nvmem data received.\n");
+		complete(&ctx->eeprom_load);
 	}
+
+	pci_dev_put(pdev);
 }
 
 static int owl_nvmem_probe(struct owl_ctx *ctx)
-- 
2.50.1.windows.1
