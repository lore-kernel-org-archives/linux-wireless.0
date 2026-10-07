Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744652D3A7C
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 01:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791335525; cv=none; b=T4PuVPJJ9LxbiShGz8BrA2qa6LI5nXJBnNS3QJj4qyhODi351JKOCL+b6JcQh1sCsWEzyKWRa2RR7WH9r9/triedNFwAKYmBJYXmqM6erq5f7fpLGNP5G8hmNUb1vzC7bhdwG5UgNijrv3PqOOxqH6F6G8bAd7WO4R2wzXmnRVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791335525; c=relaxed/simple;
	bh=yR2mqtoGrAT9oE/w2nVJS/VbhnPQHK8+n5Xy1ijwsqs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hWkiuFoFqLbtvo0fkxBx2G4b05+Zg/LwkzSvduDW0d+X1l0UisAdG7J0zC8jJ3jC1l/cAE9XAOWGC35n30YlSGj1io55PUxGcBaibkC7bwlbqzCeUWMG14ql3QC/e22+t623JjPAnoRHW2e9HSjmz/lX3ymM1q38ddI2UwFI4v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=tgUMANp7; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="tgUMANp7"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6971C04r83403955, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791335520; bh=88DEFOIsMvLAXHooQKqlu249Q6e2QF4nXNgo3H5RCGM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=tgUMANp7NuI4su7TeoT0snKWTnaOuW0E4C5EvgqioUtuLTTfXyF4MDR1x3vLeFKb+
	 qkVdLElY77tfASsuEG0s08VTeExbCgLPdGvZREEyrlik+LlnXROXZCDtte0HXwV7jt
	 qxNR4+wQePV0oDyV/du4Cd07qwo7Czv1TeZs0OAAJoVQoZ5v4cRs8swUJlaFWO3NlM
	 zCRaoemS+G8OoXoU6NzoXmafOX0+p/PJ2SJVjP9vh1W+QNsx9QdT70h0pDI/DKAjmg
	 uYpQosJQgG0rRrEEWggdN6+P4Jy4Ysr7xutN669IiBmh+8VWefX/MfvlQWrmJo0FDK
	 e2NthFaAwdaQw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6971C04r83403955
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 7 Oct 2026 09:12:00 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 09:12:01 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 09:12:01 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 7 Oct 2026 09:12:01 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH v2 rtw-next 3/3] wifi: rtw89: 8922d: update supported firmware format to 1
Date: Wed, 7 Oct 2026 09:10:57 +0800
Message-ID: <20261007011057.12125-4-pkshih@realtek.com>
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

The firmware version 0.35.119.0 changes hw_scan format, which isn't
compatible with old driver. The BT-coexistence also implements much
features in firmware side until 0.35.119.3, which needs driver side
implementation accordingly. The REGD table included in firmware
file add NZ/BR/AR countries. Increase format to 1 to prevent old driver
load the new firmware.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
v2: mention the changes of patch 2/3 is one of reason to have this.
---
 drivers/net/wireless/realtek/rtw89/rtw8922d.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922d.c b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
index 41e2aa1c8f78..b703762f4680 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922d.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
@@ -14,12 +14,12 @@
 #include "sar.h"
 #include "util.h"
 
-#define RTW8922D_FW_FORMAT_MAX 0
+#define RTW8922D_FW_FORMAT_MAX 1
 #define RTW8922D_FW_BASENAME "rtw89/rtw8922d_fw"
 #define RTW8922D_MODULE_FIRMWARE \
 	RTW89_GEN_MODULE_FWNAME(RTW8922D_FW_BASENAME, RTW8922D_FW_FORMAT_MAX)
 
-#define RTW8922DS_FW_FORMAT_MAX 0
+#define RTW8922DS_FW_FORMAT_MAX 1
 #define RTW8922DS_FW_BASENAME "rtw89/rtw8922ds_fw"
 #define RTW8922DS_MODULE_FIRMWARE \
 	RTW89_GEN_MODULE_FWNAME(RTW8922DS_FW_BASENAME, RTW8922DS_FW_FORMAT_MAX)
-- 
2.25.1

