Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:43081 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab3A2Xrw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 18:47:52 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: Seth Forshee <seth.forshee@canonical.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 4/7] mac80211: Add flushes before going off-channel
Date: Tue, 29 Jan 2013 17:47:32 -0600
Message-Id: <1359503255-18270-5-git-send-email-seth.forshee@canonical.com> (sfid-20130130_004758_258587_B2D8B732)
In-Reply-To: <1359503255-18270-1-git-send-email-seth.forshee@canonical.com>
References: <1359503255-18270-1-git-send-email-seth.forshee@canonical.com>
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
index 650af94..28274f9 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -118,8 +118,13 @@ bool ieee80211_offchannel_stop_vifs(struct ieee80211_local *local)
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
index 894c95e..c8103e4 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -343,6 +343,9 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 	if (!ieee80211_offchannel_stop_vifs(local))
 		goto error;
 
+	/* ensure nullfunc is transmitted before leaving operating channel */
+	drv_flush(local, false);
+
 	ieee80211_configure_filter(local);
 
 	/* We need to set power level at maximum rate for scanning. */
-- 
1.7.9.5

