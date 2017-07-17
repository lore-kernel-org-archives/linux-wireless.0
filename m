Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:45430 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751311AbdGQQlA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 12:41:00 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 24/29] brcmfmac: Rename chip.ctx -> chip.bus_priv
Date: Mon, 17 Jul 2017 17:16:32 +0100
Message-Id: <20170717161637.4652-25-ian@mnementh.co.uk> (sfid-20170717_184104_461698_0257912D)
In-Reply-To: <20170717161637.4652-1-ian@mnementh.co.uk>
References: <20170717161637.4652-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This driver uses the label ctx like its going out of fashion.

Lets rename this usage of it so that its easier to see whats going on.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    | 24 +++++++++++-----------
 .../wireless/broadcom/brcm80211/brcmfmac/chip.h    | 16 +++++++--------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index bab1bb3e99ae..ae21f16b31de 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -225,18 +225,18 @@ struct sbsocramregs {
 
 static inline int brcmf_readl(struct brcmf_chip *chip, u32 addr)
 {
-	return chip->ops->read32(chip->ctx, addr);
+	return chip->ops->read32(chip->bus_priv, addr);
 }
 
 static inline void brcmf_writel(struct brcmf_chip *chip, u32 addr, u32 v)
 {
-	chip->ops->write32(chip->ctx, addr, v);
+	chip->ops->write32(chip->bus_priv, addr, v);
 }
 
 static inline void brcmf_writelp(struct brcmf_chip *chip, u32 addr, u32 v)
 {
-	chip->ops->write32(chip->ctx, addr, v);
-	chip->ops->read32(chip->ctx, addr);
+	chip->ops->write32(chip->bus_priv, addr, v);
+	chip->ops->read32(chip->bus_priv, addr);
 }
 
 static void brcmf_clear_bits(struct brcmf_chip *ci, u32 reg, u32 bits)
@@ -1025,7 +1025,7 @@ static int brcmf_chip_probe(struct brcmf_chip *ci)
 	 * specific reset at this point.
 	 */
 	if (ci->ops->reset) {
-		ci->ops->reset(ci->ctx, ci);
+		ci->ops->reset(ci->bus_priv, ci);
 		brcmf_chip_set_passive(ci);
 	}
 
@@ -1097,12 +1097,12 @@ static int brcmf_chip_setup(struct brcmf_chip *chip)
 
 	/* execute bus core specific setup */
 	if (chip->ops->setup)
-		ret = chip->ops->setup(chip->ctx, chip);
+		ret = chip->ops->setup(chip->bus_priv, chip);
 
 	return ret;
 }
 
-struct brcmf_chip *brcmf_chip_attach(void *ctx,
+struct brcmf_chip *brcmf_chip_attach(void *bus_priv,
 				     const struct brcmf_buscore_ops *ops)
 {
 	struct brcmf_chip *chip;
@@ -1126,9 +1126,9 @@ struct brcmf_chip *brcmf_chip_attach(void *ctx,
 	INIT_LIST_HEAD(&chip->cores);
 	chip->num_cores = 0;
 	chip->ops = ops;
-	chip->ctx = ctx;
+	chip->bus_priv = bus_priv;
 
-	err = ops->prepare(ctx);
+	err = ops->prepare(bus_priv);
 	if (err < 0)
 		goto fail;
 
@@ -1249,7 +1249,7 @@ static bool brcmf_chip_cm3_set_active(struct brcmf_chip *chip)
 		return false;
 	}
 
-	chip->ops->activate(chip->ctx, chip, 0);
+	chip->ops->activate(chip->bus_priv, chip, 0);
 
 	core = brcmf_chip_get_core(chip, BCMA_CORE_ARM_CM3);
 	brcmf_chip_resetcore(core, 0, 0, 0);
@@ -1275,7 +1275,7 @@ static bool brcmf_chip_cr4_set_active(struct brcmf_chip *chip, u32 rstvec)
 {
 	struct brcmf_core *core;
 
-	chip->ops->activate(chip->ctx, chip, rstvec);
+	chip->ops->activate(chip->bus_priv, chip, rstvec);
 
 	/* restore ARM */
 	core = brcmf_chip_get_core(chip, BCMA_CORE_ARM_CR4);
@@ -1302,7 +1302,7 @@ static bool brcmf_chip_ca7_set_active(struct brcmf_chip *chip, u32 rstvec)
 {
 	struct brcmf_core *core;
 
-	chip->ops->activate(chip->ctx, chip, rstvec);
+	chip->ops->activate(chip->bus_priv, chip, rstvec);
 
 	/* restore ARM */
 	core = brcmf_chip_get_core(chip, BCMA_CORE_ARM_CA7);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.h
index 0babb328d155..8698abfb806e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.h
@@ -50,7 +50,7 @@ struct brcmf_chip {
 	void (*resetcore)(struct brcmf_core *core, u32 prereset, u32 reset,
 				u32 postreset);
 
-	void *ctx;
+	void *bus_priv;
 
 	u32 chip;
 	u32 chiprev;
@@ -94,15 +94,15 @@ struct brcmf_core {
  *	The callback should use the provided @rstvec when non-zero.
  */
 struct brcmf_buscore_ops {
-	u32 (*read32)(void *ctx, u32 addr);
-	void (*write32)(void *ctx, u32 addr, u32 value);
-	int (*prepare)(void *ctx);
-	int (*reset)(void *ctx, struct brcmf_chip *chip);
-	int (*setup)(void *ctx, struct brcmf_chip *chip);
-	void (*activate)(void *ctx, struct brcmf_chip *chip, u32 rstvec);
+	u32 (*read32)(void *bus_priv, u32 addr);
+	void (*write32)(void *bus_priv, u32 addr, u32 value);
+	int (*prepare)(void *bus_priv);
+	int (*reset)(void *bus_priv, struct brcmf_chip *chip);
+	int (*setup)(void *bus_priv, struct brcmf_chip *chip);
+	void (*activate)(void *bus_priv, struct brcmf_chip *chip, u32 rstvec);
 };
 
-struct brcmf_chip *brcmf_chip_attach(void *ctx,
+struct brcmf_chip *brcmf_chip_attach(void *bus_priv,
 				     const struct brcmf_buscore_ops *ops);
 void brcmf_chip_detach(struct brcmf_chip *chip);
 struct brcmf_core *brcmf_chip_get_core(struct brcmf_chip *chip, u16 coreid);
-- 
2.11.0
