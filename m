Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54366 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588Ab1IOHiA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 03:38:00 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] mac80211: fix endian issues and comments for BAR failure handling
Date: Thu, 15 Sep 2011 09:37:46 +0200
Message-Id: <1316072266-35118-1-git-send-email-nbd@openwrt.org> (sfid-20110915_093804_610952_59F1585E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/status.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 1426846..d50358c 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -278,17 +278,19 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 		}
 
 		if (!acked && ieee80211_is_back_req(fc)) {
+			u16 control;
+
 			/*
-			 * BAR failed, let's tear down the BA session as a
-			 * last resort as some STAs (Intel 5100 on Windows)
-			 * can get stuck when the BA window isn't flushed
-			 * correctly.
+			 * BAR failed, store the last SSN and retry sending
+			 * the BAR when the next unicast transmission on the
+			 * same TID succeeds.
 			 */
 			bar = (struct ieee80211_bar *) skb->data;
-			if (!(bar->control & IEEE80211_BAR_CTRL_MULTI_TID)) {
+			control = le16_to_cpu(bar->control);
+			if (!(control & IEEE80211_BAR_CTRL_MULTI_TID)) {
 				u16 ssn = le16_to_cpu(bar->start_seq_num);
 
-				tid = (bar->control &
+				tid = (control &
 				       IEEE80211_BAR_CTRL_TID_INFO_MASK) >>
 				      IEEE80211_BAR_CTRL_TID_INFO_SHIFT;
 
-- 
1.7.3.2

