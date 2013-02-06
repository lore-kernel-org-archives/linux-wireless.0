Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4281 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756378Ab3BFRlJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 12:41:09 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 03/12] brcmfmac: Use struct brcmf_if in
 brcmf_configure_opensecurity.
Date: Wed, 6 Feb 2013 18:40:38 +0100
Message-ID: <1360172447-2424-4-git-send-email-arend@broadcom.com> (sfid-20130206_184125_043970_9DF5FE05)
In-Reply-To: <1360172447-2424-1-git-send-email-arend@broadcom.com>
References: <1360172447-2424-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 62a528e..0f170cb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2968,9 +2968,8 @@ static int brcmf_cfg80211_testmode(struct wiphy *wiphy, void *data, int len)
 }
 #endif
 
-static s32 brcmf_configure_opensecurity(struct net_device *ndev, s32 bssidx)
+static s32 brcmf_configure_opensecurity(struct brcmf_if *ifp)
 {
-	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err;
 
 	/* set auth */
@@ -3433,7 +3432,6 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	struct brcmf_tlv *rsn_ie;
 	struct brcmf_vs_tlv *wpa_ie;
 	struct brcmf_join_params join_params;
-	s32 bssidx = 0;
 
 	brcmf_dbg(TRACE, "channel_type=%d, beacon_interval=%d, dtim_period=%d,\n",
 		  cfg80211_get_chandef_type(&settings->chandef),
@@ -3507,7 +3505,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		}
 	} else {
 		brcmf_dbg(TRACE, "No WPA(2) IEs found\n");
-		brcmf_configure_opensecurity(ndev, bssidx);
+		brcmf_configure_opensecurity(ifp);
 	}
 	/* Set Beacon IEs to FW */
 	err = brcmf_vif_set_mgmt_ie(ndev_to_vif(ndev),
-- 
1.7.10.4


