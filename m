Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10114 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185AbZKXLxw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 06:53:52 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 24 Nov 2009 03:53:59 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: Fix dynamic power save for scanning.
Date: Tue, 24 Nov 2009 17:23:46 +0530
Message-ID: <1259063627-20033-2-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1259063627-20033-1-git-send-email-vnatarajan@atheros.com>
References: <1259063627-20033-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not only ps_sdata but also IEEE80211_CONF_PS is to be considered
before restoring PS in scan_ps_disable(). For instance, when ps_sdata
is set but CONF_PS is not set just because the dynamic timer is still
running, a sw scan leads to setting of CONF_PS in scan_ps_disable
instead of starting the dynamic PS timer.
Also for the above case, a null data frame is to be sent after
returning to operating channel which was not happening with the
current implementation. This patch fixes this too.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/scan.c        |   14 ++++++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ab28942..57bef7c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -746,6 +746,7 @@ struct ieee80211_local {
 	unsigned int wmm_acm; /* bit field of ACM bits (BIT(802.1D tag)) */
 
 	bool pspolling;
+	bool scan_ps_enabled;
 	/*
 	 * PS can only be enabled when we have exactly one managed
 	 * interface (and monitors) in PS, this then points there.
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 4cf387c..41076e4 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -227,7 +227,8 @@ static bool ieee80211_prep_hw_scan(struct ieee80211_local *local)
 static void ieee80211_scan_ps_enable(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
-	bool ps = false;
+
+	local->scan_ps_enabled = false;
 
 	/* FIXME: what to do when local->pspolling is true? */
 
@@ -235,12 +236,13 @@ static void ieee80211_scan_ps_enable(struct ieee80211_sub_if_data *sdata)
 	cancel_work_sync(&local->dynamic_ps_enable_work);
 
 	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
-		ps = true;
+		local->scan_ps_enabled = true;
 		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 	}
 
-	if (!ps || !(local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK))
+	if (!(local->scan_ps_enabled) ||
+	    !(local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK))
 		/*
 		 * If power save was enabled, no need to send a nullfunc
 		 * frame because AP knows that we are sleeping. But if the
@@ -261,7 +263,7 @@ static void ieee80211_scan_ps_disable(struct ieee80211_sub_if_data *sdata)
 
 	if (!local->ps_sdata)
 		ieee80211_send_nullfunc(local, sdata, 0);
-	else {
+	else if (local->scan_ps_enabled) {
 		/*
 		 * In !IEEE80211_HW_PS_NULLFUNC_STACK case the hardware
 		 * will send a nullfunc frame with the powersave bit set
@@ -277,6 +279,10 @@ static void ieee80211_scan_ps_disable(struct ieee80211_sub_if_data *sdata)
 		 */
 		local->hw.conf.flags |= IEEE80211_CONF_PS;
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+	} else {
+		ieee80211_send_nullfunc(local, sdata, 0);
+		mod_timer(&local->dynamic_ps_timer, jiffies +
+			  msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
 	}
 }
 
-- 
1.6.0.4

