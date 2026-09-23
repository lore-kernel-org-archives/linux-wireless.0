Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E666134D3B0
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 07:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790148512; cv=none; b=Ov/god/X7IDJygouL8ysY+7tFQnc8g//lWNeLJxhxGPteieOiBG10keye2hl26onOj+QAhqwzH5m4oZ+gxsuo8F4XGnodJaKVOiw67LtfTZTxVYu4lXVMaQqyPRhRusrYFu676lm63WL23fiHagkoRKM8+T4PZgx6RJPwJcETkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790148512; c=relaxed/simple;
	bh=rGwoo0002KBcQWd2RQK4hq82oSt7M4ihsG3Yp9LL2ks=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Riv3p/Ia8NemXHivDZvN4ZMVTBrNWm/EvD8eIvg8KRdgUE5HxXgDM5n9owRwfXLTXZobLmrQNupw3CUQ/mukmYB3H+hVwgx3eblj98cXUI0RIJ8S/cBDa1Q3kK+3mgPb8JAVIQwEY7wrSvMQJhQ1l0o2cGjL5edygOKLGSju+g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=KVhb3kpI; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="KVhb3kpI"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68N7SQywC136866, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790148507; bh=zBc1UIPhIec7woF7FP/p71tkKitatLj2iFdtqjgV3nQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=KVhb3kpII0WzLYDBmGoDwLiqFF8oZ28R6+oG5MpmvMeMIsT/YMwN6PoyIkQkRt+JW
	 uCZozEr7kW9hW5mf0wUqfzeQrtiZekjv9D2jhugZ7YJCodQvX8JyYQBKKBRVHVPCiS
	 egjR6iz0Q8n0+cJ74YZB75rQ6aKKQU6l/E5vJ2IGgJUSQvdLlR8P1cwPPGHtpomsws
	 B2XLgWYf16x5E8QkjuQOmsN+G3CoMfqsZixhePWfe5EcINqQ0OL/I0XzV0dBktbZVq
	 6iaNU/94mYmBdpQutQ4zTU6gO6fNmG/RWlTkowSTQp7cwXbFkfrlGO7AAB/8g6OLoM
	 UjCi08jOxMGbQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68N7SQywC136866
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 15:28:26 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 15:28:27 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 15:28:27 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 23 Sep 2026 15:28:27 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 2/3] wifi: rtw89: wow: check AOAC report C2H event length
Date: Wed, 23 Sep 2026 15:27:40 +0800
Message-ID: <20260923072741.54118-3-pkshih@realtek.com>
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

The AOAC report C2H event contains fixed-size fields including GTK
and IGTK. The received C2H skb may contain less data than the expected
AOAC report size.

Check the skb length before processing the AOAC report to ensure the
complete report is available.

Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/mac.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
index 093291e8854d..ad849e4b4a50 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -5897,6 +5897,13 @@ rtw89_mac_c2h_wow_aoac_rpt(struct rtw89_dev *rtwdev, struct sk_buff *skb, u32 le
 		(const struct rtw89_c2h_wow_aoac_report *)skb->data;
 	struct rtw89_completion_data data = {};
 
+	if (skb->len < sizeof(*c2h)) {
+		rtw89_warn(rtwdev, "wow: aoac rpt skb len %u is too short\n",
+			   skb->len);
+		data.err = true;
+		goto out;
+	}
+
 	aoac_rpt->rpt_ver = c2h->rpt_ver;
 	aoac_rpt->sec_type = c2h->sec_type;
 	aoac_rpt->key_idx = c2h->key_idx;
@@ -5913,6 +5920,7 @@ rtw89_mac_c2h_wow_aoac_rpt(struct rtw89_dev *rtwdev, struct sk_buff *skb, u32 le
 	aoac_rpt->igtk_ipn = le64_to_cpu(c2h->igtk_ipn);
 	memcpy(aoac_rpt->igtk, c2h->igtk, sizeof(aoac_rpt->igtk));
 
+out:
 	rtw89_complete_cond(wait, RTW89_WOW_WAIT_COND_AOAC, &data);
 }
 
-- 
2.25.1

