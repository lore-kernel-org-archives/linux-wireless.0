Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9A637DAC0
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785391366; cv=none; b=HwZkklyBh4CBf3mOAEqBrODZzmyGWAIzimoxT8x6Ma4L9Hu46jjyr9Devip1dSt/JAhxksSrLJS4G7AAKK3guHFuEhQWA5xVrkyplspX0693t9vXixCJBpM+158RcNn179Gc1Gb3QymGPzqa5pdmSyzENDju7OjMshy3elk6i/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785391366; c=relaxed/simple;
	bh=x+9PwtBu5udVhTx1xDInnfLuoCdVNDmjhGqAUexsmZ4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n6hp7kDtrhVtTLw9bXamJBcdpj2fe4OBwrfAeks+pxhUEr1XMZgq5DwncsXuCNUkkL1PxsJ2dVXFYh5GTUmkmTUVzMJanaQ/jhqhyQKCBgw4z6Vk/tasl7tO4BDL/DldMtrTkyGcV+iB+PCa8vFTbrvclYxPpGlnSaTv3sTvgwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=qOvnJYSC; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="qOvnJYSC"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66U62cFS2985885, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785391358; bh=+lK6jTzIP0XVLlh0HvaawuBHAkWQpGCiEWjlGchWRq0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=qOvnJYSCmnxNssgTd+wNp+X/xfcJ6Z/378CLGu/9aex9YTYjYhsqx4fbcihejK3Ob
	 d5gHHMYSAMsn8mPNbKuMOJMMvQOrT9IF++d4ctbwTFu3dKYAMGg/LRl9UYOs7Wwzfl
	 YH87sWkdNa/pEJ8G+2R96rChhbIG39gLg6guTQOF8Wzet2+UlE6YIjmKU+bkWHHQPM
	 iNaUm0WIyHwbMvQICuCycsNGoeNWg7pDqed7gwolChxdZdxLRK3BZ+IqMrd2W+MmRT
	 bM9EIvxP7qNUoABFniaRggAfvWZ8reB2ivcArY7/A8tVCCWQX3RXS7yrEKPqyLMOor
	 hEitOjb5FpIyg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66U62cFS2985885
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 14:02:38 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 30 Jul 2026 14:02:38 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Thu, 30 Jul 2026 14:02:38 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 3/7] wifi: rtw89: coex: Clear BT link weight when BT is disabled
Date: Thu, 30 Jul 2026 14:02:16 +0800
Message-ID: <20260730060220.55844-4-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260730060220.55844-1-pkshih@realtek.com>
References: <20260730060220.55844-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

When a BT device is disabled, _update_bt_link_cnt() is no longer called
for that device, so its link_weight[] retains stale values from the last
active period. _set_bind_info() then computes a non-zero band score for
the disabled device, which can lead to an incorrect tdd_bind.rf_band
selection and ultimately wrong coexistence policy.

Clear link_weight[] for any disabled BT device at the start of the
_set_bind_info() loop so that stale scores are not carried forward.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index d5b1c68539d9..ac3d0c63f930 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -8167,6 +8167,10 @@ static void _set_bind_info(struct rtw89_btc *btc, u8 type)
 	memset(bd, 0, sizeof(*bd));
 	/* compare BT 2GHz/5GHz profile by link-weighting */
 	for (i = 0; i < BTC_BT_BMAX; i++) {
+		if (!cx->bt0.enable.now)
+			cx->bt0.link_weight[i] = 0;
+		if (!cx->bt1.enable.now)
+			cx->bt1.link_weight[i] = 0;
 		link_weight[BTC_BT_1ST][i] = cx->bt0.link_weight[i];
 		link_weight[BTC_BT_2ND][i] = cx->bt1.link_weight[i];
 		link_weight[BTC_BT_EXT][i] = cx->bt_ext.link_weight[i];
-- 
2.25.1

