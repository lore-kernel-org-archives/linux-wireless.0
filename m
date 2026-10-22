Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792674599;
	b=jQgtdsoQ+deX4FRLC0LZASsqhUPtZk54Rc3y8y4TTIoV49Xl1k/P7QqPUAdR+XtUtd0w
	 MlNRLIjcQlLcT+D4L64Acou6Ks9W0jHTSTNQF63K++2fVatj17+GDRWfcqziTOsh7Mgkf
	 aRb16lfYlpT2NXcV2bCKjhoGrlZmwEBbyr46BfpPpHRP/M88lwalTqUSI4c2vCvD+/Eey
	 tf78obnpVFzuZN5+KORV1HZK/pTGvKb01f3qH0pojtEJwzowuLqPfTZvqj72sLr7qbw1y
	 Yc1v9zhI+3jw6AQLmhekbmEu0pZZ7Iho2ne7LB/r0uaiR/FbIqR2Qlzqzc2lzOHWEUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792674599;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type;
	bh=Z8SnU1Cu/AZFsB1W0L57GDk1FVEjlp8xnV4QtYss9AU=;
	b=QHDPwAqjGSt5OlDHMXrHO/Xd6wyb9a9KGDa/zTAPzkQGNPrW5eGT/ePVkgB/JOM5N253
	 PjvS5MiUuuyoly10QgX5Dfnz9MN7rpMUZpngnplHE0LLHxEL2HgoD3KqslIOmKP4ZWRlD
	 aJhhN4x90/yxE+WAA8OeHnzABpdqSVIUh7j1urmSgJfNVpFY1iBQPOIpZy0iugeX6yDaR
	 67LHZY3a2ANuQIOLYjs8L3Dze2kmZdYGW68wO9IuIG9xYhdlxYImWr4/RsvRJNVuGf9MC
	 oCDgFcJ7uAt6wfLxtnBUonbzo6Po6maw889Xq3F3f0k16CcKiLc8ZMu6+IQUkPRJnFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=HeOLUCeC;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BBD606A320
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 13:09:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74BBD606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=HeOLUCeC
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69MD9pXN2893440, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1792674591; bh=Z8SnU1Cu/AZFsB1W0L57GDk1FVEjlp8xnV4QtYss9AU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=HeOLUCeCEoTGjMcbrGASSLzR1d3K6OIMJEEFFrM04CE+qxt1lUgw7oyH4fbNRXC/a
	 pK5JXzGuFnPQNFU+BkHW7iJAVKIvBA/qh4rFstxdnacsEiYSpg92nC+O/NZ6k8YypB
	 nwHCNC3F0ZP/EpF5hD4luCbYQnNUszJNvK+gFJN906DTIrcj8pdCGZgcKnKcePjcoO
	 tNSPXk4XaTPSchrQkpbV++oft+qGWO7dPwdC+4ZR2rKC2M+oM4TsD+tHn68bJHq6lg
	 lcFxY9VxniqW2NIMKigIKr18Nh//4xTaqIMdIw1akNbvy9afgsbWIvkJvAzkXzMNzv
	 Nkh5BhQxkx+BA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69MD9pXN2893440
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 22 Oct 2026 21:09:51 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 22 Oct 2026 21:09:52 +0800
Received: from [127.0.1.1] (172.21.40.76) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Thu, 22 Oct 2026 21:09:52 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <wenjie.tsai@realtek.com>, <kevin_yang@realtek.com>,
	<charlesl@valvesoftware.com>, <sabae@valvesoftware.com>
Subject: [PATCH rtw-next 2/2] wifi: rtw89: debug: support to disable regd learn
Date: Thu, 22 Oct 2026 21:09:04 +0800
Message-ID: <20261022130904.2688290-3-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261022130904.2688290-1-pkshih@realtek.com>
References: <20261022130904.2688290-1-pkshih@realtek.com>
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
index faff9e60e62e..6acec34036ad 100644
--- a/drivers/net/wireless/realtek/rtw89/regd.c
+++ b/drivers/net/wireless/realtek/rtw89/regd.c
@@ -715,6 +715,7 @@ void rtw89_regd_learn_queue(struct rtw89_dev *rtwdev)
 		4, 4, 4, 8, 16, 64, 256, 512, 1024, 2048,
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

