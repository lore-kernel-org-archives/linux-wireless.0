Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8B8364028
	for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2026 06:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782368196; cv=none; b=rdPrdcn4u0lWqbV3mHhKwloFWrCSy5c+Hj6q/v13+DWoT0zaCkGxGKUwTSqsxFkcwM0KNwxQNaNiAQcCXAWHbY4/Ea3P1Hd+jiPJwwIg/x0rN5Z7noRatdHHFSUG8BPAnt86WelYH+lHNPm37eLl+fYxpi221JD205LTJQH5t0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782368196; c=relaxed/simple;
	bh=CQ+vqwHGbt1bZT7tTDf+PVbteWtnGC4nv93gMVWziGk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lJf8PTToZVNX5TGnudgZN0YpDSIAB3vqzSbBSuYfU+kH94jJjhwcwgheE/fOvisPmWQ0VgJ6Du0b5fLgLfHu5oUN0Dod36ueg0GV+JHK1ZmwsplPZno2FVfgVRTeDcsNvSxsgWkqERz9tKoH24jPwEje3/N2g67ICW/5y7V7YvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=COO81or/; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="COO81or/"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 65P6GVL90584248, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1782368191; bh=153RE0uafEip2awqYfeQgeMdjHQzf7yTa371hAZVvu4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=COO81or/V//yZucs2Zlr5Gj9eIDa7zZt4y78NpPXRtDvftU//5LAGjgPcIyu4D7tK
	 eOuV0GgUhBV+mh9lS/ZBfPx90GEiAEc0sN3B/0bFSC9bKuBt6hlnwL6gsWeQuX8YIu
	 kZlXvsM699sGLBihL5ksElQmRtfc3024QNzsRSeJBrZTJCMtcuq3sq6//FFvV8tRln
	 wWeBajPAEVqjOPbrYAZoVPBYO7Dr2Mb911BJgkqkjYp45lxHqwXxjSz6vW6vqPaKtS
	 563KWRsfqJO989CKXnbxB9g/eoezH+XFY7fyvnMZ7tmp+hkTZ0aed1xbPgVA/m3QA0
	 EjnrQPq7iZ7fQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 65P6GVL90584248
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2026 14:16:31 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 25 Jun 2026 14:16:30 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Thu, 25 Jun 2026 14:16:30 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <timlee@realtek.com>,
	<dian_syuan0116@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 00/10] wifi: rtw89: update some MAC, FW and WoWLAN settings
Date: Thu, 25 Jun 2026 14:15:35 +0800
Message-ID: <20260625061545.44808-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

Most patches are to configure MAC/FW/PCI settings. Notable patches are
patch 4/10 to resolve hw_scan issue in certain platforms; patch 7/10 is
to fix typo of previous patch, but no problem for legacy connection.

The last three patches are related to WoWLAN, and the first two are to
support WoWLAN with MLO AP that uses MLD address.

Chih-Kang Chang (3):
  wifi: rtw89: disable sniffer mode in RX filter when initialization for
    Wi-Fi 7 chips
  wifi: rtw89: pci: disable phy error flag related to refclk
  wifi: rtw89: wow: only WiFi 6 chips initialize RF registers in WoWLAN
    mode

Chin-Yen Lee (2):
  wifi: rtw89: wow: use MLD address in WoWLAN ARP replies for MLO
    stations
  wifi: rtw89: wow: add QoS control field to WoWLAN ARP response for MLO

Dian-Syuan Yang (1):
  wifi: rtw89: drop packet offload entry on H2C addition failure to
    avoid scan issue

Ping-Ke Shih (3):
  wifi: rtw89: mac: finish active TX immediately without waiting for
    DMAC
  wifi: rtw89: mac: pass chip version to firmware
  wifi: rtw89: fw: lower debug level for UDM1 debug register

Zong-Zhe Yang (1):
  wifi: rtw89: fw: fix link ID filling for LPS MLO common info

 drivers/net/wireless/realtek/rtw89/fw.c     | 65 ++++++++++++++++-----
 drivers/net/wireless/realtek/rtw89/fw.h     |  2 +
 drivers/net/wireless/realtek/rtw89/mac_be.c | 14 ++++-
 drivers/net/wireless/realtek/rtw89/pci.h    |  2 +-
 drivers/net/wireless/realtek/rtw89/reg.h    | 28 +++++++++
 drivers/net/wireless/realtek/rtw89/wow.c    |  3 +-
 6 files changed, 95 insertions(+), 19 deletions(-)


base-commit: 972c4dd19cb92e03d75b66c426cfade07582a1ba
-- 
2.25.1

