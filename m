Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:39268 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbaAVVJO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 16:09:14 -0500
Received: by mail-pb0-f47.google.com with SMTP id rp16so915693pbb.20
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jan 2014 13:09:13 -0800 (PST)
From: Chaitanya T K <chaitanya.mgit@gmail.com>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: Chaitanya T K <chaitanya.mgit@gmail.com>
Subject: [PATCH] minstrel_ht:  Use RTS_CTS when STA is in DYNAMIC SMPS mode for frames sent using Nss>1.
Date: Wed, 22 Jan 2014 12:27:45 +0530
Message-Id: <1390373865-6088-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20140122_220922_496698_558FFC80)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the STA is in Dynamic SMPS mode, tell
minstrel_ht to use RTS_CTS for frames which
are transmitted using more than 1 spatial
streams.

Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>
---
 net/mac80211/rc80211_minstrel_ht.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index c1b5b73..a1095d3 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -925,10 +925,17 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 		    sta->bandwidth < IEEE80211_STA_RX_BW_40)
 			continue;
 
-		/* Mark MCS > 7 as unsupported if STA is in static SMPS mode */
-		if (sta->smps_mode == IEEE80211_SMPS_STATIC &&
-		    minstrel_mcs_groups[i].streams > 1)
+		/* Handle STA's SMPS State
+		 * a. Use RTS_CTS, if Nss>1 and if STA is in Dynamic SMPS Mode
+		 * b. Mark Nss>1 as unsupported, if STA is in static SMPS mode
+		 */
+		if (sta->smps_mode == IEEE80211_SMPS_DYNAMIC &&
+			minstrel_mcs_groups[i].streams > 1) {
+			mi->tx_flags |= IEEE80211_TX_RC_USE_RTS_CTS;
+		} else if (sta->smps_mode == IEEE80211_SMPS_STATIC &&
+			minstrel_mcs_groups[i].streams > 1) {
 			continue;
+		}
 
 		mi->groups[i].supported =
 			mcs->rx_mask[minstrel_mcs_groups[i].streams - 1];
