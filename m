Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab2FLJ7B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 05:59:01 -0400
Date: Tue, 12 Jun 2012 11:58:55 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org,
	David Spinadel <david.spinadel@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [RFC/RFT] mac80211: stop connection monitor on dissassoc
Message-ID: <20120612095850.GA2612@redhat.com> (sfid-20120612_115905_179706_23A45B48)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looks like is possible to do not kick of deferred scan when connection
monitoring is pending and on the same time we disconnect.

David, I can not recreate this problem locally, does below patch
fix the problem on your tests.

Thanks
Stanislaw

---
 net/mac80211/mlme.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d7134c1..1e20748 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1425,6 +1425,8 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	del_timer_sync(&sdata->u.mgd.bcn_mon_timer);
 	del_timer_sync(&sdata->u.mgd.timer);
 	del_timer_sync(&sdata->u.mgd.chswitch_timer);
+
+	ieee80211_stop_poll(sdata);
 }
 
 void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
-- 
1.7.1

