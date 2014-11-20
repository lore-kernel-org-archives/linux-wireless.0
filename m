Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:16085 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757000AbaKTV1G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2014 16:27:06 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 4/4] brcmfmac: correct .disconnect() callback while connecting
Date: Thu, 20 Nov 2014 22:27:02 +0100
Message-ID: <1416518822-29585-5-git-send-email-arend@broadcom.com> (sfid-20141120_222712_983411_1B03A37B)
In-Reply-To: <1416518822-29585-1-git-send-email-arend@broadcom.com>
References: <1416518822-29585-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the driver has sent a join iovar to the firmware it waits
for the events to report result of the connection. However, the
wpa_supplicant will request a .disconnect() after a timeout. So
upon calling .disconnect() the interface state may still be
CONNECTING. Clear the CONNECTING bit as well.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index d1928de..0ea3125 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -1815,6 +1815,7 @@ brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *ndev,
 		return -EIO;
 
 	clear_bit(BRCMF_VIF_STATUS_CONNECTED, &ifp->vif->sme_state);
+	clear_bit(BRCMF_VIF_STATUS_CONNECTING, &ifp->vif->sme_state);
 	cfg80211_disconnected(ndev, reason_code, NULL, 0, GFP_KERNEL);
 
 	memcpy(&scbval.ea, &profile->bssid, ETH_ALEN);
-- 
1.9.1

