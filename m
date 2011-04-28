Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758344Ab1D1Jwu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 05:52:50 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 03/10] iwlegacy: simplify init geos
Date: Thu, 28 Apr 2011 11:51:26 +0200
Message-Id: <1303984293-6601-3-git-send-email-sgruszka@redhat.com> (sfid-20110428_115259_612938_9865CB37)
In-Reply-To: <1303984293-6601-1-git-send-email-sgruszka@redhat.com>
References: <1303984293-6601-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't need to use conditional as ch->band is already assigned to
IEEE80211_BAND_5GHZ or IEEE80211_BAND_2GHZ

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-core.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index c1511b1..daf250e 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -211,10 +211,7 @@ int iwl_legacy_init_geos(struct iwl_priv *priv)
 		if (!iwl_legacy_is_channel_valid(ch))
 			continue;
 
-		if (iwl_legacy_is_channel_a_band(ch))
-			sband =  &priv->bands[IEEE80211_BAND_5GHZ];
-		else
-			sband =  &priv->bands[IEEE80211_BAND_2GHZ];
+		sband = &priv->bands[ch->band];
 
 		geo_ch = &sband->channels[sband->n_channels++];
 
-- 
1.7.1

