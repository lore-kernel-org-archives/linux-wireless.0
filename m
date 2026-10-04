Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3530D331EC7
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 04:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791086452; cv=none; b=Dv34ZSM3AcyuLx/sgn4lFVfYOzGU1z6C2drYV8Kr1sdsGm0ZanM+s4w6EtyARu4yD6injxCGkdlZFEpGtOOOB1Z8mVS6HPbb+AmgpgbEUuJT0S1ZFmATpCl+WwDA6OElmaA3zihrbe+gSeFdMSb4+uZA5vUMxM4moNy51sv/O0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791086452; c=relaxed/simple;
	bh=bIzQMcn9nSoSSh0W/VEzbZHjThdAdhGRM/Yy8G8V4nk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QuYU+gjXyABcBAcEzNQYagiA/mg2nTMYbN5NHX3/zhWCWo97RVhR/CkjZfW9WkPAu8E6PXGWyhUmRZwSF/9MHwJGFC7TwOSOL8jciJ7pEy64dofrpgq1lLnMXS0kcyFX7p0HXvL/s3dn6P4ZxvOIbirMaxIJWT5NndqsIRMuLuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Hk5Q6+cR; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Hk5Q6+cR"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69440mYjA833992, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791086448; bh=o+NEwzCp/EewOGeAaxYW8zTslzEgC77ij74AvDP78MA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=Hk5Q6+cRn0fx+tytcQpBCJJbMYjE0UKLbkqVLIGB7+JtihTgkWaVhDgwHgH28BAtd
	 jtZEth5ntzJ1Qz0TxrAkDwR1MpDT7hfjb0KotbMAtFJ8ROeEYQH9aq5UqPEFml8trz
	 FVECiJZudfdDhZWDUl6hIcbIdX8VwG7TwW6R1rs6FRap2hfBlXJ8daqkHT4nFXRkk7
	 nKDb0Aiy/LH0iot0AWJ7vbXWesFOBFFvBYe2iEdWaf3qjmt9bS1COFH8AjI+Qdgc0C
	 SzDYG0YedS7yCaIISDLnKFHPLGZTQK6oz4PMav5orAW7KMrW+nKsU3NS3BKqBLZTeu
	 PsoTBUuxEO5KQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69440mYjA833992
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Sun, 4 Oct 2026 12:00:48 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 12:00:49 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 12:00:48 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Sun, 4 Oct 2026 12:00:48 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 2/2] wifi: rtw89: 8922d: update supported firmware format to 1
Date: Sun, 4 Oct 2026 11:59:53 +0800
Message-ID: <20261004035953.36785-3-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261004035953.36785-1-pkshih@realtek.com>
References: <20261004035953.36785-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

The firmware version 0.35.119.0 changes hw_scan format, which isn't
compatible with old driver. The BT-coexistence also implement much
features in firmware side until 0.35.119.3, which needs driver side
implementation accordingly. Increase format to 1 to prevent old driver
load the new firmware.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
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

