Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2846 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529Ab1JUNze (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 09:55:34 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 07/17] brcm80211: smac: bugfix for tx mute in
 brcms_b_init()
Date: Fri, 21 Oct 2011 15:55:09 +0200
Message-ID: <1319205319-16891-8-git-send-email-arend@broadcom.com> (sfid-20111021_155604_774717_C015DACD)
In-Reply-To: <1319205319-16891-1-git-send-email-arend@broadcom.com>
References: <1319205319-16891-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Transmit can only be muted if the mac core is enabled. When brcms_b_init()
is called, the mac core is suspended. Brcms_b_init() calls a transmit mute
function that requires an enabled mac core. This code path is never taken,
but would have been taken in subsequent patches.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 2fecf06..8eb665e 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -2452,6 +2452,7 @@ static void brcms_b_tx_fifo_resume(struct brcms_hardware *wlc_hw,
 	}
 }
 
+/* precondition: requires the mac core to be enabled */
 static void brcms_b_mute(struct brcms_hardware *wlc_hw, bool on, u32 flags)
 {
 	static const u8 null_ether_addr[ETH_ALEN] = {0, 0, 0, 0, 0, 0};
@@ -3354,8 +3355,7 @@ static void brcms_b_coreinit(struct brcms_c_info *wlc)
 }
 
 void
-static brcms_b_init(struct brcms_hardware *wlc_hw, u16 chanspec,
-			  bool mute) {
+static brcms_b_init(struct brcms_hardware *wlc_hw, u16 chanspec) {
 	u32 macintmask;
 	bool fastclk;
 	struct brcms_c_info *wlc = wlc_hw->wlc;
@@ -3380,10 +3380,6 @@ static brcms_b_init(struct brcms_hardware *wlc_hw, u16 chanspec,
 	/* core-specific initialization */
 	brcms_b_coreinit(wlc);
 
-	/* suspend the tx fifos and mute the phy for preism cac time */
-	if (mute)
-		brcms_b_mute(wlc_hw, ON, PHY_MUTE_FOR_PREISM);
-
 	/* band-specific inits */
 	brcms_b_bsinit(wlc, chanspec);
 
@@ -8261,7 +8257,7 @@ void brcms_c_init(struct brcms_c_info *wlc)
 {
 	struct d11regs __iomem *regs;
 	u16 chanspec;
-	bool mute = false;
+	bool mute_tx = false;
 
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
@@ -8277,7 +8273,7 @@ void brcms_c_init(struct brcms_c_info *wlc)
 	else
 		chanspec = brcms_c_init_chanspec(wlc);
 
-	brcms_b_init(wlc->hw, chanspec, mute);
+	brcms_b_init(wlc->hw, chanspec);
 
 	/* update beacon listen interval */
 	brcms_c_bcn_li_upd(wlc);
@@ -8343,6 +8339,10 @@ void brcms_c_init(struct brcms_c_info *wlc)
 	/* ..now really unleash hell (allow the MAC out of suspend) */
 	brcms_c_enable_mac(wlc);
 
+	/* suspend the tx fifos and mute the phy for preism cac time */
+	if (mute_tx)
+		brcms_b_mute(wlc->hw, ON, PHY_MUTE_FOR_PREISM);
+
 	/* clear tx flow control */
 	brcms_c_txflowcontrol_reset(wlc);
 
-- 
1.7.4.1


