Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:41190 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab2DPURu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 16:17:50 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: [RFC PATCH 2/8] brcm80211: smac: always set channel specified by mac80211
Date: Mon, 16 Apr 2012 15:17:36 -0500
Message-Id: <1334607462-5387-3-git-send-email-seth.forshee@canonical.com> (sfid-20120416_221752_834115_E28E6C7E)
In-Reply-To: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
References: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some situations brcmsmac is choosing a channel internally. This makes
it difficult at times to know what channel to use for enforcing
regulatory constraints, so instead always use the channel from the
mac80211 configuration.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |   30 +++++-------------------
 1 file changed, 6 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 7083db7..41d51cb 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -3150,20 +3150,6 @@ void brcms_c_reset(struct brcms_c_info *wlc)
 	brcms_b_reset(wlc->hw);
 }
 
-/* Return the channel the driver should initialize during brcms_c_init.
- * the channel may have to be changed from the currently configured channel
- * if other configurations are in conflict (bandlocked, 11n mode disabled,
- * invalid channel for current country, etc.)
- */
-static u16 brcms_c_init_chanspec(struct brcms_c_info *wlc)
-{
-	u16 chanspec =
-	    1 | WL_CHANSPEC_BW_20 | WL_CHANSPEC_CTL_SB_NONE |
-	    WL_CHANSPEC_BAND_2G;
-
-	return chanspec;
-}
-
 void brcms_c_init_scb(struct scb *scb)
 {
 	int i;
@@ -5152,6 +5138,8 @@ static void brcms_c_wme_retries_write(struct brcms_c_info *wlc)
 /* make interface operational */
 int brcms_c_up(struct brcms_c_info *wlc)
 {
+	struct ieee80211_channel *ch;
+
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
 	/* HW is turned off so don't try to access it */
@@ -5218,8 +5206,9 @@ int brcms_c_up(struct brcms_c_info *wlc)
 	wlc->pub->up = true;
 
 	if (wlc->bandinit_pending) {
+		ch = wlc->pub->ieee_hw->conf.channel;
 		brcms_c_suspend_mac_and_wait(wlc);
-		brcms_c_set_chanspec(wlc, wlc->default_bss->chanspec);
+		brcms_c_set_chanspec(wlc, ch20mhz_chspec(ch->hw_value));
 		wlc->bandinit_pending = false;
 		brcms_c_enable_mac(wlc);
 	}
@@ -8224,19 +8213,12 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 void brcms_c_init(struct brcms_c_info *wlc, bool mute_tx)
 {
 	struct bcma_device *core = wlc->hw->d11core;
+	struct ieee80211_channel *ch = wlc->pub->ieee_hw->conf.channel;
 	u16 chanspec;
 
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
-	/*
-	 * This will happen if a big-hammer was executed. In
-	 * that case, we want to go back to the channel that
-	 * we were on and not new channel
-	 */
-	if (wlc->pub->associated)
-		chanspec = wlc->home_chanspec;
-	else
-		chanspec = brcms_c_init_chanspec(wlc);
+	chanspec = ch20mhz_chspec(ch->hw_value);
 
 	brcms_b_init(wlc->hw, chanspec);
 
-- 
1.7.9.5

