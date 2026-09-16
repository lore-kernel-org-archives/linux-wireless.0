Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA104457C1
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 07:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789543404; cv=none; b=HCzEB7PX2HWzqnCo1xZdncIiEl57a9ZmVOeoyvKu1sB+iyLBLYbwmALj8UOp4g5oiOwPTjRslibbyvFlFOvJgClo+9NKJfOE04Y5mjSWkg3kAfZhaWAYnx8O1GIo0h4Otxwys1Pes6bNUYlvNJiE22pYazZiYAiK794BjjBy68U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789543404; c=relaxed/simple;
	bh=YxlDGQKGvCSsg2UJIo8/ADwPnZxZs6Nm0Efo/9as0ZY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fADgkVrJhj1M9ye5VVNm1if7gan5Wuu4ltc1/iiJ14+FAwYKEC9TIuyyvDlJu7kS5DmM1/6FPqyHzGMlMZ8xFV0W/S3dDaeSJPSKr5dfy1mXFvwdY/vZ4480gaqVq+JUZqU8QERO9ZyB3umnvLk7atccLU+y/qnJpDahMwsM2pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=biypgHun; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="biypgHun"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68G7N88H02168297, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789543388; bh=ZurMIYxfmJPa16aj76at0LiFeC5Hb0d8DdM3aygNu9g=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=biypgHunzFc6Dw1KrcPAfnJH6Ar+ICIED3GQKnO9JRJ2ck8m57L/UNN3GOPbQ7QCf
	 LxjNCebeguHEAzcUbB5eqL6W4rbHRN9vdpkhvM9Y22pj5vIlscBP9Vh7gyGqLRT1l1
	 GLQ8NotXpn9pJs8av6YCH6wGTaDcD/eWMHTdf21H04kiwzRXhc39XqSpwU9huAW/h7
	 XdJrAq2AE+7iFH/dwRFdULY+YXau+6Lo+S0Pi4PUHTJw67YW4leVgYaMFdRSdF6QTc
	 JPd84EXTzzKc+6UtE+Vzm2znAA7rt0oJBfXDULPqafmg3fAU6gNSKzMOdrI9l/DtHF
	 L64rE/s+qITHA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68G7N88H02168297
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 15:23:08 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 15:23:07 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 15:23:07 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 16 Sep 2026 15:23:07 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 00/15] wifi: rtw89: coex: improve BT-coexistence for RTL8922DE
Date: Wed, 16 Sep 2026 15:22:23 +0800
Message-ID: <20260916072238.62574-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

The BT-coexistence of RTL8922DE is continuously developing and debugging.
Add more firmware command/event formats, and update logic for the cases
we found and fixed.

Ching-Te Ku (15):
  wifi: rtw89: coex: fix SET_H2C_MACRO not sent for BTC_FEAT_H2C_MACRO
    chips
  wifi: rtw89: coex: fix out-of-bounds read of report gnt_val
  wifi: rtw89: coex: fix rlink index bound check in _update_wl_info
  wifi: rtw89: coex: support version 8 for gpio_dbg FCX report
  wifi: rtw89: coex: support fcxtdma version 8 in TDMA policy
  wifi: rtw89: coex: add fcxcysta v8 report support
  wifi: rtw89: coex: route BT sub-reports by bt_id for dual-BT support
  wifi: rtw89: coex: split bt_profile into per-device fields in trx H2C
  wifi: rtw89: coex: add fcxtxpwr version dispatch for CXDRVINFO_TXPWR
  wifi: rtw89: coex: set dbcc_en for dual-band-active MLO modes
  wifi: rtw89: coex: evaluate CO-RX Hi-LNA request per band
  wifi: rtw89: coex: detect BT HID activity from scoreboard
  wifi: rtw89: coex: check null-tx fail ratio in nullsta report
  wifi: rtw89: coex: detect BT slot flood via A2DP empty-streak in cysta
  wifi: rtw89: coex: add AFH conflict detection on BT AFH report

 drivers/net/wireless/realtek/rtw89/coex.c | 481 +++++++++++++++++++---
 drivers/net/wireless/realtek/rtw89/core.h |  31 +-
 drivers/net/wireless/realtek/rtw89/fw.c   |  18 +-
 drivers/net/wireless/realtek/rtw89/fw.h   |  14 +-
 4 files changed, 478 insertions(+), 66 deletions(-)


base-commit: 73e3b1c94c7d5b4a113e7cbb42665dc2fe3b9d78
-- 
2.25.1

