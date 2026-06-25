Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2643DDDC3;
	Thu, 25 Jun 2026 12:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782389427; cv=none; b=D3VYea4iI2AkTx35rQsItOhTvaurHZtEFrbUEK0Q72pmvbNagl56Rh8E80Q2VGHfXFqT/B9OexWhBP786uDXY9l3SSV5p/QfaO9yB9++B744/Uff4jNVKFF34Shvc03q2NxQD2/PpPuYqz+NpEcCd/03r1eNTxRmjLSF6pumWUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782389427; c=relaxed/simple;
	bh=Dty4ExmM2WYiI8hqciFmMkMhflmLtlNOEVWDhBzCpHg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jGTtRhi9tLkSliF9uWgnFgv1wlxuGXOD1xyARZoApLgRJdRKtnyhw5cnx0LLIzWKqvx2XVhGJAHr2vGTL9GwY1jy+LfbvRADsbkkgPM6u/Qc1cVywH56wbpJcH3G4vlDAFGLsQIAf7KJ4P2Kli9jTzzIs6B7GXlBT+0kYs+GBL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IrNwxMCm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IrNwxMCm"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 25803C2BCB3;
	Thu, 25 Jun 2026 12:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1782389427;
	bh=Dty4ExmM2WYiI8hqciFmMkMhflmLtlNOEVWDhBzCpHg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=IrNwxMCmX95bEcOtuwvenoN7AU8ewQblmMoRHwIe74sBPi7SMpLhbJd7TO2y/7jW7
	 9sK08DfeldhFCgD84P4Rk3WSvmtJixPZb4jwKkafKGuUHRDE4aPBLPKCbwwpHPsoAf
	 iSPdQVZ+WDC20xcAuj66G8fzxKRVGH1kYyn04p/DbZrmKHEo3BDnAna3EFs5rzYemO
	 QANb5voKwaMOjE6ie96zepx31sQSgAR4+vanxk8elko95b0Bv+TYGD83BIdPq6Rej0
	 6B5JOwE6uXJtjWa8RvBT3t6QX4fqTNN/BA9+aL6qzJc9Zr6hGOgVKfB7Q2zw6fQS/G
	 W3SFFKku+AsWA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03CFBCDE000;
	Thu, 25 Jun 2026 12:10:27 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Thu, 25 Jun 2026 07:10:26 -0500
Subject: [PATCH 1/2] wifi: mt76: mt7915: bound the device EEPROM address
 before the EFUSE copy
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260625-b4-disp-16f99062-v1-1-aee52ecf61b9@proton.me>
References: <20260625-b4-disp-16f99062-v1-0-aee52ecf61b9@proton.me>
In-Reply-To: <20260625-b4-disp-16f99062-v1-0-aee52ecf61b9@proton.me>
To: Lorenzo Bianconi <lorenzo@kernel.org>, 
 Ryder Lee <ryder.lee@mediatek.com>, Felix Fietkau <nbd@nbd.name>
Cc: Sean Wang <sean.wang@mediatek.com>, linux-mediatek@lists.infradead.org, 
 Shayne Chen <shayne.chen@mediatek.com>, linux-wireless@vger.kernel.org, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782389425; l=1655;
 i=hexlabsecurity@proton.me; s=proton; h=from:subject:message-id;
 bh=aZWlM27FhqoCfxmJEBrSyxbvPm89MZy5+yTxeP7W7hk=;
 b=0XZxwtAAOcq9Lmc4I1vnT7NeXbySG07w+iH8wO2HoPrfrbVh26jz+Gl81dv8m+OnjffMpuH4W
 ipASWDIUA4eCst0lPXtaJ/mvw4EWP7L+kYUMqbw4MnzXPpEd0Dq/j3V
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=dmppBMZNLLoPzxHi9l8tZDzEZUunPbgsYqIZYXeUrL0=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/proton with
 auth_id=814
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

mt7915_mcu_get_eeprom() copies a fixed EFUSE block into the driver's
dev->mt76.eeprom.data buffer at the offset reported by the MCU response
(res->addr, a device-controlled __le32) without checking it against the
buffer size. A malicious or malfunctioning device can report an arbitrary
address and drive a 16-byte out-of-bounds write past eeprom.data.

Reject a response whose address would place the copy outside eeprom.data
before deriving the destination pointer. Devices that echo the requested
in-bounds offset are unaffected.

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 4a381d351e61..f39eae3c4c1c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -2909,8 +2909,15 @@ int mt7915_mcu_get_eeprom(struct mt7915_dev *dev, u32 offset, u8 *read_buf)
 		return ret;
 
 	res = (struct mt7915_mcu_eeprom_info *)skb->data;
-	if (!buf)
-		buf = dev->mt76.eeprom.data + le32_to_cpu(res->addr);
+	if (!buf) {
+		u32 addr = le32_to_cpu(res->addr);
+
+		if (addr > dev->mt76.eeprom.size - MT7915_EEPROM_BLOCK_SIZE) {
+			dev_kfree_skb(skb);
+			return -EINVAL;
+		}
+		buf = dev->mt76.eeprom.data + addr;
+	}
 	memcpy(buf, res->data, MT7915_EEPROM_BLOCK_SIZE);
 
 	dev_kfree_skb(skb);

-- 
2.43.0


