Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE6E1C861D
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 01:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791335520; cv=none; b=slqoLBoDCanTePPYBsJxT9lbniHh0hGOsX5qm2Qd0A8Bjc2pm1kGdw6skON8cJ1327hRW2c3IYFdRdTmB6ydPSUYuAgZD3LArdKoT7vto92vXu/NvtOc6dtc1EOXK0o6oj9uIdb76/iNVKktfs85p1lQAfZ/VSXpiDw0DHuNEgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791335520; c=relaxed/simple;
	bh=oOE8FxFEBKeQ541fDzEwY9isvLlRSTfV0cro5Q4kPsE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AuwVDfiCaM53RLFoe8ClCkvdDu9Oz6462X2NWu9S9AmV+NWGPcx7u4imPFdpukPGNIuVGumzdofjD9wUivE+LPZokD/+8777LJsG6grI8I1Hfkjfr6AXxeTMGowxI3eOijCTCvw2illNWAynrCNxHJ5wkPe8MgRGmxca0+Xgyf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=fvGP++jq; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="fvGP++jq"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6971BtclE3403821, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791335515; bh=OZ/+YhmQ4AN2UNGH27FYFK/an0tZhUm83BsXa7OTx2E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=fvGP++jqcMl2BXo7CYqdoibgUbkHECbQdKRVJM43n+h9VCgQeHmtLFQFfQeINgJXK
	 pJHJ0Tz386rYK5s+Q4IiMXnw+GTjzQEk4kw1Xm+IzdxjGhBthBRSrfTEinopaDJ0Uh
	 +EBCiiZUVK2cVzlKHZSJ211xzNBhDyQqGBnAGQmoxZ1p/fh+ZaQlj8+6ViJ6f6MiP2
	 3HKLYywR//Pyc7pe/vzWdvgSuRBRhuyy9IUNy41vzRWTUcjauCV7hV8aYZneswoOlT
	 sO6JjNOap554QdKt6FFuJZTd9BHhkRcgwRCzQgsVe12vcXo3ga1Dodp8qc0mf9nxcZ
	 5b6hlsKDTm3nA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6971BtclE3403821
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 7 Oct 2026 09:11:55 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 09:11:56 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 09:11:55 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 7 Oct 2026 09:11:55 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH v2 rtw-next 2/3] wifi: rtw89: regd: add NZ/BR/AR for individual TX power settings
Date: Wed, 7 Oct 2026 09:10:56 +0800
Message-ID: <20261007011057.12125-3-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261007011057.12125-1-pkshih@realtek.com>
References: <20261007011057.12125-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Zong-Zhe Yang <kevin_yang@realtek.com>

Add NZ (New Zealand), BR (Brazil) and Add AR (Argentina) into Realtek
regulatory enum. Some chipsets may need individual TX power settings
for them.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
v2: new in v2
---
 drivers/net/wireless/realtek/rtw89/core.h | 3 +++
 drivers/net/wireless/realtek/rtw89/regd.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 7e74b5c9ed49..f17717ac2036 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -791,6 +791,9 @@ enum rtw89_regulation_type {
 	RTW89_QATAR	= 13,
 	RTW89_UK	= 14,
 	RTW89_THAILAND	= 15,
+	RTW89_NZ	= 16,
+	RTW89_BR	= 17,
+	RTW89_AR	= 18,
 	RTW89_REGD_NUM,
 };
 
diff --git a/drivers/net/wireless/realtek/rtw89/regd.c b/drivers/net/wireless/realtek/rtw89/regd.c
index 942f55633942..f0d47c313bb0 100644
--- a/drivers/net/wireless/realtek/rtw89/regd.c
+++ b/drivers/net/wireless/realtek/rtw89/regd.c
@@ -666,6 +666,9 @@ static const char * const rtw89_regd_string[] = {
 	RTW89_DEF_REGD_STR(QATAR),
 	RTW89_DEF_REGD_STR(UK),
 	RTW89_DEF_REGD_STR(THAILAND),
+	RTW89_DEF_REGD_STR(NZ),
+	RTW89_DEF_REGD_STR(BR),
+	RTW89_DEF_REGD_STR(AR),
 };
 
 static_assert(ARRAY_SIZE(rtw89_regd_string) == RTW89_REGD_NUM);
-- 
2.25.1

