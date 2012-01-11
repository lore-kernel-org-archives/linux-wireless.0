Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail54.messagelabs.com ([216.82.241.131]:37229 "HELO
	mail54.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933111Ab2AKSdo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 13:33:44 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Subject: [PATCH 1/2] wireless: Save original maximum regulatory transmission power for the calucation of the local maximum transmit power
Date: Wed, 11 Jan 2012 20:33:39 +0200
Message-ID: <5EFF534737810441B0F97C2792E49C2DD20371@ILMAIL01.dspg.com> (sfid-20120111_193352_709004_29CFFC5A)
From: "Hong Wu" <Hong.Wu@dspg.com>
To: <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The local maximum transmit power for a channel is defined as the maximum
regulatory transmission power minus the local power constraint specified
for the channel in the Power Constraint element. (7.3.2.15 IEEE80211 2007)

Signed-off-by: Hong Wu <hong.wu@dspg.com>
---
 include/net/cfg80211.h |    2 ++
 net/wireless/reg.c     |   19 ++-----------------
 2 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 15f4be7..208a7b5 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -120,6 +120,7 @@ enum ieee80211_channel_flags {
  * @band: band this channel belongs to.
  * @max_antenna_gain: maximum antenna gain in dBi
  * @max_power: maximum transmission power (in dBm)
+ * @max_reg_power: maximum regulatory transmission power (in dBm)
  * @beacon_found: helper to regulatory code to indicate when a beacon
  *   has been found on this channel. Use regulatory_hint_found_beacon()
  *   to enable this, this is useful only on 5 GHz band.
@@ -133,6 +134,7 @@ struct ieee80211_channel {
      u32 flags;
      int max_antenna_gain;
      int max_power;
+     int max_reg_power;
      bool beacon_found;
      u32 orig_flags;
      int orig_mag, orig_mpwr;
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index f65feaa..e9a0ac8 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -882,23 +882,8 @@ static void handle_channel(struct wiphy *wiphy,
      chan->flags = flags | bw_flags | map_regdom_flags(reg_rule->flags);
      chan->max_antenna_gain = min(chan->orig_mag,
            (int) MBI_TO_DBI(power_rule->max_antenna_gain));
-     if (chan->orig_mpwr) {
-           /*
-           * Devices that have their own custom regulatory domain
-           * but also use WIPHY_FLAG_STRICT_REGULATORY will follow the
-           * passed country IE power settings.
-           */
-           if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE &&
-               wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY &&
-               wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY) {
-                 chan->max_power =
-                       MBM_TO_DBM(power_rule->max_eirp);
-           } else {
-                 chan->max_power = min(chan->orig_mpwr,
-                       (int) MBM_TO_DBM(power_rule->max_eirp));
-           }
-     } else
-           chan->max_power = (int) MBM_TO_DBM(power_rule->max_eirp);
+     chan->max_reg_power = (int) MBM_TO_DBM(power_rule->max_eirp);
+     chan->max_power = min(chan->max_power, chan->max_reg_power);
 }
 
 static void handle_band(struct wiphy *wiphy,
-- 
1.7.0.4




______________________________________________________________________
DSP Group, Inc. automatically scans all emails and attachments using MessageLabs Email Security System.
_____________________________________________________________________
