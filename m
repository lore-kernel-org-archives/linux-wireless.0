Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36861 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236AbbFBS2L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 14:28:11 -0400
Received: by pabqy3 with SMTP id qy3so17791281pab.3
        for <linux-wireless@vger.kernel.org>; Tue, 02 Jun 2015 11:28:11 -0700 (PDT)
From: Chaitanya T K <chaitanya.mgit@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Chaitanya Tata <chaitanya.mgit@gmail.com>
Subject: [PATCH] mac80211: Minstrel HT: Handle all SMPS states of the peer STA.
Date: Tue,  2 Jun 2015 23:57:47 +0530
Message-Id: <1433269667-9588-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20150602_202816_847914_EABB29D4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaitanya Tata <chaitanya.mgit@gmail.com>

In case of Dynamic SMPS enable RTS/CTS for all rates.
In case of Static SMPS mark the Nss > 1 rates as not supported.
---
 net/mac80211/rc80211_minstrel_ht.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 7430a1d..fdc08d0 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -1176,9 +1176,16 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 
 		nss = minstrel_mcs_groups[i].streams;
 
-		/* Mark MCS > 7 as unsupported if STA is in static SMPS mode */
-		if (sta->smps_mode == IEEE80211_SMPS_STATIC && nss > 1)
-			continue;
+		/* Handle STA's SMPS State, if Nss > 1.
+		* a. Use RTS_CTS, if STA is in Dynamic SMPS Mode
+		* b. Mark Nss > 1 as unsupported, if STA is in static SMPS mode
+		*/
+		if (nss > 1) {
+			if (sta->smps_mode == IEEE80211_SMPS_DYNAMIC)
+			       gflags |= IEEE80211_TX_RC_USE_RTS_CTS;
+			else if (sta->smps_mode == IEEE80211_SMPS_STATIC)
+				continue;
+		}
 
 		/* HT rate */
 		if (gflags & IEEE80211_TX_RC_MCS) {
-- 
1.9.1

