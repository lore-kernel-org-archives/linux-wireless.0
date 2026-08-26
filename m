Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3602399CED
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 06:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787726475; cv=none; b=JKxh7IYa6dr/6ZSqG5Qf8A6iQHSMw8njX5nJG6kMqhAlgJOQiX7uCvw59F/wFO+peOhmEKkzvPODAb0SsZOnZ40ChVFac9SR0vqLlpP4W1MHFymnzrvbqfFs9erDQiTziKNbn18QuMj5FVD8Qu6kdraEo1noaM3oqlOiS+Tr1a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787726475; c=relaxed/simple;
	bh=Vpl149fNj+/VgySysrYREu8IKOMFOAxY/sgeRp5yEh8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BIc/ntB26TNM9unHx0vF5/umIlOP2kwOciNwfmWib35SZIyYm3jHOlHaf+hgcmxF2Cjq3MxBUIiNp6QcameB6cU8fg3jY3CGRp89ylboDh2rin2Xg9+nGnEkbF0jadaA7k/KNphlf9HA6DkwaskRwe2NHiu1kIb0bWNCoRYaEVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=CIYmQpVd; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="CIYmQpVd"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67Q6fAST1352964, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787726470; bh=ZHrLh/MgW7osLaLKRWJfhUrsTpzDlzn8qDJ57hir5BE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=CIYmQpVdb96PJXvYyoRvpAh3rop+JTWhfl0XJn46ktmtskFWVxK1UugKYXp7y8Vv5
	 gO3ldITn3wketUs9aDXqW3kcxBcxDTN9DeCw7vpLSc8UVC28tbFd3ZyHl0br8Pcx/0
	 vSD9HEdRNqlEWFUNuSQenUnRJ7p+z1wffO1zxjlmFQ9covk02MCbWl3Wure0xGLs4H
	 wRvEcHcm0aj0DhrJ02qjRQoSVwwqPwuHqxsjFJTN3/jUmvlcdPfkeN0ryWK0aPs5+W
	 WGvzdoGGQkoDWvDt+V0ghF9b43Wtc0YXR4GV3Co+NGq3A/YYwLEBQp8pX5dbQxxfAV
	 3c4qAByV5/zbA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67Q6fAST1352964
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 14:41:10 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 26 Aug 2026 14:41:10 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 26 Aug 2026 14:41:10 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 26 Aug 2026 14:41:10 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <owen.hsiao@realtek.com>, <echuang@realtek.com>,
	<henchy.chen@realtek.com>, <phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 00/14] wifi: rtw89: update RTL8922D capabilities and settings, and enable P2P device
Date: Wed, 26 Aug 2026 14:40:47 +0800
Message-ID: <20260826064101.58892-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

Patches 1-3 are to enable/disable certain capabilities by specific
application.

Patches 4-10 are to update hardware settings according to internal
development.

Patches 11-14 are to support interface type P2P device, which is necessary
for MLO concurrency.

Chih-Wen Hsiao (1):
  wifi: rtw89: 8922d: disable VCORE for thermal protection by default

Eric Huang (1):
  wifi: rtw89: 8922d: update BB wrapper RFSI ctrl to v4

Hsiao-Yung Chen (2):
  wifi: rtw89: 8922de: add low latency quirk for Valve device
  wifi: rtw89: allow two station interfaces in SCC

Ping-Ke Shih (6):
  wifi: rtw89: 8922d: set BB wrapper settings according to operating
    channel
  wifi: rtw89: 8922d: move conditionally disabled TX shape to common
    flow
  wifi: rtw89: 8922d: update BB wrapper RFSI ctrl to v5
  wifi: rtw89: 8922d: send RFE type to firmware
  wifi: rtw89: 8922d: bypass RX IQK when scan
  wifi: rtw89: 8922d: correct selection of CCK rate circuit

Po-Hao Huang (1):
  wifi: rtw89: add p2p device declaration

Zong-Zhe Yang (3):
  wifi: rtw89: chan: introduce helper and refine active list iteration
  wifi: rtw89: regd: check only active vifs when recalculating 6 GHz
    power type
  wifi: rtw89: skip tracking things when entity is paused

 drivers/net/wireless/realtek/rtw89/chan.c     |  28 ++-
 drivers/net/wireless/realtek/rtw89/chan.h     |   1 +
 drivers/net/wireless/realtek/rtw89/core.c     |  24 +-
 drivers/net/wireless/realtek/rtw89/core.h     |   5 +-
 drivers/net/wireless/realtek/rtw89/debug.c    |   3 +-
 drivers/net/wireless/realtek/rtw89/fw.c       |  46 +++-
 drivers/net/wireless/realtek/rtw89/fw.h       |   7 +
 drivers/net/wireless/realtek/rtw89/phy.c      |   8 +-
 drivers/net/wireless/realtek/rtw89/phy.h      |  20 +-
 drivers/net/wireless/realtek/rtw89/phy_be.c   | 193 +++++++++-----
 drivers/net/wireless/realtek/rtw89/ps.c       |   8 +-
 drivers/net/wireless/realtek/rtw89/reg.h      |   8 +
 drivers/net/wireless/realtek/rtw89/regd.c     |   2 +-
 drivers/net/wireless/realtek/rtw89/rtw8922d.c | 237 +++++++++++-------
 .../net/wireless/realtek/rtw89/rtw8922de.c    |   8 +-
 drivers/net/wireless/realtek/rtw89/util.h     |   4 +
 16 files changed, 419 insertions(+), 183 deletions(-)


base-commit: ca800a9302764c445de0da0e84d2252400a770ee
-- 
2.25.1

