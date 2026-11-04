Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793777238;
	b=Yt8fcD0JGlXkgPpdgpqb+G4T3qlGXBZ1MqFFTrHaUWzqjbzY0jbJWevT5Zz/BQcdXL2c
	 O7PgWg+4EYYIgFFWiHb/7tiKuv0JRaNb/mgTv2zs9O7O4g1dZSUCJcQhTQxh7+S9F8IMp
	 dzxx7kiQdEnNzLvMDpaVLy2Ta04NPpAjcq8bCNVb3Cv5FaEFviuIVrGVh/NMJkeK1+kcV
	 ZPg5CPK9lN0QHUycTOAJ3qur/Mpz3QbmwqiaZZrRi6webqXYxFroydMtLINE6afLTqFgf
	 MsYSvRg0in/wEP7SFE/UiXm4qlULr/dXxf/6lpgAPKVNUDmGBardbNIMa0pdTOmbznA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793777238;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	bh=WMtrfMGLVZHWr+J/eWMcwUhyJUIqxXYFkGyILwpY800=;
	b=H12PtV26Wts5sE0wyP4kvF4ZUvvuZO86ijBBR0pajmUQedmuXCEasSE9OkoccIrrrH2c
	 ulbznQgWyvPsGZZlJV6lgs61VKXnVdvVJDhOwliaZ8pua+JGV6rHFGKB19EhyjwUTAb9N
	 nFcNQRWsOFytgN1gRFq2KGvB8Wke5upeeSs1nlo/kU9a8Ml93DUmBuJB5cBPhyvRg3WdM
	 5Mddm06O8bZ6HhF3N25b6tc0L87Cl1b0ERNk9XjD/YQWnRemqG+zIo6HqgqqQqHcNw2FD
	 xjpBO1oI0Di9qADUQsGhGXBMpWMfUhWA4F+7xTSAmP5EbidsZ1eoqXvEV+sSFIE9fbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=ETvczBM3;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F40606A328
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 07:27:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40F40606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=ETvczBM3
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A47RBnpC3800268, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793777231; bh=WMtrfMGLVZHWr+J/eWMcwUhyJUIqxXYFkGyILwpY800=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=ETvczBM3Vu58Ecim2CYo+/ur3F6c+OvqAl+3CNaRIJ8SwnWUmD47FZ/6As6zmeprx
	 TpT9+e6OPS3E6FADYTk1GmRkcChYuARHkEooM2ct070x0lXDrnlSISx8ytR+B/2Uj6
	 5lr84jcCaJQBgnAukZaLw4iFUWYANQ73Md463D1+cIY/mT4JO/rK735ofLiSqCc5yY
	 JQjbisLCeulZQdCVMBIWJnEaePRo2ZSTNJt1kZgYkpUQ6GPYLz4ngn6J9k6KwW7ybZ
	 CbTlR5VSiCrLXU8tK66pS93L4iN6eeSYiUbznCAtC612xle4Yw/JINU2lEY/jn5n1T
	 V/sU1SaAHXQfw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A47RBnpC3800268
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 4 Nov 2026 15:27:11 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 4 Nov 2026 15:27:10 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Wed, 4 Nov 2026 15:27:10 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <charlesl@valvesoftware.com>, <sabae@valvesoftware.com>,
	<kevin_yang@realtek.com>, <wenjie.tsai@realtek.com>
Subject: [PATCH rtw-next v3 0/2] wifi: rtw89: add regulatory domain learning by firmware
Date: Wed, 4 Nov 2026 15:27:08 +0800
Message-ID: <20261104072710.48560-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

The regulatory learning is added to determine operating domain by firmware.
With determined regulatory, it will change to a non-worldwide and become
possible to access specific channels such as 6GHz channels to get better
user experience.

v3:
 - return -EAGAIN to scan request while learning is ongoing

v2:
 - update backoff time to prevent busy retry for the environment
   where AP doesn't advertise country IE.

Johnson Tsai (1):
  wifi: rtw89: add firmware-assisted regulatory domain learning

Zong-Zhe Yang (1):
  wifi: rtw89: debug: support to disable regd learn

 drivers/net/wireless/realtek/rtw89/chan.h     |   1 +
 drivers/net/wireless/realtek/rtw89/core.c     |  12 +
 drivers/net/wireless/realtek/rtw89/core.h     |  22 ++
 drivers/net/wireless/realtek/rtw89/debug.c    |   1 +
 drivers/net/wireless/realtek/rtw89/fw.c       |  43 +++
 drivers/net/wireless/realtek/rtw89/fw.h       |  29 ++
 drivers/net/wireless/realtek/rtw89/mac.c      |  69 +++++
 drivers/net/wireless/realtek/rtw89/mac.h      |   1 +
 drivers/net/wireless/realtek/rtw89/mac80211.c |  32 ++-
 drivers/net/wireless/realtek/rtw89/pci.c      |   1 +
 drivers/net/wireless/realtek/rtw89/ps.h       |   5 +-
 drivers/net/wireless/realtek/rtw89/regd.c     | 262 ++++++++++++++++++
 drivers/net/wireless/realtek/rtw89/ser.c      |   1 +
 13 files changed, 475 insertions(+), 4 deletions(-)


base-commit: dc16902cad9c6b08df9395a510c7be44fbab545d
-- 
2.25.1

