Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C52F271456
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 00:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790210837; cv=none; b=WcqTYh9VH3EgJRk8gQV2rZTsdDaG2dB51Hnsqln9TzCvwNAEDjKzHEIBv87yjCf/PCjW2ABf1r/sy9tGvclJ7mDoFW38mSsqQU8ca8KhU/4MeAB6VbMZSv8pYjMNb553tjj9H1+bh3Va/dTn397iaU8YwrX3VT2OSBNJeDb2T48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790210837; c=relaxed/simple;
	bh=x7g1KZ6LdOCYy9d8lwInI8fCuxRi2vYed/xiO9gKUBI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=j8282713eDnRyPwXgdY2x34QEEB4KDtXNdghzzA68hRSuxAbUEgeQDuBtAPDovW6Id+5owzyUgjPD8pONa2M0PB4hSAKHiPBZ4IFMsSKqsXG4/JnOJC9sX40fhqeoT8B9w4lDKkZyoQelDiyYHBVR0mTYOIrRINl3zya6qfLQ7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=jT1u9BOY; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="jT1u9BOY"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68O0lCqgD767568, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790210833; bh=PGYjjIzKfxMlT26PXEKXigJp88d7RQY52hzHtQcjLaQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=jT1u9BOYd8Wogc39hvqNXfsrjtYKTkU0mrRbbR+v52oM5WkRGjTwVfY4w5zEIyURe
	 Bq9u591Pf80KEMv7Yfj1eahonb9e8Sq6lhBF0BBafNUj1hELE1p6YYsrUOOXb+jLIO
	 3Rrsmj797nIFwCpVom6jVOc+VSKY+IGqDgfIkdFJxL1qbKppMYvQ4RSmayfJjSZnMT
	 nUEbJmpFiCS5hyGBBLVSKH65HQAn0EUbY9AoE2G4yyoWhg51J32J/Du2bx2bbv3Rgk
	 klqoInzflyI4KNZuSMb0BYH3h4oHPWVQ3L1j4LsfjzvdUI8AEsC1bJfE8KOjpUj8Tc
	 KLpKleZl9H6pQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68O0lCqgD767568
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 08:47:12 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 24 Sep 2026 08:47:13 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 24 Sep 2026 08:47:13 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Thu, 24 Sep 2026 08:47:13 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH rtw-next] wifi: rtw88: TX report with long timeout for non-PCIE devices
Date: Thu, 24 Sep 2026 08:46:37 +0800
Message-ID: <20260924004637.9958-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

Many USB and SDIO devices can't report TX status within 500 ms, and
extending to 2500 ms as tested USB/SDIO devices can fix the problem [1].
To avoid adding chip ID one by one, and this change looks harmless.
Keep PCIE using short timeout, and others use long timeout.

[1] https://lore.kernel.org/linux-wireless/20260921165343.8131-1-pepe.schlehofer@gmail.com/

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/tx.c | 10 +++++-----
 drivers/net/wireless/realtek/rtw88/tx.h |  3 ++-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/tx.c b/drivers/net/wireless/realtek/rtw88/tx.c
index 4e110a457e71..701ed7c4f3f7 100644
--- a/drivers/net/wireless/realtek/rtw88/tx.c
+++ b/drivers/net/wireless/realtek/rtw88/tx.c
@@ -196,7 +196,7 @@ void rtw_tx_report_purge_timer(struct timer_list *t)
 void rtw_tx_report_enqueue(struct rtw_dev *rtwdev, struct sk_buff *skb, u8 sn)
 {
 	struct rtw_tx_report *tx_report = &rtwdev->tx_report;
-	unsigned long timeout = RTW_TX_PROBE_TIMEOUT;
+	unsigned long timeout;
 	unsigned long flags;
 	u8 *drv_data;
 
@@ -208,10 +208,10 @@ void rtw_tx_report_enqueue(struct rtw_dev *rtwdev, struct sk_buff *skb, u8 sn)
 	__skb_queue_tail(&tx_report->queue, skb);
 	spin_unlock_irqrestore(&tx_report->q_lock, flags);
 
-	if ((rtwdev->chip->id == RTW_CHIP_TYPE_8723D &&
-	     rtwdev->hci.type == RTW_HCI_TYPE_USB) ||
-	    rtw_is_8723bs(rtwdev))
-		timeout = msecs_to_jiffies(2500);
+	if (rtwdev->hci.type == RTW_HCI_TYPE_PCIE)
+		timeout = RTW_TX_PROBE_TIMEOUT_SHORT;
+	else
+		timeout = RTW_TX_PROBE_TIMEOUT_LONG;
 
 	mod_timer(&tx_report->purge_timer, jiffies + timeout);
 }
diff --git a/drivers/net/wireless/realtek/rtw88/tx.h b/drivers/net/wireless/realtek/rtw88/tx.h
index d34cdeca16f1..168f48e87853 100644
--- a/drivers/net/wireless/realtek/rtw88/tx.h
+++ b/drivers/net/wireless/realtek/rtw88/tx.h
@@ -7,7 +7,8 @@
 
 #define RTK_TX_MAX_AGG_NUM_MASK		0x1f
 
-#define RTW_TX_PROBE_TIMEOUT		msecs_to_jiffies(500)
+#define RTW_TX_PROBE_TIMEOUT_SHORT	msecs_to_jiffies(500)
+#define RTW_TX_PROBE_TIMEOUT_LONG	msecs_to_jiffies(2500)
 
 struct rtw_tx_desc {
 	__le32 w0;

base-commit: 2f77c66694108785a1f6ae6c5de06453e7f7a91f
-- 
2.25.1

