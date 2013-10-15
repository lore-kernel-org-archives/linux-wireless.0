Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:42011 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555Ab3JORc3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 13:32:29 -0400
Received: by mail-pb0-f42.google.com with SMTP id un15so9118099pbc.29
        for <linux-wireless@vger.kernel.org>; Tue, 15 Oct 2013 10:32:28 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/7] ath10k: prevent starting monitor without a vdev
Date: Tue, 15 Oct 2013 10:29:50 -0700
Message-Id: <1381858196-17000-2-git-send-email-michal.kazior@tieto.com> (sfid-20131015_193232_046689_0FFCDE07)
In-Reply-To: <1381858196-17000-1-git-send-email-michal.kazior@tieto.com>
References: <1381858196-17000-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes issue with interface bridging.

Linux bridging sets promiscuous mode for all
interfaces that are in a bridge. This translates
to configure_filter() being called in a mac80211
driver.

Before the patch operational interface would be
started and upped again when promiscuous mode was
enabled causing all sorts of strange issues:

 * no HTT RX happening (i.e. no traffic)
 * FW crash upon driver reload/unload

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 049eca2..9f26fcf 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2205,8 +2205,13 @@ static void ath10k_configure_filter(struct ieee80211_hw *hw,
 	*total_flags &= SUPPORTED_FILTERS;
 	ar->filter_flags = *total_flags;
 
+	/* Monitor must not be started if it wasn't created first. Promiscuous
+	 * mode may be started on a non-monitor interface - in such case the monitor
+	 * vdev is not created so starting the monitor makes no sense. Since
+	 * ath10k uses no special RX filters (only BSS filter in STA mode)
+	 * there's no need for any special action here. */
 	if ((ar->filter_flags & FIF_PROMISC_IN_BSS) &&
-	    !ar->monitor_enabled) {
+	    !ar->monitor_enabled && ar->monitor_present) {
 		ath10k_dbg(ATH10K_DBG_MAC, "mac monitor %d start\n",
 			   ar->monitor_vdev_id);
 
@@ -2214,7 +2219,7 @@ static void ath10k_configure_filter(struct ieee80211_hw *hw,
 		if (ret)
 			ath10k_warn("Unable to start monitor mode\n");
 	} else if (!(ar->filter_flags & FIF_PROMISC_IN_BSS) &&
-		   ar->monitor_enabled) {
+		   ar->monitor_enabled && ar->monitor_present) {
 		ath10k_dbg(ATH10K_DBG_MAC, "mac monitor %d stop\n",
 			   ar->monitor_vdev_id);
 
-- 
1.8.4.rc3

