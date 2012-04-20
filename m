Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38921 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712Ab2DTSdP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 14:33:15 -0400
From: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Subject: [PATCH] ath6kl: unblock fwlog_block_read() on exit
Date: Fri, 20 Apr 2012 11:33:07 -0700
Message-ID: <1334946787-10784-1-git-send-email-c_tpeder@qca.qualcomm.com> (sfid-20120420_203319_469345_8D5A3254)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Complete the waiting fwlog_block_read on debugfs cleanup, otherwise
userspace and module unload might softlock.

Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index fed3232..15cfe30 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -1818,6 +1818,7 @@ int ath6kl_debug_init_fs(struct ath6kl *ar)
 void ath6kl_debug_cleanup(struct ath6kl *ar)
 {
 	skb_queue_purge(&ar->debug.fwlog_queue);
+	complete(&ar->debug.fwlog_completion);
 	kfree(ar->debug.roam_tbl);
 }
 
-- 
1.7.4.1

