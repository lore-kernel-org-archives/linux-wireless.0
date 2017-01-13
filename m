Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44400 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751363AbdAMKaN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 05:30:13 -0500
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        "Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH] ath10k: Fix per station tx bit rate reporting
Date: Fri, 13 Jan 2017 16:00:03 +0530
Message-ID: <1484303403-8908-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20170113_113016_801495_1B4BF94D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Not clearing the previous tx bit rate status
results in a ambigous tx bit rate reporting to
mac80211/cfg80211, for example the previous bit
rate status would have been marked as legacy rate
, while the current rate would have been an HT/VHT
rate with the tx bit rate flags set and this results
in exporting tx bitrate as legacy rate but with HT/VHT
rate flags set, fix this by clearing the tx bitrate
status for each event. This also fixes the below
warning when we do:

iw dev wlan#N station dump

WARNING: net/wireless/util.c:1222 cfg80211

[<c022f104>] (warn_slowpath_null) from [<bf3b9adc>]
(cfg80211_calculate_bitrate+0x110/0x1f4 [cfg80211])
[<bf3b9adc>] (cfg80211_calculate_bitrate [cfg80211]) from
[<bf3dcd54>] (nl80211_put_sta_rate+0x44/0x1dc [cfg80211])
[<bf3dcd54>] (nl80211_put_sta_rate [cfg80211]) from
[<bf3cbc34>] (nl80211_set_interface+0x724/0xd70 [cfg80211])
[<bf3cbc34>] (nl80211_set_interface [cfg80211]) from
[<bf3d0a18>] (nl80211_dump_station+0xdc/0x100 [cfg80211])
[<bf3d0a18>] (nl80211_dump_station [cfg80211])

Fixes: cec17c382140 ("ath10k: add per peer htt tx stats support for 10.4")
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 0bc7fe8..74b66e5 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2231,6 +2231,8 @@ static inline bool is_valid_legacy_rate(u8 rate)
 		return;
 	}
 
+	memset(&arsta->txrate, 0, sizeof(arsta->txrate));
+
 	if (txrate.flags == WMI_RATE_PREAMBLE_CCK ||
 	    txrate.flags == WMI_RATE_PREAMBLE_OFDM) {
 		rate = ATH10K_HW_LEGACY_RATE(peer_stats->ratecode);
-- 
1.9.1
