Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0774562BA
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 07:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789544452; cv=none; b=jIpkNsvoiMypfSNRczZnPKGKnIJoDrA4bpDl5+5JLm4v/o5tbY3wNQLA+gLhx/SBRYeLmK3XAq62pUJXqB90V8wgu+7O/6M7KqOahyKxNunnOInoVmWinXGbLMJK9nbk3jxlFpnV3uca2fILZhDvZfsN8xvIAYG+WUmju5uwjYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789544452; c=relaxed/simple;
	bh=yfSKa+FHcy4WA9db6srwZHCq3Rvny4F6/nxbKNTis9w=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UKafnZcoH/AGYLR7r0ErvTtQaEme2+vgtfSBiLqQ5r+pvWcQbPNe1QfRBsNHrVIDWgMtB68aMhlnTfiRzBVZpnMPwj1M++W2EmG2lpEtzApkcxNgiA8QlGsYhrn9g84ANortuxmwHrhmgL/7RXdvLpAATvlwBKoDt1av+PSw9D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=gVm/5miU; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="gVm/5miU"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68G7eVtlD2173518, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789544432; bh=AapfzfKyjmsYpsznuan0JN/MmWTdtvcaqnKu+Wzv+LA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=gVm/5miU26UP9N0wpx5lk2qMI+4y4LKj+iBkplw8vpfueX3yuS+dNLxBE9EHvzqSp
	 cfTnU6lVpA1MN1tADePlEuKriGml8NzgoRZZE5+Eo65LIDAnDccpHmejf2BoLVfOlL
	 KOut097BbKfUgGG696HWj+k8IbijaospC7hbXUKmayu6x2Hwwrj9OTkFQeSvX85vBV
	 D9YYXlot/uKwiFvzRhH2JQLQ75q6zqHsCTO5555+dCDKmf9LcOufFYPb6XyLzr0wcD
	 +TxEd+jKgtTZywYK3bxqmdEim3zy9bC/+vwONySGILCtIJEdPWARZyRUqu0QwH2qaG
	 PQcDPcrcymf4g==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68G7eVtlD2173518
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 15:40:32 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 15:40:30 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 15:40:29 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 16 Sep 2026 15:40:29 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <skokovmaksimevg@gmail.com>
Subject: [PATCH rtw-next] wifi: rtw89: 8851b: avoid using CPUIO feature with old firmware
Date: Wed, 16 Sep 2026 15:40:00 +0800
Message-ID: <20260916074000.65960-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Chih-Kang Chang <gary.chang@realtek.com>

The old firmware for RTL8851B doesn't support CPUIO feature. Add firmware
feature check to avoid C2H register polling timeout.

Reported-by: Maxim Skokov <skokovmaksimevg@gmail.com>
Closes: https://lore.kernel.org/linux-wireless/20260912193939.5565-1-skokovmaksimevg@gmail.com/
Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index fa30543a8b42..8866c81edc7d 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -892,6 +892,7 @@ static const struct __fw_feat_cfg fw_feat_tbl[] = {
 	__CFG_FW_FEAT(RTL8851B, ge, 0, 29, 37, 1, TX_WAKE),
 	__CFG_FW_FEAT(RTL8851B, ge, 0, 29, 37, 1, SCAN_OFFLOAD),
 	__CFG_FW_FEAT(RTL8851B, ge, 0, 29, 41, 0, CRASH_TRIGGER_TYPE_0),
+	__CFG_FW_FEAT(RTL8851B, lt, 0, 29, 57, 0, NO_WOW_CPU_IO_RX),
 	__CFG_FW_FEAT(RTL8851B, ge, 0, 29, 127, 0, SER_L1_BY_EVENT),
 	__CFG_FW_FEAT(RTL8851B, ge, 0, 29, 130, 0, SIM_SER_L0L1_BY_HALT_H2C),
 	__CFG_FW_FEAT(RTL8852A, le, 0, 13, 29, 0, OLD_HT_RA_FORMAT),

base-commit: 73e3b1c94c7d5b4a113e7cbb42665dc2fe3b9d78
prerequisite-patch-id: a874231735fadfceb48a05d7f3b8e9c698976037
-- 
2.25.1

