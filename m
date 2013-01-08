Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:55075 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834Ab3AHSKv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2013 13:10:51 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 1/3] mac80211: Add flushes to ensure off-channel PS is enabled during sw scans
Date: Tue,  8 Jan 2013 12:10:43 -0600
Message-Id: <1357668645-5101-2-git-send-email-seth.forshee@canonical.com> (sfid-20130108_191054_124563_03088B9D)
In-Reply-To: <1357668645-5101-1-git-send-email-seth.forshee@canonical.com>
References: <1357668645-5101-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We've got a couple of races when enabling powersave with an AP for
off-channel operation. The first is fairly simple. If we go off-channel
prior to the nullfunc frame to enable PS is actually transmitted then it
may not be received by the AP. Add a flush after enabling off-channel PS
to prevent this from happening.

The second race is a bit more subtle. If the driver supports QoS and has
frames queued when the nullfunc frame is queued, those frames may get
transmitted after the nullfunc frame. If PM is not set then the AP is
being told that we've exited PS before we go off-channel and may try to
deliver frames. To prevent this, add a flush after stopping the netdev
queues but before passing the nullfunc frame to the driver.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 net/mac80211/offchannel.c |   17 ++++++++++++++++-
 net/mac80211/scan.c       |    8 ++++++++
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index a5379ae..ccb91a2 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -136,8 +136,23 @@ void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
 			netif_tx_stop_all_queues(sdata->dev);
 			if (offchannel_ps_enable &&
 			    (sdata->vif.type == NL80211_IFTYPE_STATION) &&
-			    sdata->u.mgd.associated)
+			    sdata->u.mgd.associated) {
+				/*
+				 * Need to flush frames in driver queues
+				 * before sending nullfunc. Otherwise
+				 * devices which support QoS may send the
+				 * nullfunc before these queued frames, and
+				 * those frames may not have PM set.
+				 *
+				 * XXX: Would be nice to not flush for each
+				 * vif, however I don't see that there's any
+				 * protection to prevent frames being handed
+				 * to the driver before stopping the netdev
+				 * queue.
+				 */
+				drv_flush(local, false);
 				ieee80211_offchannel_ps_enable(sdata);
+			}
 		}
 	}
 	mutex_unlock(&local->iflist_mtx);
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 8ed83dc..a875f74 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -355,6 +355,14 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 
 	ieee80211_offchannel_stop_vifs(local, true);
 
+	/*
+	 * Flush hw queues to ensure that the nullfunc to enable powersave
+	 * gets sent before going off-channel.
+	 *
+	 * XXX: Delay for drivers not supporting flush?
+	 */
+	drv_flush(local, false);
+
 	ieee80211_configure_filter(local);
 
 	/* We need to set power level at maximum rate for scanning. */
-- 
1.7.9.5

