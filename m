Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:42645 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab2FPMsE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2012 08:48:04 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v3 2/9] brcm80211: smac: always set channel specified by mac80211
Date: Sat, 16 Jun 2012 07:47:49 -0500
Message-Id: <1339850876-8020-3-git-send-email-seth.forshee@canonical.com> (sfid-20120616_144809_238450_EA1D8D06)
In-Reply-To: <1339850876-8020-1-git-send-email-seth.forshee@canonical.com>
References: <1339850876-8020-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some situations brcmsmac is choosing a channel internally. This makes
it difficult at times to know what channel to use for enforcing
regulatory constraints, so instead always use the channel from the
mac80211 configuration.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |   30 +++++-------------------
 1 file changed, 6 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 19db405..93c865d 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -3139,20 +3139,6 @@ void brcms_c_reset(struct brcms_c_info *wlc)
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
@@ -5129,6 +5115,8 @@ static void brcms_c_wme_retries_write(struct brcms_c_info *wlc)
 /* make interface operational */
 int brcms_c_up(struct brcms_c_info *wlc)
 {
+	struct ieee80211_channel *ch;
+
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
 	/* HW is turned off so don't try to access it */
@@ -5195,8 +5183,9 @@ int brcms_c_up(struct brcms_c_info *wlc)
 	wlc->pub->up = true;
 
 	if (wlc->bandinit_pending) {
+		ch = wlc->pub->ieee_hw->conf.channel;
 		brcms_c_suspend_mac_and_wait(wlc);
-		brcms_c_set_chanspec(wlc, wlc->default_bss->chanspec);
+		brcms_c_set_chanspec(wlc, ch20mhz_chspec(ch->hw_value));
 		wlc->bandinit_pending = false;
 		brcms_c_enable_mac(wlc);
 	}
@@ -8201,19 +8190,12 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
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

