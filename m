Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8595464D
	for <linux-wireless@vger.kernel.org>; Mon,  2 Feb 2026 01:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769996456; cv=none; b=qfkx76SEOZL7ZBNZFFXqp92HfektG9RB3Fgd5hGwZcuJsUsYNC+s6Oxo8j7hGQfcahgaQAHOyNkmhryd464blbfWn1o4cXZaHKxnVjDum+W6OThx+B4ftiW9SA6i8U8KGn7IPos8IrdrKw5MGdMP8xIWnkmSMr+LVSwUSBAueLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769996456; c=relaxed/simple;
	bh=ANl910oa30g3dfMTS0CnmxjjWkWdmTUBumajbGdUEAg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kPk18bwjhQm9a4exhYW10YR1RYr5H/Nsu7frTyDPeUNcKknNMTrjk33kiiS6LlwqCP5Qc4k0jbB2GEHTAI+8Wbveh6smWQiFodmWG5FE050B+0H1NJn16tmU+qevB1omYWU8O9SD7gTBMHPPa0XNe3fHrefipXd2smiApVlSEKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=X2a67yz2; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="X2a67yz2"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6121en9731862600, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1769996449; bh=VMjGj7G5TJTzr1rhe2cfXwxZLawWaGZOLS4TieOzmj4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=X2a67yz2bc/OW3DE3dNk7BD9uhIQcwnop5qgTcJHdZ0IvAiSZBDv5+ReWwQFeMVnr
	 7No9skejr5E3+/LS1ZfpQCcnT588VDjvd21neKweoHSIbvotJ+E2rWTmOKraXOPage
	 W/8XdZVuj0wj4cJeYwsZvuLqb3aTLdxLl9J/XfYN3R0VljRVlYw86XwikA2bVsae9w
	 twmFzv36UXic6WGFAwYdyXDbRIFCbO1Uzns11bzPB9oZbkXYT4TiOPKeVkdU7qAv9g
	 vuNeuCdylnRT78R6aHjewSbvjTxfuhX6iU9URUzzvqINgi8ypaHaXO0av1nHdAxWoK
	 VqYVX1HDDWjmw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.21/5.94) with ESMTPS id 6121en9731862600
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Feb 2026 09:40:49 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 2 Feb 2026 09:40:50 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 2 Feb 2026 09:40:50 +0800
Received: from [127.0.1.1] (172.21.40.76) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Mon, 2 Feb 2026 09:40:50 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <iohann.tachy@gmail.com>
Subject: [PATCH rtw-next] wifi: rtw89: pci: add quirks to avoid using PCI DAC for X99 board across chips
Date: Mon, 2 Feb 2026 09:40:49 +0800
Message-ID: <20260202014049.11783-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

RTL8852BE can't enable 36-bits DMA on Intel X99 motherboard, which isn't
a sold combination so add quirk across all chips, not only on specific chip
RTL8852BE,

Reported-by: Iohann Tachy <iohann.tachy@gmail.com>
Closes: https://lore.kernel.org/linux-wireless/CAPVS0eLR5KCmBEkGHnSxwKQM0hwCSaL0TSaTMNT_GJQK1sT8hg@mail.gmail.com/T/#m976028ea900ea6f2c5fbbd1ff14a92377227f555
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.h |  1 +
 drivers/net/wireless/realtek/rtw89/pci.c  | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 4778957d6b2d..0c894ba73a65 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -5205,6 +5205,7 @@ enum rtw89_flags {
 
 enum rtw89_quirks {
 	RTW89_QUIRK_PCI_BER,
+	RTW89_QUIRK_PCI_NO_DAC,
 	RTW89_QUIRK_THERMAL_PROT_120C,
 	RTW89_QUIRK_THERMAL_PROT_110C,
 
diff --git a/drivers/net/wireless/realtek/rtw89/pci.c b/drivers/net/wireless/realtek/rtw89/pci.c
index 43c61b3dc969..fded15b2029f 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -19,6 +19,18 @@ MODULE_PARM_DESC(disable_clkreq, "Set Y to disable PCI clkreq support");
 MODULE_PARM_DESC(disable_aspm_l1, "Set Y to disable PCI ASPM L1 support");
 MODULE_PARM_DESC(disable_aspm_l1ss, "Set Y to disable PCI L1SS support");
 
+static const struct dmi_system_id rtw89_pci_quirks[] = {
+	{
+		.ident = "MACHINIST X99-RS9",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MACHINIST"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "X99-RS9"),
+		},
+		.driver_data = (void *)RTW89_QUIRK_PCI_NO_DAC,
+	},
+	{},
+};
+
 static int rtw89_pci_get_phy_offset_by_link_speed(struct rtw89_dev *rtwdev,
 						  u32 *phy_offset)
 {
@@ -3305,6 +3317,9 @@ static bool rtw89_pci_is_dac_compatible_bridge(struct rtw89_dev *rtwdev)
 	if (!bridge)
 		return false;
 
+	if (test_bit(RTW89_QUIRK_PCI_NO_DAC, rtwdev->quirks))
+		return false;
+
 	switch (bridge->vendor) {
 	case PCI_VENDOR_ID_INTEL:
 		return true;
@@ -4765,6 +4780,7 @@ int rtw89_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	rtwdev->hci.cpwm_addr = pci_info->cpwm_addr;
 
 	rtw89_check_quirks(rtwdev, info->quirks);
+	rtw89_check_quirks(rtwdev, rtw89_pci_quirks);
 	rtw89_check_pci_ssid_quirks(rtwdev, pdev, pci_info->ssid_quirks);
 
 	SET_IEEE80211_DEV(rtwdev->hw, &pdev->dev);

base-commit: 4c1552473acf03cad828884b4e1c90b97a89b265
-- 
2.25.1

