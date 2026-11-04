Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793784630;
	b=o4uxb5gXi1Jsx8BYPjCJvoPa//X3F0DEm1kztMAT7eWlEEUxlWO+C/RdJ12LKCEE+Aqd
	 EOzsoFik9J1TH7yPCYZ+uAc1hrMUysVmVT5rs7IFu9WaYxlSf1PI2mcYYppzUDqu19sj1
	 8mQ31CnqNX+gnM4jRTCMOzV5Apdu9vQCRBZu40xv1JZMiTDoAWsWKe1H92jL+r7G2FEM/
	 /yahJX8gj88CB3EYu9GpZnspid5kwpbT+6vtcRFa03+DjSbCh+ebd0P5A+05wwa6n+EQm
	 oSd93NRYyk8CENf6XbxxOvB4jvLmePuRa9aQDR0+rvZHow2LGcsYkG/zAukpL6l1krQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793784630;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type;
	bh=jsti4YIlw4BR0jgt8eBfSPm9Ca6RK0WfCgBKQFI3oAY=;
	b=x5jDacyKRhIzEGbuN+Y4/MixZH2rCnxNJfFN5Yx3VmCfptEtyBt5OuoxbEmQTT0Hw/kz
	 JSsNsDh11t3NdvT1Ac4GCP1EHjv/hqaFqWDLrlFTzv1tB6yjeRT8FEMkd15LOEjTFQxXq
	 KH6WmpIOxocZwAJ1sPlp7ABmTmnDUXjsCQSYMeYxx1gfOLIDKwfaJZ7OfC/p6Jngc6wvz
	 ZMeUEXZvGFj/v67fZmqnY7hTMGf4K41T/0OwQwnTDenrYEbB6d+YXi0Yb1anhGEwr85QU
	 8oRgl43SWhXUaDpe2gygctqbqp7m7v9UEsdMu6e/3cveeoHRedKcc3P3HCqoE32em4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=O1xNuvG6;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809D5606A31B
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 09:30:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 809D5606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=O1xNuvG6
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A49UNa743873491, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793784623; bh=jsti4YIlw4BR0jgt8eBfSPm9Ca6RK0WfCgBKQFI3oAY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=O1xNuvG6Ic8MDHbAID6WwP5q4mngdDxDXhmNP1KLbU3M2hWyzsFfFRC7zhv9CArTE
	 AOAyuxv6fKHB3xM1R7eCfk90V/pNmyCa37IPAop+DQeAXaweUnQkrJOGEk+tcubgOK
	 hB5V6iqeS0eMU8WQzwcVSMHQzJbsTKkNESWuK6FhiFzZs8QBOqQ6OX2kY0F3GSghlV
	 idU1+cL/PlIXsshvVgX1kySfRajO5bJvER+NSR9/vJsbI9XLX9a93dwOnLDEwWeK64
	 iTw9UZPAFFEPfhV1nowAuus7msKOfWe/VVWaNW5gKRQcqWI78ehazSzauDFE3wjEvg
	 XOBDmMMGYWklA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A49UNa743873491
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 4 Nov 2026 17:30:23 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 4 Nov 2026 17:30:21 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Wed, 4 Nov 2026 17:30:21 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <charlesl@valvesoftware.com>, <sabae@valvesoftware.com>,
	<kevin_yang@realtek.com>, <wenjie.tsai@realtek.com>
Subject: [PATCH rtw-next v4 2/2] wifi: rtw89: debug: support to disable regd learn
Date: Wed, 4 Nov 2026 17:30:08 +0800
Message-ID: <20261104093008.63916-3-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261104093008.63916-1-pkshih@realtek.com>
References: <20261104093008.63916-1-pkshih@realtek.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Zong-Zhe Yang <kevin_yang@realtek.com>

