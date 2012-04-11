Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40901 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932416Ab2DKRxY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 13:53:24 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH 06/10] mac80211: Add sta_state to ethtool stats.
Date: Wed, 11 Apr 2012 10:52:14 -0700
Message-Id: <1334166738-28243-7-git-send-email-greearb@candelatech.com> (sfid-20120411_195329_226978_FB464821)
In-Reply-To: <1334166738-28243-1-git-send-email-greearb@candelatech.com>
References: <1334166738-28243-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Helps to know how the station is doing in it's association
attempt.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 bbaf564... a63834d... M	net/mac80211/cfg.c
 net/mac80211/cfg.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index bbaf564..a63834d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -118,7 +118,7 @@ static const char ieee80211_gstrings_sta_stats[][ETH_GSTRING_LEN] = {
 	"rx_duplicates", "rx_fragments", "rx_dropped",
 	"tx_packets", "tx_bytes", "tx_fragments",
 	"tx_filtered", "tx_retry_failed", "tx_retries",
-	"beacon_loss", "txrate", "rxrate", "signal",
+	"beacon_loss", "sta_state", "txrate", "rxrate", "signal",
 	"channel", "noise", "ch_time", "ch_time_busy",
 	"ch_time_ext_busy", "ch_time_rx", "ch_time_tx"
 };
@@ -534,10 +534,12 @@ static void ieee80211_get_et_stats(struct wiphy *wiphy,
 		data[i++] += sta->beacon_loss_count;
 
 		if (!do_once) {
-			i += 3;
+			i += 4;
 			goto after_once;
 		}
 
+		data[i++] = sta->sta_state;
+
 		do_once = false;
 		sinfo.filled = 0;
 		sta_set_sinfo(sta, &sinfo);
-- 
1.7.3.4

