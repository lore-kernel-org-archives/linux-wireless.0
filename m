Received: from mta1.migadu.com (out-84.mta1.migadu.com [95.215.58.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1715F44064C
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 07:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788939989; cv=none; b=lNGeT3GaJYqsHcUh0ybHJbjKkFAu8w+bBqRPs7DhaoCmokRE7Ur/58KabvKs8k2szZN1Zu+kMkZZC/IRh1wgg8lQCUS0TVcQ00qVcypmrDhPX1zQPBuzYL4GpAlV0jMyqowK1QeS5yyW/AEcpPZQWcB0mh4yayDhJEL2AIdUAhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788939989; c=relaxed/simple;
	bh=FHAVAgnPTkkVTucfD73+axRxGRKhYp+PvfqXkQoGNzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djjQHtR4ezrOr67ENru3Q888HITkn6GNmYJApvWoy7aPYak5A0yIrcZ2hw8n3G/ZWqdKNpz3VKOgbkzHt3A4ey8/TM2deN1lHqkldKWOpKE7wS4TWYfMgufVVzngjjSrUVlQPE2OoV0bZfTSy4lQFG1dGC7nLJt/WI+Oya2URMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AWe5UMiK; arc=none smtp.client-ip=95.215.58.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AWe5UMiK"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=FHAVAgnPTkkVTucfD73+axRxGRKhYp+PvfqXkQoGNzY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788939983; v=1; x=1789544783;
 b=AWe5UMiK4qBgpXXl8qisMH/2TIBTsgjLsp6WhNOEVt7ZUhhW0a5xWIH0Jx4G6JApqG+h1y1O
 4Bqa0o+lLw+y4qB5VSWT4lwFgI7hg5bAy5l43Z0Jbong7F0Y/ZsB0cbiUnahbK5CLgxURJ8Ta5Z
 WoxJY95aqLUZUGGUwRHLhqO0=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id bb76d9970d045c24;
	Wed, 09 Sep 2026 07:46:23 +0000
X-Mizu-Trace-ID: bb76d9970d045c24
X-Migadu-Flow: FLOW_OUT
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v11 4/7] wifi: rtw88: sdio: zero the padding added to a TX transfer
Date: Wed,  9 Sep 2026 09:45:53 +0200
Message-ID: <20260909074556.55709-5-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909074556.55709-1-luka.gejak@linux.dev>
References: <20260909074556.55709-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Luka Gejak <luka.gejak@linux.dev>

rtw_sdio_write_port() rounds the transfer up with sdio_align_size() and
then hands that length to sdio_memcpy_toio() while the skb still only
holds skb->len bytes. The difference, between one and 511 bytes, is read
from beyond the end of the frame and transmitted. Whether it stays
inside the skb's allocation depends on how much tailroom the skb happens
to have, so this is at best sending uninitialised memory over the air.

Pad the skb up to the transfer size first. __skb_pad() zeroes the added
bytes, reallocates a cloned skb rather than writing into a buffer a
clone still shares, and leaves skb->len alone, so nothing else in the
transmit path has to change.

It must not free the skb on failure: rtw_sdio_write_data() frees the skb
itself and rtw_sdio_process_tx_queue() requeues it, so both callers
still own it and would double free.

Found while reworking this path for the RTL8723BS. Measured on RTL8723BS
hardware, padding the transfer costs nothing observable: uplink is
19.5 to 19.8 Mbit/s padded against 20.9 to 21.1 Mbit/s unpadded in an
interleaved A/B, with scans, reconnection and a UDP flood clean in both.
The other SDIO parts sharing this path are untested; I have only the
RTL8723BS.

Fixes: 65371a3f14e7 ("wifi: rtw88: sdio: Add HCI implementation for SDIO based chipsets")
Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---

Notes:
    New in v11.
    
      Ping-Ke asked for this to come before the RTL8723BS accounting patch
      rather than after the series, so that it backports on its own and so
      that it is clear it is an existing problem rather than something the
      RTL8723BS work introduced.
    
      The pad_size local is the shape he asked for on v9: declared at the
      top, computed unconditionally, and tested with if (pad_size > 0).

 drivers/net/wireless/realtek/rtw88/sdio.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index 5b40d74b16ee..8466abad972a 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -636,6 +636,7 @@ static int rtw_sdio_write_port(struct rtw_dev *rtwdev, struct sk_buff *skb,
 			       enum rtw_tx_queue_type queue)
 {
 	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	size_t pad_size;
 	bool bus_claim;
 	size_t txsize;
 	u32 txaddr;
@@ -646,6 +647,17 @@ static int rtw_sdio_write_port(struct rtw_dev *rtwdev, struct sk_buff *skb,
 		return -EINVAL;
 
 	txsize = sdio_align_size(rtwsdio->sdio_func, skb->len);
+	pad_size = txsize - skb->len;
+
+	if (pad_size > 0) {
+		/*
+		 * __skb_pad() must not free the skb on failure: both callers
+		 * still own it, one requeues it and the other frees it.
+		 */
+		ret = __skb_pad(skb, pad_size, false);
+		if (ret)
+			return ret;
+	}
 
 	ret = rtw_sdio_check_free_txpg(rtwdev, queue, txsize);
 	if (ret)
-- 
2.55.0

