Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:63709 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbaA2Occ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 09:32:32 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Kim <dekim@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 13/14] brcmfmac: correct setting of WEP broadcast/unicast keys
Date: Wed, 29 Jan 2014 15:32:23 +0100
Message-ID: <1391005944-3220-14-git-send-email-arend@broadcom.com> (sfid-20140129_153237_656536_C5B9FE2B)
In-Reply-To: <1391005944-3220-1-git-send-email-arend@broadcom.com>
References: <1391005944-3220-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Kim <dekim@broadcom.com>

The brcmf_add_keyext() is for setting per-station key for cipher
algorithms such as WPA1/WPA2 and should not be used to set
WEP broadcast/unicast keys. This patch fixes connect failure
problem with AP using 802.1x-WEP.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Daniel Kim <dekim@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 843f1c7..fa42c0d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -1981,7 +1981,9 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
-	if (mac_addr) {
+	if (mac_addr &&
+		(params->cipher != WLAN_CIPHER_SUITE_WEP40) &&
+		(params->cipher != WLAN_CIPHER_SUITE_WEP104)) {
 		brcmf_dbg(TRACE, "Exit");
 		return brcmf_add_keyext(wiphy, ndev, key_idx, mac_addr, params);
 	}
-- 
1.7.10.4

