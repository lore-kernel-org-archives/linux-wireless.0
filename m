Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59473 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278Ab1IOPAu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 11:00:50 -0400
From: Vivek Natarajan <nataraja@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] ath6kl: deinitialise wiphy on error
Date: Thu, 15 Sep 2011 20:30:43 +0530
Message-ID: <1316098843-6660-1-git-send-email-nataraja@qca.qualcomm.com> (sfid-20110915_170053_449672_9CA4BAE1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the following panic observed on card removal.

BUG: unable to handle kernel paging request at f86e22ac
EIP is at wiphy_update_regulatory+0x252/0x590 [cfg80211]
Call Trace:
 [<f92fb9e5>] set_regdom+0x165/0x600 [cfg80211]
 [<c02057ba>] ? __kmalloc+0x10a/0x190
 [<c0366557>] ? nla_parse+0xb7/0xd0
 [<f9300b92>] ? T.1400+0x12/0x20 [cfg80211]
 [<f9300c84>] nl80211_set_reg+0xe4/0x270 [cfg80211]
 [<f92fe560>] ? nl80211_pre_doit+0x0/0x160 [cfg80211]
 [<c050bdeb>] genl_rcv_msg+0x23b/0x280
 [<c050bbb0>] ? genl_rcv_msg+0x0/0x280
 [<c050ab76>] netlink_rcv_skb+0x86/0xb0
 [<c050bb80>] ? genl_rcv+0x0/0x30
 [<c050bb9c>] genl_rcv+0x1c/0x30

Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/sdio.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 0cce801..4724ddf 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -25,6 +25,7 @@
 #include "hif-ops.h"
 #include "target.h"
 #include "debug.h"
+#include "cfg80211.h"
 
 struct ath6kl_sdio {
 	struct sdio_func *func;
@@ -816,7 +817,7 @@ static int ath6kl_sdio_probe(struct sdio_func *func,
 			ath6kl_err("Failed to enable 4-bit async irq mode %d\n",
 				   ret);
 			sdio_release_host(func);
-			goto err_dma;
+			goto err_cfg80211;
 		}
 
 		ath6kl_dbg(ATH6KL_DBG_TRC, "4-bit async irq mode enabled\n");
@@ -829,7 +830,7 @@ static int ath6kl_sdio_probe(struct sdio_func *func,
 
 	ret = ath6kl_sdio_power_on(ar_sdio);
 	if (ret)
-		goto err_dma;
+		goto err_cfg80211;
 
 	sdio_claim_host(func);
 
@@ -853,6 +854,8 @@ static int ath6kl_sdio_probe(struct sdio_func *func,
 
 err_off:
 	ath6kl_sdio_power_off(ar_sdio);
+err_cfg80211:
+	ath6kl_cfg80211_deinit(ar_sdio->ar);
 err_dma:
 	kfree(ar_sdio->dma_buffer);
 err_hif:
-- 
1.7.1

