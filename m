Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:52642 "EHLO v3-1039.vlinux.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730062AbeGZPZN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Jul 2018 11:25:13 -0400
From: Sven Eckelmann <sven@narfation.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Sven Eckelmann <sven.eckelmann@openmesh.com>,
        Simon Wunderlich <simon.wunderlich@openmesh.com>,
        Marek Puzyniak <marek.puzyniak@tieto.com>
Subject: [PATCH RESENT] ath10k: Prevent active scans on potential unusable channels
Date: Thu, 26 Jul 2018 15:59:48 +0200
Message-Id: <20180726135948.29160-1-sven@narfation.org> (sfid-20180726_160815_008243_C8C42FE9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sven Eckelmann <sven.eckelmann@openmesh.com>

The QCA4019 hw1.0 firmware 10.4-3.2.1-00050 and 10.4-3.5.3-00053 (and most
likely all other) seem to ignore the WMI_CHAN_FLAG_DFS flag during the
scan. This results in transmission (probe requests) on channels which are
not "available" for transmissions.

Since the firmware is closed source and nothing can be done from our side
to fix the problem in it, the driver has to work around this problem. The
WMI_CHAN_FLAG_PASSIVE seems to be interpreted by the firmware to not
scan actively on a channel unless an AP was detected on it. Simple probe
requests will then be transmitted by the STA on the channel.

ath10k must therefore also use this flag when it queues a radar channel for
scanning. This should reduce the chance of an active scan when the channel
might be "unusable" for transmissions.

Fixes: e8a50f8ba44b ("ath10k: introduce DFS implementation")
Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
---
Cc: Simon Wunderlich <simon.wunderlich@openmesh.com>
Cc: Marek Puzyniak <marek.puzyniak@tieto.com>
---

 drivers/net/wireless/ath/ath10k/mac.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 95243b48a179..76e9c6eaa051 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3085,6 +3085,13 @@ static int ath10k_update_channel_list(struct ath10k *ar)
 			passive = channel->flags & IEEE80211_CHAN_NO_IR;
 			ch->passive = passive;
 
+			/* the firmware is ignoring the "radar" flag of the
+			 * channel and is scanning actively using Probe Requests
+			 * on "Radar detection"/DFS channels which are not
+			 * marked as "available"
+			 */
+			ch->passive |= ch->chan_radar;
+
 			ch->freq = channel->center_freq;
 			ch->band_center_freq1 = channel->center_freq;
 			ch->min_power = 0;
-- 
2.11.0
