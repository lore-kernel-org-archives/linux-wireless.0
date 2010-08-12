Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42371 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab0HLIxe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Aug 2010 04:53:34 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 12 Aug 2010 01:53:34 -0700
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <stable@kernel.org>
Subject: [PATCH v2] ath9k_htc: Fix disconnect issue in HT40 mode.
Date: Thu, 12 Aug 2010 14:23:28 +0530
Message-ID: <1281603208-6633-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some APs advertise that they may be HT40 capable in the capabilites
but the current operating channel configuration may be only HT20.
This causes disconnection as ath9k_htc sets WLAN_RC_40_FLAG despite
the AP operating in HT20 mode.
Hence set this flag only if the current channel configuration
is HT40 enabled.

Cc: stable@kernel.org
Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index ebed9d1..7d09b4b 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -366,7 +366,8 @@ static void ath9k_htc_setup_rate(struct ath9k_htc_priv *priv,
 		caps = WLAN_RC_HT_FLAG;
 		if (sta->ht_cap.mcs.rx_mask[1])
 			caps |= WLAN_RC_DS_FLAG;
-		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
+		if ((sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) &&
+		     (conf_is_ht40(&priv->hw->conf)))
 			caps |= WLAN_RC_40_FLAG;
 		if (conf_is_ht40(&priv->hw->conf) &&
 		    (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40))
-- 
1.7.2.1

