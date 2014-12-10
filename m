Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932319AbaLJT3l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2014 14:29:41 -0500
From: Jes.Sorensen@redhat.com
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 1/1] wireless: mac80211: Avoid using uninitialized stack data
Date: Wed, 10 Dec 2014 14:14:07 -0500
Message-Id: <1418238847-3332-2-git-send-email-Jes.Sorensen@redhat.com> (sfid-20141210_202944_276875_1BFA0DC0)
In-Reply-To: <1418238847-3332-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1418238847-3332-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Avoid case where we would access uninitialized stack data if a driver
advertises HT support without 40MHz channel support.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 net/mac80211/mlme.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 93af0f1..da1f639 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -174,6 +174,7 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 	if (!(ht_cap->cap_info &
 	      cpu_to_le16(IEEE80211_HT_CAP_SUP_WIDTH_20_40))) {
 		ret = IEEE80211_STA_DISABLE_40MHZ;
+		vht_chandef = *chandef;
 		goto out;
 	}
 
-- 
1.9.3

