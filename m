Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4450B3B3896
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 06:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784271526; cv=none; b=ouxRHv8q6od4rzf5WRMVpTjqd7nR2kPyH4Yw1aMmkLucS0qFTQfPYC0o6ulhbgwzlrUDWu43gLneNfZE360cY2CwT4V4rrnLq8bkpShaf93NYXt7LpP2dI8tTF34tVr8pmI9tMsW0aaQCxvK3LPf7sMAaxZSBfcR0Kaq7DzBA3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784271526; c=relaxed/simple;
	bh=1MsAL2LVhywQX3SgCFyDAtcXwjC8wo6BlfEA8cXYJtg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MXqfwY4zPukV5m6dEfKCs5l89cGFlCH9QgNdYUSlDjWhhKdQHubExZG0gUttkYMqtBUUx+qBodmbMzp42u4O0GDn11QztbXBsK/4Gv1gxRZfCGAGGXWNMO+TN/kQLV0Rn4ktLwYxk0SguvmTqZQxL+MmbBwjLKT0bx6kRKghblw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=H4sEGo8c; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="H4sEGo8c"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66H6wgCzB4176303, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784271522; bh=hMRQvalVnGOkhHCa3nNIBxCo9ASYm3le9qa+lXxR2JI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=H4sEGo8cP/jeua2vHWFrKzyMJyJxviHXi0HP2lb/aa2z8lXisbxy6xrBw28a02oiC
	 e0h3mchBcx3ZT1Vm3lRkgy5z6IWIBcSINIjq2WCldyO497pScj0/mPluuAyH/xKUMk
	 FSbiZAVK0wbh3pupr92z6mK+z272uCI7/zP+fuVgRDrQ/M1l6NOiBPbcb1PxU9BKSl
	 QI6qWXhh3T3p0plWOD8VGbObJmptSw5BdN1aGPWxETCFsMpTo840afo5MD5tHTy//D
	 YmMxJwQoyUyQ/HOFMMrPfhkOBkndfaljteMK6H03Ic+O9bBeJpABjYz90Kbz6huicP
	 8CTwwK/IfCJEA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66H6wgCzB4176303
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:58:42 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 14:58:42 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 17 Jul 2026 14:58:42 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 00/13] wifi: rtw89: coex: add more firmware command and event formats for newer version
Date: Fri, 17 Jul 2026 14:57:26 +0800
Message-ID: <20260717065739.64124-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

In order to support newer firmware including WiFi 6 chips, add necessary
firmware command and events formats, and define needed version by
chip and firmware version.

Ching-Te Ku (13):
  wifi: rtw89: coex: Add version 107 TX/RX info for firmware feature
  wifi: rtw89: coex: Add version 9 report control info
  wifi: rtw89: coex: Fix unexpected grant-signal assignee
  wifi: rtw89: coex: Branch out version 105 firmware report map index
  wifi: rtw89: coex: Refine chip initial related structure
  wifi: rtw89: coex: Add driver info H2C command index version 103
  wifi: rtw89: coex: Fix Wi-Fi role info H2C command header issue
  wifi: rtw89: coex: Add firmware 0.29.133.X support for RTL8852B family
  wifi: rtw89: coex: Add TDMA version 4
  wifi: rtw89: coex: Add slots version 2
  wifi: rtw89: coex: Add cycle status report version 105
  wifi: rtw89: coex: Add wifi role info version 101
  wifi: rtw89: coex: Add firmware 0.27.97.X support for RTL8852C

 drivers/net/wireless/realtek/rtw89/coex.c     | 672 ++++++++++++++----
 drivers/net/wireless/realtek/rtw89/coex.h     |   8 +-
 drivers/net/wireless/realtek/rtw89/core.h     | 137 +++-
 drivers/net/wireless/realtek/rtw89/fw.c       | 303 ++++++--
 drivers/net/wireless/realtek/rtw89/fw.h       |  64 ++
 drivers/net/wireless/realtek/rtw89/rtw8851b.c | 128 ++--
 drivers/net/wireless/realtek/rtw89/rtw8852a.c |  62 +-
 drivers/net/wireless/realtek/rtw89/rtw8852b.c |  66 +-
 .../net/wireless/realtek/rtw89/rtw8852bt.c    |  71 +-
 drivers/net/wireless/realtek/rtw89/rtw8852c.c |  62 +-
 drivers/net/wireless/realtek/rtw89/rtw8922a.c |  53 +-
 drivers/net/wireless/realtek/rtw89/rtw8922d.c | 149 ++--
 12 files changed, 1198 insertions(+), 577 deletions(-)


base-commit: 730dbda6dc70d29180eb2a7e9fa36823838bb042
-- 
2.25.1

