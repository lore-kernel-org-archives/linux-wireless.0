Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:36779 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750720AbdKZFiW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 26 Nov 2017 00:38:22 -0500
Received: by mail-pl0-f66.google.com with SMTP id b12so6562667plm.3
        for <linux-wireless@vger.kernel.org>; Sat, 25 Nov 2017 21:38:22 -0800 (PST)
Date: Sun, 26 Nov 2017 13:38:18 +0800
From: Kenneth Lu <kuohsianglu@gmail.com>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath6kl@lists.infradead.org
Subject: [PATCH] ath6kl: remove redundant variable ies_len
Message-ID: <20171126053818.GA6602@blackstone> (sfid-20171126_064100_189666_13ED3D5E)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To get rid of W=1 warning: variable ‘ies_len’ set but not used.
Variable ies_len is being assigned but never read.

Signed-off-by: Kenneth Lu <kuohsianglu@gmail.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index b53eb2b..2ba8cf3 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2766,7 +2766,6 @@ static int ath6kl_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_mgmt *mgmt;
 	bool hidden = false;
 	u8 *ies;
-	int ies_len;
 	struct wmi_connect_cmd p;
 	int res;
 	int i, ret;
@@ -2804,7 +2803,6 @@ static int ath6kl_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	ies = mgmt->u.beacon.variable;
 	if (ies > info->beacon.head + info->beacon.head_len)
 		return -EINVAL;
-	ies_len = info->beacon.head + info->beacon.head_len - ies;
 
 	if (info->ssid == NULL)
 		return -EINVAL;
-- 
2.7.4
