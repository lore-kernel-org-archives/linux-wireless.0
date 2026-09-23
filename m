Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11FB03148DA
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 07:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790148516; cv=none; b=Uxfmd4du0CI/Qf+O9bNIMs2k0F1nkN0ZMzRZHGy6j+vVyxDvFkRBwpCOuN+8NZDzV1fiJwR2zuojID5E4Cs8RukbgSWEWvh0sQ9tjkf9dA3sPOSeSpoJomKw2+q92NRUxeBIMmq4iNzhEahWLq1ZPLG97MK0KMkfhVV0n9c6eE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790148516; c=relaxed/simple;
	bh=ILMw6DOS665Hf8v2eNwmKfr4190xr5gk7uJll+YTAfQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gg0DPxkyG2JTtMNOr0h4k3ld2oobbrGRJxFMZrMqXc/U3cyJ4294R9mCj9o6ULInMygesJ+FGRAPpStl42k2RDzQIy2Xu++STrLsqTzpKvCQqBraFACxiQKYtxaNZjCQCOd4LMZ8w0Vb5mh3MTivJS8zDgwSHm2k7fJBLamZFZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=n76mkvLh; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="n76mkvLh"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68N7SW1a8136887, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790148512; bh=frQltAAtg7XDKKzthlKlGNYbNJQytHb1R4EPviWULbs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=n76mkvLhDxYsnOhB4l1JVx9H36tw460GPj3iGuAiZHzjPJKp+FOnCp69S6cvUJ1H0
	 DDKVmPoZSNh+gGuO9P4l9WZ2BzxXKnbdHjudYO9tAqe6mDtrtAqygBT3zaitP2uSRd
	 Pdgx06cf4TrG/nPGCQAauQvTB2LkAyK/n15NWGTZ1+OhxYq05jli7AQVw6K2HbVRPN
	 VDpWhrzcK81gaYMbIy6oEQoAEc/NQzy7zz529XLtYEewVIijNE6Fx9TySAbK2vRmqh
	 V4Wanq0ANCg8BpW3LC8v0f2bOooNXvxcJ7ID0VPrHlFx4TrgjPEn9nn9zy+tU+yKHJ
	 wCph14v3RTE7w==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68N7SW1a8136887
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 15:28:32 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 15:28:32 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 15:28:32 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 23 Sep 2026 15:28:32 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 3/3] wifi: rtw89: wow: check AOAC report key index
Date: Wed, 23 Sep 2026 15:27:41 +0800
Message-ID: <20260923072741.54118-4-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260923072741.54118-1-pkshih@realtek.com>
References: <20260923072741.54118-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Chih-Kang Chang <gary.chang@realtek.com>

Check the key index reported by firmware before updating the GTK RX IV
information in the AOAC report.

The key index is obtained from the firmware C2H register and is used
to select the GTK RX IV entry. Make sure the reported index is within
the available GTK RX IV entries before processing the report.

Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/wow.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/wow.c b/drivers/net/wireless/realtek/rtw89/wow.c
index 0bf34692c7ce..7a2d6904951f 100644
--- a/drivers/net/wireless/realtek/rtw89/wow.c
+++ b/drivers/net/wireless/realtek/rtw89/wow.c
@@ -546,6 +546,9 @@ static int rtw89_wow_get_aoac_rpt_reg(struct rtw89_dev *rtwdev)
 	aoac_rpt->key_idx =
 		u32_get_bits(c2h_info.u.c2hreg[0], RTW89_C2HREG_AOAC_RPT_1_W0_KEY_IDX);
 	key_idx = aoac_rpt->key_idx;
+	if (key_idx >= ARRAY_SIZE(aoac_rpt->gtk_rx_iv))
+		return -EINVAL;
+
 	aoac_rpt->gtk_rx_iv[key_idx][0] =
 		u32_get_bits(c2h_info.u.c2hreg[1], RTW89_C2HREG_AOAC_RPT_1_W1_IV_0);
 	aoac_rpt->gtk_rx_iv[key_idx][1] =
-- 
2.25.1

