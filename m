Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFBC61FCE
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 04:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791086442; cv=none; b=SpY8QfzOfr/VtoDyo0hAcmxCebnQ1brweVwqUxI8jYoZOOKQY46UlOEmIBPCht1AUQf/rZy/uXf3xAL8GyGtu2swI/C07WhLPjVsJDz0+AfFGYy+YPPFnoJrP+qvGjZ0nDWRkp98jXdMev2yK6FZiyH1B9JljJ7ST98f/tEYL64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791086442; c=relaxed/simple;
	bh=aVLGuS6gRUSt8WN8r5tjx1ElNE2xpIg97pOWXhkfMf8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qPPdfn6D/kxhda9281467Bg0brgE5ElwIfmHao50ev+jV3DBcFhI5Arzqa9KrCsfSRPQVF8pHPlfNjg+Grj8rpAlfn2JVDmZCcBjNKOviAcVmklwlu5fbQ03E1C2fwn7QCxQdd+3IdgX2ZC8T1siHbBR9qPaJXiKAUCjnGjtF8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=uun6XY3d; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="uun6XY3d"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69440bjN6833951, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791086437; bh=vUhcAQ7FmLQrd3aVARO6TNgZH/WvAd65/2Na7tsep9I=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=uun6XY3dAlHewAwQoKu8pvNKl5IrjZHqzbCoPG+W8x+LG+FT8GJp8VWKNg52ai4bN
	 lcigZg+3gLWq9S4oQXW2J6Z+c0aJE2MYDensqYz2orufbIIw1EbH0q8iESVCWeY6VY
	 DZIoWg0HijfCnNBeKINrxR2x58HoJPJWDnkoXIWtKlmw6Q4udtVd9skwG+ujZxV1Zg
	 HQUz9em9XCbPXtHMNprhFpaP3Jc5Bw+HE4gYUugL+poF1KleMMH22njjU5SGPvbjLD
	 VQI07GVNbvylwHt8kIyzPgrz0WRgyg4JmuIiMDSFdW+H37euxHrLsFKYhfyXgGeUhS
	 7SZzD1jdzsm3A==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69440bjN6833951
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Sun, 4 Oct 2026 12:00:37 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 12:00:38 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 12:00:38 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Sun, 4 Oct 2026 12:00:38 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 0/2] wifi: rtw89: 8922d: increase firmware format to 1
Date: Sun, 4 Oct 2026 11:59:51 +0800
Message-ID: <20261004035953.36785-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

The firmware commands/events formats are changed since 0.35.119.0, and
BT-coxistence has much changes needed implementation in driver side.
Update the firmware format version to support newer formats and features.

Ching-Te Ku (1):
  wifi: rtw89: coex: Update Wi-Fi/Bluetooth coexistence version to
    9.24.2

Ping-Ke Shih (1):
  wifi: rtw89: 8922d: update supported firmware format to 1

 drivers/net/wireless/realtek/rtw89/coex.c     | 2 +-
 drivers/net/wireless/realtek/rtw89/rtw8922d.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)


base-commit: 7cde94dab0e74434ccc0a387d7ad373fb3becda0
-- 
2.25.1

