Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52985 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab1IBRHu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 13:07:50 -0400
Date: Fri, 2 Sep 2011 20:07:06 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] athk6l: Fix channel list processing in scan requests
Message-ID: <20110902170706.GA16999@jouni.qca.qualcomm.com> (sfid-20110902_190754_411595_EB537282)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Limit the length of the channel list to WMI_MAX_CHANNELS to avoid
rejection of the request in wmi.c. Since there is not really much
point in using a specific list of more than 32 channels, drop the
channel list if more channels are specified and scan all channels.

Fix cfg80211 scan API use: ar->scan_req must be set only if returning
success from scan() handler. The previous version would result in use
of freed memory and likely kernel panic should the scan request fail
to be sent to the target.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 7db6658..1fe55f6 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -793,10 +793,16 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 		}
 	}
 
-	if (request->n_channels > 0) {
+	/*
+	 * Scan only the requested channels if the request specifies a set of
+	 * channels. If the list is longer than the target supports, do not
+	 * configure the list and instead, scan all available channels.
+	 */
+	if (request->n_channels > 0 &&
+	    request->n_channels <= WMI_MAX_CHANNELS) {
 		u8 i;
 
-		n_channels = min(127U, request->n_channels);
+		n_channels = request->n_channels;
 
 		channels = kzalloc(n_channels * sizeof(u16), GFP_KERNEL);
 		if (channels == NULL) {
@@ -813,8 +819,8 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 				       false, 0, 0, n_channels, channels);
 	if (ret)
 		ath6kl_err("wmi_startscan_cmd failed\n");
-
-	ar->scan_req = request;
+	else
+		ar->scan_req = request;
 
 	kfree(channels);
 
-- 
1.7.4.1


-- 
Jouni Malinen                                            PGP id EFC895FA
