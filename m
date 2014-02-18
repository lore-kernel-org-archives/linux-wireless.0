Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45288 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbaBRQ4m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 11:56:42 -0500
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath10k:  make TARGET_NUM_PEERS match WMI_MAX_KEY_INDEX.
Date: Tue, 18 Feb 2014 08:56:07 -0800
Message-Id: <1392742567-6134-1-git-send-email-greearb@candelatech.com> (sfid-20140218_175653_868230_583FD2D7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This appears to fix the problem of running out of keys
in the firmware.  Possibly it only hides the problem,
however.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/hw.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 89167d5..dede8e0 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -83,7 +83,7 @@ enum ath10k_mcast2ucast_mode {
 #define TARGET_NUM_PEERS			16
 #define TARGET_NUM_OFFLOAD_PEERS		0
 #define TARGET_NUM_OFFLOAD_REORDER_BUFS         0
-#define TARGET_NUM_PEER_KEYS			2
+#define TARGET_NUM_PEER_KEYS			(WMI_MAX_KEY_INDEX + 1) /* 4 */
 #define TARGET_NUM_TIDS		(2 * ((TARGET_NUM_PEERS) + (TARGET_NUM_VDEVS)))
 #define TARGET_TX_CHAIN_MASK			(BIT(0) | BIT(1) | BIT(2))
 #define TARGET_RX_CHAIN_MASK			(BIT(0) | BIT(1) | BIT(2))
@@ -125,7 +125,7 @@ enum ath10k_mcast2ucast_mode {
 
 #define TARGET_10X_NUM_OFFLOAD_PEERS		0
 #define TARGET_10X_NUM_OFFLOAD_REORDER_BUFS	0
-#define TARGET_10X_NUM_PEER_KEYS		2
+#define TARGET_10X_NUM_PEER_KEYS		(WMI_MAX_KEY_INDEX + 1) /* 4 */
 #define TARGET_10X_NUM_TIDS			256
 #define TARGET_10X_TX_CHAIN_MASK		(BIT(0) | BIT(1) | BIT(2))
 #define TARGET_10X_RX_CHAIN_MASK		(BIT(0) | BIT(1) | BIT(2))
-- 
1.7.11.7

