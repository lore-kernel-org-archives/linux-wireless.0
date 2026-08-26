Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127111A6836
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 06:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787726486; cv=none; b=Oc0j15ur3S/3QwtxQp9npAgT0rBinf4Y/4gWZ17ngmiLf4a4gYUqZD2Hzl4uH+IgbTttfJ08ZpLKoZ3fR6bk6YBysAQOnBUWHdQUMaKKZiEeImeP+Rikt3n9DSSeknb/0wgo0ColNvSUrmhBIsLXNNR/DWA/5/KQMqKRpkqaMMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787726486; c=relaxed/simple;
	bh=VPW+WJWnb7myGMLnQiN8U2FK7j2Bl5hd0jU2YExpCxY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=evGgR6d+Q8BHTCs3Ns5A9RHUL6Y6hlRNv6b1eU0QZqi7QwXoDeIhZZBE3KqEiULNMSbMY1GEdbJ+M7S+4rwZENFBlLB5ZqJJpWPkLsqh30aST+jsxxGlIPUpPu3mrbju/eSwAQm+nEJSYKlrd576cdEODvp5UgyaFSR77xBd65U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=MyXqVAEd; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="MyXqVAEd"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67Q6fLEp9353006, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787726481; bh=SyquOS5Wr2Ew2WJzVHiQhDX5TECcNthweZXjTs+F81w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=MyXqVAEdzJXmqidxjHBDLFbeenwZKS8LzyXXLnavpGzF/KMMplPYqbGdf25TKnDNz
	 UbXvw/irpjgbQG9O5W6dGklFkeuffYR+3PMV49YKpX4i/KvkHL54weBtrSql68zrkF
	 nSRlD8+K4DkkYctBBsGAzSec5UZUycMyncMyL7xEQMgaouFK4ZQvSIbLmqP4vVf5Wx
	 buCVxrsvhruSpaJ+z+6RBmXi1T4iwFESopCVUd7IBTGjqOz4pbRvNf48IdbVjrp35X
	 BoSQtJMDxrxlvOtx6d/0j4UxlD3VxYVdAKlsITzoBRArtVan6CD6jM/mG0wc/ItMDB
	 /j2QK5+lpaLWQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67Q6fLEp9353006
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 14:41:21 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 26 Aug 2026 14:41:22 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 26 Aug 2026 14:41:20 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 26 Aug 2026 14:41:20 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <owen.hsiao@realtek.com>, <echuang@realtek.com>,
	<henchy.chen@realtek.com>, <phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 02/14] wifi: rtw89: 8922d: disable VCORE for thermal protection by default
Date: Wed, 26 Aug 2026 14:40:49 +0800
Message-ID: <20260826064101.58892-3-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260826064101.58892-1-pkshih@realtek.com>
References: <20260826064101.58892-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Chih-Wen Hsiao <owen.hsiao@realtek.com>

To ensure the stability of the thermal protection mechanism,
the primary approach is to reduce the transmit (TX) duty cycle;
the option to lower the voltage(VCORE) is disabled by default.

Signed-off-by: Chih-Wen Hsiao <owen.hsiao@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.h     | 1 +
 drivers/net/wireless/realtek/rtw89/rtw8922d.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index b1a0103aaf0c..a2f6e68987a9 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -6463,6 +6463,7 @@ enum rtw89_quirks {
 	RTW89_QUIRK_PCI_BER,
 	RTW89_QUIRK_THERMAL_PROT_120C,
 	RTW89_QUIRK_THERMAL_PROT_110C,
+	RTW89_QUIRK_THERMAL_PROT_VCORE,
 	RTW89_QUIRK_HW_INFO_SYSFS,
 	RTW89_QUIRK_DISABLE_2GHZ,
 	RTW89_QUIRK_LOW_LATENCY,
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922d.c b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
index 142e693c87bf..a9737c674ecb 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922d.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
@@ -901,6 +901,9 @@ static int rtw8922d_read_sys(struct rtw89_dev *rtwdev, u8 *log_map)
 	u16 digk;
 	u8 vmin;
 
+	if (!test_bit(RTW89_QUIRK_THERMAL_PROT_VCORE, rtwdev->quirks))
+		return 0;
+
 	digk = log_map[0x200] | log_map[0x201] << 8;
 	hal->thermal_prot_vmax = u16_get_bits(digk, B_BE_PWMTUNE_MASK);
 
-- 
2.25.1

