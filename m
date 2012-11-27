Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:33497 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185Ab2K0RDd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 12:03:33 -0500
Received: by mail-wg0-f42.google.com with SMTP id dr1so2756716wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 09:03:31 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: johannes@sipsolutions.net
Cc: javier@cozybit.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] mac80211: Don't reinit rate control when mesh sta exists
Date: Tue, 27 Nov 2012 18:03:13 +0100
Message-Id: <1354035793-23498-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20121127_180336_398999_8341FC07)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes some unintended resets of the rate control statistics
when minstrel_ht is used resulting in non-optimal throughput on mesh
links.

Tested-by: Emanuel Taube <emanuel.taube@gmail.com>
Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/mesh_plink.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 234fe75..0327755 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -394,7 +394,9 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
 			ieee80211_ht_oper_to_channel_type(elems->ht_operation);
 	}
 
-	rate_control_rate_init(sta);
+	if (insert)
+		rate_control_rate_init(sta);
+
 	spin_unlock_bh(&sta->lock);
 
 	if (insert && sta_info_insert(sta))
-- 
1.7.7

