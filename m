Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CA431ED83
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 06:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790750808; cv=none; b=nPS5OCqNKjt34QPV/f7JFQWY4wsY1Cn/Hd55+rCHmW7gnHoPVcOGvWkVVr4cDi1N1NlCkmuU/jdWWD6vOCmFOQnrmS5YijM4uEHAEt5pgo0+t91MFgmsWZwF/Ly9VKW7ozOA+EK9Gk6bS89EDLDLr6eQvl40+hJRLMTXpgnDJuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790750808; c=relaxed/simple;
	bh=y4zdWSaB3yUW2s63sXZEgB06lkrme5hwpa5KaXAtRnc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SLLGMkzUCxUWcCRjdYW+89u3lOukkONJbboRR6EeIyObVPpStmZmACVIXX8WUcxrJujQVzPvREYFVK26HmbCyMXL4Zd+pVyIPw7eDngwHFiKl/MCX7xAxEsYr/KWkIqIhxdWa4j2w3Wb3xIe7nIfTSdtlpAz/lde3g8BKwsF4zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=n9PRNfah; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="n9PRNfah"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68U6kcGmB1883076, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790750798; bh=znelBt7MoLLStHEdiNmDeh7FloU+YpeutnCM62Fyglc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=n9PRNfahu0QerGYn/rCvTPeynwrFfdmnq7fTCiLE17hi83X2sufQhX0N9lzns5dtG
	 TvMWEuz8k00n/nkXBr7qwJmxp/lGHAyF/KEkuQbglU5iz8RrpeDzWJuQCX8WWqQqDm
	 RlAqb7CLwLUq7ftx5rOYbvxsZ/apfzHZcAN7GVnejhswQ3gAtyYhKby8bNBsnWlQT5
	 jTjj1iIRFImjXsjvdPEml45Eh7m9O1b7v/Zp7sTuxyb22OC8VHaB4lfv1r72cOhVtB
	 HqyWWF4DXmhA7Tu4emrqvqGq6Juptw1coIK2Kv9k3dgGrMZ1cDz6egucaM9lIvGiI9
	 WRCTnswajCrlg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68U6kcGmB1883076
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 14:46:38 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 14:46:39 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 14:46:38 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 30 Sep 2026 14:46:38 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <echuang@realtek.com>,
	<wenjie.tsai@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 6/6] wifi: rtw89: pack I/O during RF nctl init to reduce execution time
Date: Wed, 30 Sep 2026 14:45:24 +0800
Message-ID: <20260930064524.39403-7-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260930064524.39403-1-pkshih@realtek.com>
References: <20260930064524.39403-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Johnson Tsai <wenjie.tsai@realtek.com>

Wrap the register writes of rtw89_phy_init_rf_nctl() with
rtw89_io_pack/unpack so they are batched into single bus transactions,
reducing API execution time.

8852C USB2.0 AMD B450 initialization time:
    rtw89_phy_init_rf_nctl                  5355 ms -> 10 ms

Signed-off-by: Johnson Tsai <wenjie.tsai@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/phy.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/phy.c b/drivers/net/wireless/realtek/rtw89/phy.c
index 074865665b16..795920b899d9 100644
--- a/drivers/net/wireless/realtek/rtw89/phy.c
+++ b/drivers/net/wireless/realtek/rtw89/phy.c
@@ -2071,7 +2071,10 @@ static void rtw89_phy_init_rf_nctl(struct rtw89_dev *rtwdev)
 	rtw89_phy_preinit_rf_nctl(rtwdev);
 
 	nctl_table = elm_info->rf_nctl ? elm_info->rf_nctl : chip->nctl_table;
+
+	rtw89_io_pack(rtwdev);
 	rtw89_phy_init_reg(rtwdev, nctl_table, false, rtw89_phy_config_bb_reg, NULL);
+	rtw89_io_unpack(rtwdev);
 
 	if (chip->nctl_post_table)
 		rtw89_rfk_parser(rtwdev, chip->nctl_post_table);
-- 
2.25.1

