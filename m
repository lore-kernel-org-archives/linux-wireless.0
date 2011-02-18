Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:20008 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754198Ab1BRLsJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 06:48:09 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 03:47:48 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] mac80211: Clear PS related flag on disabling power save.
Date: Fri, 18 Feb 2011 17:18:03 +0530
Message-ID: <1298029683-14997-1-git-send-email-vnatarajan@atheros.com>
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
index 17ef4f4..34edf7f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -236,6 +236,7 @@ ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
 	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 		ieee80211_stop_queues_by_reason(&local->hw,
 						IEEE80211_QUEUE_STOP_REASON_PS);
+		ifmgd->flags &= ~IEEE80211_STA_NULLFUNC_ACKED;
 		ieee80211_queue_work(&local->hw,
 				     &local->dynamic_ps_disable_work);
 	}
-- 
1.6.3.3

