Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:59873
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933485AbcILOFI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 10:05:08 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 15/15] iwlegacy: use IS_ENABLED() instead of checking for built-in or module
Date: Mon, 12 Sep 2016 10:03:46 -0400
Message-Id: <1473689026-6983-16-git-send-email-javier@osg.samsung.com> (sfid-20160912_160603_529840_C8EA8860)
In-Reply-To: <1473689026-6983-1-git-send-email-javier@osg.samsung.com>
References: <1473689026-6983-1-git-send-email-javier@osg.samsung.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The IS_ENABLED() macro checks if a Kconfig symbol has been enabled either
built-in or as a module, use that macro instead of open coding the same.

Using the macro makes the code more readable by helping abstract away some
of the Kconfig built-in and module enable details.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/net/wireless/intel/iwlegacy/common.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/common.h b/drivers/net/wireless/intel/iwlegacy/common.h
index 726ede391cb9..3bba521d2cd9 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.h
+++ b/drivers/net/wireless/intel/iwlegacy/common.h
@@ -1320,7 +1320,7 @@ struct il_priv {
 	u64 timestamp;
 
 	union {
-#if defined(CONFIG_IWL3945) || defined(CONFIG_IWL3945_MODULE)
+#if IS_ENABLED(CONFIG_IWL3945)
 		struct {
 			void *shared_virt;
 			dma_addr_t shared_phys;
@@ -1351,7 +1351,7 @@ struct il_priv {
 
 		} _3945;
 #endif
-#if defined(CONFIG_IWL4965) || defined(CONFIG_IWL4965_MODULE)
+#if IS_ENABLED(CONFIG_IWL4965)
 		struct {
 			struct il_rx_phy_res last_phy_res;
 			bool last_phy_res_valid;
-- 
2.7.4
