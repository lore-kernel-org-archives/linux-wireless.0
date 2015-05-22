Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:37696 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbbEVIWy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2015 04:22:54 -0400
Received: by wibt6 with SMTP id t6so39099030wib.0
        for <linux-wireless@vger.kernel.org>; Fri, 22 May 2015 01:22:52 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3] mac80211: prevent possible crypto tx tailroom corruption
Date: Fri, 22 May 2015 10:22:40 +0200
Message-Id: <1432282960-4980-1-git-send-email-michal.kazior@tieto.com> (sfid-20150522_102300_569337_B5E56B76)
In-Reply-To: <1431508609-9841-2-git-send-email-michal.kazior@tieto.com>
References: <1431508609-9841-2-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There was a possible race between
ieee80211_reconfig() and
ieee80211_delayed_tailroom_dec(). This could
result in inability to transmit data if driver
crashed during roaming or rekeying and subsequent
skbs with insufficient tailroom appeared.

This race was probably never seen in the wild
because a device driver would have to crash AND
recover within 0.5s which is very unlikely.

I was able to prove this race exists after
changing the delay to 10s locally and crashing
ath10k via debugfs immediately after GTK
rekeying. In case of ath10k the counter went below
0. This was harmless but other drivers which
actually require tailroom (e.g. for WEP ICV or
MMIC) could end up with the counter at 0 instead
of >0 and introduce insufficient skb tailroom
failures because mac80211 would not resize skbs
appropriately anymore.

Fixes: 8d1f7ecd2af5 ("mac80211: defer tailroom counter manipulation when roaming")
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v3:
     * use flush_work() [Johannes]

 net/mac80211/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 99d27babd9f0..674164fe5cdb 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -246,6 +246,7 @@ static void ieee80211_restart_work(struct work_struct *work)
 {
 	struct ieee80211_local *local =
 		container_of(work, struct ieee80211_local, restart_work);
+	struct ieee80211_sub_if_data *sdata;
 
 	/* wait for scan work complete */
 	flush_workqueue(local->workqueue);
@@ -254,6 +255,8 @@ static void ieee80211_restart_work(struct work_struct *work)
 	     "%s called with hardware scan in progress\n", __func__);
 
 	rtnl_lock();
+	list_for_each_entry(sdata, &local->interfaces, list)
+		flush_delayed_work(&sdata->dec_tailroom_needed_wk);
 	ieee80211_scan_cancel(local);
 	ieee80211_reconfig(local);
 	rtnl_unlock();
-- 
2.1.4

