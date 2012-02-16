Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16567 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab2BPGnk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Feb 2012 01:43:40 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	<stable@vger.kernel.org>, Pavel Roskin <proski@gnu.org>
Subject: [RFC] mac80211: zero initialize count field in ieee80211_tx_rate
Date: Thu, 16 Feb 2012 12:13:31 +0530
Message-ID: <1329374611-3793-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120216_074355_832747_AC495CF2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

rate control algorithms concludes the rate as invalid
with rate[i].idx < -1 , while they do also check for rate[i].count is
non-zero. it would be safer to zero initialize the 'count' field.
recently we had a ath9k rate control crash where the ath9k rate control
in ath_tx_status assumed to check only for rate[i].count being non-zero
in one instance and ended up in using invalid rate index for
'connection monitoring NULL func frames' which eventually lead to the crash.
thanks to Pavel Roskin for fixing it and finding the root cause.
https://bugzilla.redhat.com/show_bug.cgi?id=768639

Cc: stable@vger.kernel.org
Cc: Pavel Roskin <proski@gnu.org>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 net/mac80211/rate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 111fba3..b4f7600 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -447,7 +447,7 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
 		info->control.rates[i].idx = -1;
 		info->control.rates[i].flags = 0;
-		info->control.rates[i].count = 1;
+		info->control.rates[i].count = 0;
 	}
 
 	if (sdata->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL)
-- 
1.7.0.4

