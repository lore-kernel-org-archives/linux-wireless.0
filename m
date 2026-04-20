Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636992FD1B1
	for <linux-wireless@vger.kernel.org>; Mon, 20 Apr 2026 03:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776656478; cv=none; b=URMBujzRQ2GfBJhqwrsIDZAljqf2HbFWqp85TArTbesNYAdo9NpF/VyA8hskI4hY4xkG1DlNoh/W7ch159c/Pu5bbs+eqU2UQiidnahGfQ3s1v9GYQ4/a4efr7sn1IOdaOC6UYuCdAqyvT/riauRRLk8dSrJ+d5qw0yndBB6Mhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776656478; c=relaxed/simple;
	bh=pXrzpOh5n6sHS2CyXXENdoJtiKE7+zWbiYNfcr5EWss=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NfkjnDaWK5iQrzkhhKK3jX0Xlz9WZ35fD1yYauvceWSE/iTQ22Lmx4evKwWww+vwE4j4YktE8kamBlt7B+XNdmYhsI8H5xOSZ1D87nZAKFS/lMhTm2rmzFndBoGcjLosG6RYTSy/GUcBPpF3q0juW4Cl9myH5opxPKnpMvyNZ+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Qf6374OT; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Qf6374OT"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 63K3fESO1426689, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1776656474; bh=jYyCcyc6jo1QaY0CzVoLeK6MefiSq2S4G9lI27vCoYs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=Qf6374OTfWD+4loEuOnN4zJQz90hYGv4LfIaH9ogpIhsof9NQBoUzMpBhmB+KuXdw
	 4fUqHzpkxJTb4xZYvr4HrC80nFzEwPydGyf3JDdPa2p9v4zXrb06WeSIx75SOWSExA
	 IWKK03z3wYbcM+mWWv/SxFr2sKRZsIo/0PfBO0Th1e1qNcLeC8g7ISYoPxBta+z1N1
	 F++rOZgwfZdQufjqRulFClMJ71lneHJHIdUvAcZ+JM6x69M3srXVSfB+1UBFbTkZ1O
	 lPfxpkzwLUFotKyHqcRYvpR/NBzahhbiAqlDjvaTwReyNpYFC4yYthCW9PRflEUIqg
	 q0Es0hNlq0PRw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.26/5.94) with ESMTPS id 63K3fESO1426689
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Mon, 20 Apr 2026 11:41:14 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 20 Apr 2026 11:41:15 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 20 Apr 2026 11:41:15 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Mon, 20 Apr 2026 11:41:14 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <leo.li@realtek.com>, <gary.chang@realtek.com>, <echuang@realtek.com>,
        <wenjie.tsai@realtek.com>, <phhuang@realtek.com>, <isaiah@realtek.com>,
        <kevin_yang@realtek.com>, <mh_chen@realtek.com>
Subject: [PATCH rtw-next 01/16] wifi: rtw89: 8922d: fix typo rx_freq_frome_ie
Date: Mon, 20 Apr 2026 11:40:36 +0800
Message-ID: <20260420034051.17666-2-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260420034051.17666-1-pkshih@realtek.com>
References: <20260420034051.17666-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

The commit 127ea8d0b068 ("wifi: rtw89: fix typo "frome" -> "from" in rx_freq_frome_ie")
change the struct field to correct the typo, but miss to fix this for
RTL8922D because it is submitting at the same time.

As RTL8922D is not enabled yet, this build error doesn't appear.

Fix it accordingly.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/rtw8922d.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922d.c b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
index e3b77cd23514..a3890e863423 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922d.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
@@ -2988,7 +2988,7 @@ const struct rtw89_chip_info rtw8922d_chip_info = {
 	.support_noise		= false,
 	.ul_tb_waveform_ctrl	= false,
 	.ul_tb_pwr_diff		= false,
-	.rx_freq_frome_ie	= false,
+	.rx_freq_from_ie	= false,
 	.hw_sec_hdr		= true,
 	.hw_mgmt_tx_encrypt	= true,
 	.hw_tkip_crypto		= true,
-- 
2.25.1

