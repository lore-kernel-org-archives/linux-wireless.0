Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:36246 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab3KETWz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 14:22:55 -0500
Received: by mail-pa0-f48.google.com with SMTP id kq14so9318572pab.21
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 11:22:54 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Subject: [PATCH 08/17] mac80211: mesh_plink: don't ignore holding timer
Date: Tue,  5 Nov 2013 11:16:56 -0800
Message-Id: <1383679025-7150-8-git-send-email-thomas@cozybit.com> (sfid-20131105_202303_674934_25943E4F)
In-Reply-To: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
References: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bob Copeland <me@bobcopeland.com>

The ignore_plink_timer flag is set when doing mod_timer() if
the timer was not previously active.  This is to avoid executing
the timeout if del_timer() was subsequently called.  However,
del_timer() only happens if we are moving to ESTAB state or
get a close frame while in HOLDING.

We cannot leave HOLDING and re-enter ESTAB unless we receive a
close frame (in which case ignore_plink_timer is already set) or
if the timeout expires, so there actually isn't a case where
this is needed on mod_timer().

Signed-off-by: Bob Copeland <bob@cozybit.com>
---
 net/mac80211/mesh_plink.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 8e23395..550ebc1 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -671,8 +671,7 @@ static void mesh_plink_close(struct ieee80211_sub_if_data *sdata,
 
 	sta->reason = reason;
 	sta->plink_state = NL80211_PLINK_HOLDING;
-	if (!mod_plink_timer(sta, mshcfg->dot11MeshHoldingTimeout))
-		sta->ignore_plink_timer = true;
+	mod_plink_timer(sta, mshcfg->dot11MeshHoldingTimeout);
 }
 
 static u32 mesh_plink_establish(struct ieee80211_sub_if_data *sdata,
-- 
1.8.4.rc3

