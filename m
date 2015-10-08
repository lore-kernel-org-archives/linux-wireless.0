Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:54408 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609AbbJHSd1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 14:33:27 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 11/11] brcmfmac: Properly set carrier state of netdev.
Date: Thu, 8 Oct 2015 20:33:21 +0200
Message-ID: <1444329201-3696-12-git-send-email-arend@broadcom.com> (sfid-20151008_203342_869266_72D82342)
In-Reply-To: <1444329201-3696-1-git-send-email-arend@broadcom.com>
References: <1444329201-3696-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Use the netif_carrier api to correctly set carrier state on the
different modes.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c |  4 ++++
 drivers/net/wireless/brcm80211/brcmfmac/core.c     | 25 ++++++++++++++++++----
 drivers/net/wireless/brcm80211/brcmfmac/core.h     |  8 +++++--
 3 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index ddb4e74..deb5f78 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -4251,6 +4251,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		brcmf_dbg(TRACE, "GO mode configuration complete\n");
 	}
 	set_bit(BRCMF_VIF_STATUS_AP_CREATED, &ifp->vif->sme_state);
+	brcmf_net_setcarrier(ifp, true);
 
 exit:
 	if ((err) && (!mbss)) {
@@ -4315,6 +4316,7 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 	brcmf_set_mpc(ifp, 1);
 	brcmf_configure_arp_offload(ifp, true);
 	clear_bit(BRCMF_VIF_STATUS_AP_CREATED, &ifp->vif->sme_state);
+	brcmf_net_setcarrier(ifp, false);
 
 	return err;
 }
@@ -5024,6 +5026,7 @@ brcmf_notify_connect_status(struct brcmf_if *ifp,
 				&ifp->vif->sme_state);
 		} else
 			brcmf_bss_connect_done(cfg, ndev, e, true);
+		brcmf_net_setcarrier(ifp, true);
 	} else if (brcmf_is_linkdown(e)) {
 		brcmf_dbg(CONN, "Linkdown\n");
 		if (!brcmf_is_ibssmode(ifp->vif)) {
@@ -5033,6 +5036,7 @@ brcmf_notify_connect_status(struct brcmf_if *ifp,
 		brcmf_init_prof(ndev_to_prof(ndev));
 		if (ndev != cfg_to_ndev(cfg))
 			complete(&cfg->vif_disabled);
+		brcmf_net_setcarrier(ifp, false);
 	} else if (brcmf_is_nonetwork(cfg, e)) {
 		if (brcmf_is_ibssmode(ifp->vif))
 			clear_bit(BRCMF_VIF_STATUS_CONNECTING,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.c b/drivers/net/wireless/brcm80211/brcmfmac/core.c
index 6e39121..b5ab98e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -635,8 +635,7 @@ static int brcmf_netdev_stop(struct net_device *ndev)
 
 	brcmf_cfg80211_down(ndev);
 
-	/* Set state and stop OS transmissions */
-	netif_stop_queue(ndev);
+	brcmf_net_setcarrier(ifp, false);
 
 	return 0;
 }
@@ -670,8 +669,8 @@ static int brcmf_netdev_open(struct net_device *ndev)
 		return -EIO;
 	}
 
-	/* Allow transmit calls */
-	netif_start_queue(ndev);
+	/* Clear, carrier, set when connected or AP mode. */
+	netif_carrier_off(ndev);
 	return 0;
 }
 
@@ -736,6 +735,24 @@ static void brcmf_net_detach(struct net_device *ndev)
 		brcmf_cfg80211_free_netdev(ndev);
 }
 
+void brcmf_net_setcarrier(struct brcmf_if *ifp, bool on)
+{
+	struct net_device *ndev;
+
+	brcmf_dbg(TRACE, "Enter, idx=%d carrier=%d\n", ifp->bssidx, on);
+
+	ndev = ifp->ndev;
+	brcmf_txflowblock_if(ifp, BRCMF_NETIF_STOP_REASON_DISCONNECTED, !on);
+	if (on) {
+		if (!netif_carrier_ok(ndev))
+			netif_carrier_on(ndev);
+
+	} else {
+		if (netif_carrier_ok(ndev))
+			netif_carrier_off(ndev);
+	}
+}
+
 static int brcmf_net_p2p_open(struct net_device *ndev)
 {
 	brcmf_dbg(TRACE, "Enter\n");
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.h b/drivers/net/wireless/brcm80211/brcmfmac/core.h
index f10fc37..2f9101b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.h
@@ -154,10 +154,13 @@ struct brcmf_fws_mac_descriptor;
  *	netif stopped due to firmware signalling flow control.
  * @BRCMF_NETIF_STOP_REASON_FLOW:
  *	netif stopped due to flowring full.
+ * @BRCMF_NETIF_STOP_REASON_DISCONNECTED:
+ *	netif stopped due to not being connected (STA mode).
  */
 enum brcmf_netif_stop_reason {
-	BRCMF_NETIF_STOP_REASON_FWS_FC = 1,
-	BRCMF_NETIF_STOP_REASON_FLOW = 2
+	BRCMF_NETIF_STOP_REASON_FWS_FC = BIT(0),
+	BRCMF_NETIF_STOP_REASON_FLOW = BIT(1),
+	BRCMF_NETIF_STOP_REASON_DISCONNECTED = BIT(2)
 };
 
 /**
@@ -213,5 +216,6 @@ void brcmf_txflowblock_if(struct brcmf_if *ifp,
 			  enum brcmf_netif_stop_reason reason, bool state);
 void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success);
 void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb);
+void brcmf_net_setcarrier(struct brcmf_if *ifp, bool on);
 
 #endif /* BRCMFMAC_CORE_H */
-- 
1.9.1

