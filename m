Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793609775;
	b=VhTdl1gpm1z5BeaECDtE5IdBeNeX7aMDmqnX3e7MSw4EQdMvpRlNvDUZctYzgto0YN+x
	 KLeK3jK8NrvVAIQHa4ZjPrMPGTA80ZkiuDwuh68JDsDks+LZgV5E8CHMvF6/3mnoMJM8F
	 338wRuNytyIPwQTjqS6DzN4LN5RupkTvZ2EKFElSCmaEZpClgsYHq052iG9qswDZR14MZ
	 INvMXpu7I7Pwv7UNIJVI6aJR/kOhI7HxuaJkiipVjL6EKtvKExLuVtjvXyNOM2j8bjvvH
	 5KN4TCBy7ynUzPft02DjzSc1vSrEGxBj4Vpy9vuxqstx224g2jqb2JLq+i0a98ndHWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793609775;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type;
	bh=oiaRa1AowtMNJMv51HujMiomN8O5VYNpKPiv8Yixwjg=;
	b=r6xu4y11qWl/9htbi+ByAkW1BXchAx+s1xe69LtmnsQxTZyWoh/jg6ShJsBiV98Ln4HA
	 CJ+51IFP3IdUACr92Jo5Uc6alCkBBEBqF3ui7Mt2z9kMwxL/8BOQCxHsRPeLZDYy9Ouqu
	 r81xeTyb5W9dvST6QCRT2o2bNh/yyayQv9x7Hc1nSmOCvfb4X3KDnsGbBmcER/kZX6YzU
	 2H3b3JALdA5pcZx1UzvwPQaSV3IzYhDCKjdw905KSLvHNBpReNog/XgM6lpN0VfQglGuB
	 jRyEZ0VHlWVyuj4y37f6VxFCztZR/jhqJGy7Jvpbw3ROVRYn0fKl/575egv/y8YeBEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=gS0ikxbR;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B12606A324
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 08:56:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8B12606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=gS0ikxbR
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A28u8hC51997670, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793609768; bh=oiaRa1AowtMNJMv51HujMiomN8O5VYNpKPiv8Yixwjg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=gS0ikxbR9gUqrcKZ7drh0yDLkYb52gpMadL7vFwySO0ITYCDg0z3i55BV42ocWHE5
	 owoUjAiBpAcYBPXeE+5Nmu2HzxuwqZtZET+PMhZVU4SyAIUAmj+CVOpNYihXQqE27T
	 +0+xFyeUlTe44HZJ6gbxQdzT3EM4NsCyg0yEjydL8yjwYKN3pxp8FAH5N94ytVBC12
	 /GmkaNtneygSYn2RHQnsAagvN4ruHR2oYl+Y/bs2DFCBSrYuAsqIxbLuMYCxAaTDzn
	 IIY5BjD1R1W56tBrK+dbG1VDPS18zILxWXtZaWvCORWblG9CNv52CMfrLlM6Chb9qy
	 x0ECcTKEIRzmQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A28u8hC51997670
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 2 Nov 2026 16:56:08 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 2 Nov 2026 16:56:08 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 2 Nov 2026 16:56:08 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Mon, 2 Nov 2026 16:56:08 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <charlesl@valvesoftware.com>, <sabae@valvesoftware.com>,
	<kevin_yang@realtek.com>, <wenjie.tsai@realtek.com>
Subject: [PATCH rtw-next v2 2/2] wifi: rtw89: debug: support to disable regd learn
Date: Mon, 2 Nov 2026 16:55:34 +0800
Message-ID: <20261102085534.15153-3-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261102085534.15153-1-pkshih@realtek.com>
References: <20261102085534.15153-1-pkshih@realtek.com>
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
index 3a430bd082c3..49cbdc3e3718 100644
--- a/drivers/net/wireless/realtek/rtw89/debug.c
+++ b/drivers/net/wireless/realtek/rtw89/debug.c
@@ -4777,6 +4777,7 @@ static const struct rtw89_disabled_dm_info {
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

