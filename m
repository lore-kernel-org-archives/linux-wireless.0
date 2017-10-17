Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:44358 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759363AbdJQTht (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 15:37:49 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] libertas: don't write wdev->ssid/_len
Date: Tue, 17 Oct 2017 21:37:45 +0200
Message-Id: <20171017193745.7604-1-johannes@sipsolutions.net> (sfid-20171017_213751_770098_CC2F50C1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When joining an IBSS network, wdev->ssid/_len will already be
set, so there's no need to write them. In any case, they are
internal cfg80211 values, and have very little user-visible
impact.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/marvell/libertas/cfg.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/cfg.c b/drivers/net/wireless/marvell/libertas/cfg.c
index 71ba2c8d09b5..bb76707881cd 100644
--- a/drivers/net/wireless/marvell/libertas/cfg.c
+++ b/drivers/net/wireless/marvell/libertas/cfg.c
@@ -1698,9 +1698,6 @@ static void lbs_join_post(struct lbs_private *priv,
 				  0, GFP_KERNEL);
 	cfg80211_put_bss(priv->wdev->wiphy, bss);
 
-	memcpy(priv->wdev->ssid, params->ssid, params->ssid_len);
-	priv->wdev->ssid_len = params->ssid_len;
-
 	cfg80211_ibss_joined(priv->dev, bssid, params->chandef.chan,
 			     GFP_KERNEL);
 
-- 
2.14.2
