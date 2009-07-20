Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42898 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbZGTDq0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jul 2009 23:46:26 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 1/5] cfg80211: set_default_key only for WEP
Date: Mon, 20 Jul 2009 11:47:43 +0800
Message-Id: <1248061667-8614-2-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1248061667-8614-1-git-send-email-yi.zhu@intel.com>
References: <1248061667-8614-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We invoke the cfg80211 set_default_key callback only for WEP key
configuring.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 net/wireless/wext-compat.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index aa80c0c..c63e10e 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -531,7 +531,8 @@ static int __cfg80211_set_encryption(struct cfg80211_registered_device *rdev,
 			wdev->wext.keys->data[idx];
 	}
 
-	if (params->cipher != WLAN_CIPHER_SUITE_AES_CMAC &&
+	if ((params->cipher == WLAN_CIPHER_SUITE_WEP40 ||
+	     params->cipher == WLAN_CIPHER_SUITE_WEP104) &&
 	    (tx_key || (!addr && wdev->wext.default_key == -1))) {
 		if (wdev->current_bss)
 			err = rdev->ops->set_default_key(&rdev->wiphy,
-- 
1.6.0.4

