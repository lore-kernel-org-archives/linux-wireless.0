Received: from mta1.migadu.com (out-137.mta1.migadu.com [95.215.58.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9C34D598B
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 12:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791549050; cv=none; b=LwKYcIIJOGESg3ASf/iDT5bOtZ3lTBigm/C3LwqRceRGEOdTHInSyPjqbJXeWqdASBLuxaQULACqcDASjgglKM1O6uHTKh+KuXBcT6KZ5+BGCzTO9s4RmywIXjWVuoX4rL001hHgQhiXPDM3a2H0saUjcF36xOPgvn7FHmtm2+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791549050; c=relaxed/simple;
	bh=xVL4GFavCPIhSY+sQODNgo3KmrmxrCIcaev0qZ+6NO4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tY5vEQQwW19NlzJrzumwm/IQvUst0zFwbPgaGftI3ZhYrA5adYzjQNvCtouA8C7rxDge1/u0KArOwZtPZDRpoZq1aLhH/lzCTJ25i+uHVA1QWfPya3ZrD9g9IJn3Xo5kSvqUao8DY32zzxMs8uJEKIouveiQhv1GizoaKCWxpsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=f1d3JJbz; arc=none smtp.client-ip=95.215.58.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="f1d3JJbz"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=xVL4GFavCPIhSY+sQODNgo3KmrmxrCIcaev0qZ+6NO4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791549044; v=1; x=1792153844;
 b=f1d3JJbzBM0sVQ9y+pKCZgYlyuQHrcBOdF2IgL3ST2B7704P+tsoqqkSpkdach1Kxlwxfg0X
 r1eqK7sQ7lypZCqXZjL0ndbziVmQZFsxF7vyXXTZmS9UGhMVixIg4HMjBpXRHckIoVNM7VCYVeX
 gsnNPwNwFPtVr0Kq4SnWQVi4=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ff963d78d54d91b6;
	Fri, 09 Oct 2026 12:30:28 +0000
X-Mizu-Trace-ID: ff963d78d54d91b6
X-Migadu-Flow: FLOW_OUT
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Kalle Valo <kvalo@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luka Gejak <luka.gejak@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH rtw-next] wifi: rtw88: sdio: reject oversized RX packets
Date: Fri,  9 Oct 2026 14:30:22 +0200
Message-ID: <20261009123022.87787-1-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rtw_sdio_rxfifo_recv() also takes the last-entry path when the descriptor
claims more data than rx_len. The skb is then passed to rtw_sdio_rx_skb(),
which calls skb_put() with pkt_len and does not check it against the space
left, so a bad descriptor can overflow the skb.

Reject the packet when pkt_offset + pkt_len exceeds the bytes left.

Fixes: 65371a3f14e7 ("wifi: rtw88: sdio: Add HCI implementation for SDIO based chipsets")
Cc: stable@vger.kernel.org
Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/sdio.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index dc2fd0f8f9ff..3a86fdcde367 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -1389,6 +1389,14 @@ static void rtw_sdio_rxfifo_recv(struct rtw_dev *rtwdev, u32 rx_len)
 		curr_pkt_len = ALIGN(pkt_offset + pkt_stat.pkt_len,
 				     RTW_SDIO_DATA_PTR_ALIGN);
 
+		if (unlikely(pkt_offset + pkt_stat.pkt_len > rx_len)) {
+			rtw_dbg(rtwdev, RTW_DBG_SDIO,
+				"oversized RX packet: %u, %u bytes left\n",
+				pkt_offset + pkt_stat.pkt_len, rx_len);
+			dev_kfree_skb_any(skb);
+			return;
+		}
+
 		if ((curr_pkt_len + pkt_desc_sz) >= rx_len) {
 			/* Use the original skb (with it's adjusted offset)
 			 * when processing the last (or even the only) entry to
-- 
2.55.0

