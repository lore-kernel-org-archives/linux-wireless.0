Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:26456 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306Ab3BVOul (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 09:50:41 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH v2 4/5] ath6kl: Remove NETDEV_REGISTERED flag
Date: Fri, 22 Feb 2013 20:20:33 +0530
Message-ID: <1361544633-9015-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20130222_155044_627474_3C82CEE5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Currently its no where used.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    1 -
 drivers/net/wireless/ath/ath6kl/core.h     |    1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 227fc43..e065c24 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3667,7 +3667,6 @@ struct wireless_dev *ath6kl_interface_add(struct ath6kl *ar, const char *name,
 	vif->sme_state = SME_DISCONNECTED;
 	set_bit(WLAN_ENABLED, &vif->flags);
 	ar->wlan_pwr_state = WLAN_POWER_STATE_ON;
-	set_bit(NETDEV_REGISTERED, &vif->flags);
 
 	if (type == NL80211_IFTYPE_ADHOC)
 		ar->ibss_if_active = true;
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 61b2f98..1c9ed40 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -560,7 +560,6 @@ enum ath6kl_vif_state {
 	WMM_ENABLED,
 	NETQ_STOPPED,
 	DTIM_EXPIRED,
-	NETDEV_REGISTERED,
 	CLEAR_BSSFILTER_ON_BEACON,
 	DTIM_PERIOD_AVAIL,
 	WLAN_ENABLED,
-- 
1.7.9.5

