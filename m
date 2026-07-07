Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D012392C4C
	for <linux-wireless@vger.kernel.org>; Tue,  7 Jul 2026 09:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783415542; cv=none; b=VB2E/VehMQMWA9QxGhlCYxoH4iPIUCNnRs3VF38iXQNUJp578g0IopcIFhkKbBYwnmFFV8gA69OWUtPBruAMCxMTFmL+G0quIBt0J9g9du6B2wW8vsrizhTTAr4KQDUhxt8x0I4nu3v1elTI6elV1JewRWriO4sDvWFU31WxZck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783415542; c=relaxed/simple;
	bh=Z9e76qTePyVC8zrRilXpjmE6Y2bkdiNHQ5haw1sxZuQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D4JWR7G2ZsNF2ysTo4DDKhchMtmrbEdw964tfjzkRandTDRmtaS35nnOe+AdyIcIZlXNoiXbwKdhs30waTWQTFNHMYeztOXcnAPNXQ5lebCgcncjJCEcjOPaAmddjDLmrFu8c/Bg+lqJNzN/3T6882gQ99RbnbjMTdkLLIFB+XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=cAj67tDD; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="cAj67tDD"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6679CI8o81359525, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1783415538; bh=CTu9aOxPiG/wtGfKT9CGESD5etgBn/gZI8rSUXnJGD4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=cAj67tDDCYPovJQOawSc1JNa7OUuljHpMUfq2JZlQmKuFqoEXWEdc2dzSA/Bkmf5W
	 R8xgy0n3wLpVJz/RvXsF99FJlS94zfhnLEpTS1fWoTYX6zoV0fNVdGkglvuFhYD2Ki
	 mp2MjOOKUICTB6zjlJngpMIshqZy/IEALzo1eXY4qJY4xO3pqhK7bLWymNxWZFlu40
	 pI9pkKSEEtYQoST72OwhHYoYIc/qChJ4kKmvyCvkvb5dhjn/SShpgwbY6O2tnWm/mS
	 smGcbfq6cXv4/I4jLL0Tki6zUmRmhgWT7P/h2gnfsEsnc2LmszLEZKqfp3d3AkVgYf
	 o3j1RpepvWo2Q==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6679CI8o81359525
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Tue, 7 Jul 2026 17:12:18 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 7 Jul 2026 17:12:19 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 7 Jul 2026 17:12:18 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Tue, 7 Jul 2026 17:12:18 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <echuang@realtek.com>
Subject: [PATCH rtw-next 05/15] wifi: rtw89: 8922d: set TX compensation by format v2
Date: Tue, 7 Jul 2026 17:10:46 +0800
Message-ID: <20260707091056.42771-6-pkshih@realtek.com>
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

The total number of TX compensation registers is 22, including 7 base and
15 ones according to operating channel.

The v0 is 22 ones per channel. To reduce array size, v1 treats 7 base as
common part across all conditions. However, we can fine tune the base part
to yield better performance, so divide base into two sets according to NSS.
Summarize dimensions as follows

	base (7)		vals(15)
  v0	nss * band * path	nss * band * path
  v1	1			nss * band * path
  v2	nss			nss * band * path

Currently, v1 and v2 can present in a file, but only one fw element with
a specific format will be used for specific RFE type.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/rtw8922d.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922d.c b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
index 212917db7154..e8267173bd4c 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922d.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
@@ -2249,6 +2249,12 @@ static void rtw8922d_set_digital_pwr_comp(struct rtw89_dev *rtwdev,
 		struct {
 			__le32 vals[DIGITAL_PWR_COMP_VALS_NUM];
 		} sets[2][RTW89_TX_COMP_BAND_NR][BB_PATH_NUM_8922D];
+	} *pwr_comp_v1;
+	const struct {
+		__le32 base[2][DIGITAL_PWR_COMP_BASE_NUM];
+		struct {
+			__le32 vals[DIGITAL_PWR_COMP_VALS_NUM];
+		} sets[2][RTW89_TX_COMP_BAND_NR][BB_PATH_NUM_8922D];
 	} *pwr_comp;
 	struct rtw89_fw_elm_info *elm_info = &rtwdev->fw.elm_info;
 	const struct rtw89_fw_element_hdr *txcomp_elm = elm_info->tx_comp;
@@ -2259,8 +2265,12 @@ static void rtw8922d_set_digital_pwr_comp(struct rtw89_dev *rtwdev,
 
 	if (sizeof(*pwr_comp) == le32_to_cpu(txcomp_elm->size)) {
 		pwr_comp = (const void *)txcomp_elm->u.common.contents;
-		comp_base = &pwr_comp->base;
+		comp_base = &pwr_comp->base[nss];
 		comp_vals = &pwr_comp->sets[nss][chan->tx_comp_band][path].vals;
+	} else if (sizeof(*pwr_comp_v1) == le32_to_cpu(txcomp_elm->size)) {
+		pwr_comp_v1 = (const void *)txcomp_elm->u.common.contents;
+		comp_base = &pwr_comp_v1->base;
+		comp_vals = &pwr_comp_v1->sets[nss][chan->tx_comp_band][path].vals;
 	} else if (sizeof(*pwr_comp_v0) == le32_to_cpu(txcomp_elm->size)) {
 		pwr_comp_v0 = (const void *)txcomp_elm->u.common.contents;
 		comp_base = &pwr_comp_v0->sets[nss][chan->tx_comp_band][path].base;
-- 
2.25.1

