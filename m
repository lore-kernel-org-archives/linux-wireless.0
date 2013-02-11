Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:45256 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757838Ab3BKRVS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 12:21:18 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v4 2/2] mac80211: Add flushes before going off-channel
Date: Mon, 11 Feb 2013 11:21:08 -0600
Message-Id: <1360603268-28594-2-git-send-email-seth.forshee@canonical.com> (sfid-20130211_182302_667414_8377C071)
In-Reply-To: <1360603268-28594-1-git-send-email-seth.forshee@canonical.com>
References: <20130211171829.GD13768@thinkpad-t410>
 <1360603268-28594-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We've got a couple of races when enabling powersave with an AP for
off-channel operation. The first is fairly simple. If we go off-channel
before the nullfunc frame to enable PS is transmitted then it may not be
received by the AP. Add a flush after enabling off-channel PS to prevent
this from happening.

The second race is a bit more subtle. If the driver supports QoS and has
frames queued when the nullfunc frame is queued, those frames may get
transmitted after the nullfunc frame. If PM is not set then the AP is
being told that we've exited PS before we go off-channel and may try to
deliver frames. To prevent this, add a flush after stopping the queues
but before passing the nullfunc frame to the driver.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 net/mac80211/offchannel.c |    5 +++++
 net/mac80211/scan.c       |    3 +++
 2 files changed, 8 insertions(+)

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 4c3ee3e..cc79b4a 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -114,8 +114,13 @@ void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local)
 	 * STA interfaces.
 	 */
 
+	/*
+	 * Stop queues and transmit all frames queued by the driver
+	 * before sending nullfunc to enable powersave at the AP.
+	 */
 	ieee80211_stop_queues_by_reason(&local->hw,
 					IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL);
+	drv_flush(local, false);
 
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 29e7d6e..ae422fa 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -330,6 +330,9 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 
 	ieee80211_offchannel_stop_vifs(local);
 
+	/* ensure nullfunc is transmitted before leaving operating channel */
+	drv_flush(local, false);
+
 	ieee80211_configure_filter(local);
 
 	/* We need to set power level at maximum rate for scanning. */
-- 
1.7.9.5

