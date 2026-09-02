Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CAE37A493
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 05:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327031; cv=none; b=csgz9g2Q69arFnXBqpXN1TCsYmKcVfuwO7FTiOcY93aRT8yuICg2rC7/yapAO5axi7l/Nz8q9BmVQfwCbS/lbpyEpduwQUK2RBIgJGVy5WckuR8W79TjEJGosnAw81NzhLNwgvCQelKjTqXXUp521sJQ7qkRjyRBRZ9671XiKGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327031; c=relaxed/simple;
	bh=VPW+WJWnb7myGMLnQiN8U2FK7j2Bl5hd0jU2YExpCxY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K1rZBmUFZkaaE4chY6CUCPxSGCKDxq++qdHBMadg/PHjzgkyQ7EcMvcndPNVIDDTVql/H23M1V5+HikuR/9N2rcmhsVWX4L7Mszzoj+uZMiW5R2pcoAd/ZzuzKYRbRtXYZMAI6ZSWlzvyB+Lr0z9NgcSGGzgKobgzwE10BGm5Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=eCCdy55N; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="eCCdy55N"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6825UQjsC2368357, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788327027; bh=SyquOS5Wr2Ew2WJzVHiQhDX5TECcNthweZXjTs+F81w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=eCCdy55NRkOArUBNRUtzENloGqls61uIaAJuuFOFPmc4pMEgHMQRjtBq4b7gT6Tuu
	 htrZadFHJ8degUN4EqUX/g5AOFpp41n6+SMmGdcaexw0evtH5ojp7TWV4zB3RKA4D4
	 tbSFmud6wrk3S2obF+gayqnbDwvsGU0wwdf8WrHAeV4oDS8e/ldS40Ax6cylrt0Ro0
	 7EebUpSFGEDih9TsEP8iM0Jdh6YfBFK2cyD3Ejj8HH9T7rbYG8luRthdpWDOTQMr7V
	 q2wmYkf9dxt1BvPi/y5Bp04PzGykgkkLBa3hXi0vsD8B5CWS5IyoFTqpW1bp8UCXaH
	 UnHxkFMxCZPaw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6825UQjsC2368357
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 2 Sep 2026 13:30:26 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 13:30:26 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 13:30:26 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 2 Sep 2026 13:30:26 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <owen.hsiao@realtek.com>, <echuang@realtek.com>,
	<henchy.chen@realtek.com>, <phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next v2 02/14] wifi: rtw89: 8922d: disable VCORE for thermal protection by default
Date: Wed, 2 Sep 2026 13:29:46 +0800
Message-ID: <20260902052958.50371-3-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260902052958.50371-1-pkshih@realtek.com>
References: <20260902052958.50371-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Chih-Wen Hsiao <owen.hsiao@realtek.com>

To ensure the stability of the thermal protection mechanism,
the primary approach is to reduce the transmit (TX) duty cycle;
the option to lower the voltage(VCORE) is disabled by default.

Signed-off-by: Chih-Wen Hsiao <owen.hsiao@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.h     | 1 +
 drivers/net/wireless/realtek/rtw89/rtw8922d.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index b1a0103aaf0c..a2f6e68987a9 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -6463,6 +6463,7 @@ enum rtw89_quirks {
 	RTW89_QUIRK_PCI_BER,
 	RTW89_QUIRK_THERMAL_PROT_120C,
 	RTW89_QUIRK_THERMAL_PROT_110C,
+	RTW89_QUIRK_THERMAL_PROT_VCORE,
 	RTW89_QUIRK_HW_INFO_SYSFS,
 	RTW89_QUIRK_DISABLE_2GHZ,
 	RTW89_QUIRK_LOW_LATENCY,
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922d.c b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
index 142e693c87bf..a9737c674ecb 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922d.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
@@ -901,6 +901,9 @@ static int rtw8922d_read_sys(struct rtw89_dev *rtwdev, u8 *log_map)
 	u16 digk;
 	u8 vmin;
 
+	if (!test_bit(RTW89_QUIRK_THERMAL_PROT_VCORE, rtwdev->quirks))
+		return 0;
+
 	digk = log_map[0x200] | log_map[0x201] << 8;
 	hal->thermal_prot_vmax = u16_get_bits(digk, B_BE_PWMTUNE_MASK);
 
-- 
2.25.1

