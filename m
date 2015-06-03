Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:33230 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbbFCSWf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 14:22:35 -0400
Received: by pdbqa5 with SMTP id qa5so12931608pdb.0
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jun 2015 11:22:34 -0700 (PDT)
From: Chaitanya T K <chaitanya.mgit@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Chaitanya T K <chaitanya.mgit@gmail.com>
Subject: [PATCH V3] mac80211: minstrel_ht: Handle Dynamic SMPS state of the peer.
Date: Wed,  3 Jun 2015 23:52:12 +0530
Message-Id: <1433355732-7604-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20150603_202238_305381_5125904D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of Dynamic SMPS enable RTS/CTS for all rates.

Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>
---
V3: Moved the check to set_rate.
V2: Fix indent and add signoff.
---
 net/mac80211/rc80211_minstrel_ht.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 7430a1d..600208f 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -867,7 +867,15 @@ minstrel_ht_set_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 	else
 		idx = index % MCS_GROUP_RATES + (group->streams - 1) * 8;
 
-	if (offset > 0) {
+	/* Enable RTS/CTS for below cases.
+	 * 1) Handle STA's SMPS State, if Nss > 1.
+	 *    a. Use RTS_CTS, if STA is in Dynamic SMPS Mode
+	 *    b. Mark Nss > 1 as unsupported, if STA is in static SMPS mode
+	 * 2) 2nd and 3rd Rates, as 1st Rate Failed.
+	 */
+	if ((mi->sta->smps_mode == IEEE80211_SMPS_DYNAMIC &&
+	     group->streams > 1) ||
+	     offset > 0) {
 		ratetbl->rate[offset].count = ratetbl->rate[offset].count_rts;
 		flags |= IEEE80211_TX_RC_USE_RTS_CTS;
 	}
-- 
1.9.1

