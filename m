Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34384 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934675Ab3DHSIB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 14:08:01 -0400
Received: by mail-pa0-f52.google.com with SMTP id fb10so3372575pad.25
        for <linux-wireless@vger.kernel.org>; Mon, 08 Apr 2013 11:08:00 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 5/6] mac80211: stringify another plink state
Date: Mon,  8 Apr 2013 11:06:16 -0700
Message-Id: <1365444377-9959-5-git-send-email-thomas@cozybit.com> (sfid-20130408_200806_024222_D6D8A981)
In-Reply-To: <1365444377-9959-1-git-send-email-thomas@cozybit.com>
References: <1365444377-9959-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch "mac80211: stringify mesh peering events" missed
an opportunity to print the peering state as a string.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_plink.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 937e06f..cdd4183 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -544,8 +544,8 @@ static void mesh_plink_timer(unsigned long data)
 		return;
 	}
 	mpl_dbg(sta->sdata,
-		"Mesh plink timer for %pM fired on state %d\n",
-		sta->sta.addr, sta->plink_state);
+		"Mesh plink timer for %pM fired on state %s\n",
+		sta->sta.addr, mplstates[sta->plink_state]);
 	reason = 0;
 	llid = sta->llid;
 	plid = sta->plid;
-- 
1.7.10.4

