Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933436AbaLKQhJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2014 11:37:09 -0500
From: Jes.Sorensen@redhat.com
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 1/1] wireless: mac80211: Avoid using uninitialized stack data
Date: Thu, 11 Dec 2014 11:37:04 -0500
Message-Id: <1418315824-23753-2-git-send-email-Jes.Sorensen@redhat.com> (sfid-20141211_173714_440470_1E914710)
In-Reply-To: <1418315824-23753-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1418315824-23753-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Disable VHT in case driver advertises HT support without 40MHz+
channel support, in order to avoid accessing uninitialized stack data.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 net/mac80211/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 93af0f1..d7fe2fe 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -173,7 +173,7 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 
 	if (!(ht_cap->cap_info &
 	      cpu_to_le16(IEEE80211_HT_CAP_SUP_WIDTH_20_40))) {
-		ret = IEEE80211_STA_DISABLE_40MHZ;
+		ret = IEEE80211_STA_DISABLE_40MHZ | IEEE80211_STA_DISABLE_VHT;
 		goto out;
 	}
 
-- 
1.9.3

