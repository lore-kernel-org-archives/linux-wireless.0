Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:54668 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab0ILDBr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Sep 2010 23:01:47 -0400
Received: by pxi10 with SMTP id 10so1617584pxi.19
        for <linux-wireless@vger.kernel.org>; Sat, 11 Sep 2010 20:01:47 -0700 (PDT)
From: Steve deRosier <steve@cozybit.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Cc: Steve deRosier <steve@cozybit.com>
Subject: [PATCH] mac80211: Fix dangling pointer in ieee80211_xmit
Date: Sat, 11 Sep 2010 20:01:31 -0700
Message-Id: <1284260491-35051-1-git-send-email-steve@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hdr pointer is left dangling after call to ieee80211_skb_resize. This
can cause guards around mesh path selection to fail.

Signed-off-by: Steve deRosier <steve@cozybit.com>
---
 net/mac80211/tx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index ccf3737..e1733dc 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1609,6 +1609,7 @@ static void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 		return;
 	}
 
+	hdr = (struct ieee80211_hdr *) skb->data;
 	info->control.vif = &sdata->vif;
 
 	if (ieee80211_vif_is_mesh(&sdata->vif) &&
-- 
1.7.0

