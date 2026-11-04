Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793784622;
	b=3iI9ORjuQsIS2XtNNdgniOjz5MxYIwdx80+PQWgdKCF9GLneAuZx1IpyH0R/mgfV4zi3
	 bYcvtQzV2D283paT9zu2a4jjd7ExOV5ZquJauZi4QE9qhAwO4kMx39LIHxsSpd2+Vpoo1
	 eRYrjO8RbKBAEuc7kD50YgT5iTLnZadJOhCxUrnocvMrsau7pbwjdak5f6tKRK8xRVcL6
	 MQHViZUsC6FZZgDz2vQptYI+BkOz+l0UZIXe/pNJ2MQbiMtdnCsuu1ZiOIFiPk4X3/pli
	 TM/3QAQTJT+KSmfxdPFNDULv90SL8pOHaC2c56Zbz5xz3EBiWLpQa6EcT/AQrqR/G5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793784622;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	bh=uigoz2UZpfJh9gEcQ+iDCBFyK3Y2vDM0ZDZU6uhClHQ=;
	b=jttZgC0LI6cKTrUuXV3wPD7snP/ZLAojkbnN4efuOtTTAzZ55DkjCzquBgZ9ykUUziur
	 NJM+NMyv6b6tKu/csn7nlTwNhYxulJXA7rtER1YUp1sgKLfdLcvrg10iI+sifUXtPMECS
	 k1SZIxnYuYPivqyk+mTf1hLx6oA/RBaULz04bBVhZUmgd7T3T6Wu/zGZyjhgi1CDcR5yR
	 3pOdRUOSniCdWVE8y6QHqJNcOSXorvIC294DD0CX4gGZNBJK6hKxw+wlWlZAKhG4x20Pv
	 HrCM7unkw7vrBAA05Uak+f4kN3VZDmwt+j3HQvFZrkYf8Uf+6EyQ+vo8Gf5ftdc45/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=TEwBY8t2;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D1F606A32C
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 09:30:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38D1F606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=TEwBY8t2
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A49U9yP43873254, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793784610; bh=uigoz2UZpfJh9gEcQ+iDCBFyK3Y2vDM0ZDZU6uhClHQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=TEwBY8t2fSwKMEj7VABv7nF7cG9aSfMqubSOeZvUIXQCSt1urA9ohvVPj2Ts/820R
	 +YuIq2K2SsLbPlaBrBRPX/h5dadU4QBnOnjpVmCgZ1sQDOlfmirdFcZkSZyqT5Pgy+
	 J783JDqgRDLJESb1ERYA28eKNoNe5fB5gdh+BHgtsLwrcry7iT9DxI1tDMSh332mFl
	 kTy8hdMRBNX8QIWeUPCNjU3bk6BBn1/7Zl5iV2auJksX3M5a9PS/wm8IlquZZBKzc0
	 WdD8WRjVL6zbg0eWTEbLhXI1OBNwWWqHFg+PfD1QOuXONzP0gdF0dxM+2a0eLo6asG
	 UCVeoZdQlyMbw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A49U9yP43873254
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 4 Nov 2026 17:30:10 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 4 Nov 2026 17:30:10 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 4 Nov 2026 17:30:09 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Wed, 4 Nov 2026 17:30:09 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <charlesl@valvesoftware.com>, <sabae@valvesoftware.com>,
	<kevin_yang@realtek.com>, <wenjie.tsai@realtek.com>
Subject: [PATCH rtw-next v4 0/2] wifi: rtw89: add regulatory domain learning by firmware
Date: Wed, 4 Nov 2026 17:30:06 +0800
Message-ID: <20261104093008.63916-1-pkshih@realtek.com>
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

v4:
 - check list empty of active_list of chan_ctx to trigger learning.

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
 drivers/net/wireless/realtek/rtw89/mac80211.c |  28 +-
 drivers/net/wireless/realtek/rtw89/pci.c      |   1 +
 drivers/net/wireless/realtek/rtw89/ps.h       |   5 +-
 drivers/net/wireless/realtek/rtw89/regd.c     | 262 ++++++++++++++++++
 drivers/net/wireless/realtek/rtw89/ser.c      |   1 +
 drivers/net/wireless/realtek/rtw89/util.h     |   8 +
 14 files changed, 479 insertions(+), 4 deletions(-)


base-commit: dc16902cad9c6b08df9395a510c7be44fbab545d
-- 
2.25.1

