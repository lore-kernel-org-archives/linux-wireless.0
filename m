Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6042637B021;
	Mon,  3 Aug 2026 10:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785752262; cv=none; b=PSIwJ7S3Ta6MM8QV13OYlZWmWbny4ufsX6+yCDKhF8foEkC2w/5SnjlYZVyoUOe9TIPNR95NzsMQ7iKDwinJfRe6UHL+CxEo459cB2DAl0dc3129AxIngNIlHcecKzzloN/4nndt3bFuOZFPZgwDZ7jqFJFlJKz8xon6MkEstwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785752262; c=relaxed/simple;
	bh=R2j2jo01yIAtEiNFhUo1msrdmGjaHJaGeQvs/2uWMq0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Czm95KalKpr7QPK42zbbeHrXuGgsDRalX0rd0t/WmCoFZHQL/h3h2nvK7JeHoIerP4YB6Fn2tv3CvNnd7SR1rYXj7qyjew91wyIgeKj84SGf2Iu2I//4AkfAdraD0Tlq9fMidPV/7WluUg5KdS7bJo8Wkp1xvsaaQUuUOeCQklw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mB9uPx/I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mB9uPx/I"
Received: by smtp.kernel.org (Postfix) with ESMTPS id DE65FC2BCB9;
	Mon,  3 Aug 2026 10:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785752261;
	bh=R2j2jo01yIAtEiNFhUo1msrdmGjaHJaGeQvs/2uWMq0=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=mB9uPx/IwYOylnqrQ8G/uEcfr9J3OwSD9eBzoJIIXKxVYCpw5dNOQhu1Rg3C85nyb
	 1urIzal/ssgE0t24tO5GeWAyJxiqs42p4mFk6UEXnZYVQyaAVIsDJS9q9k/ZXYEjHk
	 hz2wWeaY4zfwoqvRPdo27rLkd4C726FgxwLLOaLNnOG5k4Fmsu/BOetk2zPOQkyAC/
	 MUKIlfx6xWeoYUjRHGKjPjXMVSbPb+uUJoG/HRUZQKJmp9uvH9tgyb36BEglUqkjat
	 GE9hYDxvrBtfKVFSZOe4yFzZUX2FYRdc6rmX7k0E0pwjrzovW1Mb7P9hvYZ8h1wpes
	 q2SGSmbLwjGcg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA66EC5518F;
	Mon,  3 Aug 2026 10:17:41 +0000 (UTC)
From: Markuss Broks via B4 Relay <devnull+markuss.broks.gmail.com@kernel.org>
Date: Mon, 03 Aug 2026 13:17:41 +0300
Subject: [PATCH] brcmfmac: Add support for BCM4361 PCIe chipset
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260803-broadcom-staging-v1-1-f6f77e55b72e@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMTQ7CIBBA4as0s5YEaVHxKo0LfgYcE8Ew2DRpe
 ndRl9/ivQ0YKyHDddig4kJMJXccDwP4u80JBYVuUFKd5EWOwtVigy9Pwc0mykloY8/BRK2Nm6B
 nr4qR1t9yvv3Nb/dA374f2PcPStFnTHQAAAA=
X-Change-ID: 20260803-broadcom-staging-59a7d9f559b4
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev, 
 brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org, 
 Markuss Broks <markuss.broks@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785752260; l=4130;
 i=markuss.broks@gmail.com; s=20260803; h=from:subject:message-id;
 bh=wojphpqxOjYA3sK/i1dqEbMhbU33wHBn+bfOlTOLYLE=;
 b=3WKR18P/KHGM4Qxj2KwWl1MU0Y1S7/U7XRacy8VELpCWIo7m9S4DtANAPr8kBtUupzpYFpC86
 FN53afGJxtwA+OFfM2gs1pLo8hoUD4RfcgAwFVkORaow9HUxTq6pqsn
X-Developer-Key: i=markuss.broks@gmail.com; a=ed25519;
 pk=oKzGUTm30BCDqinRMpiHQqByOx1mp2mwmhg80Mv7Zg4=
X-Endpoint-Received: by B4 Relay for markuss.broks@gmail.com/20260803 with
 auth_id=911
X-Original-From: Markuss Broks <markuss.broks@gmail.com>
Reply-To: markuss.broks@gmail.com

From: Markuss Broks <markuss.broks@gmail.com>

Those are the required changes for the BCM4361 PCIe chipset support.

Signed-off-by: Markuss Broks <markuss.broks@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c       | 3 +++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c       | 3 +++
 drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 2 ++
 3 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index 4adc0d0e4251..97120a659f8b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -735,6 +735,8 @@ static u32 brcmf_chip_tcm_rambase(struct brcmf_chip_priv *ci)
 	case BRCM_CC_4355_CHIP_ID:
 	case BRCM_CC_4359_CHIP_ID:
 		return (ci->pub.chiprev < 9) ? 0x180000 : 0x160000;
