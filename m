Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:45585 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbaEORFP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 13:05:15 -0400
Received: by mail-wi0-f177.google.com with SMTP id f8so4570720wiw.10
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 10:05:14 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/24] iwlwifi: pcie: disable BHs in iwl_pcie_txq_check_wrptrs
Date: Thu, 15 May 2014 20:04:31 +0300
Message-Id: <1400173481-9047-14-git-send-email-egrumbach@gmail.com> (sfid-20140515_190523_612771_DD734FCC)
In-Reply-To: <5374F373.6040902@gmail.com>
References: <5374F373.6040902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This fixes:

=================================
[ INFO: inconsistent lock state ]
3.14.3+ #5 Tainted: G           O
---------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
swapper/3/0 [HC0[0]:SC1[3]:HE1:SE0] takes:
 (&(&txq->lock)->rlock){+.?...}, at: [<ffffffffa059803c>] iwl_pcie_enqueue_hcmd+0x12c/0x1000 [iwlwifi]
{SOFTIRQ-ON-W} state was registered at:
  [<ffffffff810d9071>] __lock_acquire+0x5f1/0x13b0
  [<ffffffff810d9ee0>] lock_acquire+0xb0/0x1f0
  [<ffffffff817ef80e>] _raw_spin_lock+0x3e/0x80
  [<ffffffffa0598f7a>] iwl_pcie_txq_check_wrptrs+0x6a/0xb0 [iwlwifi]
  [<ffffffffa0594b5a>] iwl_pcie_irq_handler+0xdba/0x2670 [iwlwifi]
  [<ffffffff810ef1e0>] irq_thread_fn+0x20/0x50
  [<ffffffff810ef77f>] irq_thread+0x11f/0x150
  [<ffffffff810a04f0>] kthread+0xf0/0x110
  [<ffffffff817fa4bc>] ret_from_fork+0x7c/0xb0
irq event stamp: 1142192
hardirqs last  enabled at (1142192): [<ffffffff817efb6c>] _raw_spin_unlock_irq+0x2c/0x40
hardirqs last disabled at (1142191): [<ffffffff817ef9ef>] _raw_spin_lock_irq+0x1f/0x80
softirqs last  enabled at (1142188): [<ffffffff81079082>] _local_bh_enable+0x22/0x50
softirqs last disabled at (1142189): [<ffffffff8107ad35>] irq_exit+0xe5/0xf0

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&(&txq->lock)->rlock);
  <Interrupt>
    lock(&(&txq->lock)->rlock);

Fixes: ea68f46070c7 ("iwlwifi: pcie: clarify TX queue need_update handling")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/tx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 77a512a..2841af3 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -332,12 +332,12 @@ void iwl_pcie_txq_check_wrptrs(struct iwl_trans *trans)
 	for (i = 0; i < trans->cfg->base_params->num_of_queues; i++) {
 		struct iwl_txq *txq = &trans_pcie->txq[i];
 
-		spin_lock(&txq->lock);
+		spin_lock_bh(&txq->lock);
 		if (trans_pcie->txq[i].need_update) {
 			iwl_pcie_txq_inc_wr_ptr(trans, txq);
 			trans_pcie->txq[i].need_update = false;
 		}
-		spin_unlock(&txq->lock);
+		spin_unlock_bh(&txq->lock);
 	}
 }
 
-- 
1.8.3.2

