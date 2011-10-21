Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1351 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754810Ab1JUOQs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 10:16:48 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH v2 08/17] brcm80211: smac: fixed inconsistency in
 transmit mute
Date: Fri, 21 Oct 2011 16:16:26 +0200
Message-ID: <1319206595-17138-9-git-send-email-arend@broadcom.com> (sfid-20111021_161719_320347_BAF28FDA)
In-Reply-To: <1319206595-17138-1-git-send-email-arend@broadcom.com>
References: <1319206595-17138-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Transmit was muted in two ways: full mute and a partial mute called
'pre ism cac time' mute. But, this 'pre ism cac time' mute was done at
one place in the code (when tx_mute == false), and overridden later
on in another place in code.

To fix this, the 'pre ism cac time' mute has been replaced by a non
mute.

Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 8eb665e..cc74205 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -2453,11 +2453,11 @@ static void brcms_b_tx_fifo_resume(struct brcms_hardware *wlc_hw,
 }
 
 /* precondition: requires the mac core to be enabled */
-static void brcms_b_mute(struct brcms_hardware *wlc_hw, bool on, u32 flags)
+static void brcms_b_mute(struct brcms_hardware *wlc_hw, bool mute_tx)
 {
 	static const u8 null_ether_addr[ETH_ALEN] = {0, 0, 0, 0, 0, 0};
 
-	if (on) {
+	if (mute_tx) {
 		/* suspend tx fifos */
 		brcms_b_tx_fifo_suspend(wlc_hw, TX_DATA_FIFO);
 		brcms_b_tx_fifo_suspend(wlc_hw, TX_CTL_FIFO);
@@ -2479,9 +2479,9 @@ static void brcms_b_mute(struct brcms_hardware *wlc_hw, bool on, u32 flags)
 				       wlc_hw->etheraddr);
 	}
 
-	wlc_phy_mute_upd(wlc_hw->band->pi, on, flags);
+	wlc_phy_mute_upd(wlc_hw->band->pi, mute_tx, 0);
 
-	if (on)
+	if (mute_tx)
 		brcms_c_ucode_mute_override_set(wlc_hw);
 	else
 		brcms_c_ucode_mute_override_clear(wlc_hw);
@@ -3892,7 +3892,7 @@ static void brcms_c_set_home_chanspec(struct brcms_c_info *wlc, u16 chanspec)
 
 void
 brcms_b_set_chanspec(struct brcms_hardware *wlc_hw, u16 chanspec,
-		      bool mute, struct txpwr_limits *txpwr)
+		      bool mute_tx, struct txpwr_limits *txpwr)
 {
 	uint bandunit;
 
@@ -3918,7 +3918,7 @@ brcms_b_set_chanspec(struct brcms_hardware *wlc_hw, u16 chanspec,
 		}
 	}
 
-	wlc_phy_initcal_enable(wlc_hw->band->pi, !mute);
+	wlc_phy_initcal_enable(wlc_hw->band->pi, !mute_tx);
 
 	if (!wlc_hw->up) {
 		if (wlc_hw->clk)
@@ -3930,7 +3930,7 @@ brcms_b_set_chanspec(struct brcms_hardware *wlc_hw, u16 chanspec,
 		wlc_phy_txpower_limit_set(wlc_hw->band->pi, txpwr, chanspec);
 
 		/* Update muting of the channel */
-		brcms_b_mute(wlc_hw, mute, 0);
+		brcms_b_mute(wlc_hw, mute_tx);
 	}
 }
 
@@ -8341,7 +8341,7 @@ void brcms_c_init(struct brcms_c_info *wlc)
 
 	/* suspend the tx fifos and mute the phy for preism cac time */
 	if (mute_tx)
-		brcms_b_mute(wlc->hw, ON, PHY_MUTE_FOR_PREISM);
+		brcms_b_mute(wlc->hw, true);
 
 	/* clear tx flow control */
 	brcms_c_txflowcontrol_reset(wlc);
-- 
1.7.4.1


