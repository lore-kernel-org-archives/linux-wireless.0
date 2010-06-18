Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41529 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760133Ab0FRKb7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jun 2010 06:31:59 -0400
Subject: [PATCH] mac80211_hwsim: fix fake_hw_scan
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Jun 2010 12:31:56 +0200
Message-ID: <1276857116.3638.21.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since mac80211 will not set the max_scan parameters
if hw scan is enabled, hwsim needs to do it so that
cfg80211 won't reject the scan.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    5 +++++
 1 file changed, 5 insertions(+)

--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2010-06-18 12:02:50.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2010-06-18 12:17:43.000000000 +0200
@@ -1291,6 +1291,11 @@ static int __init init_mac80211_hwsim(vo
 		hw->wiphy->n_addresses = 2;
 		hw->wiphy->addresses = data->addresses;
 
+		if (fake_hw_scan) {
+			hw->wiphy->max_scan_ssids = 255;
+			hw->wiphy->max_scan_ie_len = IEEE80211_MAX_DATA_LEN;
+		}
+
 		hw->channel_change_time = 1;
 		hw->queues = 4;
 		hw->wiphy->interface_modes =


