Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:24365 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756910Ab3BNJgs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 04:36:48 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH 1/6] ath6kl: Cosmetic change in checking for free vif slot
Date: Thu, 14 Feb 2013 15:06:41 +0530
Message-ID: <1360834601-10972-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20130214_103654_170152_EC1C6966)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

A minor optimization is done in finding the free slot
available for the new virtual interface in the firmware.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index bc21489..8e45f41 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -402,7 +402,7 @@ static bool ath6kl_is_valid_iftype(struct ath6kl *ar, enum nl80211_iftype type,
 	if (type == NL80211_IFTYPE_STATION ||
 	    type == NL80211_IFTYPE_AP || type == NL80211_IFTYPE_ADHOC) {
 		for (i = 0; i < ar->vif_max; i++) {
-			if ((ar->avail_idx_map >> i) & BIT(0)) {
+			if ((ar->avail_idx_map) & BIT(i)) {
 				*if_idx = i;
 				return true;
 			}
@@ -412,7 +412,7 @@ static bool ath6kl_is_valid_iftype(struct ath6kl *ar, enum nl80211_iftype type,
 	if (type == NL80211_IFTYPE_P2P_CLIENT ||
 	    type == NL80211_IFTYPE_P2P_GO) {
 		for (i = ar->max_norm_iface; i < ar->vif_max; i++) {
-			if ((ar->avail_idx_map >> i) & BIT(0)) {
+			if ((ar->avail_idx_map) & BIT(i)) {
 				*if_idx = i;
 				return true;
 			}
-- 
1.7.9.5

