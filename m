Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FE926AA91
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 15:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784991898; cv=none; b=hXqkbkvkeREcriZU53afYUH4fHF8w+HVtoMbR8Mkpt22B6ftE6stI2eJazRccVkg9hpeh5OM02+Ay6Zgnw4K25TRio/oxHoyvms1sBZGNyGNCNUTz65nm7gmbTjSzv8wtbdYHAQ7SVfQDNMdfbEShce108+ylZzpzaQ/h7kRO18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784991898; c=relaxed/simple;
	bh=A7wPUJsgy/RTBLkA3plhGKpTGDu2PU58SFXyj4G8CNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QpVkHiSpq9FTAhjjQxlnZ3/dPaSEFPbf6ruXyqBm4qT1Q0JimBJvf61C+oP8Z/PjQ2DDs54n2mR/SegJnzejOkBnuzYpimPkyO9JHWKzpV6tLMkr7mnHSs1aArzuUEVQgC3+YopgRSKrTLRHfgP/nDCz/qpfHKtWLGaP6nfC5oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PNHFnbxs; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PNHFnbxs"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784991893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Mi6MjhsaXmEuc5i6mIKcJemekMse5QliukSRqipF/Q=;
	b=PNHFnbxsA096r34tWJrNqHlWZ5q6NC2B/SHqyLuQnOqiOPmW3uGhCd4OqlkLyaz2jVjlN1
	yPiasGqx8x/qzkVwyDmMmdT/nMcxbenSV6YnJ9aFJ4IzPYK4Z2XKPOagvDTLzTRcyBHuFB
	kjFV3i4vcA1vzgab5sqL4guyp1wp7tk=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v2 01/11] wifi: rtw88: add the RTL8723B chip type and SDIO helper
Date: Sat, 25 Jul 2026 17:04:17 +0200
Message-ID: <20260725150427.93887-2-luka.gejak@linux.dev>
In-Reply-To: <20260725150427.93887-1-luka.gejak@linux.dev>
References: <20260725150427.93887-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

The RTL8723B is a 802.11n combo chip whose SDIO variant, RTL8723BS, runs
a Realtek vendor firmware that differs from the firmware used by the
other rtw88 8723 family devices. Supporting it needs a number of small
adjustments spread across the shared core, all of which have to be
restricted to this one chip and bus combination.

Add the chip type and a helper that tests for it, so the changes that
follow can be gated without repeating the chip and bus comparison.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/main.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index c6e981ba7986..8f86f7c12de5 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -194,6 +194,7 @@ enum rtw_chip_type {
 	RTW_CHIP_TYPE_8723D,
 	RTW_CHIP_TYPE_8821C,
 	RTW_CHIP_TYPE_8703B,
+	RTW_CHIP_TYPE_8723B,
 	RTW_CHIP_TYPE_8821A,
 	RTW_CHIP_TYPE_8812A,
 	RTW_CHIP_TYPE_8814A,
@@ -2194,6 +2195,12 @@ static inline bool rtw_chip_has_tx_stbc(struct rtw_dev *rtwdev)
 	return rtwdev->chip->tx_stbc;
 }
 
+static inline bool rtw_is_8723bs(struct rtw_dev *rtwdev)
+{
+	return rtwdev->chip->id == RTW_CHIP_TYPE_8723B &&
+	       rtwdev->hci.type == RTW_HCI_TYPE_SDIO;
+}
+
 static inline u8 rtw_acquire_macid(struct rtw_dev *rtwdev)
 {
 	unsigned long mac_id;
-- 
2.55.0

