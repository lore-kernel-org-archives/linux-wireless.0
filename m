Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D924356A35
	for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2026 01:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769132504; cv=none; b=mKAnDKzovQetc5NcdixiC5RZ1jfOmXr4n/VD9q95+mkxdLm86YdKW8zQkO0M9DHfql6dMr+bisjC4oTZB2pJyYq9LUHPVq6XCEPpO1zUqYwJecQaUtMJSVTh73W+2+ODVdMpy1pHO/NK9EksQzFDTwWxdo25doegAhzd0isCBTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769132504; c=relaxed/simple;
	bh=wgCxhwXRc1sHXujiCyPIXZqsvFR73uVRyAd3uSajnos=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RL86M0Ao/dVee4ZR2dKNPUqA2VPv8zfR4DUrmPE9WeNQVO7IOQY/Vv7fspuq59uFbUtYF5JC//NB9fCjF/kf2cReOHT/54NeCpyek0xTXIfDtEqvAO6FjNaa4881sUfg8Jkj1ysi1Mb33YMs9/puxtA0jYnwtEdg/+nnjrFbvyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=VEXgmInR; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="VEXgmInR"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 60N1fS4112206967, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1769132488; bh=HjK2znIkuJa75tfG9NRMq2SPGZRgoNrzl4U1+/6OZT4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=VEXgmInRXF8jymmHTt8vDTjA0iJV7JyKYCR0MyMULkku9IH/eqWjSkKKi8ZlwWANx
	 q+7Q9SzWQjGtQDCl0bIRWYRAAoQzKg2hZ6+l6EM6qq7Pi/qk7SIw4quSsjOg7R9qo3
	 ebFSqzehqvY1pN8zOJLkbIhakeDFzrmssfxx5ZkU8IWr5X+2ECJ26ehMAh5TWBYW+R
	 3OxuPvMWPOjTBz0FQbJb8jjDlVTlf8lkA6HJI7kAORGBvyaTFHYjBpWF5c8sZQrqdD
	 h5qufcW0lEK3lOoS1gYmCNX/RaFiqD+QPdTCzWp8fjJLijng29mvjHKlabgs7nY9bo
	 ithYLFjeiWsdg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.21/5.94) with ESMTPS id 60N1fS4112206967
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2026 09:41:28 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Fri, 23 Jan 2026 09:41:28 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Fri, 23 Jan 2026 09:41:28 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 10/11] wifi: rtw89: pci: validate release report content before using for RTL8922DE
Date: Fri, 23 Jan 2026 09:39:56 +0800
Message-ID: <20260123013957.16418-11-pkshih@realtek.com>
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

The commit 957eda596c76
("wifi: rtw89: pci: validate sequence number of TX release report")
does validation on existing chips, which somehow a release report of SKB
becomes malformed. As no clear cause found, add rules ahead for RTL8922DE
to avoid crash if it happens.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/pci.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/pci.c b/drivers/net/wireless/realtek/rtw89/pci.c
index 093960d7279f..b8135cf15d13 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -604,8 +604,10 @@ static void rtw89_pci_release_rpp(struct rtw89_dev *rtwdev, void *rpp)
 
 	info->parse_rpp(rtwdev, rpp, &rpp_info);
 
-	if (unlikely(rpp_info.txch == RTW89_TXCH_CH12)) {
-		rtw89_warn(rtwdev, "should no fwcmd release report\n");
+	if (unlikely(rpp_info.txch >= RTW89_TXCH_NUM ||
+		     info->tx_dma_ch_mask & BIT(rpp_info.txch))) {
+		rtw89_warn(rtwdev, "should no release report on txch %d\n",
+			   rpp_info.txch);
 		return;
 	}
 
-- 
2.25.1

