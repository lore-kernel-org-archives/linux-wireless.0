Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:65233 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab3JUROb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 13:14:31 -0400
Received: by mail-wi0-f175.google.com with SMTP id hm4so4309067wib.2
        for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2013 10:14:30 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, janusz.dziedzic@tieto.com,
	smihir@qti.qualcomm.com, tushnimb@qca.qualcomm.com,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 1/5] ath: fix logic on ath_reg_apply_active_scan_flags()
Date: Mon, 21 Oct 2013 19:14:20 +0200
Message-Id: <1382375664-25417-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20131021_191434_117053_BF6E404F)
In-Reply-To: <1382375664-25417-1-git-send-email-mcgrof@do-not-panic.com>
References: <1382375664-25417-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The existing logic removes the passive scan flag from
channels 12 and 13 when a regulatory hint coming from
something other than a country IE has been passed. This
is incorrect, the original intention was to ensure we
always have passive scan enabled for these two channels
for a specific set of custom world regulatory domains.

Cc: smihir@qti.qualcomm.com
Cc: tushnimb@qca.qualcomm.com
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ath/regd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index c00687e..1b4a532 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -255,16 +255,16 @@ ath_reg_apply_active_scan_flags(struct wiphy *wiphy,
 		return;
 
 	/*
-	 * If no country IE has been received always enable active scan
-	 * on these channels. This is only done for specific regulatory SKUs
+	 * If no country IE has been received always enable passive scan
+	 * and no-ibss on these channels. This is only done for specific
+	 * regulatory SKUs.
 	 */
 	if (initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE) {
 		ch = &sband->channels[11]; /* CH 12 */
-		if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
-			ch->flags &= ~IEEE80211_CHAN_PASSIVE_SCAN;
+		ch->flags |= IEEE80211_CHAN_PASSIVE_SCAN;
+
 		ch = &sband->channels[12]; /* CH 13 */
-		if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
-			ch->flags &= ~IEEE80211_CHAN_PASSIVE_SCAN;
+		ch->flags |= IEEE80211_CHAN_PASSIVE_SCAN;
 		return;
 	}
 
-- 
1.8.4.rc3

