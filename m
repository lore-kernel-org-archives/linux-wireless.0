Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:14808 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbYG2SDy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 14:03:54 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1737059nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2008 11:03:53 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Tue, 29 Jul 2008 19:59:31 +0200
Subject: [PATCH] mac80211: fix mesh beaconing
Message-ID: <488f5b87.1636440a.2c8e.ffffb08d@mx.google.com> (sfid-20080729_200405_549051_36910A5B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes mesh beaconing, which was broken by commit 1d22d3f6e3b (revamp
beacon configuration).

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/mlme.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 8f51375..9c451eb 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3303,6 +3303,7 @@ void ieee80211_start_mesh(struct net_device *dev)
 	ifsta = &sdata->u.sta;
 	ifsta->state = IEEE80211_MESH_UP;
 	ieee80211_sta_timer((unsigned long)sdata);
+	ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON);
 }
 #endif
 
-- 
1.5.4.3



