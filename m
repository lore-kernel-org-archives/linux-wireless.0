Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56398 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328Ab2BYJNR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Feb 2012 04:13:17 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl: Make sure wiphy is registered before calling regulatory_hint()
Date: Sat, 25 Feb 2012 14:43:17 +0530
Message-ID: <1330161197-8593-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120225_101322_824417_DF5F5DC3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As regulatory events are processed even before the wiphy is registered,
calling regulatory_hint() at early stage should be fixed.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    4 ++++
 drivers/net/wireless/ath/ath6kl/core.h     |    2 ++
 drivers/net/wireless/ath/ath6kl/wmi.c      |    2 +-
 3 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index e82f220..af3d0ab 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3021,12 +3021,16 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
 		return ret;
 	}
 
+	ar->wiphy_registered = true;
+
 	return 0;
 }
 
 void ath6kl_cfg80211_cleanup(struct ath6kl *ar)
 {
 	wiphy_unregister(ar->wiphy);
+
+	ar->wiphy_registered = false;
 }
 
 struct ath6kl *ath6kl_cfg80211_create(void)
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 8d8677d..cb5ddda 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -654,6 +654,8 @@ struct ath6kl {
 
 	bool p2p;
 
+	bool wiphy_registered;
+
 #ifdef CONFIG_ATH6KL_DEBUG
 	struct {
 		struct sk_buff_head fwlog_queue;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 0527933..97680a2 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -914,7 +914,7 @@ static void ath6kl_wmi_regdomain_event(struct wmi *wmi, u8 *datap, int len)
 				regpair->regDmnEnum);
 	}
 
-	if (country) {
+	if (country && wmi->parent_dev->wiphy_registered) {
 		alpha2[0] = country->isoName[0];
 		alpha2[1] = country->isoName[1];
 
-- 
1.7.0.4

