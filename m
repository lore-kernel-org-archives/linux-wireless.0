Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697F03FE656
	for <linux-wireless@vger.kernel.org>; Fri,  1 May 2026 16:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777652446; cv=none; b=dKj1oK7TjxPtygy03bPkGlEC7/IWoBBgN6PRKNoY/1oNnV3fYWkmltvOZalJ1bAmQyN0Cku2HO2pASkdXNo0ZX+NK3zojlEu8tEfAcDReyq5MfcOKdwRJvWEE/icUg3OCt/C8RVnEdqwWGqjgC6vowQKdRC/ubiVRS7c7DaQou4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777652446; c=relaxed/simple;
	bh=kThxq1vqAM0QTylt7bfpD1v3CJZQvq1pAKWN5HC4rhs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iFjL8U7M1MNIQylF5NI3LzFG5/Vhc5lQjw/QcuxC0P8orKtjGB2bS9sXBdHhqPTExjIJCX2LIMZkeePE5Y1ltDSLCg2xqjqbsY2B5JH8etjaTDsS211FFj6a8LyCBjVAkxtopZkWDiKA/1yMPg0seTCBd5qdQq/R2YDxdhZU9Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vinU02id; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vinU02id"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777652432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=TGGzFQ12nKFXyDObTpju8dgi8jZOyemG5etJq+jNSdc=;
	b=vinU02idbaZwvYTjiBtdRmuz1y3zU50Z9ifi4AxZuCPSAm9naGCndmXUd3CK76gZvbeg5N
	sZ2nK8EAl5iNqN/NJmdYQiJ3lb5jx1tSO1VXd6C/gLZG+DPgRIHLbx+/h7Qt/nj1kXelMy
	zepTJVkR2RC0Xc7lGWKlg7PTvSJO7xA=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Yan-Hsuan Chuang <yhchuang@realtek.com>,
	Brian Norris <briannorris@chromium.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luka Gejak <luka.gejak@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH] wifi: rtw88: usb: fix memory leaks on USB write failures
Date: Fri,  1 May 2026 18:20:12 +0200
Message-ID: <20260501162012.250013-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

When rtw_usb_write_port() fails to submit a USB Request Block (URB)
(e.g., due to device disconnect or ENOMEM), the completion callback is
never executed.

Currently, the driver ignores the return value of rtw_usb_write_port()
in rtw_usb_write_data() and rtw_usb_tx_agg_skb(). Because these
functions rely on the completion callback to free the socket buffers
(skbs) and the transaction control block (txcb), a submission failure
results in:
1. A memory leak of the allocated skb in rtw_usb_write_data().
2. A memory leak of the txcb structure and all aggregated skbs in
   rtw_usb_tx_agg_skb().

Fix this by checking the return value of rtw_usb_write_port(). If it
fails, explicitly free the skb in rtw_usb_write_data(), and properly
purge the tx_ack_queue and free the txcb in rtw_usb_tx_agg_skb().

Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Cc: stable@vger.kernel.org
Tested-by: Luka Gejak <luka.gejak@linux.dev>
Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/usb.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index 718940ebba31..d430645a3ef3 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -456,7 +456,13 @@ static bool rtw_usb_tx_agg_skb(struct rtw_usb *rtwusb, struct sk_buff_head *list
 	tx_desc = (struct rtw_tx_desc *)skb_head->data;
 	qsel = le32_get_bits(tx_desc->w1, RTW_TX_DESC_W1_QSEL);
 
-	rtw_usb_write_port(rtwdev, qsel, skb_head, rtw_usb_write_port_tx_complete, txcb);
+	if (rtw_usb_write_port(rtwdev, qsel, skb_head,
+			       rtw_usb_write_port_tx_complete, txcb)) {
+		/* URB submission failed, completion won't run, free the queue */
+		skb_queue_purge(&txcb->tx_ack_queue);
+		kfree(txcb);
+		return false;
+	}
 
 	return true;
 }
@@ -518,8 +524,10 @@ static int rtw_usb_write_data(struct rtw_dev *rtwdev,
 
 	ret = rtw_usb_write_port(rtwdev, qsel, skb,
 				 rtw_usb_write_port_complete, skb);
-	if (unlikely(ret))
+	if (unlikely(ret)) {
 		rtw_err(rtwdev, "failed to do USB write, ret=%d\n", ret);
+		dev_kfree_skb_any(skb);
+	}
 
 	return ret;
 }
-- 
2.54.0

