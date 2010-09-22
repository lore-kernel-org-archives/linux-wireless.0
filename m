Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54300 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab0IVAEE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 20:04:04 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [ath5k] ath5k:  Add bssid mask and rxfilter to debugfs.
Date: Tue, 21 Sep 2010 17:03:57 -0700
Message-Id: <1285113837-25620-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Helps with debugging virtual interfaces.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 6583a82... 0f06e84... M	drivers/net/wireless/ath/ath5k/debug.c
:100644 100644 9b22722... 4f078b1... M	drivers/net/wireless/ath/ath5k/debug.h
 drivers/net/wireless/ath/ath5k/debug.c |   58 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath5k/debug.h |    1 +
 2 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index 6583a82..0f06e84 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -483,6 +483,59 @@ static const struct file_operations fops_antenna = {
 	.owner = THIS_MODULE,
 };
 
+/* debugfs: misc */
+
+static ssize_t read_file_misc(struct file *file, char __user *user_buf,
+				   size_t count, loff_t *ppos)
+{
+	struct ath5k_softc *sc = file->private_data;
+	char buf[700];
+	unsigned int len = 0;
+	u32 filt = ath5k_hw_get_rx_filter(sc->ah);
+
+	len += snprintf(buf+len, sizeof(buf)-len, "bssid-mask: %pM\n",
+			sc->bssidmask);
+	len += snprintf(buf+len, sizeof(buf)-len, "filter-flags: 0x%x ",
+			filt);
+	if (filt & AR5K_RX_FILTER_UCAST)
+		len += snprintf(buf+len, sizeof(buf)-len, " UCAST");
+	if (filt & AR5K_RX_FILTER_MCAST)
+		len += snprintf(buf+len, sizeof(buf)-len, " MCAST");
+	if (filt & AR5K_RX_FILTER_BCAST)
+		len += snprintf(buf+len, sizeof(buf)-len, " BCAST");
+	if (filt & AR5K_RX_FILTER_CONTROL)
+		len += snprintf(buf+len, sizeof(buf)-len, " CONTROL");
+	if (filt & AR5K_RX_FILTER_BEACON)
+		len += snprintf(buf+len, sizeof(buf)-len, " BEACON");
+	if (filt & AR5K_RX_FILTER_PROM)
+		len += snprintf(buf+len, sizeof(buf)-len, " PROM");
+	if (filt & AR5K_RX_FILTER_XRPOLL)
+		len += snprintf(buf+len, sizeof(buf)-len, " XRPOLL");
+	if (filt & AR5K_RX_FILTER_PROBEREQ)
+		len += snprintf(buf+len, sizeof(buf)-len, " PROBEREQ");
+	if (filt & AR5K_RX_FILTER_PHYERR_5212)
+		len += snprintf(buf+len, sizeof(buf)-len, " PHYERR-5212");
+	if (filt & AR5K_RX_FILTER_RADARERR_5212)
+		len += snprintf(buf+len, sizeof(buf)-len, " RADARERR-5212");
+	if (filt & AR5K_RX_FILTER_PHYERR_5211)
+		snprintf(buf+len, sizeof(buf)-len, " PHYERR-5211");
+	if (filt & AR5K_RX_FILTER_RADARERR_5211)
+		len += snprintf(buf+len, sizeof(buf)-len, " RADARERR-5211\n");
+	else
+		len += snprintf(buf+len, sizeof(buf)-len, "\n");
+
+	if (len > sizeof(buf))
+		len = sizeof(buf);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static const struct file_operations fops_misc = {
+	.read = read_file_misc,
+	.open = ath5k_debugfs_open,
+	.owner = THIS_MODULE,
+};
+
 
 /* debugfs: frameerrors */
 
@@ -856,6 +909,10 @@ ath5k_debug_init_device(struct ath5k_softc *sc)
 				S_IWUSR | S_IRUSR,
 				sc->debug.debugfs_phydir, sc, &fops_antenna);
 
+	sc->debug.debugfs_misc = debugfs_create_file("misc",
+				S_IRUSR,
+				sc->debug.debugfs_phydir, sc, &fops_misc);
+
 	sc->debug.debugfs_frameerrors = debugfs_create_file("frameerrors",
 				S_IWUSR | S_IRUSR,
 				sc->debug.debugfs_phydir, sc,
@@ -886,6 +943,7 @@ ath5k_debug_finish_device(struct ath5k_softc *sc)
 	debugfs_remove(sc->debug.debugfs_beacon);
 	debugfs_remove(sc->debug.debugfs_reset);
 	debugfs_remove(sc->debug.debugfs_antenna);
+	debugfs_remove(sc->debug.debugfs_misc);
 	debugfs_remove(sc->debug.debugfs_frameerrors);
 	debugfs_remove(sc->debug.debugfs_ani);
 	debugfs_remove(sc->debug.debugfs_queue);
diff --git a/drivers/net/wireless/ath/ath5k/debug.h b/drivers/net/wireless/ath/ath5k/debug.h
index 9b22722..4f078b1 100644
--- a/drivers/net/wireless/ath/ath5k/debug.h
+++ b/drivers/net/wireless/ath/ath5k/debug.h
@@ -75,6 +75,7 @@ struct ath5k_dbg_info {
 	struct dentry		*debugfs_beacon;
 	struct dentry		*debugfs_reset;
 	struct dentry		*debugfs_antenna;
+	struct dentry		*debugfs_misc;
 	struct dentry		*debugfs_frameerrors;
 	struct dentry		*debugfs_ani;
 	struct dentry		*debugfs_queue;
-- 
1.7.2.2

