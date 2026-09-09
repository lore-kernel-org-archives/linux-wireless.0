Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029073B8412
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 07:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788937264; cv=none; b=BNtRnkH+ku5WnCnHQGFTS/3CukfvF/qAMGHJn5tx6lXD/82GH0M8CDFZVYnNM8jstg/b8xnZA1Hd9KP7S+u9obKWjYDqQkNTKrJC0BakbkOfX/6T3AeGEOY+veWM5ZhE5XmKrRQT5lQQZisLtmpkVnKz43SqOtaBTO4biGFfVXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788937264; c=relaxed/simple;
	bh=FpTbzEQ+qVRLOcvy6SzD/oGRsGu87qViPvYg6xMg7vI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AASQ/RJmCIoc3azuWWDSfvbBED9pNWUEOLrvU5EXeM50austxKY4sB2oD/US3hLvzB74O9Kbl2rZY1mjkstbNLAX5/zKu3cHLxhFi4eD624PyhCmG4uxku9Lu9sT5QYc8yFRdZmWCZFeg5K7jvfZdv4YM8q40upBreMsVYp/SoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=emSqTAnZ; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="emSqTAnZ"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 689710Qb8356779, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788937260; bh=ibXzV1Mu6ujsqakYEULzvU0A88V0ncNZ+6a39BQX9HI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=emSqTAnZHBpK/jp+/0Xp//U1MzVK15JaI2ZNMtTe2+XRFupPl71EKkaxRM03BHKYh
	 K7+CvqvK+60GrJdljb71E8nZCTFCekEzZhYMX3tO21+uBzTmCJMpSyzcq94nh2j1sK
	 uPJMkkj32QnEPwVOSlSIqg2X0auQDMTXRuPpblb/Y5uOEygxN++fMo1kdFeVfEryE1
	 qNJvDbJ8igjA0Atuue25GJBTReirelfIsxx3TuHJiAi+a1+fRqZIwA1uoHY9EcaYfn
	 76H0XpN5ynnT4g2VFD27Jp1SAEjrpPGKm27jBmfOLo1Zmq51arFHO6ZIcjO7YDwpZz
	 Ez6ZwUCnI0cSA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 689710Qb8356779
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2026 15:01:00 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 9 Sep 2026 15:01:00 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 9 Sep 2026 15:01:00 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 9 Sep 2026 15:00:59 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <dian_syuan0116@realtek.com>, <echuang@realtek.com>,
	<phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 05/15] wifi: rtw89: fix ctrl_sco_cck for Wi-Fi 7
Date: Wed, 9 Sep 2026 14:59:54 +0800
Message-ID: <20260909070004.35353-6-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260909070004.35353-1-pkshih@realtek.com>
References: <20260909070004.35353-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Zong-Zhe Yang <kevin_yang@realtek.com>

Wi-Fi 7 chips have function to control SCO (Symbol Carrier Offset) for
CCK. The corresponding valid primary channels are from 1 to 14, i.e.
array index is from 0 to 13. So, fix the condition.

Resolve INTEGER_OVERFLOW (Overflowed array index read) reported by
Coverity.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/rtw8922a.c | 2 +-
 drivers/net/wireless/realtek/rtw89/rtw8922d.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922a.c b/drivers/net/wireless/realtek/rtw89/rtw8922a.c
index 2d225e009b28..6402bd4f06aa 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922a.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922a.c
@@ -1152,7 +1152,7 @@ static int rtw8922a_ctrl_sco_cck(struct rtw89_dev *rtwdev,
 {
 	u8 ch_element;
 
-	if (primary_ch >= 14)
+	if (primary_ch > 14 || unlikely(primary_ch == 0))
 		return -EINVAL;
 
 	ch_element = primary_ch - 1;
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922d.c b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
index 75297b39c4d7..89c1f58d0dc0 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922d.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
@@ -1320,7 +1320,7 @@ static int rtw8922d_ctrl_sco_cck(struct rtw89_dev *rtwdev,
 {
 	u8 ch_element;
 
-	if (primary_ch >= 14)
+	if (primary_ch > 14 || unlikely(primary_ch == 0))
 		return -EINVAL;
 
 	ch_element = primary_ch - 1;
-- 
2.25.1

