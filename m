Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35415 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab0JAUdz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 16:33:55 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org,
	Jouni Malinen <j@w1.fi>, Paul Stewart <pstew@google.com>,
	Amod Bodas <amod.bodas@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH v2 2/3] mac80211: wait until completely disassociated before new association
Date: Fri,  1 Oct 2010 16:33:52 -0400
Message-Id: <1285965233-11097-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1285965233-11097-1-git-send-email-lrodriguez@atheros.com>
References: <1285965233-11097-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When roaming we try to disassociate with our old AP prior to
associating. The assumption though is that we will send our
disassociation first prior to sending our association request
to the new AP. This should in theory work given that the
association is put in through a workqueue but to avoid any
possible races just ensure we wait for complete disassociation
prior to trying to associate to the new AP.

In the worst case scenerio this will delay our association
request by one iteration on the work item.

This patch has a fix for kernels >= v2.6.34

Cc: stable@kernel.org
Cc: Jouni Malinen <j@w1.fi>
Cc: Paul Stewart <pstew@google.com>
Cc: Amod Bodas <amod.bodas@atheros.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/mlme.c |    3 ++-
 net/mac80211/work.c |   14 ++++++++++++++
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index daab0c6..7eff124 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -936,7 +936,6 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 
 	memcpy(bssid, ifmgd->associated->bssid, ETH_ALEN);
 
-	ifmgd->associated = NULL;
 	memset(ifmgd->bssid, 0, ETH_ALEN);
 
 	/*
@@ -1007,6 +1006,8 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	del_timer_sync(&sdata->u.mgd.bcn_mon_timer);
 	del_timer_sync(&sdata->u.mgd.timer);
 	del_timer_sync(&sdata->u.mgd.chswitch_timer);
+
+	ifmgd->associated = NULL;
 }
 
 void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index ae344d1..268ac1d 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -513,6 +513,19 @@ ieee80211_associate(struct ieee80211_work *wk)
 {
 	struct ieee80211_sub_if_data *sdata = wk->sdata;
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	bool associated;
+
+	mutex_lock(&ifmgd->mtx);
+	associated = !!ifmgd->associated;
+	mutex_unlock(&ifmgd->mtx);
+
+	if (associated) {
+		printk(KERN_DEBUG "%s: delaying association with %pM as "
+		       "we are still associated",
+		       sdata->name, wk->filter_ta);
+		goto wait;
+	}
 
 	wk->assoc.tries++;
 	if (wk->assoc.tries > IEEE80211_ASSOC_MAX_TRIES) {
@@ -534,6 +547,7 @@ ieee80211_associate(struct ieee80211_work *wk)
 	       sdata->name, wk->filter_ta, wk->assoc.tries);
 	ieee80211_send_assoc(sdata, wk);
 
+wait:
 	wk->timeout = jiffies + IEEE80211_ASSOC_TIMEOUT;
 	run_again(local, wk->timeout);
 
-- 
1.7.0.4

