Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756792Ab1KRIW7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:22:59 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8MxUr032507
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:22:59 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 61/77] iwlegacy: use FH39_ prefix in 3945 code
Date: Fri, 18 Nov 2011 09:22:23 +0100
Message-Id: <1321604559-10707-61-git-send-email-sgruszka@redhat.com> (sfid-20111118_092304_159577_22E03213)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |    2 +-
 drivers/net/wireless/iwlegacy/3945.h     |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index 3c89999..ffd6ddf 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -1528,7 +1528,7 @@ static void il3945_irq_tasklet(struct il_priv *il)
 	if (inta & ~il->inta_mask) {
 		IL_WARN("Disabled INTA bits 0x%08x were pending\n",
 			 inta & ~il->inta_mask);
-		IL_WARN("   with FH_INT = 0x%08x\n", inta_fh);
+		IL_WARN("   with inta_fh = 0x%08x\n", inta_fh);
 	}
 
 	/* Re-enable all interrupts */
diff --git a/drivers/net/wireless/iwlegacy/3945.h b/drivers/net/wireless/iwlegacy/3945.h
index 33233ab..ed367bb 100644
--- a/drivers/net/wireless/iwlegacy/3945.h
+++ b/drivers/net/wireless/iwlegacy/3945.h
@@ -481,8 +481,8 @@ static inline int il3945_hw_valid_rtc_data_addr(u32 addr)
 		addr < IL39_RTC_DATA_UPPER_BOUND);
 }
 
-/* Base physical address of il3945_shared is provided to FH_TSSR_CBB_BASE
- * and &il3945_shared.rx_read_ptr[0] is provided to FH_RCSR_RPTR_ADDR(0) */
+/* Base physical address of il3945_shared is provided to FH39_TSSR_CBB_BASE
+ * and &il3945_shared.rx_read_ptr[0] is provided to FH39_RCSR_RPTR_ADDR(0) */
 struct il3945_shared {
 	__le32 tx_base_ptr[8];
 } __packed;
-- 
1.7.1

