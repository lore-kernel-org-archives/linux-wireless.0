Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12702 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466Ab1KRKHf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 05:07:35 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] ath6kl: Remove modparam multi_norm_if_support
Date: Fri, 18 Nov 2011 10:05:26 +0530
Message-ID: <1321590928-11646-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111118_110756_899853_83D7E6C0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This modparam was introduced to enable non-p2p mode operation
on two virtual interfaces. It does not seem to be necessary to
have a separate module parameter to do that. Instead, this option
can be enabled when any one of the interfaces is not going to be
used for p2p (ath6kl_p2p).

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index ed3fbbe..afa7279 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -23,10 +23,8 @@
 #include "testmode.h"
 
 static unsigned int ath6kl_p2p;
-static unsigned int multi_norm_if_support;
 
 module_param(ath6kl_p2p, uint, 0644);
-module_param(multi_norm_if_support, uint, 0644);
 
 #define RATETAB_ENT(_rate, _rateid, _flags) {   \
 	.bitrate    = (_rate),                  \
@@ -2454,14 +2452,13 @@ struct ath6kl *ath6kl_core_alloc(struct device *dev)
 	}
 
 	ar = wiphy_priv(wiphy);
-	if (!multi_norm_if_support)
-		ar->p2p = !!ath6kl_p2p;
+	ar->p2p = !!ath6kl_p2p;
 	ar->wiphy = wiphy;
 	ar->dev = dev;
 
 	ar->vif_max = 1;
 
-	if (multi_norm_if_support)
+	if (!ar->p2p)
 		ar->max_norm_iface = 2;
 	else
 		ar->max_norm_iface = 1;
-- 
1.7.0.4

