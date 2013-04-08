Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:57713 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934675Ab3DHSID (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 14:08:03 -0400
Received: by mail-pa0-f45.google.com with SMTP id kl13so3377022pab.18
        for <linux-wireless@vger.kernel.org>; Mon, 08 Apr 2013 11:08:02 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 6/6] mac80211: avoid mesh peer rate update warning
Date: Mon,  8 Apr 2013 11:06:17 -0700
Message-Id: <1365444377-9959-6-git-send-email-thomas@cozybit.com> (sfid-20130408_200807_629725_2073CFC2)
In-Reply-To: <1365444377-9959-1-git-send-email-thomas@cozybit.com>
References: <1365444377-9959-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some drivers (like ath9k_htc) will take a mutex in
rate_control_rate_update(), so drop the sta lock before we
get there.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>

Can go towards 3.9.
---
 net/mac80211/mesh_plink.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index cdd4183..ca284ee 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -379,8 +379,10 @@ static void mesh_sta_info_init(struct ieee80211_sub_if_data *sdata,
 	sta->last_rx = jiffies;
 
 	/* rates and capabilities don't change during peering */
-	if (sta->plink_state == NL80211_PLINK_ESTAB)
-		goto out;
+	if (sta->plink_state == NL80211_PLINK_ESTAB) {
+		spin_unlock_bh(&sta->lock);
+		return;
+	}
 
 	if (sta->sta.supp_rates[band] != rates)
 		changed |= IEEE80211_RC_SUPP_RATES_CHANGED;
@@ -398,13 +400,12 @@ static void mesh_sta_info_init(struct ieee80211_sub_if_data *sdata,
 			changed |= IEEE80211_RC_BW_CHANGED;
 		sta->sta.bandwidth = IEEE80211_STA_RX_BW_20;
 	}
+	spin_unlock_bh(&sta->lock);
 
 	if (insert)
 		rate_control_rate_init(sta);
 	else
 		rate_control_rate_update(local, sband, sta, changed);
-out:
-	spin_unlock_bh(&sta->lock);
 }
 
 static struct sta_info *
-- 
1.7.10.4

