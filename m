Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59297 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab1JMOas (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Oct 2011 10:30:48 -0400
Received: by eye27 with SMTP id 27so65379eye.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Oct 2011 07:30:47 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 2/2] mac80211: Provide station flags to cfg80211
Date: Thu, 13 Oct 2011 16:30:40 +0200
Message-Id: <1318516240-10033-2-git-send-email-helmut.schaa@googlemail.com> (sfid-20111013_163052_299921_E6B2234A)
In-Reply-To: <1318516240-10033-1-git-send-email-helmut.schaa@googlemail.com>
References: <1318516240-10033-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only station flags that are already defined in nl80211 are added for
now.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/cfg.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d0705f2..e253afa 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -344,7 +344,8 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 			STATION_INFO_RX_BITRATE |
 			STATION_INFO_RX_DROP_MISC |
 			STATION_INFO_BSS_PARAM |
-			STATION_INFO_CONNECTED_TIME;
+			STATION_INFO_CONNECTED_TIME |
+			STATION_INFO_STA_FLAGS;
 
 	do_posix_clock_monotonic_gettime(&uptime);
 	sinfo->connected_time = uptime.tv_sec - sta->last_connected;
@@ -404,6 +405,23 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		sinfo->bss_param.flags |= BSS_PARAM_FLAGS_SHORT_SLOT_TIME;
 	sinfo->bss_param.dtim_period = sdata->local->hw.conf.ps_dtim_period;
 	sinfo->bss_param.beacon_interval = sdata->vif.bss_conf.beacon_int;
+
+	sinfo->sta_flags.set = 0;
+	sinfo->sta_flags.mask = BIT(NL80211_STA_FLAG_AUTHORIZED) |
+				BIT(NL80211_STA_FLAG_SHORT_PREAMBLE) |
+				BIT(NL80211_STA_FLAG_WME) |
+				BIT(NL80211_STA_FLAG_MFP) |
+				BIT(NL80211_STA_FLAG_AUTHENTICATED);
+	if (test_sta_flag(sta, WLAN_STA_AUTHORIZED))
+		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_AUTHORIZED);
+	if (test_sta_flag(sta, WLAN_STA_SHORT_PREAMBLE))
+		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_SHORT_PREAMBLE);
+	if (test_sta_flag(sta, WLAN_STA_WME))
+		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_WME);
+	if (test_sta_flag(sta, WLAN_STA_MFP))
+		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_MFP);
+	if (test_sta_flag(sta, WLAN_STA_AUTH))
+		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_AUTHENTICATED);
 }
 
 
-- 
1.7.3.4

