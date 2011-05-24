Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551Ab1EXO3P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 10:29:15 -0400
Date: Tue, 24 May 2011 16:28:55 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] iwl4965: fix 5GHz operation
Message-ID: <20110524142854.GA6575@redhat.com> (sfid-20110524_162920_234640_04533769)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rx_status.band is used uninitialized, what disallow to work on 5GHz .

Cc: stable@kernel.org # 2.6.39+
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-4965-lib.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
index 7e5e85a..a7a4739 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
@@ -628,11 +628,11 @@ void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 
 	/* rx_status carries information about the packet to mac80211 */
 	rx_status.mactime = le64_to_cpu(phy_res->timestamp);
+	rx_status.band = (phy_res->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
+				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
 	rx_status.freq =
 		ieee80211_channel_to_frequency(le16_to_cpu(phy_res->channel),
 							rx_status.band);
-	rx_status.band = (phy_res->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
-				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
 	rx_status.rate_idx =
 		iwl4965_hwrate_to_mac80211_idx(rate_n_flags, rx_status.band);
 	rx_status.flag = 0;
-- 
1.7.1

