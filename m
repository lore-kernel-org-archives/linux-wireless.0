Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:6407 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbaAFLk5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 06:40:57 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 13/15] brcmfmac: call brcmf_cfg80211_detach() after removal of interfaces
Date: Mon, 6 Jan 2014 12:40:48 +0100
Message-ID: <1389008450-28529-14-git-send-email-arend@broadcom.com> (sfid-20140106_124106_719011_4D8FA475)
In-Reply-To: <1389008450-28529-1-git-send-email-arend@broadcom.com>
References: <1389008450-28529-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of calling brcmf_cfg80211_detach() in brcmf_del_if() when
deleting the primary interface, call it in brcmf_detach() after
deleting all interfaces.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c   |    7 +++----
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |    3 +++
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index bce0b8e..d3c4fba 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -859,8 +859,6 @@ void brcmf_del_if(struct brcmf_pub *drvr, s32 bssidx)
 		}
 		/* unregister will take care of freeing it */
 		unregister_netdev(ifp->ndev);
-		if (bssidx == 0)
-			brcmf_cfg80211_detach(drvr->config);
 	} else {
 		kfree(ifp);
 	}
@@ -963,8 +961,7 @@ int brcmf_bus_start(struct device *dev)
 fail:
 	if (ret < 0) {
 		brcmf_err("failed: %d\n", ret);
-		if (drvr->config)
-			brcmf_cfg80211_detach(drvr->config);
+		brcmf_cfg80211_detach(drvr->config);
 		if (drvr->fws) {
 			brcmf_fws_del_interface(ifp);
 			brcmf_fws_deinit(drvr);
@@ -1039,6 +1036,8 @@ void brcmf_detach(struct device *dev)
 			brcmf_del_if(drvr, i);
 		}
 
+	brcmf_cfg80211_detach(drvr->config);
+
 	brcmf_bus_detach(drvr);
 
 	brcmf_proto_detach(drvr);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 5598a20..3e3de34 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4975,6 +4975,9 @@ cfg80211_attach_out:
 
 void brcmf_cfg80211_detach(struct brcmf_cfg80211_info *cfg)
 {
+	if (!cfg)
+		return;
+
 	WARN_ON(!list_empty(&cfg->vif_list));
 	wiphy_unregister(cfg->wiphy);
 	brcmf_btcoex_detach(cfg);
-- 
1.7.10.4

