Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3596363C52
	for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2026 07:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774423353; cv=none; b=aY3rpH6DGHGY2oez5QItuqm8t+zqvJAlhunMS4xqMF9EE3r/lpV2x4jl4EazMx9d0Fov950oO+6YPuZfVG8+uXyeswGU0itK86trfdNfNI170c94NeML6aYNpXOWzb2CZ47eKTa8NNtcFbPCvQ8XsrVqlUfQcFl0my0GtqHEEC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774423353; c=relaxed/simple;
	bh=megjmMnXq0pZYdEC7ALrKEKw6HuqgzVWNZOQsyP+HjE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OLN/SpygqhYpfGfPc7oXVhr0Xv3XmrDA/rDR+bJ+O6TCzNBUdXEOaM/AklfFiiW+yyF+79pRFM6baUiu4QVncQlIgVbUaSTz0ZAOx0ATARuSneapzz/z7UN1XQU9YXERKK/WqerVv3yJW+y3iJoxcShpqsYeqLFs24T6CDRpX0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=CwDy7SBG; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="CwDy7SBG"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 62P7MSMy82939471, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1774423348; bh=bADN+/r2Q39T1DnJ6UXVKnX49hBv/nGWjc8cIaPTJKo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=CwDy7SBGjz87CfzqKTUL14ymFpSsyMpiSneXLB7bh4O4hho92qb8txQUZ1rZyYAJg
	 gVWghBUxaDWLzrjFE2+LIyALtjEK01yg1K6AK6NPzc2zAr3rx1CYDwclLHVDzi1Fjt
	 S5LnK/uUU3PHqpNBDsIziTYWbGbkTPLiRe23+SAyhQ08Xg/TqWva6i7bOUayPYcxmu
	 wDO1i2/q7MbVFyzC1+qoduobOqgR5qMyLIC/kXtxy5jYCvOJ3r/L+Ne+IQYjWWkvEB
	 jVy2hf9Bud1lD6tw0FQ+I53xzZ/fxPvcCE29NZRATInH3N2lwt7KERtyjpLUbpd4el
	 Qh0JCJYwgRAGA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.26/5.94) with ESMTPS id 62P7MSMy82939471
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2026 15:22:28 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Wed, 25 Mar 2026 15:22:29 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 25 Mar 2026 15:22:29 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Wed, 25 Mar 2026 15:22:29 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <timlee@realtek.com>, <echuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 5/8] wifi: rtw89: mac: disable pre-load function for RTL8922DE
Date: Wed, 25 Mar 2026 15:21:27 +0800
Message-ID: <20260325072130.41751-6-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260325072130.41751-1-pkshih@realtek.com>
References: <20260325072130.41751-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

The pre-load function is a MAC function to pre-load TX packets into
WiFi device's memory, so it can enhance performance. However, RTL8922DE
has not fully verified and fine tune this function, temporarily disable
this function.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/mac.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/mac.h b/drivers/net/wireless/realtek/rtw89/mac.h
index 93bedf056f17..9db9ae219cd6 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.h
+++ b/drivers/net/wireless/realtek/rtw89/mac.h
@@ -1828,8 +1828,7 @@ static inline bool rtw89_mac_chk_preload_allow(struct rtw89_dev *rtwdev)
 	if (rtwdev->hci.type != RTW89_HCI_TYPE_PCIE)
 		return false;
 
-	if (rtwdev->chip->chip_id == RTL8922D && rtwdev->hal.cid == RTL8922D_CID7090)
-		return true;
+	/* The RTL8922DE will re-enable pre-load function after verification. */
 
 	return false;
 }
-- 
2.25.1

