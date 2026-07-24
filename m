Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054E1435AB2
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 14:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784902970; cv=none; b=P38M8umlZjMxfLFD6LZ0473WFFYL5VKJ29+4cq9qgd78RtkCzG+NENUDRBOdbqGBOuuAvmDn5tG+Tub1TjOxmzYvLbd5WQfLyIrlJJrNB+QY0Ad1C7j3yGhl/4O745aebYqMGpbQzPhC+ulSjb8MXSq1u4YaPBNVm1OhapJDiMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784902970; c=relaxed/simple;
	bh=WYoEEGKu7vKFbel5txsv53IKdUaa1T05kekkWWu3IVY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=l3Hj1l5ZbulOIQDxsYXbDehlvd9ng9B4wdWxTtww8t6TA5gTUvJNiO0EBzXJfN3MXJrSLWJgXA2FwfE8wExuAZ4d/L3y31BIDoWIQB7RZ/8C/PkIY1OyXcnWFtT1xshiL/LYOihhv3nSZrgRxGiQKsELld3ALHDYiKIlv3nxw6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=OTBoTWVv; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="OTBoTWVv"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66OEMkwtE1234033, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784902966; bh=UfbvZc3ZJ3ltxaU018svRhoFKXR2ogBUIVZ7JiSJyuM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=OTBoTWVvUoFr+IP6m8kzy0h5z4pCPNEWYwzjw2WHlqsDolslduhr/FedsFQBc5YUw
	 kzygUxM57Gvu75/QGZiGUcU+bgGurJXfaSSSXMrhmeR8ATHWhYkJtmTT2ROhuCk0H+
	 xGQN88Vv2BaKLG2omSM2w21H4oe3haN9JW4KmNM+sOJl9u3m0uYEgw4TtHzFWZa+yC
	 x54XQ5Q2VH+ZPLBu4Mp6zFeq0/uMnzJ8/em4X0D8R3wHWw3LeT47eiNgK+Yq9I7Fox
	 3CxIQIGSDlQbh65kW8U5JIQccZp+AVT2cHSrW6dL6xOmVQLYR7iBjD1oSBxPtJxc2l
	 K0TuaGAk0MM4Q==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66OEMkwtE1234033
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 22:22:46 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 22:22:46 +0800
Received: from [127.0.1.1] (172.21.40.76) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 24 Jul 2026 22:22:46 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <dian_syuan0116@realtek.com>, <phhuang@realtek.com>
Subject: [PATCH rtw-next 0/3] wifi: rtw89: support hw_scan v3 format for WiFI 7 chips
Date: Fri, 24 Jul 2026 22:22:43 +0800
Message-ID: <20260724142246.3195274-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

Due to firmware change the hw_scan format, update the format accordingly
to support current new firmware. (By patch 2/3 and 3/3)

The patch 1/3 is to store RX filter settings by a variable, so hardware
leaves from idle can restore the setting from the variable. Otherwise,
the RX filter is unexpected, and AP mode can't receive certain types of
frames.

Dian-Syuan Yang (1):
  wifi: rtw89: refine RX filter configuration for WiFi 7 generation

Po-Hao Huang (2):
  wifi: rtw89: fix scan offload version check logic
  wifi: rtw89: change scan offload format to V3 for WiFi 7 IC

 drivers/net/wireless/realtek/rtw89/core.c   |   3 +-
 drivers/net/wireless/realtek/rtw89/core.h   |   4 +
 drivers/net/wireless/realtek/rtw89/fw.c     | 126 ++++++++++++++++++--
 drivers/net/wireless/realtek/rtw89/fw.h     |   1 +
 drivers/net/wireless/realtek/rtw89/mac.c    |   1 +
 drivers/net/wireless/realtek/rtw89/mac.h    |   1 +
 drivers/net/wireless/realtek/rtw89/mac_be.c |   7 +-
 drivers/net/wireless/realtek/rtw89/reg.h    |   6 +-
 8 files changed, 131 insertions(+), 18 deletions(-)


base-commit: b0034a2e415603daa1cf00363b407cc145bbcd31
-- 
2.25.1

