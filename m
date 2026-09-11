Received: from sonic306-19.consmr.mail.ir2.yahoo.com (sonic306-19.consmr.mail.ir2.yahoo.com [77.238.176.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2306B3793A5
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 11:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=77.238.176.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789124638; cv=none; b=aS5RZkjh0PzNXg+ZZmm2FN8d+hy+Q3xroS7qMbX7TBxvYIIOojhtrOBbVawjm/AH8xz4xfSm/Q0iwEFoBwbqLY7+Xdgr842w/Yztk+B4jPDGprPFk/3/8dxXSNb7k0kKsOJO6shVnUg3WjKhsmsEsujuX5fx98SMY21iRwfbkrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789124638; c=relaxed/simple;
	bh=1fzndY7pQhgcD89pgQfc/DtonFPG3yDxsBTo1s5xKlI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:References; b=u89uVat+r+BKiaWS8LQvYGGwJEAgWRCcSIlInCpz9KKDUIcu76vXoYXTXi6cu5XURWVnLllBdtbbRNeQtdeikOatDL0gz5lTKa2faIxmGFaFBSVAQwVbz2W2hslsPPti0Q6qSdPA6KfTj/StvpNupy8zW4qFPZ/3C/oN6rDTwrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aol.com; spf=pass smtp.mailfrom=aol.com; dkim=pass (2048-bit key) header.d=aol.com header.i=@aol.com header.b=tx5YMSXH; arc=none smtp.client-ip=77.238.176.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aol.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aol.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aol.com header.i=@aol.com header.b="tx5YMSXH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1789124635; bh=6d1pg9KPMdpEmcY7xoVv0KJvI14hELNgS/sY0B6JKbc=; h=From:To:Cc:Subject:Date:References:From:Subject:Reply-To; b=tx5YMSXHAEyUh2xuOwNoc8Mi7LV7U8FOFmq4Wx5foKJMaHOv4XFXAE2+nKZeZ+wuL+U9cgI3YF67W3ahWXE0/DUqS1MPuFQ8YwCXlqz/UakxzxTfGIfyAr7So9Dvmb3bO6yXIjZoLAjKDYC/8anjhwRyG7Wb0DvHjzM0K/5f0UuOxKVXaAJVyRxXrpMgD2wUllMdBLBKiQ0nJ2rU04mKOj4wLROWvpGGtZ5/eD5KGjCKM3DrHobTSrOul/SuGqH/u0nfuGym4DB4yzMRLLDFMIdNZJkI5Vzwstu/8BWEXh3O1vFPy1oHt6RkOwbgb4lqsD0g3W/vUdexpyU2crOqLw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1789124635; bh=AuRnd2FeThP77PFeyWJEjyC/+Zq8XRdTFRjn9R5yIZj=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=DPyqVB69LxOIm0FlYYyKzYsmbfpAHALTESZvAdZkwjuWzpMLASTBzfUZfg3aE+M1x3QqRVm7AhgFhUlgMbLh+ShruqkdtaCtGRpV1Ghw2pFOLeZDjuETivt9qNw11EKI7eegK3p4eH65L+yTb7EsL3fWAc7E3NSiHL72q5pVU/XeaWSsxEpaAACbZz5552sbEqfmam5zXZoA8YTXbv4Q9jX08+U9z3LJK6eWTEPiQGl535vbY4TIZliUAEMsqiA/OhSOGOcxDqgPiQXaT/Rja236jlYngDM0dZFH8UT9bjx4Couimi9XexqzltsuBye2rRzyw29VgbqU+942hB4Q3g==
X-YMail-OSG: nAMuKzMVM1nJx8y9R0u4vOytgmYgcAxdsz2A63vPm7IGUyxOYP6UHt869LoRqck
 .dAS0qZFxOIH8B3QELhdBdkcBoeAk7ZNXpFKfml_j1urL88Bs_LiSJ6aBLt4oB_BEC6qPO7Egf4n
 utnCXm3mp3vAYJ1V5YX9Fk6puVHxFM2Yz6i1.F3UGq1LOoj4u0ptZxG69QR.x6gyZBHj7ffSwHXP
 iypyJhWNI0EURzd2NLNXLFd9Qtf9qkql1h0_aZIudVuBfIEH9SBqbB0IIyHF8tsh0TBeM1R8HyQF
 D2Hqn2nOLil3ZR4ysZpoOCchw4YZxmzaRLssZAJrRtb3R7h0YQyiOZKyIj0AsRQHqDB9WMp7x08t
 U7pFBkQvfqls2XeLTiaWZgm5SZ45n5FNk0tVsjl2JHkSvV9kH01h3Fn.DPnShHzWs7yedfgYZvgq
 bJPOEdKNvk485W6n5gh.XVwesssSTN5BATP881Wr5L3XY5dfz5UNsAz3_T2iJLbTfukQHm_EWluz
 jifE0_PkJC7qgNsO66UPaQnQqazQLAeVXzY6tKlEvRiPh4SOtdJ12UeZYSX9j9ebAqNUPYkBZ7e0
 0O2cz6jtMHv.GcW.dwfXCPEjrOI7iqvlqHGabVv1fb2esrauYjndhp_YGFboREhcqfGIM74qj3D.
 anPB01kcP6Q1V64TD8Yc_MSdsqfMDZzD5xPeN8PN.Hn5nyHUyxAXS0BcneAm6lUazBuo3HaMRpPk
 VeVhke6WQjXV4LiC8zvMvuFaHs4XGogcIWKOSvSdRXdS8byUEZ.Tr1XPyNM3IdkFPgGmzWRWNbxN
 YGNmUKZOqQHen7v5d3FWMFiMi9pYMznWnStzMZYaJJByK.iN1IL6J3aFy8XDGj1qpJ.G0euVKOL8
 hH35K47W8WAK16C6j_9amOOzT5uqBX2VTyS18ZGZI5.1FQOBtsTO.wvO1YYMWObLOLjcgj2GTIFy
 9KXSr.Tc1mey5AOFXnJbMKCedwYykWHbrxHE3tP4c7Ixo87IXHnWoFG_aHp6BJ3W94FAKMEklayW
 lXqBT7rWtIZoR9b8wAHAEGpekvmCmOEhM3yKqskZntL_3xMWKczI.wqJ77hG9N_pM9xfzSLKWbL0
 fJTCGhuY662_TV6TnVvbep8ttYtJ1fB9tDMEJo7zwT4AHeWb6XfbBxuZ3hJV5se8ARbpFI9AzBeE
 40sVqVhunY1mLB_HTceFC..4KWNqco3hDQhtkW8_.3e1Q1F3z6KHbF0IH1iNDlncY0MjBC6R2Yz_
 n0MTbjtGU0YpcTZxvvAvCmQYhrVPGDDCNewzXSzaLD0eUOJq2gc4kzI2znQW_NEb5.y7FlUL9Yye
 grWE5jHkaKwcbQb01TGo1cgg77wviy1K.FcN3YCCIYQvT8CeGz575VTzU6Tx5GdqLlyt0Gy0dJjT
 FxbWbY_B81K6euNrQxAoaEwHb.wfvL80gzFZuRc.P_LBmqA428DfVdceb7wJV9OagFOinmzCeG1D
 4C_P4YwJXHkmoyF9GzeKff3qddshhWOuFz8xD.9fOIokAyEgsFgRfoj8dS.7wiXTun0nPg0AxL.v
 5sArPJeSHKChecRFBo3qbXBw.ry.U2GN84crwCQHw87Pvhe1nby4WCT4BKiF4r5XWEI3vqcYy6ou
 ockHrLnvdhHaKfZQsWoI1t6d3A1VQFxkF4cfajC.8bcQ_QOKsi4JBDFeMZLWZJmk.36M37Coriiw
 8Opm6oRf7Zmt.NEREyIFyXL_QxaPa9tT3tNlKgLxmjKs3SizhmeGmlbjkil1cnVQW.mZyeNFIVI3
 Ur08d5w9wbBsBfvThsjVDl.iTKkxtRKenfKUyKwiTZz3H2Ompl6rl_j3NXZ1jKvHQrmM_1rBMZFk
 FWIAJJm91.vd7Z90ePdqQGm8CtTRrDUlaFqwXiIab1I2eMsETJppUyBGJmzJIR35BlkbcUoAgTjN
 9Aj2oTAks4i4debRMsHvvWxCSZywg.pFzc3otZ.XVwud1ObvNnelte_rS4GOpHcfZ575iuxG.5_I
 6dGjkM5cP69X0juN8pc_e2ODCjUhn0ZMEGL1BClPm_B3q9M4AfzAliX9cHJHjLkV7fJEoSiO2Vhq
 m4xN.H4q7L2ZbyUXIEYj9MI_D5mj4YLNUlQLRydPrJ0kyuuRVUJPOMD25m7Bwc8_LvaYdgv9zOGy
 _5lM6wh.ImCSD5slQWBPhtvjBB1GRCm7t905y7bSBV_jX7DUo3DdLsddafbO2GA--
X-Sonic-MF: <eexto@aol.com>
X-Sonic-ID: a2b40ffb-6821-42be-98b5-47f303ab34d6
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ir2.yahoo.com with HTTP; Fri, 11 Sep 2026 11:03:55 +0000
Received: by hermes--production-ir2-cddf86dcf-299wn (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 5a4e7a00ae694a37e2ae64cb3faaf16e;
          Fri, 11 Sep 2026 10:09:05 +0000 (UTC)
From: not-eexto <eexto@aol.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	not-eexto <eexto@aol.com>
Subject: [PATCH] wifi: rtw88: 8821c: Add HP single-antenna quirk
Date: Fri, 11 Sep 2026 12:09:04 +0200
Message-ID: <20260911100904.50320-1-eexto@aol.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20260911100904.50320-1-eexto.ref@aol.com>

Certain HP laptop platforms with RTL8821CE (PCI ID 10ec:c821, subsystem
103c:831a) are manufactured with only a single physical antenna wire
connected to the Aux/S1 port (Port 2). As documented in the OEM Windows
INF file (netrtwlane.inf):
  "single ant(connect to right one S1)"

However, the eFuse on these chipsets reports RFE Type 2 (Main antenna,
Port 1), causing the hardware SPDT RF switch to route to an unconnected
port under Linux. This leads to severe signal attenuation (~ -86 dBm)
and frequent beacon-loss disconnections.

Add an automatic quirk in rtw8821c_read_efuse() for HP subsystem
10ec:c821 [103c:831a] that overrides efuse->rfe_option and
efuse->rfe_option_full to 4 (Aux), routing the RF path to the physically
connected antenna.

Signed-off-by: not-eexto <eexto@aol.com>
---
 rtw8821c.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.c b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
index 9f0964d..32c7de5 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
@@ -15,6 +15,9 @@
 #include "debug.h"
 #include "bf.h"
 #include "regd.h"
+#if IS_ENABLED(CONFIG_PCI)
+#include <linux/pci.h>
+#endif
 
 static const s8 lna_gain_table_0[8] = {22, 8, -6, -22, -31, -40, -46, -52};
 static const s8 lna_gain_table_1[16] = {10, 6, 2, -2, -6, -10, -14, -17,
@@ -56,6 +59,21 @@ static int rtw8821c_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
 
 	efuse->rfe_option = map->rfe_option & 0x1f;
 	efuse->rfe_option_full = map->rfe_option;
+
+#if IS_ENABLED(CONFIG_PCI)
+	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_PCIE && dev_is_pci(rtwdev->dev)) {
+		struct pci_dev *pdev = to_pci_dev(rtwdev->dev);
+
+		if (pdev->vendor == PCI_VENDOR_ID_REALTEK &&
+		    pdev->device == 0xc821 &&
+		    pdev->subsystem_vendor == 0x103c &&
+		    pdev->subsystem_device == 0x831a) {
+			efuse->rfe_option = 4;
+			efuse->rfe_option_full = 4;
+			rtw_info(rtwdev, "HP quirk auto-detected (10ec:c821 [103c:831a]): forced RFE option 4 (Aux antenna S1)\n");
+		}
+	}
+#endif
 	efuse->rf_board_option = map->rf_board_option;
 	efuse->crystal_cap = map->xtal_k;
 	efuse->pa_type_2g = map->pa_type;
-- 
2.43.0

