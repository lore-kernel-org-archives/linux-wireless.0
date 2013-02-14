Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:5973 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932372Ab3BNJi3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 04:38:29 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH 6/6] ath6kl: Fix mgmt subtypes for station and p2p client
Date: Thu, 14 Feb 2013 15:08:21 +0530
Message-ID: <1360834701-11231-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20130214_103833_097301_8C4ECB69)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

The mgmt subtypes advertized for the STA mode seems to
be inverted, fix this. Found this during code review.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index e065c24..9ebeb60 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3364,9 +3364,9 @@ static const struct ieee80211_txrx_stypes
 ath6kl_mgmt_stypes[NUM_NL80211_IFTYPES] = {
 	[NL80211_IFTYPE_STATION] = {
 		.tx = BIT(IEEE80211_STYPE_ACTION >> 4) |
-		BIT(IEEE80211_STYPE_PROBE_RESP >> 4),
+		BIT(IEEE80211_STYPE_PROBE_REQ >> 4),
 		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
-		BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
+		BIT(IEEE80211_STYPE_PROBE_RESP >> 4)
 	},
 	[NL80211_IFTYPE_AP] = {
 		.tx = BIT(IEEE80211_STYPE_ACTION >> 4) |
@@ -3376,9 +3376,9 @@ ath6kl_mgmt_stypes[NUM_NL80211_IFTYPES] = {
 	},
 	[NL80211_IFTYPE_P2P_CLIENT] = {
 		.tx = BIT(IEEE80211_STYPE_ACTION >> 4) |
-		BIT(IEEE80211_STYPE_PROBE_RESP >> 4),
+		BIT(IEEE80211_STYPE_PROBE_REQ >> 4),
 		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
-		BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
+		BIT(IEEE80211_STYPE_PROBE_RESP >> 4)
 	},
 	[NL80211_IFTYPE_P2P_GO] = {
 		.tx = BIT(IEEE80211_STYPE_ACTION >> 4) |
-- 
1.7.9.5

