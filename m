Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:58860 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934681Ab2DLVco (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 17:32:44 -0400
Received: by mail-pz0-f52.google.com with SMTP id e40so2999487dak.11
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2012 14:32:44 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Marco Porsch <marco.porsch@s2005.tu-chemnitz.de>,
	Pavel Zubarev <pavel.zubarev@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	devel@lists.open80211s.org, ashok@cozybit.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/4] mac80211: Choose a new toffset setpoint if a big tsf jump is detected.
Date: Thu, 12 Apr 2012 14:32:22 -0700
Message-Id: <1334266343-3970-4-git-send-email-javier@cozybit.com> (sfid-20120412_233248_660718_6F12BECD)
In-Reply-To: <1334266343-3970-1-git-send-email-javier@cozybit.com>
References: <1334266343-3970-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_sync.c |   26 ++++++++++++++++++++------
 1 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mesh_sync.c b/net/mac80211/mesh_sync.c
index f78b013..22a5f1e 100644
--- a/net/mac80211/mesh_sync.c
+++ b/net/mac80211/mesh_sync.c
@@ -22,7 +22,14 @@
 /* This is not in the standard.  It represents a tolerable tbtt drift below
  * which we do no TSF adjustment.
  */
-#define TBTT_MINIMUM_ADJUSTMENT 10
+#define TOFFSET_MINIMUM_ADJUSTMENT 10
+
+/* This is not in the standard.  It represents the maximum Toffset jump above
+ * which we'll invalidate the Toffset setpoint and choose a new setpoint.  This
+ * could be, for instance, in case a neighbor is restarted and its TSF counter
+ * reset.
+ * */
+#define TOFFSET_MAXIMUM_ADJUSTMENT 30000		/* 30 ms */
 
 struct sync_method {
 	u8 method;
@@ -156,15 +163,22 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	if (test_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN)) {
 		s64 t_clockdrift = sta->t_offset_setpoint
 				   - sta->t_offset;
-
-		msync_dbg("STA %pM : sta->t_offset=%lld,"
-			  " sta->t_offset_setpoint=%lld,"
-			  " t_clockdrift=%lld",
+		msync_dbg("STA %pM : sta->t_offset=%lld, sta->t_offset_setpoint=%lld, t_clockdrift=%lld",
 			  sta->sta.addr,
 			  (long long) sta->t_offset,
 			  (long long)
 			  sta->t_offset_setpoint,
 			  (long long) t_clockdrift);
+
+		if (t_clockdrift > TOFFSET_MAXIMUM_ADJUSTMENT ||
+			t_clockdrift < -TOFFSET_MAXIMUM_ADJUSTMENT) {
+			msync_dbg("STA %pM : t_clockdrift=%lld too large, setpoint reset",
+				  sta->sta.addr,
+				  (long long) t_clockdrift);
+			clear_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN);
+			goto no_sync;
+		}
+
 		rcu_read_unlock();
 
 		spin_lock_bh(&ifmsh->sync_offset_lock);
@@ -200,7 +214,7 @@ static void mesh_sync_offset_adjust_tbtt(struct ieee80211_sub_if_data *sdata)
 	spin_lock_bh(&ifmsh->sync_offset_lock);
 
 	if (ifmsh->sync_offset_clockdrift_max >
-		TBTT_MINIMUM_ADJUSTMENT) {
+		TOFFSET_MINIMUM_ADJUSTMENT) {
 		/* Since ajusting the tsf here would
 		 * require a possibly blocking call
 		 * to the driver tsf setter, we punt
-- 
1.7.5.4

