Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446D345561F
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 10:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789124192; cv=none; b=LVBDNJWWU3wnenaD4gfthXjX/yjgt0n8sb0sIxoG1cmMfkl+H8qww9VrRlSbmhk0MIuecwhHcwudowHZC8sClP0zrXpFZOjRznl35E0ipVcp1QN/e1rMRyReXPpg96xMCUgMBM/y5eKtorvz5vAdTHQVcbjjWJA46dmoJNlSc68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789124192; c=relaxed/simple;
	bh=d+Z/BWQqznMjqlF5QhSb0JFVB5m52CflouKz/7xlBnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iG1zVFfkCMfOk6qYeb41lS469Z/7V7eH/JUbwpps680eTRv9w0GPUm5SbUNkp0sbV/IkNTw4R4yyNeNqdrAwzi/jIPxD/xLiwEnQHhLd9ji8pfYju/aJHgOLEvIiumWg6QOh4SNEfGzyY56LAW2ZMRvRxrmnJwBFJ94tsV9nlnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bKdPvEry; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bKdPvEry"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-499db1740e4so488885e9.0
        for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 03:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789124187; x=1789728987; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eSFskdzITehM2bPvNRZfY7m8ghz1qlkZICGf3hrj1fI=;
        b=bKdPvEry337P1HlqWLkkmMP99kPGyyqdLw96mvyVGjfz2DGQbrFtidTlDPzgbqsXnB
         IZBlKszgVfHAK6nUJglmsKazhW9j7wVZXuDQ7ixAioULeAL6Tlm7FUvxkeqUsbd5Gsy3
         kQqcMm1J/hPgNihU3GmIiyyVSQLtKwuokOONvJ5YkdslCLInGgDNdeG2NXVYbA0o+7Pn
         CO0Vstyk8wlCn5/SiIClByNqloBLCSQrOK+Phf6oMC9075iPzvEEgVudUTbeNRdS4irJ
         93b1Y07XJGtXXyl+HUo9JirrUIgK1Ujg8op1YEEKtwieSJo4I76BCVxKpJcFtyT0vFt6
         UCHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789124187; x=1789728987;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eSFskdzITehM2bPvNRZfY7m8ghz1qlkZICGf3hrj1fI=;
        b=L3DmMZ5vRf4q6F/gSftM5u/I79UrZVVlCOMMrjwObtHDoIG7Y0lBMzqAkMvfoOLkH0
         L9nGTyC+ItiPX7n7l6drP9MRGXoX0IxX4YMfB2ANlnLLD4VFljLNmJ+jovTJwYGdFtU5
         3MOo/Beh21EGlEZtVosdRPTSh0LqG+kW4hgI9kyK+DzpHR1vNmEMrln4bE/5YPQxkdwz
         bNEvN5qKZL0trRxJAn2bvaIO0Uh/tNDEDPhPKaFa6/hIFBxzG/LHpk71lHEHx3D+hCKX
         6z8LQKpuGc7r3yVNgVds2VrG48dXrMqtnVcnDGjWJH/Xbk8V61TY8r5D8IQGNV9hLOHm
         Pz7A==
X-Gm-Message-State: AFuF++nT04IJum5QGw7HK/6EH5t+mxiJ565YgKSF1sVcXSaTI3uxKH1/
	p6UYvYcjKjueiB9mC26I1TK4uPQfKSa4z5KjUgWLcyHmsriQ1QgBCm6J
X-Gm-Gg: AYBFou0Pst0A0utsLp4xfuLirNeaphSivwrUbprh2XzPKdG5qxr/TAODyK0s9H7SLh6
	MtIj7D762/Xu+XqjTLoIXwfZVwSQZGnOQyImw+W6QNWgddA9EQbHM7/B/pRCc5A7Qj/wlplvLLP
	8sgo70Nt7oQ9Av8TBCb6RL2twB0tShkkk5GhZTH6tsVaWwR49F/pF4RwlFHhHm3Y3CCddoQ4ANi
	ZDvYXtIZsbzy5XHcZ80baxolXYO2+qNTk5rWg1rP15cmbPLpq8x8bH69tFH/KZnFZ/mOH+oBqJw
	tPXtzpaVOQLMF2XA+y+X5hYm+Gt+oyV7hslu1iZFlJrUPEO6hq2fWaiNI4JY97IvRhvTf/tLvo2
	YOkY1tNBS5YFwtNfa15YhZMafQe9luZh5Bfxxo/EqAbqo+SGlCRzh2Wn0i6iNQswokrsvdlYe15
	CBo42qXvcKkEYJPsTO3WmY5t1hGDyGGBRkYT0vJU5glQw0pEMun3PF3HJIUGYb9rUodSbknNuRo
	XM7GarVbNMqtw==
X-Received: by 2002:a05:600c:46d1:b0:49d:798:67a4 with SMTP id 5b1f17b1804b1-49e61640f73mr35506595e9.0.1789124186942;
        Fri, 11 Sep 2026 03:56:26 -0700 (PDT)
Received: from localhost.localdomain ([2001:b07:5d33:1c52:f4cb:9f90:ddcb:4bc8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb35bd1esm5141796f8f.31.2026.09.11.03.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 03:56:26 -0700 (PDT)
From: not-eexto <p17232763@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	not-eexto <p17232763@gmail.com>
Subject: [PATCH] wifi: rtw88: 8821c: Add HP single-antenna quirk
Date: Fri, 11 Sep 2026 12:56:25 +0200
Message-ID: <20260911105625.63048-1-p17232763@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

Signed-off-by: not-eexto <p17232763@gmail.com>
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

