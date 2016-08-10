Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0099.outbound.protection.outlook.com ([104.47.42.99]:59738
	"EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932836AbcHJUhr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2016 16:37:47 -0400
Date: Wed, 10 Aug 2016 16:01:00 +0800
From: Wright Feng <wright.feng@cypress.com>
To: <brcm80211-dev-list.pdl@broadcom.com>,
	<arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
	<hante.meuleman@broadcom.com>, <pieterpg@broadcom.com>,
	<chln@cypress.com>, <linux-wireless@vger.kernel.org>,
	<kvalo@codeaurora.org>
CC: <wright.feng@cypress.com>
Subject: [PATCH] brcmfmac: shut down AP and set IBSS mode only on primary
 interface
Message-ID: <20160810080100.GA10783@cypress.com> (sfid-20160810_223757_662058_8D6C79B9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When stopping hostap on virtual interface, driver will set INFRA and AP
mode that may affect the functionality on primary interface. For example,
if we create and stop hostapd on virtual interface then association
cannot work on primary interface because INFRA mode has been set to IBSS.
Hence we shut down AP and set IBSS mode only on primary interface.

Signed-off-by: Wright Feng <wright.feng@cypress.com>
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
+       struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+       struct net_device *primary_ndev = cfg_to_ndev(cfg);
        struct brcmf_if *ifp = netdev_priv(ndev);
        s32 err;
        struct brcmf_fil_bss_enable_le bss_enable;
@@ -4723,7 +4725,8 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)

        brcmf_dbg(TRACE, "Enter\n");

-       if (ifp->vif->wdev.iftype == NL80211_IFTYPE_AP) {
+       if ((ifp->vif->wdev.iftype == NL80211_IFTYPE_AP) &&
+           (ndev == primary_ndev)) {
                /* Due to most likely deauths outstanding we sleep */
                /* first to make sure they get processed by fw. */
                msleep(400);
--
1.9.1


This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
