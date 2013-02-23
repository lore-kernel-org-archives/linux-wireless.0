Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51954 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350Ab3BWRlB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2013 12:41:01 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 3.9] mac80211: fix idle handling in monitor mode
Date: Sat, 23 Feb 2013 18:40:57 +0100
Message-Id: <1361641257-26963-1-git-send-email-nbd@openwrt.org> (sfid-20130223_184115_288120_B09C30B6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the driver does not want a monitor mode VIF, no channel context is
allocated for it. This causes ieee80211_recalc_idle to put the hardware
into idle mode if only a monitor mode is active, breaking injection.

Fix this by checking local->monitors in addition to active channel
contexts.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/iface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 2c059e5..640afab 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -107,7 +107,7 @@ void ieee80211_recalc_idle(struct ieee80211_local *local)
 
 	lockdep_assert_held(&local->mtx);
 
-	active = !list_empty(&local->chanctx_list);
+	active = !list_empty(&local->chanctx_list) || local->monitors;
 
 	if (!local->ops->remain_on_channel) {
 		list_for_each_entry(roc, &local->roc_list, list) {
-- 
1.8.0.2

