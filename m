Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:34219 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbcCAMPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 07:15:21 -0500
Received: by mail-lb0-f169.google.com with SMTP id of3so97719231lbc.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2016 04:15:20 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/2] ath10k: fix HTT Tx CE ring size
Date: Tue,  1 Mar 2016 13:16:10 +0100
Message-Id: <1456834571-9847-1-git-send-email-michal.kazior@tieto.com> (sfid-20160301_131527_823295_08CB7A4A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

QCA4019 can queue up to 2500 frames at a time.
This means it requires roughly 5000 entires on the
ring to work properly. Otherwise random tx failure
may occur.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/ce.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index 47b734ce7ecf..dac676817532 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -22,7 +22,7 @@
 
 /* Maximum number of Copy Engine's supported */
 #define CE_COUNT_MAX 12
-#define CE_HTT_H2T_MSG_SRC_NENTRIES 4096
+#define CE_HTT_H2T_MSG_SRC_NENTRIES 8192
 
 /* Descriptor rings must be aligned to this boundary */
 #define CE_DESC_RING_ALIGN	8
-- 
2.1.4

