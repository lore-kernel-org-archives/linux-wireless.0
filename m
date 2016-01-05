Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:31395 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbcAEKGB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 05:06:01 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 6/6] brcmfmac: Do not handle link downs for ibss.
Date: Tue, 5 Jan 2016 11:05:50 +0100
Message-ID: <1451988350-2197-7-git-send-email-arend@broadcom.com> (sfid-20160105_110633_958505_5ADEBBF3)
In-Reply-To: <1451988350-2197-1-git-send-email-arend@broadcom.com>
References: <1451988350-2197-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Sometimes on module reload and reconnect to ibss a deauth from
other station can be received. This is treated as a link down but
for ibss this is wrong. It will close the interface and no data
is possible. Ignore the firmware generated link down events in
ibss mode, as ibss is always teared down by cfg80211.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 84788ea..7b01e4d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -1454,6 +1454,7 @@ brcmf_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *ndev)
 	}
 
 	brcmf_link_down(ifp->vif, WLAN_REASON_DEAUTH_LEAVING);
+	brcmf_net_setcarrier(ifp, false);
 
 	brcmf_dbg(TRACE, "Exit\n");
 
@@ -5248,12 +5249,13 @@ brcmf_notify_connect_status(struct brcmf_if *ifp,
 		brcmf_dbg(CONN, "Linkdown\n");
 		if (!brcmf_is_ibssmode(ifp->vif)) {
 			brcmf_bss_connect_done(cfg, ndev, e, false);
+			brcmf_link_down(ifp->vif,
+					brcmf_map_fw_linkdown_reason(e));
+			brcmf_init_prof(ndev_to_prof(ndev));
+			if (ndev != cfg_to_ndev(cfg))
+				complete(&cfg->vif_disabled);
+			brcmf_net_setcarrier(ifp, false);
 		}
-		brcmf_link_down(ifp->vif, brcmf_map_fw_linkdown_reason(e));
-		brcmf_init_prof(ndev_to_prof(ndev));
-		if (ndev != cfg_to_ndev(cfg))
-			complete(&cfg->vif_disabled);
-		brcmf_net_setcarrier(ifp, false);
 	} else if (brcmf_is_nonetwork(cfg, e)) {
 		if (brcmf_is_ibssmode(ifp->vif))
 			clear_bit(BRCMF_VIF_STATUS_CONNECTING,
-- 
1.9.1

