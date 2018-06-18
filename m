Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:39073 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754601AbeFRPMo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Jun 2018 11:12:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc: y2038@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] ipw2x00: track time using boottime
Date: Mon, 18 Jun 2018 17:11:16 +0200
Message-Id: <20180618151142.1214422-3-arnd@arndb.de> (sfid-20180618_171439_887299_773DB9B7)
In-Reply-To: <20180618151142.1214422-1-arnd@arndb.de>
References: <20180618151142.1214422-1-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ipw2x00 driver family uses get_seconds() to read the current time
for various purposes. This function is deprecated because of the 32-bit
time_t overflow, and it can cause unexpected behavior when the time
changes due to settimeofday() calls or leap second updates.

In many cases, we want to use monotonic time instead, however ipw2x00
explicitly tracks the time spent in suspend, so this changes the
driver over to use ktime_get_boottime_seconds(), which is slightly
slower, but not used in a fastpath here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/intel/ipw2x00/ipw2100.c | 18 +++++++++---------
 drivers/net/wireless/intel/ipw2x00/ipw2100.h | 12 ++++++------
 drivers/net/wireless/intel/ipw2x00/ipw2200.c |  4 ++--
 drivers/net/wireless/intel/ipw2x00/ipw2200.h |  6 +++---
 4 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index b8fd3cc90634..1ad83ef5f202 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -692,7 +692,7 @@ static void printk_buf(int level, const u8 * data, u32 len)
 
 static void schedule_reset(struct ipw2100_priv *priv)
 {
-	unsigned long now = get_seconds();
+	time64_t now = ktime_get_boottime_seconds();
 
 	/* If we haven't received a reset request within the backoff period,
 	 * then we can reset the backoff interval so this reset occurs
@@ -701,10 +701,10 @@ static void schedule_reset(struct ipw2100_priv *priv)
 	    (now - priv->last_reset > priv->reset_backoff))
 		priv->reset_backoff = 0;
 
-	priv->last_reset = get_seconds();
+	priv->last_reset = now;
 
 	if (!(priv->status & STATUS_RESET_PENDING)) {
-		IPW_DEBUG_INFO("%s: Scheduling firmware restart (%ds).\n",
+		IPW_DEBUG_INFO("%s: Scheduling firmware restart (%llds).\n",
 			       priv->net_dev->name, priv->reset_backoff);
 		netif_carrier_off(priv->net_dev);
 		netif_stop_queue(priv->net_dev);
@@ -2079,7 +2079,7 @@ static void isr_indicate_associated(struct ipw2100_priv *priv, u32 status)
 	memcpy(priv->bssid, bssid, ETH_ALEN);
 
 	priv->status |= STATUS_ASSOCIATING;
-	priv->connect_start = get_seconds();
+	priv->connect_start = ktime_get_boottime_seconds();
 
 	schedule_delayed_work(&priv->wx_event_work, HZ / 10);
 }
@@ -4070,8 +4070,8 @@ static ssize_t show_internals(struct device *d, struct device_attribute *attr,
 #define DUMP_VAR(x,y) len += sprintf(buf + len, # x ": %" y "\n", priv-> x)
 
 	if (priv->status & STATUS_ASSOCIATED)
-		len += sprintf(buf + len, "connected: %lu\n",
-			       get_seconds() - priv->connect_start);
+		len += sprintf(buf + len, "connected: %llu\n",
+			       ktime_get_boottime_seconds() - priv->connect_start);
 	else
 		len += sprintf(buf + len, "not connected\n");
 
@@ -4108,7 +4108,7 @@ static ssize_t show_internals(struct device *d, struct device_attribute *attr,
 	DUMP_VAR(txq_stat.lo, "d");
 
 	DUMP_VAR(ieee->scans, "d");
-	DUMP_VAR(reset_backoff, "d");
+	DUMP_VAR(reset_backoff, "lld");
 
 	return len;
 }
@@ -6437,7 +6437,7 @@ static int ipw2100_suspend(struct pci_dev *pci_dev, pm_message_t state)
 	pci_disable_device(pci_dev);
 	pci_set_power_state(pci_dev, PCI_D3hot);
 
-	priv->suspend_at = get_seconds();
+	priv->suspend_at = ktime_get_boottime_seconds();
 
 	mutex_unlock(&priv->action_mutex);
 
@@ -6482,7 +6482,7 @@ static int ipw2100_resume(struct pci_dev *pci_dev)
 	 * the queue of needed */
 	netif_device_attach(dev);
 
-	priv->suspend_time = get_seconds() - priv->suspend_at;
+	priv->suspend_time = ktime_get_boottime_seconds() - priv->suspend_at;
 
 	/* Bring the device back up */
 	if (!(priv->status & STATUS_RF_KILL_SW))
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.h b/drivers/net/wireless/intel/ipw2x00/ipw2100.h
index ce3e35f6b60f..8c11c7fa2eef 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.h
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.h
@@ -491,7 +491,7 @@ struct ipw2100_priv {
 
 	/* Statistics */
 	int resets;
-	int reset_backoff;
+	time64_t reset_backoff;
 
 	/* Context */
 	u8 essid[IW_ESSID_MAX_SIZE];
@@ -500,8 +500,8 @@ struct ipw2100_priv {
 	u8 channel;
 	int last_mode;
 
-	unsigned long connect_start;
-	unsigned long last_reset;
+	time64_t connect_start;
+	time64_t last_reset;
 
 	u32 channel_mask;
 	u32 fatal_error;
@@ -581,9 +581,9 @@ struct ipw2100_priv {
 
 	int user_requested_scan;
 
-	/* Track time in suspend */
-	unsigned long suspend_at;
-	unsigned long suspend_time;
+	/* Track time in suspend, using CLOCK_BOOTTIME */
+	time64_t suspend_at;
+	time64_t suspend_time;
 
 	u32 interrupts;
 	int tx_interrupts;
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index 8a858f7e36f4..33186a6b28c0 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -11888,7 +11888,7 @@ static int ipw_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	pci_disable_device(pdev);
 	pci_set_power_state(pdev, pci_choose_state(pdev, state));
 
-	priv->suspend_at = get_seconds();
+	priv->suspend_at = ktime_get_boottime_seconds();
 
 	return 0;
 }
@@ -11925,7 +11925,7 @@ static int ipw_pci_resume(struct pci_dev *pdev)
 	 * the queue of needed */
 	netif_device_attach(dev);
 
-	priv->suspend_time = get_seconds() - priv->suspend_at;
+	priv->suspend_time = ktime_get_boottime_seconds() - priv->suspend_at;
 
 	/* Bring the device back up */
 	schedule_work(&priv->up);
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.h b/drivers/net/wireless/intel/ipw2x00/ipw2200.h
index aa301d1eee3c..f98ab1f71edd 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.h
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.h
@@ -1343,9 +1343,9 @@ struct ipw_priv {
 
 	s8 tx_power;
 
-	/* Track time in suspend */
-	unsigned long suspend_at;
-	unsigned long suspend_time;
+	/* Track time in suspend using CLOCK_BOOTIME */
+	time64_t suspend_at;
+	time64_t suspend_time;
 
 #ifdef CONFIG_PM
 	u32 pm_state[16];
-- 
2.9.0
