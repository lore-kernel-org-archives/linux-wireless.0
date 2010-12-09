Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vwp2514.webpack.hosteurope.de ([87.230.42.24]:43412 "EHLO
	vwp2514.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751369Ab0LIJBJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 04:01:09 -0500
Subject: [PATCH] libertas: fix potential NULL-pointer dereference
From: Sven Neumann <s.neumann@raumfeld.com>
To: linux-wireless@vger.kernel.org
Cc: Dan Williams <dcbw@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 09:38:36 +0100
Message-ID: <1291883916.1924.0.camel@sven>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The code wants to check if there's a channel and it is not disabled,
but it used to check if channel is not NULL and accessed the channel
struct if this check failed.

Signed-off-by: Sven Neumann <s.neumann@raumfeld.com>
---
 drivers/net/wireless/libertas/cfg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index 373930a..113f4f2 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -619,7 +619,7 @@ static int lbs_ret_scan(struct lbs_private *priv, unsigned long dummy,
 				     print_ssid(ssid_buf, ssid, ssid_len),
 				     LBS_SCAN_RSSI_TO_MBM(rssi)/100);
 
-			if (channel ||
+			if (channel &&
 			    !(channel->flags & IEEE80211_CHAN_DISABLED))
 				cfg80211_inform_bss(wiphy, channel,
 					bssid, le64_to_cpu(*(__le64 *)tsfdesc),
-- 
1.7.2.3




