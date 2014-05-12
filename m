Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:7664 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597AbaELIrn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2014 04:47:43 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Kim <dekim@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 07/14] brcmfmac: Fix reconnect failure after beacon timeout
Date: Mon, 12 May 2014 10:47:32 +0200
Message-ID: <1399884459-5048-8-git-send-email-arend@broadcom.com> (sfid-20140512_104817_611702_97E90FEC)
In-Reply-To: <1399884459-5048-1-git-send-email-arend@broadcom.com>
References: <1399884459-5048-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Kim <dekim@broadcom.com>

The DISASSOC command needs to be sent to firmware when a connection
loss is detected by firmware (e.g., beacon timeout). Otherwise the
next connect request fails due to a lingering LINK(down) event from
firmware. This patch resolves the issue by using brcmf_link_down()
handler, instead of the incomplete duplicated codes.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Daniel Kim <dekim@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index c3857c9..401529c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4687,7 +4687,6 @@ brcmf_notify_connect_status(struct brcmf_if *ifp,
 	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
 	struct ieee80211_channel *chan;
 	s32 err = 0;
-	u16 reason;
 
 	if (brcmf_is_apmode(ifp->vif)) {
 		err = brcmf_notify_connect_status_ap(cfg, ndev, e, data);
@@ -4708,16 +4707,6 @@ brcmf_notify_connect_status(struct brcmf_if *ifp,
 		brcmf_dbg(CONN, "Linkdown\n");
 		if (!brcmf_is_ibssmode(ifp->vif)) {
 			brcmf_bss_connect_done(cfg, ndev, e, false);
-			if (test_and_clear_bit(BRCMF_VIF_STATUS_CONNECTED,
-					       &ifp->vif->sme_state)) {
-				reason = 0;
-				if (((e->event_code == BRCMF_E_DEAUTH_IND) ||
-				     (e->event_code == BRCMF_E_DISASSOC_IND)) &&
-				    (e->reason != WLAN_REASON_UNSPECIFIED))
-					reason = e->reason;
-				cfg80211_disconnected(ndev, reason, NULL, 0,
-						      GFP_KERNEL);
-			}
 		}
 		brcmf_link_down(ifp->vif);
 		brcmf_init_prof(ndev_to_prof(ndev));
-- 
1.7.9.5

