Received: from akranes.kaiser.cx (akranes.kaiser.cx [152.53.16.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC29B40DFAF;
	Sat,  2 May 2026 13:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=152.53.16.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777727837; cv=none; b=pnB8xOQFdCyGdcnfFPq/IjPMQDnV0rOP5mDc3wdIWJio46/s4TPpMrbLXTXiwJLObXrOpr4eCImUCuVee28wDgItJSIPApQxh8hoiKXtAuHHp4Hm9ZY9n1O/qDsxv29TwJFmzOCTrsi9r7Bz6bSKvKhdP7gGH4VCypp47Mk45wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777727837; c=relaxed/simple;
	bh=BeONgfL4ZRZrt7n6ZM40omPDvpQXX+BUAqSanCgBLVw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gMaITCYqawKcEJHGIT2JrCpZ9ZLwHSS6RZ8PDCAAzkI6NR+u7N3G+9ew6Tvdd+htbdCe+q6G1KaMjIjk5bTH6/shBIv3F+/5UQeHSIN/jp+000Jxp97h4W/zjdYz3wPIV5mhkDKvXF0hD2vt2dMB0Gm8jcCvrdojF2aNsSLtYV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kaiser.cx; spf=pass smtp.mailfrom=kaiser.cx; arc=none smtp.client-ip=152.53.16.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kaiser.cx
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kaiser.cx
Received: from ipservice-092-208-105-007.092.208.pools.vodafone-ip.de ([92.208.105.7] helo=nb282.user.codasip.com)
	by akranes.kaiser.cx with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <martin@kaiser.cx>)
	id 1wJADW-000000001S7-3s6k;
	Sat, 02 May 2026 15:17:10 +0200
From: Martin Kaiser <martin@kaiser.cx>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Martin Kaiser <martin@kaiser.cx>
Subject: [PATCH] wifi: rtw88: remove rtw_txq_dequeue
Date: Sat,  2 May 2026 15:15:41 +0200
Message-ID: <20260502131641.141136-1-martin@kaiser.cx>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the rtw_txq_dequeue helper. It's a wrapper around
ieee80211_tx_dequeue with just one caller.

Call ieee80211_tx_dequeue directly in rtw_txq_push. There's no need to
fetch txq for every frame, we can do this once outside of the rcu lock.

Make the loop variable i unsigned long, it should have the same type as
frames.

Signed-off-by: Martin Kaiser <martin@kaiser.cx>
---
 drivers/net/wireless/realtek/rtw88/tx.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/tx.c b/drivers/net/wireless/realtek/rtw88/tx.c
index 3106edb84fb4..ea2dc9bda1b6 100644
--- a/drivers/net/wireless/realtek/rtw88/tx.c
+++ b/drivers/net/wireless/realtek/rtw88/tx.c
@@ -619,31 +619,19 @@ static int rtw_txq_push_skb(struct rtw_dev *rtwdev,
 	return 0;
 }
 
-static struct sk_buff *rtw_txq_dequeue(struct rtw_dev *rtwdev,
-				       struct rtw_txq *rtwtxq)
-{
-	struct ieee80211_txq *txq = rtwtxq_to_txq(rtwtxq);
-	struct sk_buff *skb;
-
-	skb = ieee80211_tx_dequeue(rtwdev->hw, txq);
-	if (!skb)
-		return NULL;
-
-	return skb;
-}
-
 static void rtw_txq_push(struct rtw_dev *rtwdev,
 			 struct rtw_txq *rtwtxq,
 			 unsigned long frames)
 {
+	struct ieee80211_txq *txq = rtwtxq_to_txq(rtwtxq);
 	struct sk_buff *skb;
 	int ret;
-	int i;
+	unsigned long i;
 
 	rcu_read_lock();
 
 	for (i = 0; i < frames; i++) {
-		skb = rtw_txq_dequeue(rtwdev, rtwtxq);
+		skb = ieee80211_tx_dequeue(rtwdev->hw, txq);
 		if (!skb)
 			break;
 
-- 
2.43.7

