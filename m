Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2A343F0BA
	for <linux-wireless@vger.kernel.org>; Sat, 18 Jul 2026 12:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784378625; cv=none; b=P0Htefuy5lYguOxeul8ZweAePvoi2hD2RVDeORuvPc+I2R4W2n3v/a3E9FPO6ArhLsJMcuP69TXP0Sgc8fOTdcVeuY5J2VJCGDMRbu2QVLkPiYDG3LEngYWSBiwgGRExu2lNYyfUy5cXHuH86VvoyRDPVlLGpmGt6wEgqdqcu8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784378625; c=relaxed/simple;
	bh=Oj5nabWO8GeQdC53KWKaNmHJgbDS4JuxsG9IObR8lh4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ivmSTVGzPJBKCTz8QU892oq+NOeHY9OpDm3KjM5zSsUnszNf4tIT7NZz+T4qUOEdyQsMBfN+TSfFsfA6igbTCUtH3XRroP/1E+G6gDl7GfS30C+/mBu25y5SLTSqKV1Vo8yLPKD2gcORdFjMAElQJLaFsZ99/LBv+BLSj/x3gbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ra56qFxf; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ra56qFxf"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-69e8ea2783aso564188a12.3
        for <linux-wireless@vger.kernel.org>; Sat, 18 Jul 2026 05:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784378622; x=1784983422; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5nQrL7SbHSl6RPxv/11ckxZIqYZdM9dzzX2W3+wYdWw=;
        b=Ra56qFxf0WCnKd+1kTl5ZfthLTcxKYfF1XPb0/SfBmD0KJfvDo55KzipStuP85SEnu
         ehh66OgnFBSipw/qA5TpINCVNbqgoGnjC1D4O+KfZ9l2oSGK1B3YGbuZ2yHU9x26igi+
         Z8L+LhPLHi9OqUOw/81pgmeJsQBegHuVTwSwLDLd1l4NwP9foPLVgyxWDhlzyQeLqcNh
         GZeIl9ZFVF1XoKXd3jZ3O8Cre4hPpVZhB3fuNJKny/D3jJ1UdhykQU5oacraQvhRTWwV
         bvL7gKGmxM8DV+ZZVewSDxVbsGIqKtchcq1SkWI5s/oXDIYm7U2F8Dvh5w697+rBxELM
         1udw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784378622; x=1784983422;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5nQrL7SbHSl6RPxv/11ckxZIqYZdM9dzzX2W3+wYdWw=;
        b=JZL3qPpNVnYoZlVDu7Kq1YO2BDL5SVFGiI2pE46jdNJvwu2Crh+3Fla8ji1ssG8mxf
         /3dzv9N1FaE/VqefxI3mTIshicsPXislqkdTxaPtBZeim6ZhKlvCIADlsC/eHrjPmxXm
         B644Z3dLV7HQdcXbVIT7qKhKJjPr27TxmgxZbJsfUXfzZbffhfTBBp8w9tjT4DunE6oW
         QfcBP1EMpS6vFEMS4ITXPbV5hfS+LoDdr8YqeQAO47Q7quryz5NtAKSlvWUtZtQLjkX7
         mx3YJDQ0zlV7x8M4WgdMeB+I2GEy6hWadmE8/6/ncTLop8M/sy4rz2kBOTUGVjoNjhEJ
         ncEA==
X-Gm-Message-State: AOJu0YyWwZVP6gflrMjKCzGLsv+3F3h1eLPZXDQZvwlkKpEVS/byGeFN
	d4MzdzSAGuQhgEuywLPL0V0lPAf0p5DIO5NhRkIaeWl/GbSgtCxzY+XxWGN45GE=
X-Gm-Gg: AfdE7ck0bOwGJDEJDj+duJwajLkENsHoDZWhhb018GOyVGVGulxGO77xEuujQlbbMip
	In3WnG3cXPJtODohiAHLllO+GneJisl8dcnnFIVFJlp10lXo8aypKoHES1Z9f/Ugy379BTmfw4C
	af0o0h/litjFhauvJ95FwXW7ZsWqvrxIW897L/hkA8+A+8wiHqJqV0+0U6RKS6+Eu0mZ9PCiYt0
	Nz1Awjt2DxPPGTIemcHeGTODvCydBB8l4gpU0hdYevTrfh6OWYnhc+KqEueqef8daDmJSsMqA0s
	+GrugccY3paYwPR8CBrn/L/M8+n3LoNH1Eaw8sNrMre06dPQV6SQOZf6V3SBuZ6ERwonHCUiq40
	sJKPpn8NBowfRRM5CWs0+JXRxHfhKqrE0glgZ6xVT4wBROY2namEtzJWD8XfNJw6apsoKOGsLcx
	J6
X-Received: by 2002:a05:6402:24d8:b0:69a:a9d3:9fc with SMTP id 4fb4d7f45d1cf-69e6525aa84mr2239587a12.1.1784378621767;
        Sat, 18 Jul 2026 05:43:41 -0700 (PDT)
Received: from mickey-13 ([92.53.25.127])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69e6ffe104esm2079837a12.22.2026.07.18.05.43.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2026 05:43:41 -0700 (PDT)
From: Mihail Dimoski <mihaildimoski@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Mihail Dimoski <mihaildimoski@gmail.com>
Subject: [PATCH] wifi: rtw88: disable ASPM and deep PS on ASUS TUF Gaming A15 FA506II
Date: Sat, 18 Jul 2026 14:40:45 +0200
Message-ID: <20260718124045.23493-1-mihaildimoski@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The RTL8822CE on the ASUS TUF Gaming A15 FA506II wedges during normal
use. The driver watchdog toggles PCIe ASPM while leaving power save;
the DBI read of the ASPM link-config register fails with -EIO, the PCIe
link becomes unstable, and the device drops off the bus, taking Wi-Fi
down until a cold power cycle:

  rtw88_8822ce 0000:03:00.0: failed to read ASPM, ret=-5
  rtw88_8822ce 0000:03:00.0: firmware failed to leave lps state
  rtw88_8822ce 0000:03:00.0: mac power on failed

This is the same platform ASPM inter-operability problem already
handled for other machines through rtw_pci_quirks[]. Disabling PCI
ASPM and deep power save on this model stops the failure. Add a DMI
quirk so the workaround is applied automatically.

Signed-off-by: Mihail Dimoski <mihaildimoski@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index a304672..2c4f123 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -1779,6 +1779,16 @@ static const struct dmi_system_id rtw_pci_quirks[] = {
 		.driver_data = (void *)(BIT(QUIRK_DIS_CAP_PCI_ASPM) |
 					BIT(QUIRK_DIS_CAP_LPS_DEEP)),
 	},
+	{
+		.callback = rtw_pci_disable_caps,
+		.ident = "ASUS TUF Gaming A15 FA506II",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "FA506II"),
+		},
+		.driver_data = (void *)(BIT(QUIRK_DIS_CAP_PCI_ASPM) |
+					BIT(QUIRK_DIS_CAP_LPS_DEEP)),
+	},
 	{}
 };
 
-- 
2.53.0

