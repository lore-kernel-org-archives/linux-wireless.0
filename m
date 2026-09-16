Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CAD448B8E
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 07:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789543427; cv=none; b=MvN2pcVL9Xq3PwG2KTQwUiKoR7sEVugsfrtZuYQDYkMrmr1dZRa4g3csFcmB9QuYHUx0oCutQ2D+vvjYGOWqWNEbJOKw4CapCwG6dVP6KnCTmJ9ornV/MOXBgM+oVlXMOI70MpzcOjykrQ7WiwNrm/p3LKeQ3JnOAUOwx7znZeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789543427; c=relaxed/simple;
	bh=3qdS0rGz+pWMcb6KU0UQzhKNyjPbtgma3JBgdeCzlAM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BnrL9OPSYboC2CA+PifXOf5JuuOsj0blrBmZcjJa+NPV9NILvsDgHZ86c8RCHIoVCOpHYOqrvTM1k2eB9e02E+06Oc4Vwhdq+s99zxopUWMEO2fhF/DZDMSgZba9dt+73GTOVSZmRZReQOAyaaI1L4ykxM7az5eFfNZVT5qvJqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=T5AiBGSy; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="T5AiBGSy"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68G7NaQC22168420, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789543416; bh=1nTZsdttj9sNAfPEG7N/XPyEe6JFDnZbqIKf99VVw68=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=T5AiBGSy39eqEoVdkwg0L3lmB2thksaF5/FLtSw7wQ6AsP9LwtYI8kLg8nKYqcxWv
	 n85HzX3VnqUpHogAfQzo1v7jr9Tff1E2cFS9vGmVkbFarFiQlC5qi3Q3YsqM9n7dr4
	 NKzfDuJ7N92qxHIQZ/ltqN5rMEZWK5o6ON/pcqYYnWn4YgU/Vx7exTLLzfDBVvvccr
	 rRfQObDGSIVqo0TA7kHoBFdm1vDER8AytCVKWoY9lzB2sx0qhZ56CqIOCKdY0261bz
	 9lYk04rhzO+GD9z5v200aJ8y8/GUsfJ9jxjntsNT/Q4GSrGnBLZOmkTtSV34x0Tpfx
	 95GZxSvkQ3TyA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68G7NaQC22168420
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 15:23:36 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 15:23:35 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 15:23:35 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 16 Sep 2026 15:23:35 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 05/15] wifi: rtw89: coex: support fcxtdma version 8 in TDMA policy
Date: Wed, 16 Sep 2026 15:22:28 +0800
Message-ID: <20260916072238.62574-6-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260916072238.62574-1-pkshih@realtek.com>
References: <20260916072238.62574-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

RTL8922A and RTL8922D firmware sets fcxtdma to 8, which shares the same
TLV encoding as version 7. Extend the _append_tdma condition to accept
version 8 so the TDMA policy is sent correctly for these chips.

Also enable the TDMA and CYCLE report types unconditionally in
_set_fw_report_map so the firmware sends cycle statistics the driver
relies on for coexistence decision-making.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 62b86dc40e87..3a5219fcc7b9 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -2719,7 +2719,7 @@ static void _append_tdma(struct rtw89_dev *rtwdev)
 		tlv->len = sizeof(*v);
 		*v = dm->tdma;
 		btc->policy_len += BTC_TLV_HDR_LEN + sizeof(*v);
-	} else if (ver->fcxtdma == 7 || ver->fcxtdma == 4) {
+	} else if (ver->fcxtdma == 4 || ver->fcxtdma == 7 || ver->fcxtdma == 8) {
 		tlv_v7 = (struct rtw89_btc_btf_tlv_v7 *)&btc->policy[len];
 		tlv_v7->len = sizeof(dm->tdma);
 		tlv_v7->ver = ver->fcxtdma;
@@ -6639,6 +6639,8 @@ static void _set_fw_report_map(struct rtw89_dev *rtwdev)
 		return;
 	}
 
+	rpt_map |= rtw89_btc_fw_rpt_ver(rtwdev, RPT_EN_TDMA);
+	rpt_map |= rtw89_btc_fw_rpt_ver(rtwdev, RPT_EN_CYCLE);
 	rpt_map |= rtw89_btc_fw_rpt_ver(rtwdev, RPT_EN_MREG);
 
 	bitmap = rtw89_btc_fw_rpt_ver(rtwdev, RPT_EN_BT_SCAN_INFO);
-- 
2.25.1

