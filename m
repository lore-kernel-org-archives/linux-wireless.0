Received: from mta1.migadu.com (out-51.mta1.migadu.com [95.215.58.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0963C3B14BC
	for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 06:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788156732; cv=none; b=phzX97abHkSpo9meitacY1KCXpPvz+mSqeE/vqLY0iESWWom+YBsowKlLYsu6A4CAyVk3oHltA36k8sYqPlKJSR18nofpTliC4BPtimkbtRXT7GbEbai65aTWG55UMH+tDdduFouTvFvyglMGbgRg8d8feFYa6QDSclqIlGYvGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788156732; c=relaxed/simple;
	bh=EzLfWy6AHQnq33EcVIOFY8v0KxYz34L3rC3KooYUqKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sKv6qM6onN/sE+vPDPl5w8Ij86G5FBJPNH6MNFJnKZiRgrVzuwp4jrPpU39szJMp9+9GDIvTSqMI5fh6TiMSy0E+3m3l1vXwCm8ZtGeAp+6IgD+iNtRF8Q2YG4TMeZ161kUsGY91AIEyiXh7EmWK5Ay1X5rRk9S+3zHPa6QBWcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=g5OBdhDo; arc=none smtp.client-ip=95.215.58.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="g5OBdhDo"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=EzLfWy6AHQnq33EcVIOFY8v0KxYz34L3rC3KooYUqKI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788156726; v=1; x=1788761526;
 b=g5OBdhDoDhVSdrgCIyXho3HesbuvCjgGczPnnuTBkxTBCtpua9rJ+Hx/T+4JBjOXcdeYppsz
 KibjfEwVG6MoxEFydU8qw4HbSmMnWCwmPhGj8WMN2KZ6LnY6C5Tk0VLiPDH3baze/gKq6NFXwYu
 pJIKqJgrIilbNBiB9kZVdcz4=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 192e6d74ed31113e;
	Mon, 31 Aug 2026 06:12:06 +0000
X-Mizu-Trace-ID: 192e6d74ed31113e
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
Subject: [PATCH v9 2/6] wifi: rtw88: rx: mark zero length packets on RTL8723BS
Date: Mon, 31 Aug 2026 06:11:40 +0000
Message-ID: <20260831061144.18631-3-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831061144.18631-1-luka.gejak@linux.dev>
References: <20260831061144.18631-1-luka.gejak@linux.dev>
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
2.53.0

