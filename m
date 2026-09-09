Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C813B47D5
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 07:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788937279; cv=none; b=B58bWsn462h20buOlCFynscyfbJJpvchy7e+vy2kUmdtWvOwuuwUUeNTxx/q+k+iWrmyLssG7cnWVBt4lQAR0EFM9PXJIJdVddwt04m/Sz6ui5tRG5vIRgsDy9/Gu0h+pcnp/Ms0FSCQ0cIKDQZ5r7C83FrErjVkGcd0cWta7To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788937279; c=relaxed/simple;
	bh=8Z7kcAhJwN1FG1H8hXub+LqYI/+i6zrtnickTFBkULk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fOaQ7LfeEOqBu6f7oNA8xoRCa7JxcA3ZDktPnvxZxr5pVpPHw5ArosRf7HiOZY7gXv/hO07wNzxkfE9qdDnvP1Avmcg/9ytuAP0gf2uhyFNQ9AzDmQYmc24YxXZjat/PSS0El5CYqRw0Ap1Y17SuKvKJeGrLtTNGlxEnBd30sg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=DkQgpOKb; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="DkQgpOKb"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68971EuzC356822, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788937275; bh=NJzeVmNeBWn7NMJsu5qptiXTBayoA/JOKhUPis2wZ8o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=DkQgpOKbMR2norQZK99l8vFnKSkh06hXO6wH2ILSUAmpsXgWDHcVpGy+pszn6cyfu
	 /buNQ8TxtTkvCyuq9dBeF1D0gWsZFhvB+/3PwlqtiRtd6kGz1rOeRz1IhazV2gdFVB
	 X5fsw/5RGVb8KM+xeeNWN0KBLK/+ZgpeEI6SYayZpOvT3L+/ShMkUOl6ZoMldIBkTE
	 ZfR0bn0UthRmjcLYSqK/yhLgKie5bGyGQDwD2/ti66p9yM9AFU8Mk7ifvrzsKAQQ5r
	 dzRKTUaSV7kQR5v1DGhQQ6RmNsBvRvUA/E122Mx1ZDvZDhtPHDy1KCyxeNpTgCp1Kl
	 udoo9QazwnfgA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68971EuzC356822
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2026 15:01:15 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 9 Sep 2026 15:01:06 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 9 Sep 2026 15:01:05 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <dian_syuan0116@realtek.com>, <echuang@realtek.com>,
	<phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 06/15] wifi: rtw89: 8852a: prevent potential OOB in ctrl_sco_cck
Date: Wed, 9 Sep 2026 14:59:55 +0800
Message-ID: <20260909070004.35353-7-pkshih@realtek.com>
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

The array size is 14. Add a check to avoid out-of-bound access.
Although it doesn't seem to happen if everything follows spec.,
it might have potential problem in pure logic.

Resolve OVERRUN (Out-of-bounds access) reported by Coverity.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/rtw8852a.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852a.c b/drivers/net/wireless/realtek/rtw89/rtw8852a.c
index 5d7b5d1a24b1..4b364f039464 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852a.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852a.c
@@ -945,6 +945,14 @@ static int rtw8852a_ctrl_sco_cck(struct rtw89_dev *rtwdev, u8 central_ch,
 		rtw89_warn(rtwdev, "Invalid BW:%d for CCK\n", bw);
 		return -EINVAL;
 	}
+
+	if (unlikely(ch_element >= 14)) {
+		rtw89_warn(rtwdev,
+			   "Invalid ch_element:%u where central_ch %u primary_ch %u\n",
+			   ch_element, central_ch, primary_ch);
+		return -EINVAL;
+	}
+
 	rtw89_phy_write32_mask(rtwdev, R_RXSCOBC, B_RXSCOBC_TH,
 			       rtw8852a_sco_barker_threshold[ch_element]);
 	rtw89_phy_write32_mask(rtwdev, R_RXSCOCCK, B_RXSCOCCK_TH,
-- 
2.25.1

