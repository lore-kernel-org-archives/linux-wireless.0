Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534AbaBSINE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 03:13:04 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/3] iwlegacy: merge reclaim check
Date: Wed, 19 Feb 2014 09:15:10 +0100
Message-Id: <1392797711-2564-2-git-send-email-sgruszka@redhat.com> (sfid-20140219_091308_853734_732F11F4)
In-Reply-To: <1392797711-2564-1-git-send-email-sgruszka@redhat.com>
References: <1392797711-2564-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Merge reclaim check for 3945 & 4965. This add some more checks for
3945, most importantly N_RX notify.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |  9 +--------
 drivers/net/wireless/iwlegacy/4965-mac.c | 12 +-----------
 drivers/net/wireless/iwlegacy/common.h   | 14 ++++++++++++++
 3 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index 46b32d4..dc1d20c 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -1248,14 +1248,7 @@ il3945_rx_handle(struct il_priv *il)
 		len = le32_to_cpu(pkt->len_n_flags) & IL_RX_FRAME_SIZE_MSK;
 		len += sizeof(u32);	/* account for status word */
 
-		/* Reclaim a command buffer only if this packet is a response
-		 *   to a (driver-originated) command.
-		 * If the packet (e.g. Rx frame) originated from uCode,
-		 *   there is no command buffer to reclaim.
-		 * Ucode should set SEQ_RX_FRAME bit if ucode-originated,
-		 *   but apparently a few don't get set; catch them here. */
-		reclaim = !(pkt->hdr.sequence & SEQ_RX_FRAME) &&
-		    pkt->hdr.cmd != N_STATS && pkt->hdr.cmd != C_TX;
+		reclaim = il_need_reclaim(il, pkt);
 
 		/* Based on type of command response or notification,
 		 *   handle those that need handling via function in
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 43f488a..50673f7 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -4274,17 +4274,7 @@ il4965_rx_handle(struct il_priv *il)
 		len = le32_to_cpu(pkt->len_n_flags) & IL_RX_FRAME_SIZE_MSK;
 		len += sizeof(u32);	/* account for status word */
 
-		/* Reclaim a command buffer only if this packet is a response
-		 *   to a (driver-originated) command.
-		 * If the packet (e.g. Rx frame) originated from uCode,
-		 *   there is no command buffer to reclaim.
-		 * Ucode should set SEQ_RX_FRAME bit if ucode-originated,
-		 *   but apparently a few don't get set; catch them here. */
-		reclaim = !(pkt->hdr.sequence & SEQ_RX_FRAME) &&
-		    (pkt->hdr.cmd != N_RX_PHY) && (pkt->hdr.cmd != N_RX) &&
-		    (pkt->hdr.cmd != N_RX_MPDU) &&
-		    (pkt->hdr.cmd != N_COMPRESSED_BA) &&
-		    (pkt->hdr.cmd != N_STATS) && (pkt->hdr.cmd != C_TX);
+		reclaim = il_need_reclaim(il, pkt);
 
 		/* Based on type of command response or notification,
 		 *   handle those that need handling via function in
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index ad123d6..21964d2 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1978,6 +1978,20 @@ void il_wr_prph(struct il_priv *il, u32 addr, u32 val);
 u32 il_read_targ_mem(struct il_priv *il, u32 addr);
 void il_write_targ_mem(struct il_priv *il, u32 addr, u32 val);
 
+static inline bool il_need_reclaim(struct il_priv *il, struct il_rx_pkt *pkt)
+{
+	/* Reclaim a command buffer only if this packet is a response
+	 * to a (driver-originated) command. If the packet (e.g. Rx frame)
+	 * originated from uCode, there is no command buffer to reclaim.
+	 * Ucode should set SEQ_RX_FRAME bit if ucode-originated, but
+	 * apparently a few don't get set; catch them here.
+	 */
+	return !(pkt->hdr.sequence & SEQ_RX_FRAME) &&
+	       pkt->hdr.cmd != N_STATS && pkt->hdr.cmd != C_TX &&
+	       pkt->hdr.cmd != N_RX_PHY && pkt->hdr.cmd != N_RX &&
+	       pkt->hdr.cmd != N_RX_MPDU && pkt->hdr.cmd != N_COMPRESSED_BA;
+}
+
 static inline void
 _il_write8(struct il_priv *il, u32 ofs, u8 val)
 {
-- 
1.7.11.7

