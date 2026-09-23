Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F1E44F540
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 07:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790147680; cv=none; b=MTx6xwzesm17FjjV69BEZIjrE4ofDNrsIGj75DJTGM7ki4XwGErOKnsacN6xFJ/aUaX7PiaUAYG2EY/M0gtBQP5F5pTej42/6xooJwnsNgPEp9Gi7DjgC2rPt0TtGCnQl7ClYvYh/6T9RiV9tNPoVO0ZifynXv0B1v+GU498PhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790147680; c=relaxed/simple;
	bh=nTgOmueCLxPO6ruJuZ4XVe0vtRTbgUuso7h0yVMbExY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=g10JttdBPsmR4XC3kOZbI0FyZ3ILJS5muX0csn1yMfYY9dFDnWboGkQEzgzVz/SkcR8XiyLRX6N+E7luSmYOtfPkJTEsoLu4dRsDZQd3XgG7WY5IdTQusMqjeH8Zkq5UyErriMTKXPmSCvMz+wNsuTqE2YHkCWSj/XC7m+v0oBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=SXmp1nJO; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="SXmp1nJO"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68N7EYxP4132690, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790147675; bh=LD56Yvz7FluNEjfvVLpoxO4Zn8mo4sjc5jP2OPJ6SGI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=SXmp1nJOyrKu6ltQEYio9vOoUTgmoqXA7IqHTfZh1/+63GcNpXxnmvn/0O1iITq0P
	 Smmwja42dFtpdSc8Wcu1ZjvckC/x12vUg+ItivakV/qitvJzSl93gH3uDboHevW0Dw
	 Eaeb/52QczW1y4XKXQPqKoUIcki8HXS8ZQwblHqdJ+9XOh9siSpyTCw1AiMiadXZPW
	 OuQV/S5OetzDUVop5BZcA1olp1EweglmaNk2FNWhSIqsIxyGMIG6B60n5ZIcuLsENo
	 PAJJdkF2Fs/BBGI0SAcExJbJBSHia4v+cmwly6xB9/oQ5EixaNyzWDQP+/0KFrdnIr
	 9ydvp1nfENCNg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68N7EYxP4132690
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 15:14:35 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 15:14:35 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 15:14:35 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 23 Sep 2026 15:14:35 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 0/7] wifi: rtw89: coex: update to support newer firmware especially RTL8852C
Date: Wed, 23 Sep 2026 15:13:47 +0800
Message-ID: <20260923071354.50864-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

Patches to support newer firmware formats, especially for RTL8852C, and
use IO pack to offload IO to firmware to speed initialization.

Ching-Te Ku (6):
  wifi: rtw89: coex: log FCX report version mismatch without dropping
  wifi: rtw89: coex: add fbtc_rpt_ctrl v205 report struct and handling
  wifi: rtw89: coex: Add firmware 0.27.130.1 support for RTL8852C
  wifi: rtw89: coex: fix BT scoreboard update for non-C2H paths
  wifi: rtw89: coex: offload 8852C IO writes via firmware CMD pack
    region
  wifi: rtw89: coex: batch PTA init with masked IO offload

Zong-Zhe Yang (1):
  wifi: rtw89: add instance of IO ops for (un)pack and [um]delay

 drivers/net/wireless/realtek/rtw89/coex.c     | 236 +++++++++++++++++-
 drivers/net/wireless/realtek/rtw89/core.h     | 170 ++++++++++---
 drivers/net/wireless/realtek/rtw89/fw.c       | 122 ++++++++-
 drivers/net/wireless/realtek/rtw89/fw.h       |   8 +-
 drivers/net/wireless/realtek/rtw89/rtw8852c.c |  12 +
 5 files changed, 491 insertions(+), 57 deletions(-)


base-commit: 2f77c66694108785a1f6ae6c5de06453e7f7a91f
-- 
2.25.1

