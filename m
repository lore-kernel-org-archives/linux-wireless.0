Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:13197 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbZKYHFw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 02:05:52 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 24 Nov 2009 23:05:58 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linux-wireless@vger.kernel.org>
Subject: [RFC PATCH] mac80211: Send null data frame after disabling power save in Tx path.
Date: Wed, 25 Nov 2009 12:35:54 +0530
Message-ID: <1259132754-18164-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For drivers setting IEEE80211_HW_PS_NULLFUNC_STACK, a null data frame
with PM bit off has to be sent before sending normal data frames.
If it is done in ps_disable_work, the actual data frame would be
queued first before this work is executed and hence null data frame
will be queued later. And also, this null data frame has to be sent
only after clearing CONF_PS.
Hence, directly clearing CONF_PS and sending null data frame in
ieee80211_xmit seems to function properly.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 net/mac80211/tx.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 943def2..51f537c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1433,10 +1433,10 @@ static void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 
 	if (need_dynamic_ps(local)) {
 		if (local->hw.conf.flags & IEEE80211_CONF_PS) {
-			ieee80211_stop_queues_by_reason(&local->hw,
-					IEEE80211_QUEUE_STOP_REASON_PS);
-			ieee80211_queue_work(&local->hw,
-					&local->dynamic_ps_disable_work);
+			local->hw.conf.flags &= ~IEEE80211_CONF_PS;
+			ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+			if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)
+				ieee80211_send_nullfunc(local, sdata, 0);
 		}
 
 		mod_timer(&local->dynamic_ps_timer, jiffies +
-- 
1.6.0.4

