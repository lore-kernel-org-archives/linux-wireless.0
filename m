Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:35668 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbbEMJRA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2015 05:17:00 -0400
Received: by labbd9 with SMTP id bd9so24704327lab.2
        for <linux-wireless@vger.kernel.org>; Wed, 13 May 2015 02:16:59 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 2/2] mac80211: prevent possible crypto tx tailroom corruption
Date: Wed, 13 May 2015 09:16:49 +0000
Message-Id: <1431508609-9841-2-git-send-email-michal.kazior@tieto.com> (sfid-20150513_111710_890097_51B4594F)
In-Reply-To: <1431508609-9841-1-git-send-email-michal.kazior@tieto.com>
References: <1431349503-5461-1-git-send-email-michal.kazior@tieto.com>
 <1431508609-9841-1-git-send-email-michal.kazior@tieto.com>
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
    While doing PATCH v2 [1/2] I've noticed a subtle bug in the
    delayed tailroom counter logic. Since this touches the
    codepaths [1/2] does I'm posting this as a pair.

 net/mac80211/key.c  | 5 ++++-
 net/mac80211/main.c | 3 +++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 577a11a13cdf..4c6f8c97d11a 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -695,10 +695,13 @@ void ieee80211_reset_crypto_tx_tailroom(struct ieee80211_sub_if_data *sdata)
 	mutex_lock(&sdata->local->key_mtx);
 
 	sdata->crypto_tx_tailroom_needed_cnt = 0;
+	sdata->crypto_tx_tailroom_pending_dec = 0;
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP) {
-		list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
+		list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list) {
 			vlan->crypto_tx_tailroom_needed_cnt = 0;
+			vlan->crypto_tx_tailroom_pending_dec = 0;
+		}
 	}
 
 	mutex_unlock(&sdata->local->key_mtx);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 3c956c5f99b2..d8e1cbdcbc43 100644
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
+		cancel_delayed_work_sync(&sdata->dec_tailroom_needed_wk);
 	ieee80211_scan_cancel(local);
 	ieee80211_reconfig(local);
 	rtnl_unlock();
-- 
2.1.4

