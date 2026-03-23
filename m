Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A426715539A
	for <linux-wireless@vger.kernel.org>; Mon, 23 Mar 2026 03:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774236378; cv=none; b=rbaHaoQ4SrwUge/a0WbUuIov99kwDkKZm7SM852/JTlzteZDjitF0FLJyDT0r9VLomYNhT0E1YD5HdkhFyzEY2ydWgW9bNnVey0XBnmWZNytU9dJc7gPmx95yHxQXgmk9Y7m282ovtBHG+EAgZTFhIQT9LjoY400U3wi94EY+e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774236378; c=relaxed/simple;
	bh=JuxGyXRshJCYXxVmLM4xXWa7WCPR+CPMml7yYT5hBIg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=h0HGgTpGE+tv5Y1mSITicXvcX0xEuECcxXPrzouuIC4u2Q0Kxf6D+TlbF1YwykYopefN+YAvq5OisV1rV0Y0Ex76HtuC2ld/Xd2Wery+kusf7LjpOW9WM5HDobtACIUlxpSe1uDaoQ7QWvt/hG0cbXF31teiH82mRZvQA/QDWoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=eY4irFC2; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="eY4irFC2"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 62N3QDJF02375017, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1774236373; bh=ZpBXPbKTKNltbpStZwhiEbT9wPihBZX3FvTnA/R97KI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=eY4irFC2IqtCi3l/ETt5IkvJBi2ykfu41qZIUjsx4Mid7UmwZFDZJgrHEbfpOV2Tl
	 +4WkUCl0VySR0OeBnRnSs9VzSMcD+uZhn6badnX1QtRMKSMDrMTIVmTnS2rZ+IoitT
	 zWGlTFMfd0W3Db2XDFpg+K42c64ibaRb98UBFFZUf1NP8z1bFkew9Wp6pK3zp84Jtr
	 fr2DAQT62V34I3KnROxhS96Z2i7qAsFK3J1g6YhJrDP0piS3W+hArp4NoM0F6fUyeJ
	 n067Ja/pSKaprnszr46b0hS/P0ZEq8gvkJ7U4zZnM/hUaXkJv7xsaTc9zzg/6g7Rk5
	 9Hl+Jzht6Njow==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.21/5.94) with ESMTPS id 62N3QDJF02375017
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Mon, 23 Mar 2026 11:26:13 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 23 Mar 2026 11:26:14 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 23 Mar 2026 11:26:14 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Mon, 23 Mar 2026 11:26:14 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH rtw-next 0/7] wifi: rtw89: 8922d: add RTL8922D common routine part 1
Date: Mon, 23 Mar 2026 11:25:49 +0800
Message-ID: <20260323032556.19825-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

This patchset is to add RTL8922D common routines. As the code is not small,
I split it into two parts, and this is the first part.

At this first part, add memory arrangement called quota, power on/off
functions, functions related to calibration data in efuse, and the
main set channel function.

Ping-Ke Shih (7):
  wifi: rtw89: 8922d: add definition of quota, registers and efuse block
  wifi: rtw89: 8922d: add power on/off functions
  wifi: rtw89: 8922d: define efuse map and read necessary fields
  wifi: rtw89: 8922d: read and configure RF by calibration data from
    efuse physical map
  wifi: rtw89: 8922d: add set channel of MAC part
  wifi: rtw89: 8922d: add set channel of BB part
  wifi: rtw89: 8922d: add set channel of RF part

 drivers/net/wireless/realtek/rtw89/core.h     |    7 +
 drivers/net/wireless/realtek/rtw89/reg.h      |  160 +-
 drivers/net/wireless/realtek/rtw89/rtw8922d.c | 1755 +++++++++++++++++
 drivers/net/wireless/realtek/rtw89/rtw8922d.h |   80 +
 .../net/wireless/realtek/rtw89/rtw8922d_rfk.c |   33 +
 .../net/wireless/realtek/rtw89/rtw8922d_rfk.h |   14 +
 6 files changed, 2048 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8922d.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8922d.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8922d_rfk.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8922d_rfk.h


base-commit: eef6d4449e8a540fde792968a26d8aa514af8089
-- 
2.25.1

