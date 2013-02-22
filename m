Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:26412 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756181Ab3BVOuW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 09:50:22 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH v2 1/5] ath6kl: Cosmetic change in checking for free vif slot
Date: Fri, 22 Feb 2013 20:19:55 +0530
Message-ID: <1361544595-8881-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20130222_155026_625703_01C6DED3)
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

