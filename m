Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB97175A70
	for <linux-wireless@vger.kernel.org>; Wed, 24 Jun 2026 03:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782272481; cv=none; b=nJ82aNcPfYVI7b/4TFyHGxE2Wj7dkkcF/AFL9E1uY2cfVKvT1VGEF1WyzMGdvudWL/TnLboLJpFzrZ6HTa/F73JGbL/mVWMdDHFRxi3z28Z7YXQpqqxO08k2flNNnwYWWryaPStr/E/a7tCbwVp9pfqmnqWRpUZb2YrzwWJAZg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782272481; c=relaxed/simple;
	bh=Y34V2FZmaLlt2qwrZVbvGXVU1ntTcysZB4esKhS2ABg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eFhauLdYU9t9RuJmAYuRYFvQSiAHQwa/PRacsr33wG4CuxQuQk/Q2W/q1AcUCVlfpTiXpztuYFHrCNhJ+629ZjcbQ98l1nidIrg0PnWn02zD7yTtmSvlRALkyquyHgP+Fxny4aKnPqP6ATBaUTydmMmf8c359kivDKRBKukI6aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=J3H3ksXB; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="J3H3ksXB"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 65O3fH1g93889116, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1782272477; bh=tEea8kjOPlC+Etlf5tAAh3+55QT9sYLkqHBWG0UcT2w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=J3H3ksXBUQXQOlCasGy584wVsL4omkD9AX6sFV6EhgNN7Zxi6n72hNpaNzpXoXVE4
	 iPn8hLzOAL0TNDzVMLo+7fWE9mSBBArs8jmBiU10JrISwvNgJREJPcszmpOJ8pO+ub
	 g+FyZsUTUmjJPlBoHYR7k0Yrh2rGvT/E/xPyzo8p3Ps6+iAL4rtITmfuQjvKBLPj4J
	 kMCaYaZYHl67V8I3Ld+CL4z5jj2mS/8qaxWiuqOpKahthXu4BesgMNPoL5ei7puNKR
	 rrcheQSus1blztGFFNuO5H7M/wZIS83Qct5l2zekk6pe9MCVoApqdR+cDT5uIOd975
	 SPUgT1Aft3eJQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 65O3fH1g93889116
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 24 Jun 2026 11:41:17 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 24 Jun 2026 11:41:18 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 24 Jun 2026 11:41:17 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Wed, 24 Jun 2026 11:41:17 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 10/10] wifi: rtw89: coex: Add RTL8922D chip string
Date: Wed, 24 Jun 2026 11:39:41 +0800
Message-ID: <20260624033941.45918-11-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260624033941.45918-1-pkshih@realtek.com>
References: <20260624033941.45918-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

Add string for logic using and show logs.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 6f9bb31b5263..1361d4d54528 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -313,6 +313,7 @@ static u32 chip_id_to_bt_rom_code_id(u32 id)
 	case RTL8851B:
 		return 0x8851;
 	case RTL8922A:
+	case RTL8922D:
 		return 0x8922;
 	default:
 		return 0;
@@ -347,6 +348,8 @@ static char *chip_id_str(u32 id)
 		return "RTL8851B";
 	case RTL8922A:
 		return "RTL8922A";
+	case RTL8922D:
+		return "RTL8922D";
 	default:
 		return "UNKNOWN";
 	}
-- 
2.25.1

