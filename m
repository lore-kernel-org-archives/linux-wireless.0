Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F209932BF4B
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785391350; cv=none; b=ruroO9Q9Nb2lHYdsT8NAo9VPrHYv5iSImnTGEQ6es6UqUO0zs1gFfXfpJVriRGutoMzxG2QW97/nVpS6hqnfszsc5JrEtG+d2D7BbroFSuEjZ33/s+n001zFaKgNDYn8A2FKDZ1CGGoCxxWVt22ntBd0jv+HkbJUsQIYcAjPsUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785391350; c=relaxed/simple;
	bh=5sb+TKZXLqzfnerzvRBRmsSimdNHe0SVI1xfZZhg9B4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IxA+nAOoK4Ym4mq/6chYnpzxsnFbLOAGO6AY2jcZ910tivYUTZhdOcA3ytT0gTOB10n4Oti1lswKN5a07DX8KCNF2HrlMln0APdU3kYBeXGxyOgfia3PF/LFA5ZjbAMZWH7B/mA9nPUO6cpgBObVOtrI9b8SFS59t95DszXwOsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=TqQiSzNa; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="TqQiSzNa"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66U62M2f8985833, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785391342; bh=ACnOeQSJsnZL3vmMPx/cXqC00hUKY5y6esv8Jy1Jtx0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=TqQiSzNazLvAkiQxR+yp3PRlfrPFToHMk6R58WdlfqN5savkAUGRRjfBuCsGW4Fnp
	 o1x5yEo72Xwp9/ti8ADKS/s8jgFLKI4NDjPCQqk1aaHHIrQ6T0fK8q2HN3tLjEKHaE
	 zKnywmZShP+0aq0Fv0PtRihq7ffaEYy0EIUjYtYwx5Sb/zPVdSdfmoFFmDG+X1+F43
	 ItTKFDvr+eRzbKADZbXyOdbEKOOZcioEs+B9nqTd7FvEh/4Bnr8USiPCiWVgUFI/tG
	 4UCeG/2Z6LM41FSpoeau3EBPTNQSGSghHI5WlTmXTnNIZIiLxvyaTdtPeM3KysT4R4
	 s6oGpNLwvRBCA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66U62M2f8985833
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 14:02:22 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 30 Jul 2026 14:02:22 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 30 Jul 2026 14:02:22 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Thu, 30 Jul 2026 14:02:22 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 0/7] wifi: rtw89: 8922d: fix and cleanup coex code and enable RTL8922DE
Date: Thu, 30 Jul 2026 14:02:13 +0800
Message-ID: <20260730060220.55844-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

Update the final BT-coexistence patchset needed by RTL8922DE, so we
can enable RTL8922DE eventually.

Ching-Te Ku (6):
  wifi: rtw89: coex: Fix Bluetooth link weight not updated on profile
    change
  wifi: rtw89: coex: Fix BT-info parsing for 5/6 GHz band & dual
    Bluetooth
  wifi: rtw89: coex: Clear BT link weight when BT is disabled
  wifi: rtw89: coex: Change Wi-Fi link_mode_v0 translating timing
  wifi: rtw89: coex: Port _update_bt_ctrl_lps() for BT profile-based LPS
    control
  wifi: rtw89: coex: Update Wi-Fi/Bluetooth coexistence version to
    9.24.1

Ping-Ke Shih (1):
  wifi: rtw89: 8922d: enable Makefile and Kconfig for RTL8922DE

 drivers/net/wireless/realtek/rtw89/Kconfig  |  15 +
 drivers/net/wireless/realtek/rtw89/Makefile |   7 +
 drivers/net/wireless/realtek/rtw89/coex.c   | 383 +++++++++++---------
 drivers/net/wireless/realtek/rtw89/core.h   |   4 +-
 4 files changed, 234 insertions(+), 175 deletions(-)


base-commit: 9f2948010764d708bda27369d09ce6f194abe8e3
-- 
2.25.1

