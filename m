Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE6A2DB7A3
	for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2026 06:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782368212; cv=none; b=BJ7z0ouzNzd4ubVy4MZhLuTep4tVsap2NWuLTK5Pz20cznLQ5QKcZpSKBYCEOrjpM46fgreif+eEjMsf+AJbe1nCKQivjBsb5soOnriCGZQsQZj14Yvq5QZx1VEGtSFhlaunuGjV89yaWJy4HwN7CTugjyTPVZdDtzq04hie38g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782368212; c=relaxed/simple;
	bh=SX2aw+yS9XbzL/sTz3HUFOSnYn7KynkQ+EGZllQgyD8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e80CsWF0QC6YRh/F3kfgSGQksHF5elZMWtcfCZKoSuKf7TTFl8norlT03pjzAUR3aY3tSUIvK4cwinXZRv8E5zE3Cm143Xe8xRA2Ww8O30oEWPqa4pomUj7797LdcIJjK8xtpVeUoU6sOKsi8Y73ismhP0+TA6YtfxzQ6ZCFAo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=gPVu9xsV; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="gPVu9xsV"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 65P6GmuA6584321, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1782368209; bh=strLXqVhW7U654YX3K/h4GwChno6U6+LvXr9PPAxylk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=gPVu9xsVtC4gGygk9tj7ziJpYjRog2/CdByXvfnWoGfmG0CfPGXwaUowGdetOL1PL
	 rkRpW/OkAhBEagv3BAgiKYmEwNzFg/oMRgouD8hCqzf+WGpGWbGIrU69swHCNr5ZCk
	 hoty2stHa4I3VdH6Osn1ISoGtDYtbre5GW9wqZK/rCIzvHiDWLhK+f+TKzwQMQchCO
	 EBoii1HLWs97tLIkCgR29E+fWEep4APBlT7nhnN6/AW+w7FcX8ReELFOlG7h5iXLKO
	 cjj7WkNMwI92zj1YGOeOp4ONQ4t7OAMKXEim2YWF/N/mqleYOJp0nJLeu0BfMpFUUM
	 EMhwLcTP0jhhA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 65P6GmuA6584321
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2026 14:16:48 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 25 Jun 2026 14:16:48 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 25 Jun 2026 14:16:48 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Thu, 25 Jun 2026 14:16:48 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <timlee@realtek.com>,
	<dian_syuan0116@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 03/10] wifi: rtw89: fw: lower debug level for UDM1 debug register
Date: Thu, 25 Jun 2026 14:15:38 +0800
Message-ID: <20260625061545.44808-4-pkshih@realtek.com>
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

The UDM1 is user define message to record count of H2C command sent by
driver and received by firmware. Normally, this value should be zero.
Otherwise, throw a warning.

For the new chip RTL8922DE, its default value is not zero, causing a
warning at first time probe. Since this is a debug purpose and the
value will be set to zero right after this checking, lower the debug level.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/mac_be.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/mac_be.c b/drivers/net/wireless/realtek/rtw89/mac_be.c
index 4cb48cf9415a..d9c93adb58ee 100644
--- a/drivers/net/wireless/realtek/rtw89/mac_be.c
+++ b/drivers/net/wireless/realtek/rtw89/mac_be.c
@@ -652,8 +652,10 @@ static int wcpu_on(struct rtw89_dev *rtwdev, u8 boot_reason, bool dlfw)
 	}
 	val32 = rtw89_read32(rtwdev, R_BE_UDM1);
 	if (val32) {
-		rtw89_warn(rtwdev, "[SER] AON L2 Debug register not empty before Boot.\n");
-		rtw89_warn(rtwdev, "[SER] %s: R_BE_UDM1 = 0x%x\n", __func__, val32);
+		rtw89_debug(rtwdev, RTW89_DBG_UNEXP,
+			    "[SER] AON L2 Debug register not empty before Boot.\n");
+		rtw89_debug(rtwdev, RTW89_DBG_UNEXP,
+			    "[SER] %s: R_BE_UDM1 = 0x%x\n", __func__, val32);
 	}
 	val32 = rtw89_read32(rtwdev, R_BE_UDM2);
 	if (val32) {
-- 
2.25.1

