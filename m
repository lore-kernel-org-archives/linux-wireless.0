Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:39386 "HELO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751010Ab1LTGFY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 01:05:24 -0500
Date: Tue, 20 Dec 2011 11:35:16 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH] mac80211: Call driver commands after drv_start in mac80211
 restart code
Message-ID: <20111220060505.GA4556@hertz.marvell.com> (sfid-20111220_070542_965445_37552613)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ideally, hardware/firmware initialization is complete after the
drv_start routine. In mac80211 restart code (ieee80211_reconfig),
defer calling the driver commands i.e. setup fragmentation
threshold, rts threshold and coverage class till drv_start
routine is called.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
---
 net/mac80211/util.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index eb1a5f7..faa0ad3 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1142,16 +1142,6 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		 */
 	}
 #endif
-
-	/* setup fragmentation threshold */
-	drv_set_frag_threshold(local, hw->wiphy->frag_threshold);
-
-	/* setup RTS threshold */
-	drv_set_rts_threshold(local, hw->wiphy->rts_threshold);
-
-	/* reset coverage class */
-	drv_set_coverage_class(local, hw->wiphy->coverage_class);
-
 	/* everything else happens only if HW was up & running */
 	if (!local->open_count)
 		goto wake_up;
@@ -1170,6 +1160,16 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		return res;
 	}
 
+	/* setup fragmentation threshold */
+	drv_set_frag_threshold(local, hw->wiphy->frag_threshold);
+
+	/* setup RTS threshold */
+	drv_set_rts_threshold(local, hw->wiphy->rts_threshold);
+
+	/* reset coverage class */
+	drv_set_coverage_class(local, hw->wiphy->coverage_class);
+
+
 	ieee80211_led_radio(local, true);
 	ieee80211_mod_tpt_led_trig(local,
 				   IEEE80211_TPT_LEDTRIG_FL_RADIO, 0);
-- 
1.7.5.4

