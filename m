Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.73
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792586610;
	b=RYx1rAKfY7uvHfoTSQ7Iq3Q2N2KhQeKDyTKGhXVEEkMrMOCEHTUGjvrbjbi7FfR0jc+5
	 1PHKjJLJdFp+SwM/ixbky61bny4bEFvYCOorIkX/9eCjmTvnIXXhlLcYpYapSM/+LD7TX
	 4XJ9ueFiuU+LHp4A97FFG5ID56NPkxxNNhyUiwPgDYm1boROr1wWLkZD0BHVy+yT63h/5
	 7Rq6CxHOqdjIxCV431QTPwVgExN0DKa0O7lQqBukiPs5vsRNSiQ7y7+3RtvlxhuiuQixx
	 ZxWoCzQiVkdSUXhWxsgBXR5Q9cKsC/k0wor5zXuWuF3l+/t6HWG9c34KxDV1dbwwuKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792586610;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=U6LLgh2x0RYHC5cbgO98zJEV00G1ZA6h3yWxhN5GC6g=;
	b=Dwi8uPaGBgZ/SIoNHLTerI19kwEs4cMTOTCoocypVvgCuobO18wYwsbRQ6G09l5IKCg4
	 JtSscpc/vR1SnN0xK9Eo7tG+Ve+Z1aYcwaAahuNh8ba46rJ8nplF7QaEH3DK5FW0cV0cV
	 jFN4fkCh3y+PS+KkVtyEaRV6+FA0PjA7RckbgBYBSU/Xe3+x1xaGCKovmTd7yv1D+fG4R
	 USULEJpHAnU+CXW6u26BIs3lloxLOfqRvvepzRMVuOlvtTzQR85VK/yHHPgoKY+MQbsak
	 9yP8ON7tqK9dl+VQ/JtU0/zXiwubg/ekzsav0XuhMISLOVEdQAdzT3y+Wb0d0QYXbpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hx1A1Imz;
	arc=none smtp.remote-ip=91.218.175.73
Received: from mta0.migadu.com (out-73.mta0.migadu.com [91.218.175.73])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD4C606A31A
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 12:43:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9FD4C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hx1A1Imz
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=KAEE5JLHz3QteKNMX6KrvUMf/Abkio53k3oXnLJQDro=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792586606; v=1; x=1793191406;
 b=hx1A1ImzQJyOW/N4+laAdEOCJZNpbMfDARfC/goE8UXR5Y+oJKL/DUmkX1KkbJX8KsLCAXKt
 aa1MMw74MHUbvt6Z1iEYrJeyAoGYfDz2NF4ubOrDwHgGdpcAcUrPWLDAcar1yHmEQROgUAEpqqQ
 t/lWm0VWAjMfE8XtgnVy1XQY=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 3b583a68deff1662;
	Wed, 21 Oct 2026 12:43:26 +0000
X-Mizu-Trace-ID: 3b583a68deff1662
X-Migadu-Flow: FLOW_OUT
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH rtw-next v2 2/2] wifi: rtw88: sdio: limit the high queue to DTIM delivery
Date: Wed, 21 Oct 2026 12:43:18 +0000
Message-ID: <20261021124318.15993-2-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261021124318.15993-1-luka.gejak@linux.dev>
References: <20261021124318.15993-1-luka.gejak@linux.dev>
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

In AP mode every broadcast and multicast (bmc) frame is sent through the
high queue, which the hardware only drains after a DTIM beacon. Only a
few frames leave per DTIM, so steady multicast traffic builds a backlog
that holds the TX pages the other queues need. Unicast traffic then
stalls for seconds and clients can no longer renew their DHCP lease.

USB had the same problem and was fixed by commit c710c7c2e038 ("wifi:
rtw88: usb: route bmc frames via the high queue only for DTIM delivery")
and the two commits that followed it. Use the same rule for SDIO. A bmc
frame goes to the high queue only when mac80211 asks for DTIM delivery
because a station is dozing, the frame is ARP, EAPOL or DHCP, and the
budget allows it. All other bmc frames go out on their access category
queue.

Tested on RTL8723BS with an ath9k client.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/sdio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index dc2fd0f8f9ff..83e9b301ae9b 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -1308,6 +1308,9 @@ static int rtw_sdio_tx_write(struct rtw_dev *rtwdev,
 	u16 q_map = skb_get_queue_mapping(skb);
 	struct rtw_sdio_tx_data *tx_data;
 
+	if (queue == RTW_TX_QUEUE_HI0 && !rtw_tx_bmc_use_hiq(rtwdev, skb))
+		queue = rtw_tx_ac_to_hwq(q_map);
+
 	rtw_sdio_tx_skb_prepare(rtwdev, pkt_info, skb, queue);
 
 	tx_data = rtw_sdio_get_tx_data(skb);
-- 
2.53.0

