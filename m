Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62495 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077Ab1CGCOo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 21:14:44 -0500
Received: by mail-yw0-f46.google.com with SMTP id 3so1451423ywj.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 18:14:43 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19828.16267.98904.690249@gargle.gargle.HOWL>
Date: Mon, 7 Mar 2011 07:44:35 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC 18/34] ath9k_htc: Reduce TX queue size
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

The current max queue length of 1024 is quite large
and unnecessary. 256 suffices well enough even for high
throughput situations.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wireless/ath/ath9k/hif_usb.h
index 7b9d863..f82b32b 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.h
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
@@ -31,7 +31,7 @@
 
 /* FIXME: Verify these numbers (with Windows) */
 #define MAX_TX_URB_NUM  8
-#define MAX_TX_BUF_NUM  1024
+#define MAX_TX_BUF_NUM  256
 #define MAX_TX_BUF_SIZE 32768
 #define MAX_TX_AGGR_NUM 20
 
-- 
1.7.4.1

