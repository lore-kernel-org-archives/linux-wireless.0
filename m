Received: from mta0.migadu.com (out-83.mta0.migadu.com [91.218.175.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82495632B6
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 13:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788874210; cv=none; b=oZQK9g4rCtwiCVhNv6ce8qhWYUV4nP9Oa7KzMbLn6NnSPDMJibts//h9AtVXZRZl/ke30+KwPpOvHhCMQPb49KcL2Wgp4d5u8D6FTmfkKrkQhkChy3Gv3Bu2nTl0nm6OIX+44VRquTH/NSDghnvYWKi0M7KT7MgWNpCdTP6qHlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788874210; c=relaxed/simple;
	bh=gLHXPsYxqwj+bexYJhqs+caAKhnK7pPHy3TuQ1u5864=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tOxFi77baZDhNTUk+szWGLXY1N+nb7M1knGBqUk4t7+KBwVB/8FdPfIwhkH0twlApKW9jkAodKDwU/sDGI5gx3l5pSGkTd38Kw7yS2UC+wrKvPHhTEDzw4jKTorbvLzO5JXh2PfLpQegJsWYFlgwhXCrOA5Chnlt9dY1p44RB+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ddYrkmvY; arc=none smtp.client-ip=91.218.175.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ddYrkmvY"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=gLHXPsYxqwj+bexYJhqs+caAKhnK7pPHy3TuQ1u5864=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788874185; v=1; x=1789478985;
 b=ddYrkmvYEyqEF9RSPq6ul+qqy5SYUAVcc0dWJMWpy0wR265ZtcWYPIc4JXLu6/0PBxp/mvpD
 o/zx8zV9qoQG+6Gwabgb/9mJqQ7xq4hO4kQc9rVWl7UYzYuxbToYu6n5zjagdh6IsMSCaYHX41O
 0sO4MORtxdQq0E/GlVAVEt1I=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 075f03fd6d7588c4;
	Tue, 08 Sep 2026 13:29:45 +0000
X-Mizu-Trace-ID: 075f03fd6d7588c4
X-Migadu-Flow: FLOW_OUT
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v10 2/6] wifi: rtw88: rx: mark zero length packets on RTL8723BS
Date: Tue,  8 Sep 2026 15:29:22 +0200
Message-ID: <20260908132926.68976-3-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908132926.68976-1-luka.gejak@linux.dev>
References: <20260908132926.68976-1-luka.gejak@linux.dev>
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
    Changes in v10: none.
    Changes in v9: none.
    Changes in v8: none.
    Changes in v7: none.
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
2.55.0

