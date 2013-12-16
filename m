Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:62521 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab3LPWBL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 17:01:11 -0500
Received: by mail-oa0-f49.google.com with SMTP id i4so5610574oah.8
        for <linux-wireless@vger.kernel.org>; Mon, 16 Dec 2013 14:01:11 -0800 (PST)
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	brcm80211-dev-list@broadcom.com,
	"John W. Linville" <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Arend van Spriel <arend@broadcom.com>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [RFC PATCH 6/8] brcmsmac: Set MCTL_HPS when PM should be set
Date: Mon, 16 Dec 2013 16:00:58 -0600
Message-Id: <1387231260-2849-7-git-send-email-seth.forshee@canonical.com> (sfid-20131216_230124_408159_FA4D33C7)
In-Reply-To: <1387231260-2849-1-git-send-email-seth.forshee@canonical.com>
References: <1387231260-2849-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Even though powersave is not supported MCTL_HPS still needs to be
set in order to transmit nullfunc frames with PM set. Add support
for the change_ps callback to set this bit whenever the powersave
mode requires PM to be set.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |  7 +++++++
 drivers/net/wireless/brcm80211/brcmsmac/main.c        | 17 ++++++++++-------
 drivers/net/wireless/brcm80211/brcmsmac/main.h        |  1 +
 3 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index e71ce8c..e6a8c72 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -734,6 +734,12 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 	return;
 }
 
+void brcms_ops_change_ps(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
+{
+	struct brcms_info *wl = hw->priv;
+	brcms_c_set_ps_ctrl(wl->wlc, vif);
+}
+
 static void
 brcms_ops_configure_filter(struct ieee80211_hw *hw,
 			unsigned int changed_flags,
@@ -944,6 +950,7 @@ static const struct ieee80211_ops brcms_ops = {
 	.remove_interface = brcms_ops_remove_interface,
 	.config = brcms_ops_config,
 	.bss_info_changed = brcms_ops_bss_info_changed,
+	.change_ps = brcms_ops_change_ps,
 	.configure_filter = brcms_ops_configure_filter,
 	.sw_scan_start = brcms_ops_sw_scan_start,
 	.sw_scan_complete = brcms_ops_sw_scan_complete,
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 8138f1c..5d4dabb 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -3072,10 +3072,13 @@ static void brcms_b_antsel_set(struct brcms_hardware *wlc_hw, u32 antsel_avail)
  * conditions under which the PM bit should be set in outgoing frames
  * and STAY_AWAKE is meaningful
  */
-static bool brcms_c_ps_allowed(struct brcms_c_info *wlc)
+static bool brcms_c_ps_allowed(struct brcms_c_info *wlc,
+			       struct ieee80211_vif *vif)
 {
-	/* not supporting PS so always return false for now */
-	return false;
+	if (!vif)
+		return false;
+	return vif->ps_mode == IEEE80211_VIF_PS_DOZE ||
+	       vif->ps_mode == IEEE80211_VIF_PS_AWAKE_PM;
 }
 
 static void brcms_c_statsupd(struct brcms_c_info *wlc)
@@ -3748,13 +3751,13 @@ brcms_c_duty_cycle_set(struct brcms_c_info *wlc, int duty_cycle, bool isOFDM,
 }
 
 /* push sw hps and wake state through hardware */
-static void brcms_c_set_ps_ctrl(struct brcms_c_info *wlc)
+void brcms_c_set_ps_ctrl(struct brcms_c_info *wlc, struct ieee80211_vif *vif)
 {
 	u32 v1, v2;
 	bool hps;
 	bool awake_before;
 
-	hps = brcms_c_ps_allowed(wlc);
+	hps = brcms_c_ps_allowed(wlc, vif);
 
 	brcms_dbg_mac80211(wlc->hw->d11core, "wl%d: hps %d\n", wlc->pub->unit,
 			   hps);
@@ -3901,7 +3904,7 @@ static void brcms_c_setband(struct brcms_c_info *wlc,
 		return;
 
 	/* wait for at least one beacon before entering sleeping state */
-	brcms_c_set_ps_ctrl(wlc);
+	brcms_c_set_ps_ctrl(wlc, NULL);
 
 	/* band-specific initializations */
 	brcms_c_bsinit(wlc);
@@ -7938,7 +7941,7 @@ void brcms_c_init(struct brcms_c_info *wlc, bool mute_tx)
 			     bi << CFPREP_CBI_SHIFT);
 
 		/* Update maccontrol PM related bits */
-		brcms_c_set_ps_ctrl(wlc);
+		brcms_c_set_ps_ctrl(wlc, NULL);
 	}
 
 	brcms_c_bandinit_ordered(wlc, chanspec);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.h b/drivers/net/wireless/brcm80211/brcmsmac/main.h
index c4d135c..58abbe3 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.h
@@ -622,6 +622,7 @@ int brcms_b_xmtfifo_sz_get(struct brcms_hardware *wlc_hw, uint fifo,
 
 int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config);
 void brcms_c_mac_promisc(struct brcms_c_info *wlc, uint filter_flags);
+void brcms_c_set_ps_ctrl(struct brcms_c_info *wlc, struct ieee80211_vif *vif);
 u16 brcms_c_calc_lsig_len(struct brcms_c_info *wlc, u32 ratespec, uint mac_len);
 u32 brcms_c_rspec_to_rts_rspec(struct brcms_c_info *wlc, u32 rspec,
 			       bool use_rspec, u16 mimo_ctlchbw);
-- 
1.8.3.2

