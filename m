Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:60315 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098Ab1BDMku (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 07:40:50 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 04 Feb 2011 04:40:30 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linux-wireless@vger.kernel.org>
Subject: [RFC] mac80211: Flush all txq before sending a nullfunc frame.
Date: Fri, 4 Feb 2011 18:10:46 +0530
Message-ID: <1296823246-5517-1-git-send-email-vnatarajan@atheros.com>
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
 net/mac80211/mlme.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 45f736e..f963df5 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -729,6 +729,7 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 	if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
 	    (!(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED))) {
 		ifmgd->flags |= IEEE80211_STA_PS_PENDING;
+		drv_flush(local, false);
 		ieee80211_send_nullfunc(local, sdata, 1);
 	}
 
-- 
1.6.3.3

