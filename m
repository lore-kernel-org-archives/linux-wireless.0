Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2859 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755024Ab1IMHuH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 03:50:07 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 03/17] staging: brcm80211: remove function
 ieee_set_channel()
Date: Tue, 13 Sep 2011 09:49:43 +0200
Message-ID: <1315900197-7260-4-git-send-email-rvossen@broadcom.com> (sfid-20110913_095015_488783_CDC8A9E3)
In-Reply-To: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
References: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The function ieee_set_channel() provides very little functionality
so it has been removed.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |   39 ++++-----------------
 drivers/staging/brcm80211/brcmsmac/main.c        |   11 +-----
 drivers/staging/brcm80211/brcmsmac/pub.h         |    3 +-
 3 files changed, 12 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index 7d012be..5696b39 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -363,34 +363,6 @@ brcms_ops_remove_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	UNLOCK(wl);
 }
 
-/*
- * precondition: perimeter lock has been acquired
- */
-static int
-ieee_set_channel(struct ieee80211_hw *hw, struct ieee80211_channel *chan,
-		 enum nl80211_channel_type type)
-{
-	struct brcms_info *wl = hw->priv;
-	int err;
-
-	switch (type) {
-	case NL80211_CHAN_HT20:
-	case NL80211_CHAN_NO_HT:
-		err = brcms_c_set_channel(wl->wlc, chan->hw_value);
-		break;
-	case NL80211_CHAN_HT40MINUS:
-	case NL80211_CHAN_HT40PLUS:
-		wiphy_err(hw->wiphy,
-			  "%s: Need to implement 40 Mhz Channels!\n", __func__);
-		err = -ENOTSUPP;
-		break;
-	default:
-		err = -EINVAL;
-	}
-
-	return err;
-}
-
 static int brcms_ops_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct ieee80211_conf *conf = &hw->conf;
@@ -433,9 +405,14 @@ static int brcms_ops_config(struct ieee80211_hw *hw, u32 changed)
 				  "\n", __func__, conf->power_level * 4,
 				  new_int);
 	}
-	if (changed & IEEE80211_CONF_CHANGE_CHANNEL)
-		err = ieee_set_channel(hw, conf->channel, conf->channel_type);
-
+	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
+		if (conf->channel_type == NL80211_CHAN_HT20 ||
+		    conf->channel_type == NL80211_CHAN_NO_HT)
+			err = brcms_c_set_channel(wl->wlc,
+						  conf->channel->hw_value);
+		else
+			err = -ENOTSUPP;
+	}
 	if (changed & IEEE80211_CONF_CHANGE_RETRY_LIMITS)
 		err = brcms_c_set_rate_limit(wl->wlc,
 					     conf->short_frame_max_tx_count,
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 705f0eb..bf3634e 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -6288,14 +6288,8 @@ u16 brcms_c_get_phy_type(struct brcms_c_info *wlc, int phyidx)
 	return wlc->band->phytype;
 }
 
-int brcms_c_set_shortslot_override(struct brcms_c_info *wlc, s8 sslot_override)
+void brcms_c_set_shortslot_override(struct brcms_c_info *wlc, s8 sslot_override)
 {
-	if (sslot_override != BRCMS_SHORTSLOT_AUTO &&
-	    sslot_override != BRCMS_SHORTSLOT_OFF &&
-	    sslot_override != BRCMS_SHORTSLOT_ON) {
-		return -EINVAL;
-	}
-
 	wlc->shortslot_override = sslot_override;
 
 	/*
@@ -6303,7 +6297,7 @@ int brcms_c_set_shortslot_override(struct brcms_c_info *wlc, s8 sslot_override)
 	 * currently on the 5G band
 	 */
 	if (wlc->band->bandtype == BRCM_BAND_5G)
-		return 0;
+		return;
 
 	if (wlc->pub->up && wlc->pub->associated) {
 		/* let watchdog or beacon processing update shortslot */
@@ -6320,7 +6314,6 @@ int brcms_c_set_shortslot_override(struct brcms_c_info *wlc, s8 sslot_override)
 			    (wlc->shortslot_override ==
 			     BRCMS_SHORTSLOT_ON);
 	}
-	return 0;
 }
 
 /*
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index 3655ac6..2069d16 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -386,7 +386,8 @@ void brcms_c_get_current_rateset(struct brcms_c_info *wlc,
 int brcms_c_set_rateset(struct brcms_c_info *wlc, struct brcm_rateset *rs);
 int brcms_c_set_beacon_period(struct brcms_c_info *wlc, u16 period);
 u16 brcms_c_get_phy_type(struct brcms_c_info *wlc, int phyidx);
-int brcms_c_set_shortslot_override(struct brcms_c_info *wlc, s8 sslot_override);
+void brcms_c_set_shortslot_override(struct brcms_c_info *wlc,
+				    s8 sslot_override);
 
 /* helper functions */
 extern bool brcms_c_check_radio_disabled(struct brcms_c_info *wlc);
-- 
1.7.4.1


