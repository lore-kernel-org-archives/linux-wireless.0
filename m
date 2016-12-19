Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41964 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758462AbcLSKzP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Dec 2016 05:55:15 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 11/11] rt2x00: add mutex to synchronize config and link tuner
Date: Mon, 19 Dec 2016 11:52:57 +0100
Message-Id: <1482144777-16760-12-git-send-email-sgruszka@redhat.com> (sfid-20161219_120239_716480_AA5B00CA)
In-Reply-To: <1482144777-16760-1-git-send-email-sgruszka@redhat.com>
References: <1482144777-16760-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not perform mac80211 config and link_tuner at the same time,
this can possibly result in wrong RF or BBP configuration.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00.h     |    4 ++++
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c  |    1 +
 drivers/net/wireless/ralink/rt2x00/rt2x00link.c |    5 +++++
 drivers/net/wireless/ralink/rt2x00/rt2x00mac.c  |    5 +++++
 4 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index 01ce8a4..60dd4ac 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -834,6 +834,10 @@ struct rt2x00_dev {
 	struct mutex csr_mutex;
 
 	/*
+	 * Mutex to synchronize config and link tuner.
+	 */
+	struct mutex conf_mutex;
+	/*
 	 * Current packet filter configuration for the device.
 	 * This contains all currently active FIF_* flags send
 	 * to us by mac80211 during configure_filter().
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index 550eaf1..e464bdc 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -1296,6 +1296,7 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 
 	spin_lock_init(&rt2x00dev->irqmask_lock);
 	mutex_init(&rt2x00dev->csr_mutex);
+	mutex_init(&rt2x00dev->conf_mutex);
 	INIT_LIST_HEAD(&rt2x00dev->bar_list);
 	spin_lock_init(&rt2x00dev->bar_list_lock);
 
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00link.c b/drivers/net/wireless/ralink/rt2x00/rt2x00link.c
index 73cbf23..2010a77 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00link.c
@@ -363,6 +363,9 @@ static void rt2x00link_tuner(struct work_struct *work)
 	    test_bit(DEVICE_STATE_SCANNING, &rt2x00dev->flags))
 		return;
 
+	/* Do not race with rt2x00mac_config(). */
+	mutex_lock(&rt2x00dev->conf_mutex);
+
 	if (rt2x00dev->intf_sta_count)
 		rt2x00link_tuner_sta(rt2x00dev, link);
 
@@ -375,6 +378,8 @@ static void rt2x00link_tuner(struct work_struct *work)
 	    (link->count % (VCO_SECONDS / LINK_TUNE_SECONDS)) == 0)
 		rt2x00dev->ops->lib->vco_calibration(rt2x00dev);
 
+	mutex_unlock(&rt2x00dev->conf_mutex);
+
 	/*
 	 * Increase tuner counter, and reschedule the next link tuner run.
 	 */
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
index d4b50fb..3cc1384 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
@@ -320,6 +320,9 @@ int rt2x00mac_config(struct ieee80211_hw *hw, u32 changed)
 	 */
 	rt2x00queue_stop_queue(rt2x00dev->rx);
 
+	/* Do not race with with link tuner. */
+	mutex_lock(&rt2x00dev->conf_mutex);
+
 	/*
 	 * When we've just turned on the radio, we want to reprogram
 	 * everything to ensure a consistent state
@@ -335,6 +338,8 @@ int rt2x00mac_config(struct ieee80211_hw *hw, u32 changed)
 	 */
 	rt2x00lib_config_antenna(rt2x00dev, rt2x00dev->default_ant);
 
+	mutex_unlock(&rt2x00dev->conf_mutex);
+
 	/* Turn RX back on */
 	rt2x00queue_start_queue(rt2x00dev->rx);
 
-- 
1.7.1
