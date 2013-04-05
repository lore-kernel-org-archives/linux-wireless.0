Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1822 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162012Ab3DEI6J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 04:58:09 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 15/16] brcmfmac: obtain wdev using vif object in action
 frame rx
Date: Fri, 5 Apr 2013 10:57:53 +0200
Message-ID: <1365152274-4252-16-git-send-email-arend@broadcom.com> (sfid-20130405_111304_618910_04ECB99A)
In-Reply-To: <1365152274-4252-1-git-send-email-arend@broadcom.com>
References: <1365152274-4252-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function brcmf_p2p_notify_action_frame_rx() the wireless_dev
is needed to pass the action frame to cfg80211. The wireless_dev
is held in brcmf_cfg80211_vif object. Use that instead of the
ieee80211_ptr in net_device as P2P_DEVICE interface does not have
a net_device associated with it.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index 6f16556..94ff045 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -1431,7 +1431,8 @@ int brcmf_p2p_notify_action_frame_rx(struct brcmf_if *ifp,
 					      CHSPEC_IS2G(chanspec) ?
 					      IEEE80211_BAND_2GHZ :
 					      IEEE80211_BAND_5GHZ);
-	wdev = ifp->ndev->ieee80211_ptr;
+
+	wdev = &ifp->vif->wdev;
 	cfg80211_rx_mgmt(wdev, freq, 0, (u8 *)mgmt_frame, mgmt_frame_len,
 			 GFP_ATOMIC);
 
-- 
1.7.10.4


