Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2BA280CC1
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 06:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784269249; cv=none; b=TV2YBom2WNRAXIkJEDjO5Ja6suYIhhfIu0sBXrX+RGY0/KGFSY5Ic44++kGTv/jBcG+0vSwzWujVCSgIh9VDOPqCM3kCdGVQyzfZKOdX398m9uXIZYFbKJn24ZJJoeluLvfr7Ii2l5Y1CIKhxbrEflC/y5g96kOSykAIMLYW2aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784269249; c=relaxed/simple;
	bh=AiKXTPyYACAVnwNr4Hw21cI51XGCk3VeOCTW618dMOY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BBWGoxBmIGGWSVQ9SVtPAgc+TMZ4Vis8zTF4ZyoksvUncSC7h81qZ/HgJGFyMhu6qSpp/wnfT0JvwL++aQ25bBZdX7jYim99Xc88pPwWxlrgxIzFf9fiDnrGyvQ8XoO/F2a0bV+7a5p0GqDUHnNYI58QbtAv7ZPrZEuYh34H7mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=tkhgifLb; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="tkhgifLb"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66H6KkqT64163670, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784269246; bh=RTvFPaDzW6qMvZ0zlkxlxHqhPr3O7e6aP7H+LU49u6s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=tkhgifLbcIMVf9Z00zeEE5bv0t85/wHr1UhjEkGdhFaLKPDuNPTnuUFCCdr2T9pH2
	 fJ4qMYPRxvA/5au4sFSMb9YjXEqC1phdFInK3YtbUU2qSBMCq3+XVLpS0syxM9wdee
	 HSQHxl167BzvkvsLtcQFsCwuspUhBc+RnsRoqKlEdygs9PkqUKUz2z/5BHJnf9vnUU
	 6Wr5hiPjHgH+USnzWHClG/FfW0GUGvMdqjbLzg9FJfuMRHbPueEdbzLN8y0miM4sTt
	 w7Jqi6VHnmKfl3uB2bZKLHa7AOmlLJFDXu7OeRr9CKtBAvW9dEGBwZWzseifnfRtfJ
	 K+Co9/j1BmhOQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66H6KkqT64163670
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:20:46 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 14:20:46 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 14:20:46 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 17 Jul 2026 14:20:46 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <sc.lee@realtek.com>, <wenjie.tsai@realtek.com>
Subject: [PATCH rtw-next 6/9] wifi: rtw89: wow: extend timeout unit to avoid SER false alarm
Date: Fri, 17 Jul 2026 14:19:07 +0800
Message-ID: <20260717061910.54466-7-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260717061910.54466-1-pkshih@realtek.com>
References: <20260717061910.54466-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

With original timeout unit, it might trigger SER false alarm causing
WiFi card lost. Extend timeout unit to avoid wrong SER.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/pci.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/pci.h b/drivers/net/wireless/realtek/rtw89/pci.h
index 92c30c7f9fb2..339706d99f6c 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.h
+++ b/drivers/net/wireless/realtek/rtw89/pci.h
@@ -1022,7 +1022,7 @@
 #define B_BE_PL1_IGNORE_HOT_RST BIT(30)
 #define B_BE_PL1_TIMER_UNIT_MASK GENMASK(19, 17)
 #define PCIE_SER_TIMER_UNIT 0x2
-#define PCIE_SER_WOW_TIMER_UNIT 0x4
+#define PCIE_SER_WOW_TIMER_UNIT 0x7
 #define B_BE_PL1_TIMER_CLEAR BIT(0)
 
 #define R_BE_REG_PL1_MASK 0x34B0
-- 
2.25.1

