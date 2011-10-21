Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2897 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754828Ab1JUOQu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 10:16:50 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH v2 10/17] brcm80211: smac: mute transmit on ops_start
Date: Fri, 21 Oct 2011 16:16:28 +0200
Message-ID: <1319206595-17138-11-git-send-email-arend@broadcom.com> (sfid-20111021_161706_876611_60EF9700)
In-Reply-To: <1319206595-17138-1-git-send-email-arend@broadcom.com>
References: <1319206595-17138-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Monitor mode functionality (not functional yet) requires transmit to be
muted after ops_start() is called, transmit is unmuted when the first
interface is added.

Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   11 +++++++++--
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.h  |    1 +
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   10 ++++++++--
 drivers/net/wireless/brcm80211/brcmsmac/pub.h      |    3 ++-
 4 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index f38ba17..824c608 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -294,6 +294,9 @@ static int brcms_ops_start(struct ieee80211_hw *hw)
 		wiphy_rfkill_stop_polling(wl->pub->ieee_hw->wiphy);
 
 	spin_lock_bh(&wl->lock);
+	/* avoid acknowledging frames before a non-monitor device is added */
+	wl->mute_tx = true;
+
 	if (!wl->pub->up)
 		err = brcms_up(wl);
 	else
@@ -335,6 +338,8 @@ static void brcms_ops_stop(struct ieee80211_hw *hw)
 static int
 brcms_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
+	struct brcms_info *wl = hw->priv;
+
 	/* Just STA for now */
 	if (vif->type != NL80211_IFTYPE_AP &&
 	    vif->type != NL80211_IFTYPE_MESH_POINT &&
@@ -346,6 +351,9 @@ brcms_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 		return -EOPNOTSUPP;
 	}
 
+	wl->mute_tx = false;
+	brcms_c_mute(wl->wlc, false);
+
 	return 0;
 }
 
@@ -1303,8 +1311,7 @@ void brcms_init(struct brcms_info *wl)
 {
 	BCMMSG(wl->pub->ieee_hw->wiphy, "wl%d\n", wl->pub->unit);
 	brcms_reset(wl);
-
-	brcms_c_init(wl->wlc);
+	brcms_c_init(wl->wlc, wl->mute_tx);
 }
 
 /*
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h
index 5c279c0..6242f18 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h
@@ -80,6 +80,7 @@ struct brcms_info {
 	struct brcms_firmware fw;
 	struct wiphy *wiphy;
 	struct brcms_ucode ucode;
+	bool mute_tx;
 };
 
 /* misc callbacks */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index cc74205..3f8a6c7 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -2396,6 +2396,7 @@ void brcms_c_intrsrestore(struct brcms_c_info *wlc, u32 macintmask)
 	W_REG(&wlc_hw->regs->macintmask, wlc->macintmask);
 }
 
+/* assumes that the d11 MAC is enabled */
 static void brcms_b_tx_fifo_suspend(struct brcms_hardware *wlc_hw,
 				    uint tx_fifo)
 {
@@ -2487,6 +2488,12 @@ static void brcms_b_mute(struct brcms_hardware *wlc_hw, bool mute_tx)
 		brcms_c_ucode_mute_override_clear(wlc_hw);
 }
 
+void
+brcms_c_mute(struct brcms_c_info *wlc, bool mute_tx)
+{
+	brcms_b_mute(wlc->hw, mute_tx);
+}
+
 /*
  * Read and clear macintmask and macintstatus and intstatus registers.
  * This routine should be called with interrupts off
@@ -8253,11 +8260,10 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 	return wlc->macintstatus != 0;
 }
 
-void brcms_c_init(struct brcms_c_info *wlc)
+void brcms_c_init(struct brcms_c_info *wlc, bool mute_tx)
 {
 	struct d11regs __iomem *regs;
 	u16 chanspec;
-	bool mute_tx = false;
 
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pub.h b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
index 97b9cce..022523a 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pub.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
@@ -540,7 +540,7 @@ extern int brcms_c_up(struct brcms_c_info *wlc);
 extern uint brcms_c_down(struct brcms_c_info *wlc);
 
 extern bool brcms_c_chipmatch(u16 vendor, u16 device);
-extern void brcms_c_init(struct brcms_c_info *wlc);
+extern void brcms_c_init(struct brcms_c_info *wlc, bool mute_tx);
 extern void brcms_c_reset(struct brcms_c_info *wlc);
 
 extern void brcms_c_intrson(struct brcms_c_info *wlc);
@@ -597,5 +597,6 @@ extern void brcms_c_set_beacon_listen_interval(struct brcms_c_info *wlc,
 extern int brcms_c_set_tx_power(struct brcms_c_info *wlc, int txpwr);
 extern int brcms_c_get_tx_power(struct brcms_c_info *wlc);
 extern bool brcms_c_check_radio_disabled(struct brcms_c_info *wlc);
+extern void brcms_c_mute(struct brcms_c_info *wlc, bool on);
 
 #endif				/* _BRCM_PUB_H_ */
-- 
1.7.4.1


