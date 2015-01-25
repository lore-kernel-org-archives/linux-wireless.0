Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:13244 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759945AbbAYTbt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 14:31:49 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 07/14] brcmfmac: Reopen netdev queue on bus state data.
Date: Sun, 25 Jan 2015 20:31:36 +0100
Message-ID: <1422214303-7816-8-git-send-email-arend@broadcom.com> (sfid-20150125_203230_823289_8C6FC268)
In-Reply-To: <1422214303-7816-1-git-send-email-arend@broadcom.com>
References: <1422214303-7816-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

During suspend the bus state is put in the down state. When data
is being transmitted during this state then the netdev queue will
be close. This patch will wake the queue on state data if the
queue was closed.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bus.h  | 10 +++-------
 drivers/net/wireless/brcm80211/brcmfmac/core.c | 21 +++++++++++++++++++++
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/brcm80211/brcmfmac/bus.h
index 55d36ff..89e6a4d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bus.h
@@ -185,13 +185,6 @@ void brcmf_bus_wowl_config(struct brcmf_bus *bus, bool enabled)
 		bus->ops->wowl_config(bus->dev, enabled);
 }
 
-static inline void brcmf_bus_change_state(struct brcmf_bus *bus,
-					  enum brcmf_bus_state new_state)
-{
-	brcmf_dbg(TRACE, "%d -> %d\n", bus->state, new_state);
-	bus->state = new_state;
-}
-
 /*
  * interface functions from common layer
  */
@@ -214,6 +207,9 @@ void brcmf_txflowblock(struct device *dev, bool state);
 /* Notify the bus has transferred the tx packet to firmware */
 void brcmf_txcomplete(struct device *dev, struct sk_buff *txp, bool success);
 
+/* Configure the "global" bus state used by upper layers */
+void brcmf_bus_change_state(struct brcmf_bus *bus, enum brcmf_bus_state state);
+
 int brcmf_bus_start(struct device *dev);
 s32 brcmf_iovar_data_set(struct device *dev, char *name, void *data, u32 len);
 void brcmf_bus_add_txhdrlen(struct device *dev, uint len);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.c b/drivers/net/wireless/brcm80211/brcmfmac/core.c
index ff8c97b..b8520c3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -1106,6 +1106,27 @@ int brcmf_netdev_wait_pend8021x(struct brcmf_if *ifp)
 	return !err;
 }
 
+void brcmf_bus_change_state(struct brcmf_bus *bus, enum brcmf_bus_state state)
+{
+	struct brcmf_pub *drvr = bus->drvr;
+	struct net_device *ndev;
+	int ifidx;
+
+	brcmf_dbg(TRACE, "%d -> %d\n", bus->state, state);
+	bus->state = state;
+
+	if (state == BRCMF_BUS_UP) {
+		for (ifidx = 0; ifidx < BRCMF_MAX_IFS; ifidx++) {
+			if ((drvr->iflist[ifidx]) &&
+			    (drvr->iflist[ifidx]->ndev)) {
+				ndev = drvr->iflist[ifidx]->ndev;
+				if (netif_queue_stopped(ndev))
+					netif_wake_queue(ndev);
+			}
+		}
+	}
+}
+
 static void brcmf_driver_register(struct work_struct *work)
 {
 #ifdef CONFIG_BRCMFMAC_SDIO
-- 
1.9.1

