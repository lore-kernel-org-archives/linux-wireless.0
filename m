Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2549 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab3ABOXO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 09:23:14 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 03/18] brcmsmac: allow user-space setting of interface
 address
Date: Wed, 2 Jan 2013 15:22:36 +0100
Message-ID: <1357136572-18273-4-git-send-email-arend@broadcom.com> (sfid-20130102_152329_524376_B273E7A4)
In-Reply-To: <1357136572-18273-1-git-send-email-arend@broadcom.com>
References: <1357136572-18273-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The interface address of the wireless device is determined by
the permanent address stored in the device. This patch allows
it to be overridden from user-space.

Reported-by: Maximilian Engelhardt <maxi@daemonizer.de>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |    1 +
 drivers/net/wireless/brcm80211/brcmsmac/main.c        |    7 +++----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 9d1b26d..696e3d8 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -363,6 +363,7 @@ brcms_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	}
 
 	spin_lock_bh(&wl->lock);
+	memcpy(wl->pub->cur_etheraddr, vif->addr, sizeof(vif->addr));
 	wl->mute_tx = false;
 	brcms_c_mute(wl->wlc, false);
 	spin_unlock_bh(&wl->lock);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 17594de..8bd8197 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -2473,6 +2473,7 @@ static void brcms_b_tx_fifo_resume(struct brcms_hardware *wlc_hw,
 static void brcms_b_mute(struct brcms_hardware *wlc_hw, bool mute_tx)
 {
 	static const u8 null_ether_addr[ETH_ALEN] = {0, 0, 0, 0, 0, 0};
+	u8 *ethaddr = wlc_hw->wlc->pub->cur_etheraddr;
 
 	if (mute_tx) {
 		/* suspend tx fifos */
@@ -2482,8 +2483,7 @@ static void brcms_b_mute(struct brcms_hardware *wlc_hw, bool mute_tx)
 		brcms_b_tx_fifo_suspend(wlc_hw, TX_AC_VI_FIFO);
 
 		/* zero the address match register so we do not send ACKs */
-		brcms_b_set_addrmatch(wlc_hw, RCM_MAC_OFFSET,
-				       null_ether_addr);
+		brcms_b_set_addrmatch(wlc_hw, RCM_MAC_OFFSET, null_ether_addr);
 	} else {
 		/* resume tx fifos */
 		brcms_b_tx_fifo_resume(wlc_hw, TX_DATA_FIFO);
@@ -2492,8 +2492,7 @@ static void brcms_b_mute(struct brcms_hardware *wlc_hw, bool mute_tx)
 		brcms_b_tx_fifo_resume(wlc_hw, TX_AC_VI_FIFO);
 
 		/* Restore address */
-		brcms_b_set_addrmatch(wlc_hw, RCM_MAC_OFFSET,
-				       wlc_hw->etheraddr);
+		brcms_b_set_addrmatch(wlc_hw, RCM_MAC_OFFSET, ethaddr);
 	}
 
 	wlc_phy_mute_upd(wlc_hw->band->pi, mute_tx, 0);
-- 
1.7.10.4


