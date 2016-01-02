Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:32579 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbcABIlw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2016 03:41:52 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH V2 5/7] brcmfmac: Fix warn trace on module unload while in ibss mode
Date: Sat, 2 Jan 2016 09:41:40 +0100
Message-ID: <1451724102-21911-6-git-send-email-arend@broadcom.com> (sfid-20160102_094230_803849_B469BB75)
In-Reply-To: <1451724102-21911-1-git-send-email-arend@broadcom.com>
References: <1451724102-21911-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

When the driver is being unloaded a situation can occur where the
wirelesss core (cfg80211) wants to remove the ibss, but the state
of brcmfmac has already been set to down. When an error is
returned in that situation then that will result in a stack
trace on removal of the wiphy object. This is avoided by
returning 0 when device is down on a leave_ibss call.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 05843b7..dc14dd4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -1448,8 +1448,13 @@ brcmf_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *ndev)
 	struct brcmf_if *ifp = netdev_priv(ndev);
 
 	brcmf_dbg(TRACE, "Enter\n");
-	if (!check_vif_up(ifp->vif))
-		return -EIO;
+	if (!check_vif_up(ifp->vif)) {
+		/* When driver is being unloaded, it can end up here. If an
+		 * error is returned then later on a debug trace in the wireless
+		 * core module will be printed. To avoid this 0 is returned.
+		 */
+		return 0;
+	}
 
 	brcmf_link_down(ifp->vif, WLAN_REASON_DEAUTH_LEAVING);
 
-- 
1.9.1

