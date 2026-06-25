Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594352E7367
	for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2026 06:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782368254; cv=none; b=T2bF7nGRGKeM8aUJznAuivrAa47J5VzZ3MB5IrbrhXBJKrYJ8+qCRLSuOwSFWNbu47/GimNSRmiJUL0scZ5Cu7Z7NuInpjbdvATWAziT6nEBf1hv+izp4kUSfW4bXUf+WCx6wTEfqX5SDEoi9CR88AqSntBsdIQqi34BsNsr3NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782368254; c=relaxed/simple;
	bh=7l8FEEiRgtKE4ywo42hCh2Ha7dOJ5qCGQ+aZ0LYgOok=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nryGUY86/BEC4hbfiP+k3+bE6DFuJ7qksYgmK4rov0isiH2+jB91N9mAI88VlwGjsdb6+/VZZqMS8gnOUf/Kni8w3nkD8HaNefkG8eLwPe91C3P3ILKO2ceS+wLhcUPkcJ/guW5n1jbzU5JSIy5IWi1Mo/MmhY9C8nrb36sBVBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=qfEAtXtz; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="qfEAtXtz"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 65P6HVUA0584530, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1782368251; bh=JAN9vlRlYcdpse+bpKWATxsLUWsBLzlBTakaTfHBdjU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=qfEAtXtzMPA019UDVUwbmTGdchUPdw16+bIIkOoRLV7OfpCiRZgzuRrVWr476pxsB
	 PneL3v92q8Ze6gTGjb9IvULwpxn8M3LXiLI5Dfvj6hmpZuK5mONumBFw2zPDKMGTPh
	 m8iKYGoB4r5hViJ4zAGymqQANEqFHrOiqznlZk86PknasabPtGT0vWTs4dybIYlPzj
	 P5DGDV+vtR1i6gnxN1OIPAd4j+LFA8mzglQrG69w0gY+HeH78H64G+SouKgAzvCFBJ
	 Qcwub+BrwYJrcozHbX0InoHn14Cav1J0xmR3UV9aXX4xGFlZdmDTO9Pu4a4D7Y0KvV
	 b0V7OmS4HmK7w==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 65P6HVUA0584530
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2026 14:17:31 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 25 Jun 2026 14:17:30 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Thu, 25 Jun 2026 14:17:30 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <timlee@realtek.com>,
	<dian_syuan0116@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 10/10] wifi: rtw89: wow: only WiFi 6 chips initialize RF registers in WoWLAN mode
Date: Thu, 25 Jun 2026 14:15:45 +0800
Message-ID: <20260625061545.44808-11-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260625061545.44808-1-pkshih@realtek.com>
References: <20260625061545.44808-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Chih-Kang Chang <gary.chang@realtek.com>

Only the WiFi 6 chips need to initialize RF register when WoWLAN download
FW for some power save issue. Applying the same initialization flow to
WiFi 7 chips might trigger the error
'RF parameters exceed size. path=1, idx=1500.'.

This happens because normal mode uses rtw89_phy_config_rf_reg_v1(), which
skips registers with addresses below 0x100. However, WoWLAN mode uses
rtw89_phy_config_rf_reg_noio(), and WiFi 7 chips do not satisfy the
rtw89_chip_rf_v1() condition. As a result, more RF registers are
configured, causing the size overflow error.

Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/wow.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/wow.c b/drivers/net/wireless/realtek/rtw89/wow.c
index 8dadd8df4fc6..a7539f91264d 100644
--- a/drivers/net/wireless/realtek/rtw89/wow.c
+++ b/drivers/net/wireless/realtek/rtw89/wow.c
@@ -1299,7 +1299,8 @@ static int rtw89_wow_swap_fw(struct rtw89_dev *rtwdev, bool wow)
 	if (disable_intr_for_dlfw)
 		rtw89_hci_enable_intr(rtwdev);
 
-	rtw89_phy_init_rf_reg(rtwdev, true);
+	if (chip->chip_gen == RTW89_CHIP_AX)
+		rtw89_phy_init_rf_reg(rtwdev, true);
 
 	ret = rtw89_fw_h2c_role_maintain(rtwdev, rtwvif_link, rtwsta_link,
 					 RTW89_ROLE_FW_RESTORE);
-- 
2.25.1

