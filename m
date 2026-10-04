Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395353AA9EF
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 03:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791085570; cv=none; b=XsV5gHeVvhGnmaSx3W6PwoJCdPjyImuBSPPan70MCMcQ5j3Sjsao8e5bSQ5krBOIqI7MAm8eRE7/UC55cTsnOlIGJZ9XAhPIPYNb5jECIeTHjXr+01lA1dXBy1Irj3dottxTRWZIiUD7ZhZjtx3Ssbfg7vpGjT4uRJHj81/aYLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791085570; c=relaxed/simple;
	bh=nFnjqy+luD61nzIYSHZgy06kVxoUCCFfUXHWyzd3h8c=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qjeI2hRaiSZ103GRKvaRdED2j0GIIg4P5v5itCVUR3Db814PJysXAJXu8LhbXMROldRItJWKjZCtFDVixuBSeUry/GsbNpJtNCwLB2eBw24Ga3lPDXJz5Zv6O1T1PnTsd+48uRc0k5bkyILXMc6V09XTOrvsklL9s72QeUKpE/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=jJL542EE; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="jJL542EE"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6943k5Zf9829246, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791085565; bh=mFlcUfCkP4CBE3dw/8YsAq9WKJ8+Dat8ixcfpVBxVmI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=jJL542EEKfWpaWkS8MDfYyGvEHDIFOfH1u8Cy/TDQkJ7J48QwaGvKCuhv+yNRPoYq
	 fJPDls7G3KXXBO4OS/J9pkkHziVbKb5w5Jq9K4+cujKrL9aZaPUkNsDxSLvzIej8Ng
	 6XPyt9BvNvFMRLsJet49LzpOdvcxIsKYiU3oWMKnRNdykR0SsX9M16aPOnWxepdEDg
	 x0V78tMkA/eNp3oeFUtS3sz18WVvkVauTe6+hBLVCAOhe30S+qULzFcfrWDf9Ce87N
	 NR/9aloWx1u3yD2b2PmKwqM0U7kwBuTBeFnF8Sk8JcfCIMgvKP12ubxYbuEkBomXKS
	 wiLDaL2fIWrrg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6943k5Zf9829246
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Sun, 4 Oct 2026 11:46:05 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 11:46:05 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Sun, 4 Oct 2026 11:46:05 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 00/15] wifi: rtw89: coex: update BT-coexistence along changes of newer firmware
Date: Sun, 4 Oct 2026 11:45:05 +0800
Message-ID: <20261004034520.33695-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

The BT-coexsitence in firmware is continuous to develop to support
dual BT feature. To cowork with the feature, more conditions are
considered in driver side. Add them accordingly.

Ching-Te Ku (15):
  wifi: rtw89: coex: fix RF band check in _set_rf_trx_para() and its
    propagation
  wifi: rtw89: coex: track per-HW-band WL role fields with arrays
  wifi: rtw89: coex: show per-HW-band MLO state in WL status dump
  wifi: rtw89: coex: add outsrc-set-info v7 for BT SPDT state
  wifi: rtw89: coex: compute WL/BT cross-talk interference maps
  wifi: rtw89: coex: add 1SS MIMO-PS decision for dual-BT CIS
  wifi: rtw89: coex: add firmware 0.35.119.3 support for RTL8922A/D
  wifi: rtw89: coex: raise default BT TX power to 10 dBm
  wifi: rtw89: coex: bind the RF band in use while WL is doing RFK
  wifi: rtw89: coex: store BT TX power per device and per RF band
  wifi: rtw89: coex: set the WL/BT antenna map on shared-antenna chips
  wifi: rtw89: coex: use the right switch-type enum on RTL8922D
  wifi: rtw89: phy: Implement API to control BTG to turn on/off BT TX/RX
  wifi: rtw89: coex: turn BT TX/RX on and off through the BTG control
  wifi: rtw89: coex: set rf_combination in _update_wl_mlo_info()

 drivers/net/wireless/realtek/rtw89/coex.c     | 736 +++++++++++++++---
 drivers/net/wireless/realtek/rtw89/core.h     |  79 +-
 drivers/net/wireless/realtek/rtw89/fw.c       | 191 ++++-
 drivers/net/wireless/realtek/rtw89/fw.h       |  12 +
 drivers/net/wireless/realtek/rtw89/phy.h      |  12 +
 drivers/net/wireless/realtek/rtw89/phy_be.c   |  18 +
 drivers/net/wireless/realtek/rtw89/reg.h      |   2 +
 drivers/net/wireless/realtek/rtw89/rtw8851b.c |   5 +
 drivers/net/wireless/realtek/rtw89/rtw8852a.c |   5 +
 drivers/net/wireless/realtek/rtw89/rtw8852b.c |   5 +
 .../net/wireless/realtek/rtw89/rtw8852bt.c    |   6 +
 drivers/net/wireless/realtek/rtw89/rtw8852c.c |   5 +
 drivers/net/wireless/realtek/rtw89/rtw8922a.c |   2 +-
 drivers/net/wireless/realtek/rtw89/rtw8922d.c |   3 +-
 14 files changed, 936 insertions(+), 145 deletions(-)


base-commit: 7cde94dab0e74434ccc0a387d7ad373fb3becda0
-- 
2.25.1

