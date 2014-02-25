Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:44801 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbaBYTao (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 14:30:44 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 01/14] brcmfmac: add delay before unregistering the network device
Date: Tue, 25 Feb 2014 20:30:25 +0100
Message-ID: <1393356639-19169-2-git-send-email-arend@broadcom.com> (sfid-20140225_203048_842452_A39499B6)
In-Reply-To: <1393356639-19169-1-git-send-email-arend@broadcom.com>
References: <1393356639-19169-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Upon deleting the interface a cfg80211_disconnected() is called under
rtnl_lock. Right after the unlocking the rtnl_lock we unregister the
network device. This patch adds delay before unregister so cfg80211
can handle disconnect and notify wpa_supplicant.

Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c   |    4 ++++
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |    9 +--------
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index d4d966b..9832b11 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -848,6 +848,10 @@ void brcmf_del_if(struct brcmf_pub *drvr, s32 bssidx)
 				rtnl_lock();
 				brcmf_netdev_stop(ifp->ndev);
 				rtnl_unlock();
+				/* make sure cfg80211 can send disconnect event
+				 * before unregistering the netdevice below.
+				 */
+				msleep(100);
 			}
 		} else {
 			netif_stop_queue(ifp->ndev);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index a54db91..51ee7f0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -5443,16 +5443,9 @@ static s32 __brcmf_cfg80211_down(struct brcmf_if *ifp)
 	 * While going down, if associated with AP disassociate
 	 * from AP to save power
 	 */
-	if (check_vif_up(ifp->vif)) {
+	if (check_vif_up(ifp->vif))
 		brcmf_link_down(ifp->vif);
 
-		/* Make sure WPA_Supplicant receives all the event
-		   generated due to DISASSOC call to the fw to keep
-		   the state fw and WPA_Supplicant state consistent
-		 */
-		brcmf_delay(500);
-	}
-
 	brcmf_abort_scanning(cfg);
 	clear_bit(BRCMF_VIF_STATUS_READY, &ifp->vif->sme_state);
 
-- 
1.7.10.4

