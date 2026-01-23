Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C2E3161A1
	for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2026 01:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769132497; cv=none; b=ixkZUmMuDLUINBpkZZwZ7Dxt1+pjy9Wc/V0Mw4aJtwA/21fEOuIVzXtTRE2e2n5SR6P+fqCRZhlri9AmDH8E/2EkwOmReOvzxhspKPQT1ak729BK6yJF0XRFekt7GqeVEs1MHDi7fl+BsEdoiUHCEyZF2AOgmFTtivq0wirScy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769132497; c=relaxed/simple;
	bh=5nLA20oBPSZC+XmwY1kZQDHo2Wd7WB5U6+aLq/y4iwo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KEKys2zjqse1yhOSxX5+5QzfUkRhKI4uujRoghE/Uud8mTBs09EQBhRGXokTcC2pTrzizkaemCdN0YtbonOstf0bPtx20FSuqxNwJB8cw6CXo8/tOR1T6IKAH2tdkAx758MhXzNd8sWoqVdIECA7eSxFXQdgeV9dBmes6+0M7cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=gnHcU9ND; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="gnHcU9ND"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 60N1f78t92206856, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1769132467; bh=PstFwKCZvNP8PX23kzywLnisRu9aUtZuzWevBtLYoMM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=gnHcU9NDfVqyy0/AezkW1ppafHn95dS4XxApRgbMtiR7swQ3P58K2MoIc2dBDgHKD
	 z8jq/dg4LJYX0asg3GkLDUShI+j3kNJN4rTMqoJAO8Dd6ZXOu5b95U0/EduE0AwdYG
	 IDmIbwNZIpecO2+tq1RLuquj7GSd6xpL82hgVPP4Y8obT491U9lyTFd3a8yl0AtRtF
	 T6OQtYtaItJpZSvOHTz9km/vGKhmpSgVnMQ70fBGwLw9bjbavwkptKKzv9ZUx93YOd
	 mzwbiuE/lvbmzWrWYsA1T9diewbidxPqfG/ra+a9QamlwOFGmZni1HosfIRslw9xhT
	 5dwMTCeatGGsw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.21/5.94) with ESMTPS id 60N1f78t92206856
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2026 09:41:07 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Fri, 23 Jan 2026 09:41:07 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Fri, 23 Jan 2026 09:41:07 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Fri, 23 Jan 2026 09:41:07 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 06/11] wifi: rtw89: fw: correct content of DACK H2C command
Date: Fri, 23 Jan 2026 09:39:52 +0800
Message-ID: <20260123013957.16418-7-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260123013957.16418-1-pkshih@realtek.com>
References: <20260123013957.16418-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

The fields of command should be u8 instead of __le32. However, current
firmware doesn't really use the data for now, so this mistake doesn't
impact performance.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 6 +++---
 drivers/net/wireless/realtek/rtw89/fw.h | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 4035ec8defa8..8a33a63619d5 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -7503,9 +7503,9 @@ int rtw89_fw_h2c_rf_dack(struct rtw89_dev *rtwdev, enum rtw89_phy_idx phy_idx,
 	skb_put(skb, len);
 	h2c = (struct rtw89_h2c_rf_dack *)skb->data;
 
-	h2c->len = cpu_to_le32(len);
-	h2c->phy = cpu_to_le32(phy_idx);
-	h2c->type = cpu_to_le32(0);
+	h2c->len = len;
+	h2c->phy = phy_idx;
+	h2c->type = 0;
 
 	rtw89_h2c_pkt_set_hdr(rtwdev, skb, FWCMD_TYPE_H2C,
 			      H2C_CAT_OUTSRC, H2C_CL_OUTSRC_RF_FW_RFK,
diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index e4dbcd899ddb..da802482c47d 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -4912,9 +4912,9 @@ struct rtw89_h2c_rf_txgapk {
 } __packed;
 
 struct rtw89_h2c_rf_dack {
-	__le32 len;
-	__le32 phy;
-	__le32 type;
+	u8 len;
+	u8 phy;
+	u8 type;
 } __packed;
 
 struct rtw89_h2c_rf_rxdck_v0 {
-- 
2.25.1

