Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792674590;
	b=3efpzKYTTULgqVCrhKRVpf/d2Mkjb3uZbfp7Oguv0ej/7GEAszJXBzHkSvXl+dk8y/bY
	 1cUwlHzct2wecV/wC7CA0xlL9DNSuSpQG2Rp8uxQpgBAL0CE7pMjJJJIPf/vrwYHClWt6
	 xdnGw19bcLadKp6lbxU5n9NnZeNMLAjq+G5cy1mFD1mAr6dHlLunXIWRWUWMoVBhnxhXI
	 8cicIUXhL6vnbUCLvDOWBm1gy1wfIeiA6Rxu+oyzZ1qU896Wgz064hebFo4c4J9PwHlbj
	 SG13StFjDAA9+cEH/NtkhPY3hDgbh3vcUU8bH2l458pk4Xy7gOhQauihhZDNnANOF9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792674590;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	bh=wkcy2SJWdhV9uQJSkIGsxc2U/qZCNFRuhP/MBzZO/Bc=;
	b=fOGBTe8EkuHza5Z4g/P+z2JQByNLxtH9bgXsAQrGqM+iD7LDvcDBpmQt4VorIcBr3Q3o
	 w6WKNSA3x5ASi3uIR2Xne5NOKuaz6auoZeMPl/a+4DVikE17lgHpkUVxbcw9Z94GjJ1aF
	 whTGv9r9IBtPbTaYBOBCl+Sf4kI5keZ6ve9IkqMSeR/GmKdEEGMMqffWHI9JVoB/PdXoZ
	 VFS6lmujVM1PiIT6PAS3dK77G725a3UGc4Fbr3vascMoBgUrvrfkRL1VhIXZbE0ej85/5
	 caGkn78YVkwkzbK2kF0yr38gVH3IpUKa4acaASDZF05wdzjnimQMQ9h3pgk1xcPXs+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b="ayOq0/09";
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44340606A31B
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 13:09:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44340606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=ayOq0/09
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69MD9f3hA893411, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1792674581; bh=wkcy2SJWdhV9uQJSkIGsxc2U/qZCNFRuhP/MBzZO/Bc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=ayOq0/09MIfMEcaf8IAdSPIuNrywHBOjZOP1pZZdI2GWX/8Y7CCX8SPF2VOSquKYl
	 o5gPsOzbH3vwP/iJcwhHd31kaq5S8JOQL8rHucDOEuXnIzOFrOJHiOqRnqy+hp8WqV
	 FCCKZ7hALzPmXoQKeKuOjh5icrl2shpL7yKvXGMcsTt2zIiQJ3nQuRcsXRhQ1xKzQR
	 vPtJhfsam44lYbYbFX6EbQUWw/aq7FFGlXmenpOgzVifnsbhsC+OW/w0lbDgxqYp+P
	 5neAujlRGMrGvPso+RpQDEexc6MKO/+esXPWyVjIuZFhurvyK11IZtBGMBp4GDHg2E
	 3MVMkPDkVciYg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69MD9f3hA893411
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 22 Oct 2026 21:09:41 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 22 Oct 2026 21:09:41 +0800
Received: from [127.0.1.1] (172.21.40.76) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Thu, 22 Oct 2026 21:09:41 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <wenjie.tsai@realtek.com>, <kevin_yang@realtek.com>,
	<charlesl@valvesoftware.com>, <sabae@valvesoftware.com>
Subject: [PATCH rtw-next 0/2] wifi: rtw89: add regulatory domain learning by firmware
Date: Thu, 22 Oct 2026 21:09:02 +0800
Message-ID: <20261022130904.2688290-1-pkshih@realtek.com>
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
 13 files changed, 474 insertions(+), 5 deletions(-)


base-commit: 9b0be45d4d52fd223994e151f169743a97abd290
-- 
2.25.1

