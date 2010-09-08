Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46288 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab0IHXeq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 19:34:46 -0400
Received: by mail-pv0-f174.google.com with SMTP id 2so255484pvg.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 16:34:46 -0700 (PDT)
From: Steve deRosier <steve@cozybit.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	Steve deRosier <steve@cozybit.com>
Subject: [PATCH 2/2] mac80211: Fix dangling pointer in ieee80211_xmit
Date: Wed,  8 Sep 2010 16:34:32 -0700
Message-Id: <1283988872-44843-3-git-send-email-steve@cozybit.com>
In-Reply-To: <1283988872-44843-1-git-send-email-steve@cozybit.com>
References: <1283988872-44843-1-git-send-email-steve@cozybit.com>
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