Set BIT(RTW89_DM_REGD_LEARN) to dbgfs disable_dm if needing to disable
regd learn mechanism at runtime. Read dbgfs disable_dm to show current
status.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
v4: no change
v3: no change
v2: no change
---
 drivers/net/wireless/realtek/rtw89/core.c  | 8 ++++++++
 drivers/net/wireless/realtek/rtw89/core.h  | 1 +
 drivers/net/wireless/realtek/rtw89/debug.c | 1 +
 drivers/net/wireless/realtek/rtw89/regd.c  | 4 ++++
 4 files changed, 14 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 8c4dd6f4a797..1cdf78a9a297 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -5552,6 +5552,7 @@ void rtw89_core_dm_disable_cfg(struct rtw89_dev *rtwdev, u32 new)
 {
 	struct rtw89_hal *hal = &rtwdev->hal;
 	u32 old = hal->disabled_dm_bitmap;
+	u32 changes = new ^ old;
 
 	if (new == old)
 		return;
@@ -5559,6 +5560,13 @@ void rtw89_core_dm_disable_cfg(struct rtw89_dev *rtwdev, u32 new)
 	hal->disabled_dm_bitmap = new;
 
 	rtw89_debug(rtwdev, RTW89_DBG_STATE, "Disable DM: 0x%x -> 0x%x\n", old, new);
+
+	if (changes & BIT(RTW89_DM_REGD_LEARN)) {
+		if (new & BIT(RTW89_DM_REGD_LEARN))
+			rtw89_regd_learn_cancel(rtwdev);
+		else
+			rtw89_regd_learn_queue(rtwdev);
+	}
 }
 
 void rtw89_core_dm_disable_set(struct rtw89_dev *rtwdev, enum rtw89_dm_type type)
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index d0a42f09fa13..27fe4c0fa316 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -6485,6 +6485,7 @@ enum rtw89_dm_type {
 	RTW89_DM_INACTIVE_PS,
 	RTW89_DM_DIG_PD,
 	RTW89_DM_VCORE,
+	RTW89_DM_REGD_LEARN,
 };
 
 #define RTW89_THERMAL_PROT_LV_MAX 5
diff --git a/drivers/net/wireless/realtek/rtw89/debug.c b/drivers/net/wireless/realtek/rtw89/debug.c
index 3b7f8a8090fa..3ebe4aa04e2b 100644
--- a/drivers/net/wireless/realtek/rtw89/debug.c
+++ b/drivers/net/wireless/realtek/rtw89/debug.c
@@ -4780,6 +4780,7 @@ static const struct rtw89_disabled_dm_info {
 	DM_INFO(INACTIVE_PS),
 	DM_INFO(DIG_PD),
 	DM_INFO(VCORE),
+	DM_INFO(REGD_LEARN),
 };
 
 static ssize_t
diff --git a/drivers/net/wireless/realtek/rtw89/regd.c b/drivers/net/wireless/realtek/rtw89/regd.c
index 89be36ccd84b..f75ce808254c 100644
--- a/drivers/net/wireless/realtek/rtw89/regd.c
+++ b/drivers/net/wireless/realtek/rtw89/regd.c
@@ -715,6 +715,7 @@ void rtw89_regd_learn_queue(struct rtw89_dev *rtwdev)
 		4, 16, 64, 256, 1024, 4096,
 	};
 	struct wiphy *wiphy = rtwdev->hw->wiphy;
+	struct rtw89_hal *hal = &rtwdev->hal;
 	unsigned int delay;
 	unsigned int index;
 
@@ -726,6 +727,9 @@ void rtw89_regd_learn_queue(struct rtw89_dev *rtwdev)
 	if (!regd_learn->shall_run)
 		return;
 
+	if (hal->disabled_dm_bitmap & BIT(RTW89_DM_REGD_LEARN))
+		return;
+
 	rtw89_debug(rtwdev, RTW89_DBG_REGD, "regd_learn: queue (retry=%u)\n",
 		    regd_learn->retry);
 
-- 
2.25.1

