Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:32173 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722AbYDQXFP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2008 19:05:15 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ester Kummer <ester.kummer@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] mac80211: correct skb allocation
Date: Thu, 17 Apr 2008 16:05:14 -0700
Message-Id: <1208473514-16688-1-git-send-email-reinette.chatre@intel.com> (sfid-20080418_000520_553284_D6063D59)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ester Kummer <ester.kummer@intel.com>

This patch corrects the allocation of skb in ADDBA req/resp and DELBA
it removes redundant space u.addba_* are already counted in sizeof(*mgmt)

Signed-off-by: Ester Kummer <ester.kummer@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/mlme.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c0a5345..b0b079c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1098,8 +1098,8 @@ static void ieee80211_send_addba_resp(struct net_device *dev, u8 *da, u16 tid,
 	struct ieee80211_mgmt *mgmt;
 	u16 capab;
 
-	skb = dev_alloc_skb(sizeof(*mgmt) + local->hw.extra_tx_headroom + 1 +
-					sizeof(mgmt->u.action.u.addba_resp));
+	skb = dev_alloc_skb(sizeof(*mgmt) + local->hw.extra_tx_headroom);
+
 	if (!skb) {
 		printk(KERN_DEBUG "%s: failed to allocate buffer "
 		       "for addba resp frame\n", dev->name);
@@ -1147,9 +1147,7 @@ void ieee80211_send_addba_request(struct net_device *dev, const u8 *da,
 	struct ieee80211_mgmt *mgmt;
 	u16 capab;
 
-	skb = dev_alloc_skb(sizeof(*mgmt) + local->hw.extra_tx_headroom + 1 +
-				sizeof(mgmt->u.action.u.addba_req));
-
+	skb = dev_alloc_skb(sizeof(*mgmt) + local->hw.extra_tx_headroom);
 
 	if (!skb) {
 		printk(KERN_ERR "%s: failed to allocate buffer "
@@ -1411,8 +1409,7 @@ void ieee80211_send_delba(struct net_device *dev, const u8 *da, u16 tid,
 	struct ieee80211_mgmt *mgmt;
 	u16 params;
 
-	skb = dev_alloc_skb(sizeof(*mgmt) + local->hw.extra_tx_headroom + 1 +
-					sizeof(mgmt->u.action.u.delba));
+	skb = dev_alloc_skb(sizeof(*mgmt) + local->hw.extra_tx_headroom);
 
 	if (!skb) {
 		printk(KERN_ERR "%s: failed to allocate buffer "
-- 
1.5.3.4

