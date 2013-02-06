Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:53942 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758465Ab3BFVBd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 16:01:33 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: Seth Forshee <seth.forshee@canonical.com>,
	Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	brcm80211-dev-list@broadcom.com
Subject: [PATCH 4/4] brcmsmac: Add support for off-channel powersave
Date: Wed,  6 Feb 2013 15:01:18 -0600
Message-Id: <1360184478-31481-5-git-send-email-seth.forshee@canonical.com> (sfid-20130206_220138_694401_0361C5F8)
In-Reply-To: <1360184478-31481-1-git-send-email-seth.forshee@canonical.com>
References: <1360184478-31481-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Broadcom hardware sets the value of the PM flag in frame control based
on the value of MCTL_HPS, which seems to include actively clearing PM
if MCTL_HPS is not set. brcmsmac needs to suppor the off-channel
powersave state in order to enable powersave at the AP at all.

Add limited support for powersave to brcmsmac to prevent frame loss
during background scans. Full powersave supoprt remains unimplemented,
but switching between the off-channel and disabled states is possible.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   16 +++++++++++-----
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |    7 ++++++-
 drivers/net/wireless/brcm80211/brcmsmac/main.h     |    1 +
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index e36df33..4fff8fc 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -394,11 +394,17 @@ static int brcms_ops_config(struct ieee80211_hw *hw, u32 changed)
 		brcms_dbg_info(core, "%s: change monitor mode: %s\n",
 			       __func__, conf->flags & IEEE80211_CONF_MONITOR ?
 			       "true" : "false");
-	if (changed & IEEE80211_CONF_CHANGE_PS)
-		brcms_err(core, "%s: change power-save mode: %s (implement)\n",
-			  __func__,
-			  ieee80211_conf_ps_mode(conf) == IEEE80211_PS_DOZE ?
-			  "true" : "false");
+	if (changed & IEEE80211_CONF_CHANGE_PS) {
+		/*
+		 * brcmsmac doesn't support powersave, but it does support
+		 * setting the PM bit in frame control for off-channel PS
+		 */
+		if (ieee80211_conf_ps_mode(conf) == IEEE80211_PS_DOZE)
+			brcms_err(core, "%s: cannot enable power-save mode (implement)\n",
+				  __func__);
+		else
+			brcms_c_set_ps_ctrl(wl->wlc);
+	}
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
 		err = brcms_c_set_tx_power(wl->wlc, conf->power_level);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 62be550..8b259ca 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -3051,6 +3051,11 @@ static bool brcms_c_ps_allowed(struct brcms_c_info *wlc)
 	if (!wlc->pub->associated)
 		return false;
 
+	/* allow PS when off-channel PS is enabled */
+	if (ieee80211_conf_ps_mode(&wlc->pub->ieee_hw->conf) ==
+	    IEEE80211_PS_OFFCHANNEL)
+		return true;
+
 	/* disallow PS when one of these meets when not scanning */
 	if (wlc->filter_flags & FIF_PROMISC_IN_BSS)
 		return false;
@@ -3740,7 +3745,7 @@ brcms_c_duty_cycle_set(struct brcms_c_info *wlc, int duty_cycle, bool isOFDM,
 }
 
 /* push sw hps and wake state through hardware */
-static void brcms_c_set_ps_ctrl(struct brcms_c_info *wlc)
+void brcms_c_set_ps_ctrl(struct brcms_c_info *wlc)
 {
 	u32 v1, v2;
 	bool hps;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.h b/drivers/net/wireless/brcm80211/brcmsmac/main.h
index fb44774..35a93ef 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.h
@@ -638,6 +638,7 @@ extern void brcms_c_beacon_phytxctl_txant_upd(struct brcms_c_info *wlc,
 					  u32 bcn_rate);
 extern void brcms_b_antsel_type_set(struct brcms_hardware *wlc_hw,
 				     u8 antsel_type);
+extern void brcms_c_set_ps_ctrl(struct brcms_c_info *wlc);
 extern void brcms_b_set_chanspec(struct brcms_hardware *wlc_hw,
 				  u16 chanspec,
 				  bool mute, struct txpwr_limits *txpwr);
-- 
1.7.9.5

