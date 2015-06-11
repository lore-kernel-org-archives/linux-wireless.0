Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:35595 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964821AbbFKVFE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 17:05:04 -0400
Received: by pabli10 with SMTP id li10so4109217pab.2
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2015 14:05:03 -0700 (PDT)
From: Chaitanya T K <chaitanya.mgit@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Chaitanya T K <chaitanya.mgit@gmail.com>
Subject: [PATCH V4] mac80211: minstrel_ht: Handle Dynamic SMPS state of the peer.
Date: Fri, 12 Jun 2015 02:34:52 +0530
Message-Id: <1434056692-8011-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20150611_230508_221700_F6F0EFB0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of Dynamic SMPS enable RTS/CTS for all rates.

Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>
---
V4: Updated commit log and fixed indent.
V3: Moved the check to set_rate.
V2:Fix indent and add signoff.
---
 net/mac80211/rc80211_minstrel_ht.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 7430a1d..c8753ce 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -867,7 +867,13 @@ minstrel_ht_set_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 	else
 		idx = index % MCS_GROUP_RATES + (group->streams - 1) * 8;
 
-	if (offset > 0) {
+	/* Enable RTS/CTS for below cases.
+	 * 1) To Handle STA's SMPS State, if Nss > 1.
+	 * 2) 2nd and 3rd Rates, as 1st Rate Failed.
+	 */
+	if (offset > 0 &&
+	    (mi->sta->smps_mode == IEEE80211_SMPS_DYNAMIC &&
+	     group->streams > 1)) {
 		ratetbl->rate[offset].count = ratetbl->rate[offset].count_rts;
 		flags |= IEEE80211_TX_RC_USE_RTS_CTS;
 	}
-- 
1.9.1

