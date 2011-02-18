Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:18038 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756071Ab1BRIsb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 03:48:31 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 00:48:10 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
Subject: [PATCH 2/2] mac80211: Clear PS related flag on disabling power save.
Date: Fri, 18 Feb 2011 14:18:25 +0530
Message-ID: <1298018905-6984-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Clear IEEE80211_STA_NULLFUNC_ACKED flag on disabling power
save. Without this fix, there is a chance of setting CONF_PS
before sending nullfunc frame.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 net/mac80211/tx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 17ef4f4..4b88edf 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -238,6 +238,7 @@ ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
 						IEEE80211_QUEUE_STOP_REASON_PS);
 		ieee80211_queue_work(&local->hw,
 				     &local->dynamic_ps_disable_work);
+		ifmgd->flags &= ~IEEE80211_STA_NULLFUNC_ACKED;
 	}
 
 	mod_timer(&local->dynamic_ps_timer, jiffies +
-- 
1.6.3.3

