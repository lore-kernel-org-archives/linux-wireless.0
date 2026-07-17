Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC952E6CA8
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 06:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784269218; cv=none; b=kSWzmhcbqGjjYZzmRxWQPz08emsTGD3TQPBdPQugr2puW6u281sJ4CwD0Pqj1EjKh7fkD90Hc/M+E5wCWJ2qp4hYxQOe3nsVlhwGm7A3DIGikJNXSqKBfd4ois8SnkBKi17W/6gzvEF6//IITKtrMWPhAeD/0CrWEurUPYQLBBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784269218; c=relaxed/simple;
	bh=yhHQU20caBlNKLxL5/tA8G1cwQzBFTdtRDQPKnFjH2o=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pbzBgkzTcPZjoVsJV17iDxkUlXF6H1J22BfDG02FPr8Nd6dONNb2gVAKwK91FF+DrCfW9LZcpAd2N93NnrAr6omGbAYDxxaZeP4LVnSCgBIhd/nbP61cxQU9NmcTZxIgOrhI27NdVe/xDaM7cU+CqIoJ79lhIdUX/VRhhaYDHy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=giwBJsOU; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="giwBJsOU"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66H6KDYe84163359, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784269213; bh=Fxz1yp86eZ/3n80Nn378G36P5sZxY1QhFEzpwIYFDfQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=giwBJsOUs0B3jaHgGhrw1jmpqq8Iq6qp9JilgXJGBYo3bpUYIjxcsuufFC2wqBful
	 WiCIseksb8sN3qxTwPnn0KNUNnigCkAxdIP8BI8a8cUNd7h2VStevx2ZvWQn/PoRhO
	 zICnUtry6gB7M86SkB9bRtsum0Vq5SjcJJCeOOxr5oJBFdeO8NeCRncgsWYtrbsKJc
	 aT54TSEPqXqf0xwd794yD4qhD3qfRMAe6KGnbK97+mT+2AuGcs7vuQBd2VQ1dCnoUK
	 lPV3plInSKTLPj6wT7nE/r0wO2RJQ1u1pbzi5NeJJNJf6qAyAe04DE6Gnrk86AJg9i
	 v1olKgRV+/New==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66H6KDYe84163359
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:20:13 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 14:20:13 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 17 Jul 2026 14:20:13 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <sc.lee@realtek.com>, <wenjie.tsai@realtek.com>
Subject: [PATCH rtw-next 0/9] wifi: rtw89: add LED support and update some random settings
Date: Fri, 17 Jul 2026 14:19:01 +0800
Message-ID: <20260717061910.54466-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

First two patches are to add LED support, including mono-/multi-color LED.
All chips can support mono-color LED triggered by association state, and
the multicolor LED is limited to board design according to VID/PID.

Patch 3 is to disable 2 GHz band support, which a specific board doesn't
want this by design.

Patches 4-5 are changes of RF TX IQ calibration, which has format and
flow changes.

Others are random registers change according to internal update.

Chih-Kang Chang (2):
  wifi: rtw89: rfk: update TXIQK H2C command format to v1
  wifi: rtw89: 8922d: bypass TXIQK when scan

David Lee (1):
  wifi: rtw89: 8852cu: add quirk to disable 2.4 GHz band

Johnson Tsai (2):
  wifi: rtw89: add LED support to reflect the wireless association
    status
  wifi: rtw89: add multicolor LED support for RTL8852CU valve board

Ping-Ke Shih (4):
  wifi: rtw89: wow: extend timeout unit to avoid SER false alarm
  wifi: rtw89: pci: set PCIe maximum TS1 for RTL8922DE
  wifi: rtw89: 8922d: reduce IO in power-on function
  wifi: rtw89: phy: set CFR to manual mode for some 2GHz channels

 drivers/net/wireless/realtek/rtw89/Kconfig    |  14 ++
 drivers/net/wireless/realtek/rtw89/Makefile   |   2 +
 drivers/net/wireless/realtek/rtw89/core.c     |   7 +
 drivers/net/wireless/realtek/rtw89/core.h     |  38 +++++
 drivers/net/wireless/realtek/rtw89/debug.h    |   1 +
 drivers/net/wireless/realtek/rtw89/fw.c       |  35 +++--
 drivers/net/wireless/realtek/rtw89/fw.h       |   7 +-
 drivers/net/wireless/realtek/rtw89/led.c      | 139 ++++++++++++++++++
 drivers/net/wireless/realtek/rtw89/led.h      |  37 +++++
 drivers/net/wireless/realtek/rtw89/led_mc.c   |  81 ++++++++++
 drivers/net/wireless/realtek/rtw89/pci.h      |   3 +-
 drivers/net/wireless/realtek/rtw89/pci_be.c   |  11 +-
 drivers/net/wireless/realtek/rtw89/phy_be.c   |   8 +-
 drivers/net/wireless/realtek/rtw89/reg.h      |  12 ++
 .../net/wireless/realtek/rtw89/rtw8851be.c    |   1 +
 .../net/wireless/realtek/rtw89/rtw8851bu.c    |   1 +
 .../net/wireless/realtek/rtw89/rtw8852ae.c    |   1 +
 .../net/wireless/realtek/rtw89/rtw8852au.c    |   1 +
 .../net/wireless/realtek/rtw89/rtw8852be.c    |   1 +
 .../net/wireless/realtek/rtw89/rtw8852bte.c   |   1 +
 .../net/wireless/realtek/rtw89/rtw8852bu.c    |   1 +
 .../net/wireless/realtek/rtw89/rtw8852ce.c    |   1 +
 .../net/wireless/realtek/rtw89/rtw8852cu.c    |  57 ++++++-
 .../net/wireless/realtek/rtw89/rtw8922ae.c    |   2 +
 .../net/wireless/realtek/rtw89/rtw8922au.c    |   1 +
 drivers/net/wireless/realtek/rtw89/rtw8922d.c |  82 +++++++++--
 .../net/wireless/realtek/rtw89/rtw8922de.c    |   2 +
 27 files changed, 521 insertions(+), 26 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtw89/led.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/led.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/led_mc.c


base-commit: 730dbda6dc70d29180eb2a7e9fa36823838bb042
-- 
2.25.1

