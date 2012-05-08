Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51455 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2EHEAp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 00:00:45 -0400
Received: by obbtb18 with SMTP id tb18so9215680obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 May 2012 21:00:45 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	javier@cozybit.com, devel@lists.open80211s.org,
	Ashok Nagarajan <ashok@cozybit.com>
Subject: [PATCH 1/4] mac80211: Push the deleted comment to correct place
Date: Mon,  7 May 2012 21:00:29 -0700
Message-Id: <1336449632-9057-1-git-send-email-ashok@cozybit.com> (sfid-20120508_060115_685153_8310A086)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This comment is deleted in the patch "mac80211: Advertise HT protection mode in
IEs". Moving the comment to the now corrected place.

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
---
 net/mac80211/ibss.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index bb1a3e6..11ac1ff 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -163,6 +163,11 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 				   sizeof(struct ieee80211_ht_operation));
 		pos = ieee80211_ie_build_ht_cap(pos, &sband->ht_cap,
 						sband->ht_cap.cap);
+		/*
+		 * Note: According to 802.11n-2009 9.13.3.1, HT Protection
+		 * field and RIFS Mode are reserved in IBSS mode, therefore
+		 * keep them at 0
+		 */
 		pos = ieee80211_ie_build_ht_oper(pos, &sband->ht_cap,
 						 chan, channel_type, 0);
 	}
-- 
1.7.5.4

