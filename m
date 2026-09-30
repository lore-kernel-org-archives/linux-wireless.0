Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B063C10BF
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 06:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790750774; cv=none; b=KN5G9AZpTgrGITHolEidIF8HTADkzQ3GY60rV4VifuVxqrs3iL/mfKO5OTZxMizgN2frjo8ZeA/Ae5GKTtMq+cEtN/1xXHmb30pAyv1FkH9B0bMDQghk/ZaxIpCWz1QG5BjXzskKK7tg8J72O3e0eYti6qYRfC0DoVYTHbgLSkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790750774; c=relaxed/simple;
	bh=Ls012yEKTfreqK5BlJkxFq/MQwq6U5Vhkb5ztb1v+Uo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UKidRQX+jARqQIIbMVAeRIooFnjQw9Lam0gxJ8wp5lEvKrXKl4/0BktoM1phq3WjunGiUBdPL5plLvfw7kOyLAIvZ0VjIQ5NjxLNiOlW048YUWdOfWG+0RcYICqjUOCZdFjvEonxQ/hTw/HLpmKSJPBIJn1o3Ead2KGnmYJRtlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=ZJfNBOqn; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="ZJfNBOqn"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68U6k7MS11882922, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790750767; bh=9jHMDSmh5jUkrER2kfpYe3b8KxSZXU4U23eFj5mp6sw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=ZJfNBOqntYVlyUNJy2ATJVBnm2hDUdrpjaJ0NZ4KKNjQzJo6XlhNIxe9ZbdQ7q53c
	 Cya8UKZ2eupzeZflbgGphZ9qWHdavYzjWAPzw2Ymq9rLrDNSrVkCCO6YBY4eXUjr6J
	 itm+KW1WWw+CNU9VGe6/2QA7/S735D3/U7yMAlRsyw91xEoWONGpx7fE4cL4dayvl3
	 /E+EY/vd3w8sHWfcilTxsjqf1Sn9f30a85+Reykqv+zsNe0FWbdlcs5Ayi5tTO+xGh
	 dbZOpvLvCa+ZKS9MUb7Fys4f9EuB4TwYbuptm6kMr8XNeDInfUW7EJB+cAuva09+5d
	 W2o4+aNVBWavA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68U6k7MS11882922
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 14:46:07 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 14:46:08 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 14:46:05 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 30 Sep 2026 14:46:05 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <echuang@realtek.com>,
	<wenjie.tsai@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 0/6] wifi: rtw89: some cleanups and improvements
Date: Wed, 30 Sep 2026 14:45:18 +0800
Message-ID: <20260930064524.39403-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

First patch is to provide MLO info to assist firmware to configure
hardware when it goes into WoWLAN mode.

Patches 2-4 are cleanups. No change logic at all.

Patch 5 is to write a version from 16 to 32 bits as helper for debug.

Patch 6 improve IO time for USB devices.

Chih-Kang Chang (1):
  wifi: rtw89: ps: send H2C command related to MLO info when FWIPS

Eric Huang (1):
  wifi: rtw89: phy: write full data for BB gain table type 15

Johnson Tsai (1):
  wifi: rtw89: pack I/O during RF nctl init to reduce execution time

Zong-Zhe Yang (3):
  wifi: rtw89: pci: fix typo of "deliver"
  wifi: rtw89: rx: refine skb/desc naming to improve readability
  wifi: rtw89: rx: no need to cancel 6 GHz probe per vif

 drivers/net/wireless/realtek/rtw89/core.c   | 101 ++++++++++----------
 drivers/net/wireless/realtek/rtw89/fw.h     |  11 +++
 drivers/net/wireless/realtek/rtw89/pci.c    |  18 ++--
 drivers/net/wireless/realtek/rtw89/pci.h    |   4 +-
 drivers/net/wireless/realtek/rtw89/phy.c    |   3 +
 drivers/net/wireless/realtek/rtw89/phy_be.c |   2 +-
 drivers/net/wireless/realtek/rtw89/ps.c     |   7 +-
 drivers/net/wireless/realtek/rtw89/wow.c    |   6 +-
 8 files changed, 82 insertions(+), 70 deletions(-)


base-commit: 7cde94dab0e74434ccc0a387d7ad373fb3becda0
-- 
2.25.1

