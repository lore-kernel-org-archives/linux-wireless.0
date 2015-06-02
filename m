Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34212 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbbFBShN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 14:37:13 -0400
Received: by payr10 with SMTP id r10so56131066pay.1
        for <linux-wireless@vger.kernel.org>; Tue, 02 Jun 2015 11:37:13 -0700 (PDT)
From: Chaitanya T K <chaitanya.mgit@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Chaitanya Tata <chaitanya.mgit@gmail.com>
Subject: [PATCH V2] mac80211: Minstrel HT: Handle all SMPS states of the peer STA.
Date: Wed,  3 Jun 2015 00:07:04 +0530
Message-Id: <1433270224-10013-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20150602_203717_631497_E8D9B4A1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaitanya Tata <chaitanya.mgit@gmail.com>

In case of Dynamic SMPS enable RTS/CTS for all rates.
In case of Static SMPS mark the Nss > 1 rates as not supported.

Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>
---
V2: Fix the Indent and Sign off missing.
---
 net/mac80211/rc80211_minstrel_ht.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 7430a1d..0889c22 100644
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
+				gflags |= IEEE80211_TX_RC_USE_RTS_CTS;
+			else if (sta->smps_mode == IEEE80211_SMPS_STATIC)
+				continue;
+		}
 
 		/* HT rate */
 		if (gflags & IEEE80211_TX_RC_MCS) {
-- 
1.9.1

