Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:34680 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab0CWUvX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Mar 2010 16:51:23 -0400
Received: by bwz1 with SMTP id 1so2263726bwz.21
        for <linux-wireless@vger.kernel.org>; Tue, 23 Mar 2010 13:51:22 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] ar9170usb: fix panic triggered by undersized rxstream buffer
Date: Tue, 23 Mar 2010 21:51:14 +0100
Cc: Christian Mehlis <mehlis@inf.fu-berlin.de>,
	John W Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003232151.14531.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While ar9170's USB transport packet size is currently set to 8KiB,
the PHY is capable of receiving AMPDUs with up to 64KiB.
Such a large frame will be split over several rx URBs and
exceed the previously allocated space for rx stream reconstruction.

This patch increases the buffer size to 64KiB which is
in fact the phy & rx stream designed size limit.

Cc: stable@kernel.org
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=15591
Reported-by: Christian Mehlis <mehlis@inf.fu-berlin.de>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/ath/ar9170/hw.h b/drivers/net/wireless/ath/ar9170/hw.h
index 0a1d4c2..06f1f3c 100644
--- a/drivers/net/wireless/ath/ar9170/hw.h
+++ b/drivers/net/wireless/ath/ar9170/hw.h
@@ -425,5 +425,6 @@ enum ar9170_txq {
 
 #define AR9170_TXQ_DEPTH	32
 #define AR9170_TX_MAX_PENDING	128
+#define AR9170_RX_STREAM_MAX_SIZE 65535
 
 #endif /* __AR9170_HW_H */
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index 257c734..e017119 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -2515,7 +2515,7 @@ void *ar9170_alloc(size_t priv_size)
 	 * tends to split the streams into separate rx descriptors.
 	 */
 
-	skb = __dev_alloc_skb(AR9170_MAX_RX_BUFFER_SIZE, GFP_KERNEL);
+	skb = __dev_alloc_skb(AR9170_RX_STREAM_MAX_SIZE, GFP_KERNEL);
 	if (!skb)
 		goto err_nomem;
 
