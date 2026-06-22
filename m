Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31673246BBA
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2026 01:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782093329; cv=none; b=WtTkQ6dQNRaeBE9oDcvpGenII8UTUa7mUzG897X3nMTuCoYUKJmKFCUG7Iaw5/PX4HgYMp1ahMgIEsR242vyoOy0Q7T+wVvM94T4r2UqwKcpHegrlLXfrtZxtTsAfAu+YW7YGMapVdZHKx29sGL6jzLD7gJ7wYdCpsDArZ0jajY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782093329; c=relaxed/simple;
	bh=DKEcuzrCu3191vXbIc3sS00Uh5KUrU+fJm+0rUBvRyk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gCKiCOX1u9V2X0CcJxJ6z9iSVe8ZbMTJS2eNw1klqb9iyIYEu9X4o1BhrKYMkZQe/9e0R86pCsxLgbNq6eyoUcUGaLTP4JfcoKNdiHdD6sp7C6JPbcW4jYLIi2RUe6bJAVLNBbeax8ZExAR4RstfUf+URTL9JGEkJ6/6v/02XrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=OsNqNGoQ; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="OsNqNGoQ"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 65M1tO5I12099618, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1782093324; bh=dUHimFRGQIHMSvZEmG6X8YOkK1zUw/oxvA6W8MNsCaA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=OsNqNGoQiNrQwz8ERSR9WBiH/GbHwiFwqtIJxp+LIlHkqrGmScd85sa4OsYjOEdLb
	 h1QwOUY0y2czZn8Zjd9LD2Xi+EN6sUoqPtmCPvcIXzPu70+wTx2jfXgANLUOht8VYd
	 gKQNXy78MjyQOUjWW3G7FakAIz0Ga2ELNv9i4YEm5d3YekwvuwPy3Y/tVweVwvbsca
	 wulOssTzPgWXvvVbRJk4h6gnxA4kWf1lLg9yCHFHoN5VvwTPs6WmyzbzwEIQvwUey2
	 izmYOOzG80qbM8r38k4ZWsJ5yV72sSYbgU63C22aLB+04PBtPVRKpFVYvxNUyzKWPN
	 3cKR1HVG5XFlA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 65M1tO5I12099618
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 22 Jun 2026 09:55:24 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Jun 2026 09:55:20 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Jun 2026 09:55:20 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Mon, 22 Jun 2026 09:55:20 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>, <Jes.Sorensen@gmail.com>
Subject: [PATCH rtw-next] wifi: rtl8xxxu: 8723bu: remove reference of non-existing firmware rtl8723bu_bt.bin
Date: Mon, 22 Jun 2026 09:54:39 +0800
Message-ID: <20260622015439.9621-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

A report from [1] that firmware is missing in linux-firmware repository.
However, there is no specific firmware for RTL8723BU for Bluetooth enabled.
Remove the unnecessary reference of firmware file.

[1] https://github.com/rtlwifi-linux/rtlwifi-next/issues/20

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/8723b.c | 11 +----------
 drivers/net/wireless/realtek/rtl8xxxu/core.c  |  1 -
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/8723b.c b/drivers/net/wireless/realtek/rtl8xxxu/8723b.c
index e314ef991b38..24c6d8ae76ec 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/8723b.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/8723b.c
@@ -483,16 +483,7 @@ static int rtl8723bu_parse_efuse(struct rtl8xxxu_priv *priv)
 
 static int rtl8723bu_load_firmware(struct rtl8xxxu_priv *priv)
 {
-	const char *fw_name;
-	int ret;
-
-	if (priv->enable_bluetooth)
-		fw_name = "rtlwifi/rtl8723bu_bt.bin";
-	else
-		fw_name = "rtlwifi/rtl8723bu_nic.bin";
-
-	ret = rtl8xxxu_load_firmware(priv, fw_name);
-	return ret;
+	return rtl8xxxu_load_firmware(priv, "rtlwifi/rtl8723bu_nic.bin");
 }
 
 static void rtl8723bu_init_phy_bb(struct rtl8xxxu_priv *priv)
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/core.c b/drivers/net/wireless/realtek/rtl8xxxu/core.c
index 646fe76b086e..4e8a4769603c 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/core.c
@@ -37,7 +37,6 @@ MODULE_FIRMWARE("rtlwifi/rtl8192cufw_B.bin");
 MODULE_FIRMWARE("rtlwifi/rtl8192cufw_TMSC.bin");
 MODULE_FIRMWARE("rtlwifi/rtl8192eu_nic.bin");
 MODULE_FIRMWARE("rtlwifi/rtl8723bu_nic.bin");
-MODULE_FIRMWARE("rtlwifi/rtl8723bu_bt.bin");
 MODULE_FIRMWARE("rtlwifi/rtl8188fufw.bin");
 MODULE_FIRMWARE("rtlwifi/rtl8710bufw_SMIC.bin");
 MODULE_FIRMWARE("rtlwifi/rtl8710bufw_UMC.bin");

base-commit: 972c4dd19cb92e03d75b66c426cfade07582a1ba
-- 
2.25.1

