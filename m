Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:48858 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754642AbYILRmI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 13:42:08 -0400
From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
To: linux-wireless@vger.kernel.org
Cc: yi.zhu@intel.com, Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Subject: [PATCH] mac80211 : Fix mode change hard_start_xmit function
Date: Fri, 12 Sep 2008 10:42:07 -0700
Message-Id: <1221241327-15720-1-git-send-email-abhijeet.kolekar@intel.com> (sfid-20080912_194212_937819_A2160941)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When monitor mode is changed to BSS or IBSS, data trasnfer can not happen
because proper transmit function is not assigend for BSS ,IBSS mode.
This patch fixes this problem assigning the ieee80211_subif_start_xmit
to device's hard_start_xmit function.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Acked-by: Zhu Yi <yi.zhu@intel.com>
---
 net/mac80211/iface.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 672cec6..df9d617 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -97,12 +97,14 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 
 	switch (type) {
 	case IEEE80211_IF_TYPE_AP:
+		sdata->dev->hard_start_xmit = ieee80211_subif_start_xmit;
 		skb_queue_head_init(&sdata->u.ap.ps_bc_buf);
 		INIT_LIST_HEAD(&sdata->u.ap.vlans);
 		break;
 	case IEEE80211_IF_TYPE_MESH_POINT:
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
+		sdata->dev->hard_start_xmit = ieee80211_subif_start_xmit;
 		ifsta = &sdata->u.sta;
 		INIT_WORK(&ifsta->work, ieee80211_sta_work);
 		setup_timer(&ifsta->timer, ieee80211_sta_timer,
-- 
1.5.4.3

