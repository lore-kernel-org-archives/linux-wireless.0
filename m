Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:54817 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750899AbcLLMAU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Dec 2016 07:00:20 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [RFC V3 05/11] brcmfmac: fix memory leak in brcmf_cfg80211_attach()
Date: Mon, 12 Dec 2016 11:59:51 +0000
Message-Id: <1481543997-24624-6-git-send-email-arend.vanspriel@broadcom.com> (sfid-20161212_130033_820003_88D57EFD)
In-Reply-To: <1481543997-24624-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1481543997-24624-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In brcmf_cfg80211_attach() there was one error path not properly
handled as it leaked memory allocated in brcmf_btcoex_attach().

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index ccae3bb..7ffc4ab 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6868,7 +6868,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,

 	err = brcmf_p2p_attach(cfg, p2pdev_forced);
 	if (err) {
-		brcmf_err("P2P initilisation failed (%d)\n", err);
+		brcmf_err("P2P initialisation failed (%d)\n", err);
 		goto wiphy_unreg_out;
 	}
 	err = brcmf_btcoex_attach(cfg);
@@ -6893,7 +6893,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 	err = brcmf_fweh_activate_events(ifp);
 	if (err) {
 		brcmf_err("FWEH activation failed (%d)\n", err);
-		goto wiphy_unreg_out;
+		goto detach;
 	}

 	/* Fill in some of the advertised nl80211 supported features */
@@ -6908,6 +6908,9 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,

 	return cfg;

+detach:
+	brcmf_btcoex_detach(cfg);
+	brcmf_p2p_detach(&cfg->p2p);
 wiphy_unreg_out:
 	wiphy_unregister(cfg->wiphy);
 priv_out:
--
1.9.1
