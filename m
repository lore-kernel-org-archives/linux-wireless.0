Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793692403;
	b=tFQvOuP5aOFu7mviYU61eFm+OY5TC8WMag+hL2pwDmYozzm1bz1UlyAHKz/WARate2cu
	 YKiKiOqBtWRChJO/bo3hDUheMC6LUN13PR6Y8Ns1F45YZ6zYxXJt4KSKbsLCuWfweXS8x
	 6QApgahcUUo6bmNtOMEf0sXNvWarbJYL4IHo+MBa/LCvagUONCHcaghe1sdjvivWA5WD1
	 jmNLc9UZwZItxQfYd/9TpJzaw6/bi6r773nINZ1an9Ya9wYSlbvjbOgaEbvB1U8CzPRgB
	 45Da/STQ/+Gs6NyyQ7KhScj8pKmwAuFNAVjzNUL6i24uSEaqfNyaHX31WQY3M4DJC0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793692403;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	bh=4oOMEkqcocH9uhdxgFo41d8tMrjNTS7kSzWIOwqXEP8=;
	b=ITptAbOq5dehSWBLMB6+eaph5bXpdwXwbZEIQcPSm6woc2a3ZG6raUF33Gg1u5cJzLty
	 riDmyGy6a5Ggk6wqpmx27HMS4xmbAIr1FaVgOe3FTNDbuRypawN2uqxTQxnZwBqvvkXyi
	 YOMkQXITRp7BAPGTQ23dn+KhZ6SzileIqrf40sjBbjgmrKK7X4qyQBYJuMuDnK2Xb4BMI
	 s0cLhOgBJyx1iWa+T+z0evbEy/yoOeze3+u7TYZcWNPU2zKu77Y6oQuVc1eE5IkmIu6DN
	 O06GjABO8pBSTICidSDUB31dKtjmM09Co2v98QmsklpjxjyEMR8yuT+htownfSlzMgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=K6YZrGjY;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485E1606A329
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 07:53:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 485E1606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=K6YZrGjY
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A37rJc252864291, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793692400; bh=4oOMEkqcocH9uhdxgFo41d8tMrjNTS7kSzWIOwqXEP8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=K6YZrGjYPRwZmgGWRBD8j3j7nRVG50szRPpXwfHOSVRDRTP0/bStBsXjJfIVyWJRI
	 1R7c9Tz83oAbR+Ekn0NXGuieB/dzUKF29rLMb/jvCNGy/UnrjYK+pPyS/24pJK44/t
	 Tb6bWhlngN723O94pmsQcZ77YBMXkPGosDu+EF/ZAhPOoCmrmruRrqbmDQkmC/AdHO
	 av52dmlEZmvUxu+1NKEIqfg0px+i9UyKUt7e9lP6biTA09znUuN6e5728V8MsR5XG6
	 gX1XAoO2VUYZxDLQ2XQIEcWbC75OK+FvqDQihoPz9rWddxCH5yJexai/WmIfClINXE
	 n/69s0i5P+nXA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A37rJc252864291
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Tue, 3 Nov 2026 15:53:19 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 15:53:19 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 15:53:19 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 15:53:19 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <timlee@realtek.com>
Subject: [PATCH rtw-next 0/2] wifi: rtw89: improve latency and tolerance for power-save
Date: Tue, 3 Nov 2026 15:52:53 +0800
Message-ID: <20261103075255.56487-1-pkshih@realtek.com>
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

Improve latency while entering power-save by first patch for verified chips
RTL8852B/RTL8852BT, and second patch is to improve rules for firmware awake
period. Both can improve user experience.

Chin-Yen Lee (2):
  wifi: rtw89: enable low-latency power-save optimization for
    RTL8852B/RTL8852BT
  wifi: rtw89: avoid premature power save entry for buffered traffic

 drivers/net/wireless/realtek/rtw89/core.c     |  2 +-
 drivers/net/wireless/realtek/rtw89/core.h     |  1 +
 drivers/net/wireless/realtek/rtw89/fw.c       | 40 +++++++++++++++++++
 drivers/net/wireless/realtek/rtw89/fw.h       | 15 +++++++
 drivers/net/wireless/realtek/rtw89/ps.c       |  1 +
 drivers/net/wireless/realtek/rtw89/rtw8851b.c |  1 +
 drivers/net/wireless/realtek/rtw89/rtw8852a.c |  1 +
 drivers/net/wireless/realtek/rtw89/rtw8852b.c |  1 +
 .../net/wireless/realtek/rtw89/rtw8852bt.c    |  1 +
 drivers/net/wireless/realtek/rtw89/rtw8852c.c |  1 +
 drivers/net/wireless/realtek/rtw89/rtw8922a.c |  1 +
 drivers/net/wireless/realtek/rtw89/rtw8922d.c |  1 +
 12 files changed, 65 insertions(+), 1 deletion(-)


base-commit: dc16902cad9c6b08df9395a510c7be44fbab545d
-- 
2.25.1

