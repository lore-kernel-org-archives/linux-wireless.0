Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [157.95.53.9] ([157.95.53.9]:56086 "HELO twsta8-Latitude-E6420"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1750708AbcHKGI6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 02:08:58 -0400
From: Wright Feng <wright.feng@cypress.com>
To: brcm80211-dev-list.pdl@broadcom.com, arend.vanspriel@broadcom.com,
	kvalo@codeaurora.org, franky.lin@broadcom.com,
	hante.meuleman@broadcom.com, pieterpg@broadcom.com,
	linux-wireless@vger.kernel.org, chln@cypress.com
Cc: Wright Feng <wright.feng@cypress.com>
Subject: [PATCH v2] brcmfmac: shut down AP and set IBSS mode only on primary interface
Date: Thu, 11 Aug 2016 13:44:20 +0800
Message-Id: <1470894260-18128-1-git-send-email-wright.feng@cypress.com> (sfid-20160811_080901_872980_A7034F4F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When stopping hostap on virtual interface, driver will set INFRA and AP
mode that may affect the functionality on primary interface. For example,
if we create and stop hostapd on virtual interface then association
cannot work on primary interface because INFRA mode has been set to IBSS.
Hence we shut down AP and set IBSS mode only on primary interface.

Signed-off-by: Wright Feng <wright.feng@cypress.com>
---
V2:Remove the footnote from the mail.
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 2628d5e..0687ab9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -4716,6 +4716,8 @@ exit:
 
 static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 {
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct net_device *primary_ndev = cfg_to_ndev(cfg);
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err;
 	struct brcmf_fil_bss_enable_le bss_enable;
@@ -4723,7 +4725,8 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	if (ifp->vif->wdev.iftype == NL80211_IFTYPE_AP) {
+	if ((ifp->vif->wdev.iftype == NL80211_IFTYPE_AP) &&
+	    (ndev == primary_ndev)) {
 		/* Due to most likely deauths outstanding we sleep */
 		/* first to make sure they get processed by fw. */
 		msleep(400);
-- 
1.9.1

