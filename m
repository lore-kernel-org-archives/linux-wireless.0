Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3217 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753900Ab1EIOdE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 10:33:04 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Arend van Spriel" <arend@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] staging: brcm80211: fix perimeter locking in
 wl_ops_bss_info_changed
Date: Mon, 9 May 2011 16:32:53 +0200
Message-ID: <1304951576-2351-2-git-send-email-arend@broadcom.com> (sfid-20110509_163606_267563_87DDD826)
In-Reply-To: <1304951576-2351-1-git-send-email-arend@broadcom.com>
References: <1304951576-2351-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several code path in the wl_ops_bss_info_changed() callback were not
using the perimeter lock. This gives potential of raise conditions
so lock/unlock calls have been added.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Roland Vossen <rvossen@broadcoom.com>
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index a932284..9f2e5a2 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -340,7 +340,9 @@ wl_ops_bss_info_changed(struct ieee80211_hw *hw,
 		 */
 		wiphy_err(wiphy, "%s: %s: %sassociated\n", KBUILD_MODNAME,
 			  __func__, info->assoc ? "" : "dis");
+		WL_LOCK(wl);
 		wlc_associate_upd(wl->wlc, info->assoc);
+		WL_UNLOCK(wl);
 	}
 	if (changed & BSS_CHANGED_ERP_SLOT) {
 		/* slot timing changed */
@@ -356,12 +358,15 @@ wl_ops_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_HT) {
 		/* 802.11n parameters changed */
 		u16 mode = info->ht_operation_mode;
+
+		WL_LOCK(wl);
 		wlc_protection_upd(wl->wlc, WLC_PROT_N_CFG,
 			mode & IEEE80211_HT_OP_MODE_PROTECTION);
 		wlc_protection_upd(wl->wlc, WLC_PROT_N_NONGF,
 			mode & IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
 		wlc_protection_upd(wl->wlc, WLC_PROT_N_OBSS,
 			mode & IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT);
+		WL_UNLOCK(wl);
 	}
 	if (changed & BSS_CHANGED_BASIC_RATES) {
 		struct ieee80211_supported_band *bi;
@@ -370,13 +375,11 @@ wl_ops_bss_info_changed(struct ieee80211_hw *hw,
 		struct wl_rateset rs;
 		int error;
 
-		/* Basic rateset changed */
-		no_printk("%s: change basic rates: 0x%x\n",
-			 __func__, (u32) info->basic_rates);
-
 		/* retrieve the current rates */
+		WL_LOCK(wl);
 		error = wlc_ioctl(wl->wlc, WLC_GET_CURR_RATESET,
 				  &rs, sizeof(rs), NULL);
+		WL_UNLOCK(wl);
 		if (error) {
 			wiphy_err(wiphy, "%s: retrieve rateset failed: %d\n",
 				  __func__, error);
@@ -394,11 +397,15 @@ wl_ops_bss_info_changed(struct ieee80211_hw *hw,
 		}
 
 		/* update the rate set */
+		WL_LOCK(wl);
 		wlc_ioctl(wl->wlc, WLC_SET_RATESET, &rs, sizeof(rs), NULL);
+		WL_UNLOCK(wl);
 	}
 	if (changed & BSS_CHANGED_BEACON_INT) {
 		/* Beacon interval changed */
+		WL_LOCK(wl);
 		wlc_set(wl->wlc, WLC_SET_BCNPRD, info->beacon_int);
+		WL_UNLOCK(wl);
 	}
 	if (changed & BSS_CHANGED_BSSID) {
 		/* BSSID changed, for whatever reason (IBSS and managed mode) */
-- 
1.7.4.1


