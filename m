Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C7A3242B2
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 01:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791335520; cv=none; b=robnCkmIQbk7VNQb4NDATGp/QON/SAzESmhq6HB1KSeB+UseLSS6EETUiPEwSwRAszDcQFNiGX8gTPZ72S/pXTe2C57uIV/+XnL94NvfHtB7dTQM6H8CNrJROGi6MtskrdXTc9d7kGARhRCASBUFWVxD3zBUSCPBMVogCWM2QF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791335520; c=relaxed/simple;
	bh=YJQOBDv8PzThV4s6siUQcdmBVu/WAqCiBcfUEekHAug=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AkAEA7YLAubeNH9K6NRfEOfM5cVs4rHrqo6In1TvCUN/nyZpMrGWtYy0E2ETQyUjVmkw+JFIW+02/7wKaxNsN8iGpzrsWP/65IF39Y8UHTgM/Z2LGWMmlZ+PV3V79P1o8QYKjzXTs/3IOQ7lrjc4RhYfuJgxVcyZejoz22nRBwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=dxVZ2buC; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="dxVZ2buC"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6971Bn3aA3403797, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791335510; bh=Ox4F5PV++e2R22iKafFJ2uqfSRR7ikTBVTRPmqRtm90=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=dxVZ2buCa/Nn0gUKcDZAeOSMoxHwsOPdDykN54lQAQ9GwI7TLIbGKf501jqp+HDet
	 Tm22MmboEbfolzYGirHR64p9/2oTYjasVqfZKzqr+Og+6CojZxJZeGwAihxOTr8O//
	 rKcK/vIAUE2meVDUfKuyhBV67UkIlFN70piSogGH1nfJjI3Z2fGlTv8gQyr/kriSdH
	 6OIa0zHtxrz8cXZ8ZyYpPNchjRwLCV0L8FHJ68xA9jgEZmFt/7C3wRF0yreieF4SgG
	 nUM7DKcrZcC8dr0GN+/9XoI8Jewh4wodEiyRJEuBiC1mZXTzlVU1u6iGfRr4n7hFTv
	 Go4sENswnMnmg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6971Bn3aA3403797
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 7 Oct 2026 09:11:49 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 09:11:50 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 7 Oct 2026 09:11:50 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH v2 rtw-next 1/3] wifi: rtw89: coex: Update Wi-Fi/Bluetooth coexistence version to 9.24.2
Date: Wed, 7 Oct 2026 09:10:55 +0800
Message-ID: <20261007011057.12125-2-pkshih@realtek.com>
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

From: Ching-Te Ku <ku920601@realtek.com>

Update 0.35.119.3 Wi-Fi firmware support. Fix dual BT, dual MAC,
MLO mechanism binding control not working issue. Fix AX/BE serial
chips logic mixing error.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
v2: no change
---
 drivers/net/wireless/realtek/rtw89/coex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 6b72e2c80d14..4fa9632649d1 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -11,7 +11,7 @@
 #include "ps.h"
 #include "reg.h"
 
-#define RTW89_COEX_VERSION 0x09180113
+#define RTW89_COEX_VERSION 0x09180213
 #define FCXDEF_STEP 50 /* MUST <= FCXMAX_STEP and match with wl fw*/
 #define BTC_E2G_LIMIT_DEF 80
 
-- 
2.25.1

