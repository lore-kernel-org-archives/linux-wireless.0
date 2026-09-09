Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D58348C7B
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 07:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788937235; cv=none; b=EluOG2vffAKOskV8Y1NEU0OJ6nKkdmfEwzPHnJJiKXMiIPYtQlxUr+IN2+n+HD38GNwUGD5zyldRwsyja5hpkyeR/LsuvjycxnjiWTEq8uo2QVUOPSOFUPtHZnR84v9GIJxtSXnFpxNID4dcdVb5Su2aX+Nb0hqKURhA3T4f9zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788937235; c=relaxed/simple;
	bh=wG4zMssKXRBQgSRDNJc0NuwXBK29OLIWuvXNrSwZZNI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=F0NruQ1x2vkqjeI/QVjDJjp/jr2s3XN5KmxsagTPAZ3mz+QNnPbtZ2FHVjJ7+gcJQvtD3FRuqVJPuNlVtb0iHZzFs6d438/IkPrcaxi3mI1iWLb1m00yDKO2q1nI3lVGjSvnAm8xpRA1F/YDzFCOVT42qOwZNoy7cYhace1YCfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=XVbb9r/e; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="XVbb9r/e"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68970T3I0355950, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788937230; bh=WSFRFXwK/xYIwgM1tkS5FcxsQjWjCQq9nhozSKciqFE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=XVbb9r/eX/nieOsxQ26b3EB5rr0/C89JJ/4iSDLDtEJitteoFBCTg8Lu4s4dRDR1J
	 gNEa9qKqFq2oogCL7Cqq0ElvL/SxOdwEEGWJq4z1Ae7W9mZGZ50XDwC4MnhTlwjY/j
	 62fKYX0xEyiweRyxmuV3719MAU1AVgyxPbtWAgX6wrSGdpoa/PE46N1IoMiDxU9SRR
	 EuVkaPgJr1ljMlD+C0XQ0i9GQ0BY0hqsY+g/F6i/66eIgRQHhNZYmHkgoqcuujqcuD
	 D5SvV72O6YuIP0j2nV/h/x/fwNqQzN4hTl59iFOHCcMxA4wB9ZVmyk0t3oDNFQjU6f
	 4xsDJ16YJYd3g==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68970T3I0355950
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2026 15:00:30 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 9 Sep 2026 15:00:27 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 9 Sep 2026 15:00:26 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 9 Sep 2026 15:00:26 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <dian_syuan0116@realtek.com>, <echuang@realtek.com>,
	<phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 00/15] wifi: rtw89: correct MLO behavior, fix Coverity issues, and update hardware settings
Date: Wed, 9 Sep 2026 14:59:49 +0800
Message-ID: <20260909070004.35353-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

The first patch is to consider AMSDU off as a factor to lower latency.

Patches 2/15 - 4/15 are to correct MLO behavior.

Patches 5/15 - 8/15 are to fix Coverity issues.

Others are to update firmware format and hardware settings according to
firmware development and update from internal driver.

Dian-Syuan Yang (1):
  wifi: rtw89: 8922d: update BA cam format to G7

Eric Huang (2):
  wifi: rtw89: 8922d: add extra data to PS H2C
  wifi: rtw89: phy: correct PHY-1 EDCCA report register access

Ping-Ke Shih (5):
  wifi: rtw89: consider sta maximum AMSDU subframes number to decide TX
    work waiting
  wifi: rtw89: mac: change beamformee CSI direct forward to CMAC_TXDMA
  wifi: rtw89: fw: extend ch_info format of hw_scan to v2
  wifi: rtw89: 8851b: rfk: set DCK start and delay time
  wifi: rtw89: 8852b: update default value for ANA SWR

Po-Hao Huang (3):
  wifi: rtw89: mlo: update link id to FW upon connection
  Revert "wifi: rtw89: fix unable to receive probe responses under MLO
    connection"
  wifi: rtw89: modify active scan rule for 6GHz band

Zong-Zhe Yang (4):
  wifi: rtw89: fix ctrl_sco_cck for Wi-Fi 7
  wifi: rtw89: 8852a: prevent potential OOB in ctrl_sco_cck
  wifi: rtw89: fw: cmd_ofld_flush always reset counter
  wifi: rtw89: explicitly declare TX queue flags by DECLARE_BITMAP()

 drivers/net/wireless/realtek/rtw89/core.c     |  36 ++--
 drivers/net/wireless/realtek/rtw89/core.h     |   8 +-
 drivers/net/wireless/realtek/rtw89/fw.c       | 173 ++++++++++++++++--
 drivers/net/wireless/realtek/rtw89/fw.h       |  49 ++++-
 drivers/net/wireless/realtek/rtw89/mac.c      |   3 +-
 drivers/net/wireless/realtek/rtw89/mac80211.c |   4 +-
 drivers/net/wireless/realtek/rtw89/mac_be.c   |   3 +
 drivers/net/wireless/realtek/rtw89/phy.c      |  25 ++-
 drivers/net/wireless/realtek/rtw89/reg.h      |  22 ++-
 .../realtek/rtw89/rtw8851b_rfk_table.c        |   3 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a.c |   8 +
 drivers/net/wireless/realtek/rtw89/rtw8852b.c |   5 +-
 drivers/net/wireless/realtek/rtw89/rtw8922a.c |   2 +-
 drivers/net/wireless/realtek/rtw89/rtw8922d.c |   8 +-
 14 files changed, 284 insertions(+), 65 deletions(-)


base-commit: f71dd599a98182d6bc34dce39977f928068ecd64
-- 
2.25.1

