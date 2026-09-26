Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742133939B1;
	Sat, 26 Sep 2026 11:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790422884; cv=none; b=X2tb4qFgndrwAgWl17GKUkSMOOwq/erT6sLcpXWT8Rks++xYn/VZVenrku7DXJq1mji/yPOP6qpoEOZ6bEEJcLeBHZSNehkrSg+XHAqJ59ES5a3FT8tA4CjuMIlO6HulqDmoDHjilZ1mx8MablQkXZJGIy88vyQzSUBGufTXdFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790422884; c=relaxed/simple;
	bh=Fq5jbDzVIuZw2ej2kHYIGcktq8SPUznJZNRSaMjI0Zs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=i8ZgMxGCaxp8B9sQCQyhiwPmxgpJ1x/gJsZhiBe1QZTj35tZgj4TQ2Csq9/zHcAT1yLf3eVAREyMY8zRz8tM1i4i0bS219lFp+nzT8kdPh4D7QZI/gp2Mo3giTj2ucM0pQy3+bRQBisPg6RQljK3dN3prc4AQkjhfdGaSvqwU1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=OeXLYos5; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="OeXLYos5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=WU
	ePfDmCfNLpzcWpvJPtJwMT6WGDZs7a4ovshwuMNTQ=; b=OeXLYos5PK8DUaHnVp
	PbTSY/2nHlPojLssC33/39ZZSklHF9mf2bylb2eG3jvyTTO9F8QwptJIU6k3u0bb
	M54YcKH8ytHRQj/Kq/1pWnYvKCNQxB1mJl4TK8mdhI1eJyZGiQe3CGNnwo2AOZCB
	ogJbB2xN4XhsuzpUTjiL4nWlY=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD3_5g2r7dqdKZ3Aw--.46536S2;
	Sat, 26 Sep 2026 19:40:39 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Jeff Johnson <jjohnson@kernel.org>,
	Venkateswara Naralasetty <quic_vnaralas@quicinc.com>,
	Govindaraj Saminathan <quic_gsamin@quicinc.com>,
	Shashidhar Lakkavalli <slakkavalli@datto.com>,
	Ganesh Sesetti <gseset@codeaurora.org>,
	Manikanta Pubbisetty <quic_mpubbise@quicinc.com>,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH] wifi: ath11k: Reject short management RX frames
Date: Sat, 26 Sep 2026 19:40:37 +0800
Message-Id: <20260926114037.3231795-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3_5g2r7dqdKZ3Aw--.46536S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7WFWUur43GryxJFW8Zw1fZwb_yoW8Xr4kpF
	W7KasFkry7AanrJr15AFW8ZayY9anYyFW2gFWrt345uFy5CF15tFn5WF9Yqr15tr45Jr12
	va1jvrW5Gas5t3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRR6wJUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8BeBu2q3rzefgwAA3E

ath11k_pull_mgmt_rx_params_tlv() verifies that the firmware-reported frame
length fits in the WMI event, but does not ensure that it can hold an IEEE
802.11 management header. It then sets skb->len to that reported length.

ath11k_mgmt_rx_event() subsequently reads frame_control and other header
fields without another length check. A firmware event with a short buf_len
can therefore cause an out-of-bounds read.

Reject frames shorter than a three-address IEEE 802.11 header before
adjusting the skb to expose the frame.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index bbca275a8289..02cd9764b6fc 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -5995,7 +5995,8 @@ static int ath11k_pull_mgmt_rx_params_tlv(struct ath11k_base *ab,
 	hdr->tsf_delta =  ev->tsf_delta;
 	memcpy(hdr->rssi_ctl, ev->rssi_ctl, sizeof(hdr->rssi_ctl));
 
-	if (skb->len < (frame - skb->data) + hdr->buf_len) {
+	if (hdr->buf_len < sizeof(struct ieee80211_hdr_3addr) ||
+	    skb->len < (frame - skb->data) + hdr->buf_len) {
 		ath11k_warn(ab, "invalid length in mgmt rx hdr ev");
 		return -EPROTO;
 	}
-- 
2.34.1

