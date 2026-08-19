Received: from mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58DF3D091A
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 07:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787124458; cv=none; b=NzXgsj207dbakrPamTp+bSqAXev95NuYKIU96UuB4JYjcyhzYXhFeZHD000pNNSaGKF5WtxM/c6HyDDjtkMO+XnQI/hyQN1C3c39vdBD1jz9zn7rdZO4oWOa8AGudt7oLDjWkXhxquhqv58f2226NZzVKtO8BG6EOKfwDi5tPiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787124458; c=relaxed/simple;
	bh=NsNg7b/W+gQJwQrUUjP/I9QQ+ee0HZENvefznl2S0lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=omIBCW9QY/lgfzUh8GD890vy2Nebbo3ipusXGGFSvqx9rT/Ujqo0uRcyOKgz2uor1BWYKm2wNgl0OhRB8gm4ViMWgYQCAEJsBdMnuFwakEIJsiXtRiNywMjFztUImQ/Ng/bdPkx70Sg+VqTE71T4HnGbbVrjMrxQVAysEUIF5IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uE3EC+td; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uE3EC+td"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=NsNg7b/W+gQJwQrUUjP/I9QQ+ee0HZENvefznl2S0lQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787124454; v=1; x=1787729254;
 b=uE3EC+tdigtCPlxXHeGOhI5u2mc1yNZ8DS0k6LLPPEzxqF7W5HfYxiFpZ23a0xLkZf1PrwSu
 w7mvLDQ1z3nxx6SQqjXdikecpdMCP9WkGXxKEfkas14eSiK1Ds8sM0aljqG4mEjgp3mjIC4UPeU
 9NA+alzxP/cb24niS7ewVDP8=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from kali (2a06:63c5:9b00:3900:e1b3:d7a6:6110:4f65)
	by smtp.migadu.com with ESMTPS id ac8c18744979f888;
	Wed, 19 Aug 2026 07:27:34 +0000
X-Migadu-Flow: FLOW_OUT
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v6 2/6] wifi: rtw88: rx: mark zero length packets on RTL8723BS
Date: Wed, 19 Aug 2026 07:27:13 +0000
Message-ID: <20260819072717.22648-3-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260819072717.22648-1-luka.gejak@linux.dev>
References: <20260819072717.22648-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Luka Gejak <luka.gejak@linux.dev>

Like the RTL8703B, the RTL8723BS reports receive descriptors with a zero
packet length, which the vendor driver drops outright. rtw88 already
flags these as having no PSDU for the RTL8703B, so extend the same
handling rather than passing an empty frame up.

This is gated on the SDIO interface rather than the chip id, because it
has only been observed there; the USB variant is not known to do it.

Co-developed-by: Michael Straube <straube.linux@gmail.com>
Signed-off-by: Michael Straube <straube.linux@gmail.com>
Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
---

Notes:
    Changes in v6: none.
    Changes in v5: the zero length test now evaluates pkt_stat->pkt_len
    first, so the unlikely case short circuits before the chip test.

 drivers/net/wireless/realtek/rtw88/rx.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rx.c b/drivers/net/wireless/realtek/rtw88/rx.c
index 01fd299abb7f..fde21c840ac0 100644
--- a/drivers/net/wireless/realtek/rtw88/rx.c
+++ b/drivers/net/wireless/realtek/rtw88/rx.c
@@ -253,10 +253,12 @@ static void rtw_rx_fill_rx_status(struct rtw_dev *rtwdev,
 
 	rtw_rx_addr_match(rtwdev, pkt_stat, hdr);
 
-	/* Rtl8723cs driver checks for size < 14 or size > 8192 and
-	 * simply drops the packet.
+	/*
+	 * Rtl8723cs and rtl8723bs drivers check for size < 14 or size > 8192
+	 * and simply drop the packet.
 	 */
-	if (rtwdev->chip->id == RTW_CHIP_TYPE_8703B && pkt_stat->pkt_len == 0) {
+	if (pkt_stat->pkt_len == 0 &&
+	    (rtwdev->chip->id == RTW_CHIP_TYPE_8703B || rtw_is_8723bs(rtwdev))) {
 		rx_status->flag |= RX_FLAG_NO_PSDU;
 		rtw_dbg(rtwdev, RTW_DBG_RX, "zero length packet");
 	}
-- 
2.53.0

