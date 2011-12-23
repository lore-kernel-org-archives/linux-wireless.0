Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180Ab1LWHOT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 02:14:19 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 07/10] iwlegacy: 4965: remove one il4965_hdl_beacon
Date: Fri, 23 Dec 2011 08:13:47 +0100
Message-Id: <1324624430-3688-7-git-send-email-sgruszka@redhat.com> (sfid-20111223_081422_122232_841C216A)
In-Reply-To: <1324624430-3688-1-git-send-email-sgruszka@redhat.com>
References: <1324624430-3688-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have two such functions.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c |    3 +--
 drivers/net/wireless/iwlegacy/4965.c     |   19 -------------------
 2 files changed, 1 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index cefc623..1667232 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -3780,13 +3780,12 @@ il4965_hdl_beacon(struct il_priv *il, struct il_rx_buf *rxb)
 #ifdef CONFIG_IWLEGACY_DEBUG
 	u8 rate = il4965_hw_get_rate(beacon->beacon_notify_hdr.rate_n_flags);
 
-	D_RX("beacon status %x retries %d iss %d " "tsf %d %d rate %d\n",
+	D_RX("beacon status %x retries %d iss %d tsf:0x%.8x%.8x rate %d\n",
 	     le32_to_cpu(beacon->beacon_notify_hdr.u.status) & TX_STATUS_MSK,
 	     beacon->beacon_notify_hdr.failure_frame,
 	     le32_to_cpu(beacon->ibss_mgr_status),
 	     le32_to_cpu(beacon->high_tsf), le32_to_cpu(beacon->low_tsf), rate);
 #endif
-
 	il->ibss_manager = le32_to_cpu(beacon->ibss_mgr_status);
 }
 
diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index 84c54dc..cacbc03 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -2114,24 +2114,6 @@ il4965_hdl_tx(struct il_priv *il, struct il_rx_buf *rxb)
 	spin_unlock_irqrestore(&il->sta_lock, flags);
 }
 
-static void
-il4965_hdl_beacon(struct il_priv *il, struct il_rx_buf *rxb)
-{
-	struct il_rx_pkt *pkt = rxb_addr(rxb);
-	struct il4965_beacon_notif *beacon = (void *)pkt->u.raw;
-	u8 rate __maybe_unused =
-	    il4965_hw_get_rate(beacon->beacon_notify_hdr.rate_n_flags);
-
-	D_RX("beacon status %#x, retries:%d ibssmgr:%d "
-	     "tsf:0x%.8x%.8x rate:%d\n",
-	     le32_to_cpu(beacon->beacon_notify_hdr.u.status) & TX_STATUS_MSK,
-	     beacon->beacon_notify_hdr.failure_frame,
-	     le32_to_cpu(beacon->ibss_mgr_status),
-	     le32_to_cpu(beacon->high_tsf), le32_to_cpu(beacon->low_tsf), rate);
-
-	il->ibss_manager = le32_to_cpu(beacon->ibss_mgr_status);
-}
-
 /* Set up 4965-specific Rx frame reply handlers */
 static void
 il4965_handler_setup(struct il_priv *il)
@@ -2140,7 +2122,6 @@ il4965_handler_setup(struct il_priv *il)
 	il->handlers[N_RX] = il4965_hdl_rx;
 	/* Tx response */
 	il->handlers[C_TX] = il4965_hdl_tx;
-	il->handlers[N_BEACON] = il4965_hdl_beacon;
 }
 
 static struct il_hcmd_ops il4965_hcmd = {
-- 
1.7.4.4

