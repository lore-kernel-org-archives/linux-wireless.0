Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:49747 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934197Ab3JPNpo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Oct 2013 09:45:44 -0400
Subject: [PATCH v2 1/8] ath10k: prevent starting monitor without a vdev
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 16 Oct 2013 16:45:41 +0300
Message-ID: <20131016134541.25095.59430.stgit@localhost6.localdomain6> (sfid-20131016_154546_873785_D1E8B332)
In-Reply-To: <20131016134503.25095.8044.stgit@localhost6.localdomain6>
References: <20131016134503.25095.8044.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

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
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 0b1cc51..527343d 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2265,8 +2265,14 @@ static void ath10k_configure_filter(struct ieee80211_hw *hw,
 	*total_flags &= SUPPORTED_FILTERS;
 	ar->filter_flags = *total_flags;
 
+	/* Monitor must not be started if it wasn't created first.
+	 * Promiscuous mode may be started on a non-monitor interface - in
+	 * such case the monitor vdev is not created so starting the
+	 * monitor makes no sense. Since ath10k uses no special RX filters
+	 * (only BSS filter in STA mode) there's no need for any special
+	 * action here. */
 	if ((ar->filter_flags & FIF_PROMISC_IN_BSS) &&
-	    !ar->monitor_enabled) {
+	    !ar->monitor_enabled && ar->monitor_present) {
 		ath10k_dbg(ATH10K_DBG_MAC, "mac monitor %d start\n",
 			   ar->monitor_vdev_id);
 
@@ -2274,7 +2280,7 @@ static void ath10k_configure_filter(struct ieee80211_hw *hw,
 		if (ret)
 			ath10k_warn("Unable to start monitor mode\n");
 	} else if (!(ar->filter_flags & FIF_PROMISC_IN_BSS) &&
-		   ar->monitor_enabled) {
+		   ar->monitor_enabled && ar->monitor_present) {
 		ath10k_dbg(ATH10K_DBG_MAC, "mac monitor %d stop\n",
 			   ar->monitor_vdev_id);
 

