Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:55176 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932264Ab2E3I6k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 04:58:40 -0400
Message-ID: <1338368319.28696.3.camel@joe2Laptop> (sfid-20120530_105842_973061_355A5E06)
Subject: [PATCH] ath6kl: Add missing newline terminations
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com,
	Etay Luz <eluz@qca.qualcomm.com>
Date: Wed, 30 May 2012 01:58:39 -0700
In-Reply-To: <4FC5D73A.9040807@qca.qualcomm.com>
References: <1338363787-12314-1-git-send-email-kvalo@qca.qualcomm.com>
	 <1338365645.28696.0.camel@joe2Laptop> <4FC5D73A.9040807@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Messages without newlines can be interleaved.
Avoid this by adding terminations.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index b869a35..d1a5436 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -943,7 +943,7 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 				       WMI_FRAME_PROBE_REQ,
 				       request->ie, request->ie_len);
 	if (ret) {
-		ath6kl_err("failed to set Probe Request appie for scan");
+		ath6kl_err("failed to set Probe Request appie for scan\n");
 		return ret;
 	}
 
@@ -3185,7 +3185,7 @@ static int ath6kl_cfg80211_sscan_start(struct wiphy *wiphy,
 				       WMI_FRAME_PROBE_REQ,
 				       request->ie, request->ie_len);
 	if (ret) {
-		ath6kl_warn("Failed to set probe request IE for scheduled scan: %d",
+		ath6kl_warn("Failed to set probe request IE for scheduled scan: %d\n",
 			    ret);
 		return ret;
 	}


