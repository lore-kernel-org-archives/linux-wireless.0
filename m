Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:33109 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbbHVK6h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Aug 2015 06:58:37 -0400
Received: by pdrh1 with SMTP id h1so36038466pdr.0
        for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2015 03:58:37 -0700 (PDT)
From: Shraddha Barke <shraddha.6596@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Donald <gdonald@gmail.com>,
	linux-wireless@vger.kernel.org, Joe Perches <joe@perches.com>
Cc: Shraddha Barke <shraddha.6596@gmail.com>
Subject: [PATCH 1/4] Staging: rtl8192e: rtl_core.c: Remove unused variable
Date: Sat, 22 Aug 2015 16:28:11 +0530
Message-Id: <1440241094-5927-1-git-send-email-shraddha.6596@gmail.com> (sfid-20150822_125854_572822_3EDBD82C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch discards the variable ResetThreshold as it is not used
anywhere throughout the kernel.

Build tested it.

Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
---
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
index d6b46df..52e1e27 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
@@ -1131,7 +1131,6 @@ static enum reset_type rtl819x_TxCheckStuck(struct net_device *dev)
 {
 	struct r8192_priv *priv = rtllib_priv(dev);
 	u8	QueueID;
-	u8	ResetThreshold = NIC_SEND_HANG_THRESHOLD_POWERSAVE;
 	bool	bCheckFwTxCnt = false;
 	struct rtl8192_tx_ring  *ring = NULL;
 	struct sk_buff *skb = NULL;
@@ -1140,13 +1139,10 @@ static enum reset_type rtl819x_TxCheckStuck(struct net_device *dev)
 
 	switch (priv->rtllib->ps) {
 	case RTLLIB_PS_DISABLED:
-		ResetThreshold = NIC_SEND_HANG_THRESHOLD_NORMAL;
 		break;
 	case (RTLLIB_PS_MBCAST|RTLLIB_PS_UNICAST):
-		ResetThreshold = NIC_SEND_HANG_THRESHOLD_POWERSAVE;
 		break;
 	default:
-		ResetThreshold = NIC_SEND_HANG_THRESHOLD_POWERSAVE;
 		break;
 	}
 	spin_lock_irqsave(&priv->irq_th_lock, flags);
-- 
2.1.4

