Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793609768;
	b=mhXKoGpeZ5P7G/TXuIxTcrq0N7AHSEmkcQL10U4K/fHvP1+uM4vIZyzdYOzJkhkQNxU7
	 rZNMvtWjonAGJMCbU3JOdmZ9ua9dphUN3j3l7X6LKoH5p3pTkWnFWeaFqmdSnSK736YcV
	 smnQrjKPFkTBMU3m7e02Nn7A86OFD+ohXIoxgZOGgacTXAOgZiP6JpyvWgXvNAtG/EGvg
	 swpsxnsgjNupSbGKFnynyQ4mOzxkvMP8NQ1gT1A8l6hkWdPWwzpT40vj1dcwLpDaxlmS8
	 TnosAh33XzBQpnmNMv/m6gz4gFCGlv5pIW4K75HFijp0wMLKZ9RBFJWEcmyHt7ZGUWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793609768;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	bh=+HIPWtaebc9FY22xXH/vJtbSJeC97eTXpqKihX19II0=;
	b=SmCb0BsoMhEe9RyEuTfHhcWPBYf4a97dJ6iRo/XVR1iZdcxf9IfAQkQfqy/mO4f/dDB7
	 rGonvo5KwGX+vloXlhz1c238d+LDYqNizS3tmdtzmJneJIUbrL+MAg1ms1gSShN1yPeHi
	 7l0fMU1g4zVZTCd00DFvjAP54IwvQspCzcni1stU9twKewZgFvh5/B8eaijLVhD+hs+Fh
	 VFZAciQzVxnufecweec0hbwqO++odkuYgyJt+HMoeSc6b9bbyx2WXx35YWD3+Fu9mHFaI
	 Quk9PaZroTXbQ5/9H48EDPPDdOec2FSD9PJt67cKtL8zchrgHfeiYb0jPlLTl5mhs6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=hSGf3v3N;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA089606A324
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 08:56:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA089606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=hSGf3v3N
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A28twHxB1997621, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793609758; bh=+HIPWtaebc9FY22xXH/vJtbSJeC97eTXpqKihX19II0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=hSGf3v3NXDA4SD3dafsmlFBxJbSX/Dt8MJnB+ytWVpgamWk5SSFkgLVtek/+CQ4/H
	 Evv4BnyK26QknHFzcBel4iyQj3S+1/EDuSnoPlJihu4+6dnc2r8lMlxfmFoIqsEhxg
	 m8beMO/z516E/2raJgFS36DEDEKQrB0SfDDT0oZdYM3ksM609wui0wQ5OfrAqB/V6D
	 grqjfInwL/SuvJlEtXKt/KpmAK3tTOu2q6y5p7uBm1VzZi8MjI9aPLQ9du6ARuSBKR
	 nXUyf2llfV1gJODEaX56oviwG3g8TC3KjCMERL6da/fPCLAMz4WvHEathvWb/h/2/c
	 96Cz/HmtuxLyA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A28twHxB1997621
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 2 Nov 2026 16:55:58 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 2 Nov 2026 16:55:58 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 2 Nov 2026 16:55:57 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Mon, 2 Nov 2026 16:55:57 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <charlesl@valvesoftware.com>, <sabae@valvesoftware.com>,
	<kevin_yang@realtek.com>, <wenjie.tsai@realtek.com>
Subject: [PATCH rtw-next v2 0/2] wifi: rtw89: add regulatory domain learning by firmware
Date: Mon, 2 Nov 2026 16:55:32 +0800
Message-ID: <20261102085534.15153-1-pkshih@realtek.com>
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
 13 files changed, 474 insertions(+), 5 deletions(-)


base-commit: 9b0be45d4d52fd223994e151f169743a97abd290
-- 
2.25.1