+	case BRCM_CC_4361_CHIP_ID:
+		return 0x170000;
 	case BRCM_CC_4364_CHIP_ID:
 	case CY_CC_4373_CHIP_ID:
 		return 0x160000;
@@ -1466,6 +1468,7 @@ bool brcmf_chip_sr_capable(struct brcmf_chip *pub)
 		reg = chip->ops->read32(chip->ctx, addr);
 		return (reg & CC_SR_CTL0_ENABLE_MASK) != 0;
 	case BRCM_CC_4359_CHIP_ID:
+	case BRCM_CC_4361_CHIP_ID:
 	case BRCM_CC_43751_CHIP_ID:
 	case BRCM_CC_43752_CHIP_ID:
 	case CY_CC_43012_CHIP_ID:
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 55f4d7b970f2..914ae72a7b74 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -59,6 +59,7 @@ BRCMF_FW_CLM_DEF(43570, "brcmfmac43570-pcie");
 BRCMF_FW_DEF(4358, "brcmfmac4358-pcie");
 BRCMF_FW_DEF(4359, "brcmfmac4359-pcie");
 BRCMF_FW_DEF(4359C, "brcmfmac4359c-pcie");
+BRCMF_FW_CLM_DEF(4361, "brcmfmac4361-pcie");
 BRCMF_FW_CLM_DEF(4364B2, "brcmfmac4364b2-pcie");
 BRCMF_FW_CLM_DEF(4364B3, "brcmfmac4364b3-pcie");
 BRCMF_FW_DEF(4365B, "brcmfmac4365b-pcie");
@@ -98,6 +99,7 @@ static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 	BRCMF_FW_ENTRY(BRCM_CC_4358_CHIP_ID, 0xFFFFFFFF, 4358),
 	BRCMF_FW_ENTRY(BRCM_CC_4359_CHIP_ID, 0x000001FF, 4359),
 	BRCMF_FW_ENTRY(BRCM_CC_4359_CHIP_ID, 0xFFFFFE00, 4359C),
+	BRCMF_FW_ENTRY(BRCM_CC_4361_CHIP_ID, 0xFFFFFFFF, 4361),
 	BRCMF_FW_ENTRY(BRCM_CC_4364_CHIP_ID, 0x0000000F, 4364B2), /* 3 */
 	BRCMF_FW_ENTRY(BRCM_CC_4364_CHIP_ID, 0xFFFFFFF0, 4364B3), /* 4 */
 	BRCMF_FW_ENTRY(BRCM_CC_4365_CHIP_ID, 0x0000000F, 4365B),
@@ -2747,6 +2749,7 @@ static const struct pci_device_id brcmf_pcie_devid_table[] = {
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43602_2G_DEVICE_ID, WCC),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43602_5G_DEVICE_ID, WCC),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43602_RAW_DEVICE_ID, WCC),
+	BRCMF_PCIE_DEVICE(BRCM_PCIE_4361_DEVICE_ID, WCC),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4364_DEVICE_ID, WCC_SEED),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4365_DEVICE_ID, BCA),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4365_2G_DEVICE_ID, BCA),
diff --git a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
index df3b67ba4db2..b800cbfdece1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
@@ -46,6 +46,7 @@
 #define BRCM_CC_4358_CHIP_ID		0x4358
 #define BRCM_CC_4359_CHIP_ID		0x4359
 #define BRCM_CC_43602_CHIP_ID		43602
+#define BRCM_CC_4361_CHIP_ID		0x4361
 #define BRCM_CC_4364_CHIP_ID		0x4364
 #define BRCM_CC_4365_CHIP_ID		0x4365
 #define BRCM_CC_4366_CHIP_ID		0x4366
@@ -86,6 +87,7 @@
 #define BRCM_PCIE_43602_2G_DEVICE_ID	0x43bb
 #define BRCM_PCIE_43602_5G_DEVICE_ID	0x43bc
 #define BRCM_PCIE_43602_RAW_DEVICE_ID	43602
+#define BRCM_PCIE_4361_DEVICE_ID	0x441f
 #define BRCM_PCIE_4364_DEVICE_ID	0x4464
 #define BRCM_PCIE_4365_DEVICE_ID	0x43ca
 #define BRCM_PCIE_4365_2G_DEVICE_ID	0x43cb

---
base-commit: 415606a7be939835db9b0d6b711887586646346d
change-id: 20260803-broadcom-staging-59a7d9f559b4

Best regards,
--  
Markuss Broks <markuss.broks@gmail.com>


