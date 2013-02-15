Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756901Ab3BOJwb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 04:52:31 -0500
Date: Fri, 15 Feb 2013 10:52:21 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] iwl4965: fix 'phys_addr' may be used uninitialized
Message-ID: <20130215095221.GE4392@redhat.com> (sfid-20130215_105236_314622_7054C90F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This should fix:

drivers/net/wireless/iwlegacy/4965-mac.c:1847:33: warning: 'phys_addr' may be used uninitialized in this function [-Wmaybe-uninitialized]

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 7941eb3..d2ab1cf 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -1843,7 +1843,7 @@ il4965_tx_skb(struct il_priv *il,
 	il->ops->txq_attach_buf_to_tfd(il, txq, txcmd_phys, firstlen, 1, 0);
 	dma_unmap_addr_set(out_meta, mapping, txcmd_phys);
 	dma_unmap_len_set(out_meta, len, firstlen);
-	if (secondlen)
+	if (secondlen > 0)
 		il->ops->txq_attach_buf_to_tfd(il, txq, phys_addr, secondlen,
 					       0, 0);
 
-- 
1.7.11.7

