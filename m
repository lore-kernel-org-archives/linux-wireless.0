Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9159361DD0
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 05:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327020; cv=none; b=qjOVItf4dD7bK24zJ3RojVkUYombHQ944ZjcgObnScYvCW2lY2+fDWPCEVdxJhBtmN9VyYj7pqMI/g5xjBZ93y6FIV6NI4osLnuXuZf915LAJ/tkuoAdW/2MiLHEhgosrms+P8qhAcn7JUheFkcOaSA7brTQZVeOkQgu3fhhMRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327020; c=relaxed/simple;
	bh=xwMoixh/6g9WnjfmkX72Ufl2eoJwf8ID7ySuGKDFiTE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fDMhp8L4lUtcYl2/EynMpKB2j4R53MJ5NEH3lUNoTDdNHY9hMF4kz6P+1rWMQgPGuq2N3sqIGT+1in3Hws15f8EoqOMCBPXNRMQ+niON9X5Jy8mKufTzwlbCHzUxoI91JavOaWrE5FZUPv999g1Fgn1oa+q6FQQbaPSXy0LKEV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=a1PPkkaj; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="a1PPkkaj"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6825UFZ702368291, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788327015; bh=zNCHOe9WQycjo7I0PG5WNDhMTbmEtjAM10ZZbkJ3N68=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=a1PPkkajSlZUhHgUpOA5xWvCxNMUgXSD+PaDVLQgwkWrU5T9csWhN9STrlRA95o41
	 uIgQbLL+HmE6lUzB3WqKQQVOLT8ahkXo1j3FF2rX9CgHWJn+Yu6wCItKQw9xohHCam
	 ZgMUoY+mi7/4OlFVrzkLuIyhghk1wH10P8j9fdnf+XksQJRkKn+TyrdOucvazETeqp
	 N6iNzIsEGwSTycfT1kkqeaSs3Vj1NhVXXQqppYye37lYVltMRuKbXxKHQONNfENY+N
	 3JLA6e+tBJr43zVLpN9T7imjhlCx9vXLJuwCd2DM1lp4brJApWhI9wVymtUJcVu+Dr
	 dREXMqGMfbOLA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6825UFZ702368291
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 2 Sep 2026 13:30:15 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 13:30:15 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 13:30:14 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 2 Sep 2026 13:30:14 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <owen.hsiao@realtek.com>, <echuang@realtek.com>,
	<henchy.chen@realtek.com>, <phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next v2 00/14] wifi: rtw89: update RTL8922D capabilities and settings, and enable P2P device
Date: Wed, 2 Sep 2026 13:29:44 +0800
Message-ID: <20260902052958.50371-1-pkshih@realtek.com>
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

v2:
 - patch 1/14: correct PID from 0x892D to 0x895D

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


base-commit: 81510c3d6f2199889a4a936d8cf8b9e05911b10e
-- 
2.25.1

