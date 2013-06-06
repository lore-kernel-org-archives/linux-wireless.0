Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4847 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932561Ab3FFLSt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 07:18:49 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 22/22] brcmfmac: add debugfs statistics for
 firmware-signalling
Date: Thu, 6 Jun 2013 13:18:07 +0200
Message-ID: <1370517487-14395-23-git-send-email-arend@broadcom.com> (sfid-20130606_131906_046072_C46FA57E)
In-Reply-To: <1370517487-14395-1-git-send-email-arend@broadcom.com>
References: <1370517487-14395-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added statistics for flow-control and packets dropped by the
driver.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c  |    8 +++++++-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |    3 +++
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   13 +++++++++----
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
index ce50686..c37b9d6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
@@ -156,8 +156,11 @@ ssize_t brcmf_debugfs_fws_stats_read(struct file *f, char __user *data,
 			"txs_suppr_core:    %u\n"
 			"txs_suppr_ps:      %u\n"
 			"txs_tossed:        %u\n"
+			"txs_host_tossed:   %u\n"
+			"bus_flow_block:    %u\n"
+			"fws_flow_block:    %u\n"
 			"send_pkts:         BK:%u BE:%u VO:%u VI:%u BCMC:%u\n"
-			"fifo_credits_sent: BK:%u BE:%u VO:%u VI:%u BCMC:%u\n",
+			"requested_sent:    BK:%u BE:%u VO:%u VI:%u BCMC:%u\n",
 			fwstats->header_pulls,
 			fwstats->header_only_pkt,
 			fwstats->tlv_parse_failed,
@@ -176,6 +179,9 @@ ssize_t brcmf_debugfs_fws_stats_read(struct file *f, char __user *data,
 			fwstats->txs_supp_core,
 			fwstats->txs_supp_ps,
 			fwstats->txs_tossed,
+			fwstats->txs_host_tossed,
+			fwstats->bus_flow_block,
+			fwstats->fws_flow_block,
 			fwstats->send_pkts[0], fwstats->send_pkts[1],
 			fwstats->send_pkts[2], fwstats->send_pkts[3],
 			fwstats->send_pkts[4],
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
index 451ebac..0af1f5d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
@@ -157,6 +157,9 @@ struct brcmf_fws_stats {
 	u32 txs_supp_core;
 	u32 txs_supp_ps;
 	u32 txs_tossed;
+	u32 txs_host_tossed;
+	u32 bus_flow_block;
+	u32 fws_flow_block;
 };
 
 struct brcmf_pub;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index b173311..d243e23 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -585,7 +585,7 @@ static int brcmf_fws_hanger_mark_suppressed(struct brcmf_fws_hanger *h,
 	if (slot_id >= BRCMF_FWS_HANGER_MAXITEMS)
 		return -ENOENT;
 
-	if (h->items[slot_id].state != BRCMF_FWS_HANGER_ITEM_STATE_INUSE) {
+	if (h->items[slot_id].state == BRCMF_FWS_HANGER_ITEM_STATE_FREE) {
 		brcmf_err("entry not in use\n");
 		return -EINVAL;
 	}
@@ -895,8 +895,10 @@ brcmf_fws_flow_control_check(struct brcmf_fws_info *fws, struct pktq *pq,
 		brcmf_txflowblock_if(ifp,
 				     BRCMF_NETIF_STOP_REASON_FWS_FC, false);
 	if (!(ifp->netif_stop & BRCMF_NETIF_STOP_REASON_FWS_FC) &&
-	    pq->len >= BRCMF_FWS_FLOWCONTROL_HIWATER)
+	    pq->len >= BRCMF_FWS_FLOWCONTROL_HIWATER) {
+		fws->stats.fws_flow_block++;
 		brcmf_txflowblock_if(ifp, BRCMF_NETIF_STOP_REASON_FWS_FC, true);
+	}
 	return;
 }
 
@@ -1297,9 +1299,10 @@ brcmf_fws_txs_process(struct brcmf_fws_info *fws, u8 flags, u32 hslot,
 	} else if (flags == BRCMF_FWS_TXSTATUS_FW_PS_SUPPRESS) {
 		fws->stats.txs_supp_ps++;
 		remove_from_hanger = false;
-	} else if ((flags == BRCMF_FWS_TXSTATUS_FW_TOSSED) ||
-		   (flags == BRCMF_FWS_TXSTATUS_HOST_TOSSED))
+	} else if (flags == BRCMF_FWS_TXSTATUS_FW_TOSSED)
 		fws->stats.txs_tossed++;
+	else if (flags == BRCMF_FWS_TXSTATUS_HOST_TOSSED)
+		fws->stats.txs_host_tossed++;
 	else
 		brcmf_err("unexpected txstatus\n");
 
@@ -2059,4 +2062,6 @@ void brcmf_fws_bus_blocked(struct brcmf_pub *drvr, bool flow_blocked)
 	fws->bus_flow_blocked = flow_blocked;
 	if (!flow_blocked)
 		brcmf_fws_schedule_deq(fws);
+	else
+		fws->stats.bus_flow_block++;
 }
-- 
1.7.10.4


