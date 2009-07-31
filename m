Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:56425 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbZGaAnu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 20:43:50 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2009 17:43:51 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH] cfg80211: fix regression on beacon world roaming feature
Date: Thu, 30 Jul 2009 17:43:48 -0700
Message-ID: <1249001028-15110-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A regression was added through patch a4ed90d6:

"cfg80211: respect API on orig_flags on channel for beacon hint"

We did indeed respect _orig flags but the intention was not clearly
stated in the commit log. This patch fixes firmware issues picked
up by iwlwifi when we lift passive scan of beaconing restrictions
on channels its EEPROM has been configured to always enable.

By doing so though we also disallowed beacon hints on devices
registering their wiphy with custom world regulatory domains
enabled, this happens to be currently ath5k, ath9k and ar9170.
The passive scan and beacon restrictions on those devices would
never be lifted even if we did find a beacon and the hardware did
support such enhancements when world roaming.

Since Johannes indicates iwlwifi firmware cannot be changed to
allow beacon hinting we set up a flag now to specifically allow
drivers to disable beacon hints for devices which cannot use them.

We enable the flag on iwlwifi to disable beacon hints and by default
enable it for all other drivers. It should be noted beacon hints lift
passive scan flags and beacon restrictions when we receive a beacon from
an AP on any 5 GHz non-DFS channels, and channels 12-14 on the 2.4 GHz
band. We don't bother with channels 1-11 as those channels are allowed
world wide.

This should fix world roaming for ath5k, ath9k and ar9170, thereby
improving scan time when we receive the first beacon from any AP,
and also enabling beaconing operation (AP/IBSS/Mesh) on cards which
would otherwise not be allowed to do so. Drivers not using custom
regulatory stuff (wiphy_apply_custom_regulatory()) were not affected
by this as the orig_flags for the channels would have been cleared
upon wiphy registration.

I tested this with a world roaming ath5k card.

Cc: Jouni Malinen <jouni.malinen@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

This issue affects 2.6.31, that's when the regression was introduced.

 drivers/net/wireless/iwlwifi/iwl-core.c     |    3 +++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 +++
 include/net/cfg80211.h                      |    5 +++++
 net/wireless/reg.c                          |    9 +++++----
 net/wireless/reg.h                          |    3 ++-
 5 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 8570d56..071c05b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1600,6 +1600,9 @@ int iwl_setup_mac(struct iwl_priv *priv)
 
 	hw->wiphy->custom_regulatory = true;
 
+	/* Firmware does not support this */
+	hw->wiphy->disable_beacon_hints = true;
+
 	hw->wiphy->max_scan_ssids = PROBE_OPTION_MAX;
 	/* we create the 802.11 header and a zero-length SSID element */
 	hw->wiphy->max_scan_ie_len = IWL_MAX_PROBE_REQUEST - 24 - 2;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 5ded898..ea051b7 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3905,6 +3905,9 @@ static int iwl3945_setup_mac(struct iwl_priv *priv)
 
 	hw->wiphy->custom_regulatory = true;
 
+	/* Firmware does not support this */
+	hw->wiphy->disable_beacon_hints = true;
+
 	hw->wiphy->max_scan_ssids = PROBE_OPTION_MAX_3945;
 	/* we create the 802.11 header and a zero-length SSID element */
 	hw->wiphy->max_scan_ie_len = IWL_MAX_PROBE_REQUEST - 24 - 2;
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index fa72997..64df51d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1076,6 +1076,10 @@ struct cfg80211_ops {
  * 	channels at a later time. This can be used for devices which do not
  * 	have calibration information gauranteed for frequencies or settings
  * 	outside of its regulatory domain.
+ * @disable_beacon_hints: enable this if your driver needs to ensure that
+ *	passive scan flags and beaconing flags may not be lifted by cfg80211
+ *	due to regulatory beacon hints. For more information on beacon
+ *	hints read the documenation for regulatory_hint_found_beacon()
  * @reg_notifier: the driver's regulatory notification callback
  * @regd: the driver's regulatory domain, if one was requested via
  * 	the regulatory_hint() API. This can be used by the driver
@@ -1104,6 +1108,7 @@ struct wiphy {
 
 	bool custom_regulatory;
 	bool strict_regulatory;
+	bool disable_beacon_hints;
 
 	bool netnsok;
 
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index b3ac0aa..0f61ae6 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1095,17 +1095,18 @@ static void handle_reg_beacon(struct wiphy *wiphy,
 
 	chan->beacon_found = true;
 
+	if (wiphy->disable_beacon_hints)
+		return;
+
 	chan_before.center_freq = chan->center_freq;
 	chan_before.flags = chan->flags;
 
-	if ((chan->flags & IEEE80211_CHAN_PASSIVE_SCAN) &&
-	    !(chan->orig_flags & IEEE80211_CHAN_PASSIVE_SCAN)) {
+	if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN) {
 		chan->flags &= ~IEEE80211_CHAN_PASSIVE_SCAN;
 		channel_changed = true;
 	}
 
-	if ((chan->flags & IEEE80211_CHAN_NO_IBSS) &&
-	    !(chan->orig_flags & IEEE80211_CHAN_NO_IBSS)) {
+	if (chan->flags & IEEE80211_CHAN_NO_IBSS) {
 		chan->flags &= ~IEEE80211_CHAN_NO_IBSS;
 		channel_changed = true;
 	}
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index 662a9da..1471225 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -30,7 +30,8 @@ int set_regdom(const struct ieee80211_regdomain *rd);
  * non-radar 5 GHz channels.
  *
  * Drivers do not need to call this, cfg80211 will do it for after a scan
- * on a newly found BSS.
+ * on a newly found BSS. If you cannot make use of this feature you can
+ * set the wiphy->disable_beacon_hints to true.
  */
 int regulatory_hint_found_beacon(struct wiphy *wiphy,
 					struct ieee80211_channel *beacon_chan,
-- 
1.6.3.3

