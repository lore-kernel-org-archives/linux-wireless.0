Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACE539446B
	for <linux-wireless@vger.kernel.org>; Tue,  7 Jul 2026 09:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783415580; cv=none; b=oE0cJ0FEHBBofHcjpltjMdRNr+x0xzgu19gf6HW2Ca3nKVmZXkZpxxLfKdYTvrC3QvfuP4Qv6ydKKPLqJV6JfdFS63JBJelWoKvmqpqlCJYFuvmFu6rnWv5usjVfhIz0wCR2Vf2D/iwedI0fwQsHKybtTHoh4zaEkzG0BtIAzwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783415580; c=relaxed/simple;
	bh=pNN0Dh1oEH+Z/+9yAeLJYgH6bKWf2yoweiBryx6L6Jo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l0kRbjLS9GOmJq8ZhppBvM1gFb+IGatAHFg/N+/UWlImvD3sKNf/cO+6q6hV+ZES/DvJnX9nAFuGn+e/yZK5DBjhXvqO66lnzleaYArAnlPawvwrH3ow3I2xB3u2QHOTfxePNYviW0boCZie/55cuFZAU+skY+XvkQbBkFPq7b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=thNvb8V1; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="thNvb8V1"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6679Ct5iA1359674, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1783415575; bh=GNlqOmdSneL9hQWHBh77pdlfGURPbqIK1eN3mE5Z8pc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=thNvb8V1W2l2W9Ip3H3kWDTEBW7s7emCfb+yQlCieInttF4sYb2d61kheFfFYl135
	 TL8hwRb8qJnajlJpbrERLeT66yQ7ZW+8mcFaUlx/ZOAYuyg2yj5ACWqv6LOoQVfUq9
	 YtwVkUgs3d3nUbBzUp6UmLVBBSCqyz6TVzgYXnaYo8VQXrqc1fk36gJnh8devWQJbj
	 8pst34xcKSxG8KYMt9OKNnx/SxRtBEblqTvx8hhqlIc61s8HkaGzh4oFyD+S2B2Rh7
	 7COK+x/lz+wf6ycw8LzHlSKfEt71pKxQWpgy53kxQLfKLU4ZCP0VythztUmuRnftW7
	 EgT7AAdEFGnIg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6679Ct5iA1359674
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Tue, 7 Jul 2026 17:12:55 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 7 Jul 2026 17:12:56 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 7 Jul 2026 17:12:55 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Tue, 7 Jul 2026 17:12:55 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <echuang@realtek.com>
Subject: [PATCH rtw-next 12/15] wifi: rtw89: 8852a: fix RSSI report when average beacon RSSI is not ready
Date: Tue, 7 Jul 2026 17:10:53 +0800
Message-ID: <20260707091056.42771-13-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260707091056.42771-1-pkshih@realtek.com>
References: <20260707091056.42771-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Chih-Kang Chang <gary.chang@realtek.com>

8852A uses the average beacon RSSI to smooth the RSSI. However, before
the average beacon RSSI is available, the RSSI should use the PPDU
status RSSI of the received packet to avoid reporting the RSSI as -110 dBm.

Fixes: f0f3bf4b370c ("wifi: rtw89: 8852a: report average RSSI to avoid unnecessary scanning")
Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/rtw8852a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852a.c b/drivers/net/wireless/realtek/rtw89/rtw8852a.c
index a5a06ae5c446..61b6b76c5bdb 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852a.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852a.c
@@ -2212,7 +2212,7 @@ static void rtw8852a_query_ppdu(struct rtw89_dev *rtwdev,
 	u8 raw;
 
 	if (!status->signal) {
-		if (phy_ppdu->to_self)
+		if (phy_ppdu->to_self && ewma_rssi_read(&bb->bcn_rssi))
 			raw = ewma_rssi_read(&bb->bcn_rssi);
 		else
 			raw = max(rx_power[RF_PATH_A], rx_power[RF_PATH_B]);
-- 
2.25.1

