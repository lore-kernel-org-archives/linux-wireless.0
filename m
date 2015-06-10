Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:18823 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbbFJWMb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 18:12:31 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 7/7] brcmfmac: assure p2pdev is unregistered upon driver unload
Date: Thu, 11 Jun 2015 00:12:23 +0200
Message-ID: <1433974343-16982-8-git-send-email-arend@broadcom.com> (sfid-20150611_001242_964564_6AC03F02)
In-Reply-To: <1433974343-16982-1-git-send-email-arend@broadcom.com>
References: <1433974343-16982-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When unloading the driver with a p2pdev interface it resulted in
a warning upon calling wiphy_unregister() and subsequently a crash
in the driver. This patch assures the p2pdev is unregistered calling
unregister_wdev() before doing the wiphy_unregister().

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 4 +---
 drivers/net/wireless/brcm80211/brcmfmac/core.c     | 1 +
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      | 6 ++++--
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index 6e45b40..d86d1f1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -6207,10 +6207,8 @@ void brcmf_cfg80211_detach(struct brcmf_cfg80211_info *cfg)
 	if (!cfg)
 		return;
 
-	WARN_ON(!list_empty(&cfg->vif_list));
-	wiphy_unregister(cfg->wiphy);
 	brcmf_btcoex_detach(cfg);
-	brcmf_p2p_detach(&cfg->p2p);
+	wiphy_unregister(cfg->wiphy);
 	wl_deinit_priv(cfg);
 	brcmf_free_wiphy(cfg->wiphy);
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.c b/drivers/net/wireless/brcm80211/brcmfmac/core.c
index 8cf4a1e..866b818 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -1098,6 +1098,7 @@ void brcmf_detach(struct device *dev)
 
 	/* stop firmware event handling */
 	brcmf_fweh_detach(drvr);
+	brcmf_p2p_detach(&drvr->config->p2p);
 
 	brcmf_bus_change_state(bus_if, BRCMF_BUS_DOWN);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index 920fcd9..2e1598f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
+#include <linux/rtnetlink.h>
 #include <net/cfg80211.h>
 
 #include <brcmu_wifi.h>
@@ -2421,8 +2422,9 @@ void brcmf_p2p_detach(struct brcmf_p2p_info *p2p)
 		brcmf_p2p_cancel_remain_on_channel(vif->ifp);
 		brcmf_p2p_deinit_discovery(p2p);
 		/* remove discovery interface */
-		brcmf_free_vif(vif);
-		p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif = NULL;
+		rtnl_lock();
+		brcmf_p2p_delete_p2pdev(p2p, vif);
+		rtnl_unlock();
 	}
 	/* just set it all to zero */
 	memset(p2p, 0, sizeof(*p2p));
-- 
1.9.1

