Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:38034 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab1BOGQs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 01:16:48 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 22:16:27 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.net>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
Subject: [RFC 2/2] mac80211: Flush all txq before sending a nullfunc frame.
Date: Tue, 15 Feb 2011 11:46:29 +0530
Message-ID: <1297750589-15465-2-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1297750589-15465-1-git-send-email-vnatarajan@atheros.com>
References: <1297750589-15465-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In a highly noisy environment, a data frame which is queued before
a nullfunc frame on a different hw queue may be sent over the air
after the tx completion of nullfunc frame. This causes the station
to enter power save and the AP to see the station as awake and
continues to send the data traffic. Fix this by flushing all tx
queues before we send the null function frame with PM bit set.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 net/mac80211/mlme.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 4c58769..79e8f49 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -741,6 +741,9 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 	    (!(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED) ||
 	     !(ifmgd->flags & IEEE80211_STA_PS_PENDING))) {
 		ifmgd->flags |= IEEE80211_STA_PS_PENDING;
+		ieee80211_stop_queues_by_reason(&local->hw,
+						IEEE80211_QUEUE_STOP_REASON_PS);
+		drv_flush(local, false);
 		ieee80211_send_nullfunc(local, sdata, 1);
 	}
 
-- 
1.6.3.3

