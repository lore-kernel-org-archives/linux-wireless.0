Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD46C48096F
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 12:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785329046; cv=none; b=Stcu977FQOds52bYUpx13PeLNs2DF1WdntVrN+DSqTGnWHZAV3utcaYOgzz48ZrdcNhJLnFx3YYDjPtDpOVOisDBZDOsXCFc9oFzVU8Fgiu/fu0asu5OLlLxIj6+PBeofU/sgGzZrq78uzYD8ce36J72S9kJYTc+MD7E9FkLBcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785329046; c=relaxed/simple;
	bh=x5dM84eID6VfdvGOBR7jh2xS9wrOubPMLvG3yckgEvw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Ebjv3VZF5s//ni3JXJq1lTGZ0c6AwSRLn/1zVGDOEzZRacA4bXaxQoWBnYBoUmaqUxCtiN/OOajdufPH16lrzMSlP4jLNSoVxy24m5pSjsWmICWtvD2uio2tbgn9wPNyKhpjJtd/huyEaLnrOQiy4UIVPD8AD+PkHDHNelbMqKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=BFaUDsin; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="BFaUDsin"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66TChsmM7421692, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785329034; bh=lUxEnXqDZfIVNztokxrmmCrib6ClHApB8hjaQ4y0hLo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=BFaUDsinNR0lEpWPaBOLT70duIUXXoiHNKuffwnPINdTy+ZQNwwMmsjb/rWrc10ld
	 ymF2Awv7J1qetp6pBNi0GQqFV3gzrXTOpn+iuKOH/VfN/n/8YDI0rnzn3HUjtIGij0
	 N42/QrR96J8xMT71fp4LKYEbOfNrQ8nPJxWM/xhE4yJ4lIFaMga/GmjWJqpOVr2QnA
	 pLAYcnMdrKg3JYEGZ9pg+yIS0QJ/av3Pzf/4DWctU40dWVtFgWbTOwvfNZy6L0NP2z
	 zIJYKv2J/LRHODZbhyqqPrhkyOiSiNteD/H+T6RwiNYT9Q9UJeiNYdAoHwETLobLUU
	 F8U/buRiHLhFA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66TChsmM7421692
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 20:43:54 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 29 Jul 2026 20:43:54 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 29 Jul 2026 20:43:54 +0800
Received: from [127.0.1.1] (172.21.40.76) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Wed, 29 Jul 2026 20:43:54 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <dian_syuan0116@realtek.com>, <phhuang@realtek.com>
Subject: [PATCH rtw-next v2 0/3] wifi: rtw89: support hw_scan v3 format for WiFI 7 chips
Date: Wed, 29 Jul 2026 20:43:51 +0800
Message-ID: <20260729124354.3231368-1-pkshih@realtek.com>
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

v2:
 - patch 3/3: consider WoWLAN PNO user scenario, and not consider
   wildcard_6ghz field for WiFi 7 chips.

Dian-Syuan Yang (1):
  wifi: rtw89: refine RX filter configuration for WiFi 7 generation

Po-Hao Huang (2):
  wifi: rtw89: fix scan offload version check logic
  wifi: rtw89: change scan offload format to V3 for WiFi 7 IC

 drivers/net/wireless/realtek/rtw89/core.c   |   3 +-
 drivers/net/wireless/realtek/rtw89/core.h   |   4 +
 drivers/net/wireless/realtek/rtw89/fw.c     | 168 +++++++++++++++++---
 drivers/net/wireless/realtek/rtw89/fw.h     |   6 +
 drivers/net/wireless/realtek/rtw89/mac.c    |   1 +
 drivers/net/wireless/realtek/rtw89/mac.h    |   1 +
 drivers/net/wireless/realtek/rtw89/mac_be.c |   7 +-
 drivers/net/wireless/realtek/rtw89/reg.h    |   6 +-
 drivers/net/wireless/realtek/rtw89/wow.c    |  20 +++
 9 files changed, 187 insertions(+), 29 deletions(-)


base-commit: b0034a2e415603daa1cf00363b407cc145bbcd31
-- 
2.25.1

