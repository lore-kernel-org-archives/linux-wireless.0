Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E292D2FFDFC
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 13:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784901406; cv=none; b=b3h7lm9greoGq3R8L9xogk9S5zuQ52KH4isUhjcjdI4K83RYSmR2SCUYGtZ+nBMJpXCkf04CCNXvo7lk55os/JuwhkbWHwdytXIMAZCDoc2ZRgD0hyPcJmfS0y1Fq53X0zzpBk+ReL6Y7Y5SzMiR1IzzsrsQN9AM0uWzWRJifMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784901406; c=relaxed/simple;
	bh=MZw4ugHr5mPKT58YjWW6vwtGGy2PbVQmvq5/awUc1yk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=htMSwg02SBMXiLvZ3NKUypjNMXagZwOTUn168BAhU7NjBbhVhSVtMuSpbK8rgAOFogyqh6Ev1fNq/rIAoySXSknp+/Rkk/svpx4Td9f5WOqWJTCe32ZA+gW4Em84ErIEq++A94c8TaTEH9tWyrpbxiXkStruVW2vvwCqdvWr1yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=sy8vjujj; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="sy8vjujj"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66ODufbI71179647, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784901401; bh=+/aKP2L9ecsLYPuZPprsGk3K772Lit/e5bYO98AnWyA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=sy8vjujjjMv9TiqZgoUprkvl1LL5gZvz1grwxa7h3io257LJVu9wQZelOEckAFt++
	 KWEDeZhooGd4omg8u2vSXUxXlMlTffhU7KKZcaxvqOm3YeZpETc4ukz/R9yJWDVjw0
	 O9gDBdOw9+DR7uWKB+qGguBtH/Mib6lLyeeoi8ESWcp0yiLr3tyl8hs6T+TV7lZCTP
	 5Aqj8a+S0td6Iev7xLH/XxTLti2+avtK0J753Jia135kKqz1LmSUy7lavPDIrzIhpG
	 JmbygZAQue7yAR0SgGZh76M7qocdXMSNWvdGnTi1IqQ9Vodz3rD+kJqUuzRvRcdbY1
	 saqZRWov7sbxA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66ODufbI71179647
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 21:56:41 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 21:56:41 +0800
Received: from [127.0.1.1] (172.21.40.76) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 24 Jul 2026 21:56:41 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 00/14] wifi: rtw89: coex: add more command / event formats for coming RTL8922D
Date: Fri, 24 Jul 2026 21:56:26 +0800
Message-ID: <20260724135640.3195044-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

To support BT-coexistence including dual Bluetooth for coming RTL8922D,
it adds more command and event formats to carry more information for
the more complex application combinations. More, introduce to show two
Bluetooth states for debugging.

Ching-Te Ku (14):
  wifi: rtw89: coex: Add chip initial info version 11 for RTL8922A/D
  wifi: rtw89: coex: Add Wi-Fi MLO info version 2 H2C command
  wifi: rtw89: coex: Add firmware 0.35.111.X support for RTL8922A/D
  wifi: rtw89: coex: Rearrange _ntfy_role_info info
  wifi: rtw89: coex: Separate _ntfy_role_info into two function
  wifi: rtw89: coex: Decrease Wi-Fi special packet protect time
  wifi: rtw89: coex: complete GPIO debug configuration handler
  wifi: rtw89: coex: Refine RF calibration notify flow
  wifi: rtw89: coex: Fix log dump format with proper newline
  wifi: rtw89: coex: Add BTC report version 8 support for BT sub-reports
  wifi: rtw89: coex: Add dual Bluetooth debug info dump
  wifi: rtw89: coex: Fix TDMA v8 handling to unblock BTC report parsing
  wifi: rtw89: coex: Fix H2C command redundant send & version fall
    through
  wifi: rtw89: coex: Handle Bluetooth LE-Audio related coexistence
    feature

 drivers/net/wireless/realtek/rtw89/coex.c     | 908 +++++++++++++++---
 drivers/net/wireless/realtek/rtw89/coex.h     |  56 +-
 drivers/net/wireless/realtek/rtw89/core.h     | 297 +++++-
 drivers/net/wireless/realtek/rtw89/fw.c       | 133 +++
 drivers/net/wireless/realtek/rtw89/fw.h       |  22 +
 drivers/net/wireless/realtek/rtw89/rtw8922a.c |  88 +-
 drivers/net/wireless/realtek/rtw89/rtw8922d.c |  40 +-
 7 files changed, 1322 insertions(+), 222 deletions(-)


base-commit: b0034a2e415603daa1cf00363b407cc145bbcd31
-- 
2.25.1

