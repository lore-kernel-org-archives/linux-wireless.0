Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779Ab3HBInz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Aug 2013 04:43:55 -0400
Date: Fri, 2 Aug 2013 10:42:36 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: ilw@linux.intel.com
Cc: linux-wireless@vger.kernel.org
Subject: Question about iwl_pcie_rxq_inc_wr_ptr
Message-ID: <20130802084235.GD8566@redhat.com> (sfid-20130802_104401_808056_8047380D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I would like to ask if below change is safe (I'm considering to do
that change on iwlegacy):

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 567e67a..1ebdb83 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -183,7 +183,7 @@ static void iwl_pcie_rxq_inc_wr_ptr(struct iwl_trans *trans, struct iwl_rxq *q)
 		} else {
 			/* Device expects a multiple of 8 */
 			q->write_actual = (q->write & ~0x7);
-			iwl_write_direct32(trans, FH_RSCSR_CHNL0_WPTR,
+			iwl_write32(trans, FH_RSCSR_CHNL0_WPTR,
 				q->write_actual);
 		}
 	}

This register seems to be only read by firmware, so maybe we can modify
it without grab nic access. We are doing that on
iwl_pcie_txq_inc_wr_ptr().

Stanislaw 
