Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3394 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594Ab1EMKAF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 06:00:05 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 12/32] staging: brcm80211: removed unused struct
 net_device_stats related code
Date: Fri, 13 May 2011 11:59:32 +0200
Message-ID: <1305280792-9475-12-git-send-email-arend@broadcom.com> (sfid-20110513_120014_344644_A1C104E0)
In-Reply-To: <1305280792-9475-1-git-send-email-arend@broadcom.com>
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Variables were set but never read.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c |   29 ----------------------
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.h |    4 ---
 2 files changed, 0 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index 5c988cd..df98bb8 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -1731,35 +1731,6 @@ void wl_free_timer(struct wl_info *wl, struct wl_timer *t)
  */
 static int wl_linux_watchdog(void *ctx)
 {
-	struct wl_info *wl = (struct wl_info *) ctx;
-	struct wl_cnt *cnt;
-	struct net_device_stats *stats = NULL;
-	uint id;
-	/* refresh stats */
-	if (wl->pub->up) {
-		cnt = wl->pub->_cnt;
-		id = 1 - wl->stats_id;
-		stats = &wl->stats_watchdog[id];
-		stats->rx_packets = cnt->rxframe;
-		stats->tx_packets = cnt->txframe;
-		stats->rx_bytes = cnt->rxbyte;
-		stats->tx_bytes = cnt->txbyte;
-		stats->rx_errors = cnt->rxerror;
-		stats->tx_errors = cnt->txerror;
-		stats->collisions = 0;
-
-		stats->rx_length_errors = 0;
-		stats->rx_over_errors = cnt->rxoflo;
-		stats->rx_crc_errors = cnt->rxcrc;
-		stats->rx_frame_errors = 0;
-		stats->rx_fifo_errors = cnt->rxoflo;
-		stats->rx_missed_errors = 0;
-
-		stats->tx_fifo_errors = cnt->txuflo;
-
-		wl->stats_id = id;
-	}
-
 	return 0;
 }
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.h b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.h
index e7e9516..e703d8b 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.h
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.h
@@ -67,10 +67,6 @@ struct wl_info {
 #ifdef LINUXSTA_PS
 	u32 pci_psstate[16];	/* pci ps-state save/restore */
 #endif
-	/* RPC, handle, lock, txq, workitem */
-	uint stats_id;		/* the current set of stats */
-	/* ping-pong stats counters updated by Linux watchdog */
-	struct net_device_stats stats_watchdog[2];
 	struct wl_firmware fw;
 	struct wiphy *wiphy;
 };
-- 
1.7.4.1


