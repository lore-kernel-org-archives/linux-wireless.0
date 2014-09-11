Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:44312 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757397AbaIKUvi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 16:51:38 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH for-3.17 3/3] brcmfmac: obtain ifp through wdev structure
Date: Thu, 11 Sep 2014 22:51:32 +0200
Message-ID: <1410468692-20852-4-git-send-email-arend@broadcom.com> (sfid-20140911_225145_692542_6A5742AF)
In-Reply-To: <1410468692-20852-1-git-send-email-arend@broadcom.com>
References: <1410468692-20852-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For P2P_DEVICE interface the function brcmf_cfg80211_update_proto_addr_mode()
resulted in a crash, because it assumed wdev->netdev would be valid. The
ifp should be obtained through the driver vif structure which contains the
wireless_dev.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 2e134a6..f3a9804 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -497,8 +497,11 @@ brcmf_configure_arp_offload(struct brcmf_if *ifp, bool enable)
 static void
 brcmf_cfg80211_update_proto_addr_mode(struct wireless_dev *wdev)
 {
-	struct net_device *ndev = wdev->netdev;
-	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_cfg80211_vif *vif;
+	struct brcmf_if *ifp;
+
+	vif = container_of(wdev, struct brcmf_cfg80211_vif, wdev);
+	ifp = vif->ifp;
 
 	if ((wdev->iftype == NL80211_IFTYPE_ADHOC) ||
 	    (wdev->iftype == NL80211_IFTYPE_AP) ||
-- 
1.9.1

