Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D76342CAE1;
	Tue, 28 Jul 2026 12:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785242078; cv=none; b=T+DNm7Eh/R5KK7dhQtRomSHsJokoIW0I6U7fz6LBxJHxPYt2FDKYBUp0x35603+Wx91pIkxAbIvC3+4gdA3iPBc9CTms7j8E4RRD/QBbXna68DeM198zyh57A61vHvD/jRhopGKFMNW0emBbu5kwRxFlXYJzH5WN2ZtWPLCtaIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785242078; c=relaxed/simple;
	bh=FO7pGZ0sGmUgpdr5xTzRior0w+Weimod0/JVDbo0Bfs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NxwHS/8a6CY6eHpr3Yc4Zly0BFjwDIYK7NzEx1feF0bYlXLJ0jP89mvwikpZUYd6PrVNQkj4eihLZUX6j/vg0iS5pYYgOCOL7qJLe9T8W92GD0uVaDDTPmCUakEXQD6x4iJJUlHNal/lw18dpWMueOktXsnJIuHMADgrVg+7xs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=jIzPNX0d; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="jIzPNX0d"
Received: from LAPTOP-99KJFSET (unknown [221.228.238.82])
	by smtp.qiye.163.com (Hmail) with ESMTP id 47e10a915;
	Tue, 28 Jul 2026 20:34:29 +0800 (GMT+08:00)
From: Hongyan Xu <getshell@seu.edu.cn>
To: toke@toke.dk,
	afaerber@suse.de,
	manivannan.sadhasivam@linaro.org
Cc: Hongyan Xu <getshell@seu.edu.cn>,
	linux-wireless@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-actions@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn
Subject: [PATCH] wifi: ath9k: stop using owl context after completion
Date: Tue, 28 Jul 2026 20:33:42 +0800
Message-ID: <20260728123423.781-8-getshell@seu.edu.cn>
X-Mailer: git-send-email 2.50.1.windows.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9fa8b82b5203a1kunm4c64fbaeeecfc
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZGUkdVkgaGRpKQh4YGUNOTFYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUpVSUlDVUlIQ1VDSVlXWRYaDxIVHRRZQVlPS0hVSktJSE
	5DQ1VKS0tVS1kG
DKIM-Signature: a=rsa-sha256;
	b=jIzPNX0d6vYqddve/BIhGHXOgDi5p/DvXpxrDoJWtQ1KhQPMmyEIXs+VMkzqy9mqsWzAYo68vZUC59WTQiHH+0BZQIVujn1neisnjG1aTENWabywT19MkcPupNViVRuwuqc/tYTb/wNWK3DiqdlfqEqTLUwTjHXlR/WSajiwzqc=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=Mlk8JJ7FnZcQE8p0F+cUnb6w0Q/i8g6DjL1yyVN33cA=;
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
