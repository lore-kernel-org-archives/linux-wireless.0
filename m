Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1622 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170Ab1ECJgS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:18 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: [PATCH 12/61] staging: brcm80211: remove
 wl_ops_set_rts_threshold
Date: Tue, 3 May 2011 11:35:12 +0200
Message-ID: <1304415361-7813-13-git-send-email-arend@broadcom.com> (sfid-20110503_113827_449940_A9F3C691)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function is not required as the driver does honour the USE_RTS_CTS
flag. The mac80211 API notes state that either one or the other is required
(see http://wireless.kernel.org/en/developers/Documentation/mac80211/API).

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index 8144587..0faf105 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -131,7 +131,6 @@ static void wl_ops_sw_scan_complete(struct ieee80211_hw *hw);
 static void wl_ops_set_tsf(struct ieee80211_hw *hw, u64 tsf);
 static int wl_ops_get_stats(struct ieee80211_hw *hw,
 			    struct ieee80211_low_level_stats *stats);
-static int wl_ops_set_rts_threshold(struct ieee80211_hw *hw, u32 value);
 static void wl_ops_sta_notify(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif,
 			      enum sta_notify_cmd cmd,
@@ -508,16 +507,6 @@ wl_ops_get_stats(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static int wl_ops_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
-{
-	struct wl_info *wl = hw->priv;
-
-	WL_LOCK(wl);
-	wlc_iovar_setint(wl->wlc, "rtsthresh", value & 0xFFFF);
-	WL_UNLOCK(wl);
-	return 0;
-}
-
 static void
 wl_ops_sta_notify(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		  enum sta_notify_cmd cmd, struct ieee80211_sta *sta)
@@ -669,7 +658,6 @@ static const struct ieee80211_ops wl_ops = {
 	.sw_scan_complete = wl_ops_sw_scan_complete,
 	.set_tsf = wl_ops_set_tsf,
 	.get_stats = wl_ops_get_stats,
-	.set_rts_threshold = wl_ops_set_rts_threshold,
 	.sta_notify = wl_ops_sta_notify,
 	.conf_tx = wl_ops_conf_tx,
 	.get_tsf = wl_ops_get_tsf,
-- 
1.7.4.1


