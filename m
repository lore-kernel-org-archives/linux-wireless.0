Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4120 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756579Ab3E0TKQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 15:10:16 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for 3.10 7/7] brcmfmac: Disable powersave mode for P2P
 link.
Date: Mon, 27 May 2013 21:09:59 +0200
Message-ID: <1369681799-3163-8-git-send-email-arend@broadcom.com> (sfid-20130527_211025_420027_8CA7DA98)
In-Reply-To: <1369681799-3163-1-git-send-email-arend@broadcom.com>
References: <1369681799-3163-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

For p2p client mode powersave mode should be kept disabled. It is
working but inefficient. In general p2p links do no benefit from this
mode, because these links are setup temporarily to transfer data.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 6a87178..301e572 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2248,6 +2248,11 @@ brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *ndev,
 	}
 
 	pm = enabled ? PM_FAST : PM_OFF;
+	/* Do not enable the power save after assoc if it is a p2p interface */
+	if (ifp->vif->wdev.iftype == NL80211_IFTYPE_P2P_CLIENT) {
+		brcmf_dbg(INFO, "Do not enable power save for P2P clients\n");
+		pm = PM_OFF;
+	}
 	brcmf_dbg(INFO, "power save %s\n", (pm ? "enabled" : "disabled"));
 
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_PM, pm);
-- 
1.7.10.4


