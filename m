Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4648 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760205Ab3BHO4m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 09:56:42 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 23/27] brcmfmac: Remove sleep on del_station.
Date: Fri, 8 Feb 2013 15:53:58 +0100
Message-ID: <1360335242-12608-24-git-send-email-arend@broadcom.com> (sfid-20130208_163816_641538_F1E7CAAC)
In-Reply-To: <1360335242-12608-1-git-send-email-arend@broadcom.com>
References: <1360335242-12608-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Currently there is a sleep after disconnect on del_station. This
timeout is not needed (anymore) and is causing problems with p2p
setup, because remote side disconnects then supplicant will do
del_station and while it waits the 400ms remote side will already
reconnect and that is something supplicant cant handle.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index e7ef827..f283a7e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3895,12 +3895,7 @@ brcmf_cfg80211_del_station(struct wiphy *wiphy, struct net_device *ndev,
 				     &scbval, sizeof(scbval));
 	if (err)
 		brcmf_err("SCB_DEAUTHENTICATE_FOR_REASON failed %d\n", err);
-	/*
-	 * Wait for the deauth event to come, supplicant will do the
-	 * delete iface immediately and we will have problem in sending
-	 * deauth frame if we delete the bss in firmware
-	 */
-	brcmf_delay(400);
+
 	brcmf_dbg(TRACE, "Exit\n");
 	return err;
 }
-- 
1.7.10.4


