Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36294 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586Ab2FEXIq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 19:08:46 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com, brudley@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 16/18] brcmsmac: do not call brcms_c_chipmatch() for non PCI
Date: Wed,  6 Jun 2012 01:07:19 +0200
Message-Id: <1338937641-8519-17-git-send-email-hauke@hauke-m.de> (sfid-20120606_012943_624214_83F8563E)
In-Reply-To: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

brcms_c_chipmatch() just works for PCIe devices and returns false for
non PCIe devices. This stops brcms_ops_stop() from calling it when the
devices is not a PCIe device.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   22 +++++++++++++-------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 50f92a0..241224f 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -31,6 +31,7 @@
 #include "scb.h"
 #include "pub.h"
 #include "ucode_loader.h"
+#include "aiutils.h"
 #include "mac80211_if.h"
 #include "main.h"
 
@@ -311,6 +312,7 @@ static int brcms_ops_start(struct ieee80211_hw *hw)
 static void brcms_ops_stop(struct ieee80211_hw *hw)
 {
 	struct brcms_info *wl = hw->priv;
+	struct si_info *sii;
 	int status;
 
 	ieee80211_stop_queues(hw);
@@ -318,14 +320,18 @@ static void brcms_ops_stop(struct ieee80211_hw *hw)
 	if (wl->wlc == NULL)
 		return;
 
-	spin_lock_bh(&wl->lock);
-	status = brcms_c_chipmatch(wl->wlc->hw->vendorid,
-				   wl->wlc->hw->deviceid);
-	spin_unlock_bh(&wl->lock);
-	if (!status) {
-		wiphy_err(wl->wiphy,
-			  "wl: brcms_ops_stop: chipmatch failed\n");
-		return;
+	sii = container_of(wl->pub->sih, struct si_info, pub);
+
+	if (sii->icbus->hosttype == BCMA_HOSTTYPE_PCI) {
+		spin_lock_bh(&wl->lock);
+		status = brcms_c_chipmatch(wl->wlc->hw->vendorid,
+					   wl->wlc->hw->deviceid);
+		spin_unlock_bh(&wl->lock);
+		if (!status) {
+			wiphy_err(wl->wiphy,
+				  "wl: brcms_ops_stop: chipmatch failed\n");
+			return;
+		}
 	}
 
 	/* put driver in down state */
-- 
1.7.9.5

