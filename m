Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:46162 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbbCLVrL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 17:47:11 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [RFC] ath10k:  Allow setting bcast, mcast, mgt fixed tx rates.
Date: Thu, 12 Mar 2015 14:47:07 -0700
Message-Id: <1426196827-15802-1-git-send-email-greearb@candelatech.com> (sfid-20150312_224720_194586_E0AC7E77)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The default behaviour when setting a fixed transmit rate in ath10k
is to only set the 'ucast' rate.  This does not affect beacons,
multicast, or broadcast traffic.

In order to allow a back-door way to set these other types of
traffic as well, provide a debugfs file that can set the
traffic type.  Then, use can use the normal 'iw' commands to
set the rate to the desired value.

Upstream firmware *should* support all of this, but at least
10.1 does NOT have support for the WMI_10X_VDEV_PARAM_MGMT_RATE
parameter.  I added this to the CT firmware so it works there.

Possibly other upstream firmware have fixed this as well.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |   1 +
 drivers/net/wireless/ath/ath10k/debug.c | 102 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/mac.c   |  22 +++++--
 3 files changed, 119 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 69fa7b4..f54a4bc 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -477,6 +477,7 @@ struct ath10k {
 	u32 ht_cap_info;
 	u32 vht_cap_info;
 	u32 num_rf_chains;
+	u32 set_rate_type; /* override for set-rate behaviour */
 
 	DECLARE_BITMAP(fw_features, ATH10K_FW_FEATURE_COUNT);
 
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index f4c60d6..08d0330 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -893,6 +893,105 @@ static const struct file_operations fops_simulate_fw_crash = {
 	.llseek = default_llseek,
 };
 
+static ssize_t ath10k_read_set_rates(struct file *file,
+				     char __user *user_buf,
+				     size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	const char buf[] =
+		"To set unicast, beacon/mgt, multicast, and broadcast,\n"
+		"select a type below and then use 'iw' as normal to set\n"
+		"the desired rate.\n"
+		"beacon   # Beacons and management frames\n"
+		"bcast    # Broadcast frames\n"
+		"mcast    # Multicast frames\n"
+		"ucast    # Unicast frames (normal traffic, default)\n";
+
+	char tmpbuf[strlen(buf) + 80];
+	char* str = "ucast";
+
+	if (ar->set_rate_type == ar->wmi.vdev_param->mgmt_rate) {
+		str = "beacon";
+	}
+	else if (ar->set_rate_type == ar->wmi.vdev_param->bcast_data_rate) {
+		str = "bcast";
+	}
+	else if (ar->set_rate_type == ar->wmi.vdev_param->mcast_data_rate) {
+		str = "mcast";
+	}
+	sprintf(tmpbuf, "%sCurrent: %s\n", buf, str);
+
+	return simple_read_from_buffer(user_buf, count, ppos, tmpbuf, strlen(tmpbuf));
+}
+
+/* Set the rates for specific types of traffic.
+ */
+static ssize_t ath10k_write_set_rates(struct file *file,
+				      const char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	char buf[32];
+	int ret;
+
+	mutex_lock(&ar->conf_mutex);
+
+	memset(buf, 0, sizeof(buf));
+
+	simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, user_buf, count);
+
+	/* make sure that buf is null terminated */
+	buf[sizeof(buf) - 1] = 0;
+
+	/* drop the possible '\n' from the end */
+	if (buf[count - 1] == '\n')
+		buf[count - 1] = 0;
+
+	/* Ignore empty lines, 'echo' appends them sometimes at least. */
+	if (buf[0] == 0) {
+		ret = count;
+		goto exit;
+	}
+
+	if (ar->state != ATH10K_STATE_ON &&
+	    ar->state != ATH10K_STATE_RESTARTED) {
+		ret = -ENETDOWN;
+		goto exit;
+	}
+
+	if (strncmp(buf, "beacon", strlen("beacon")) == 0) {
+		ar->set_rate_type = ar->wmi.vdev_param->mgmt_rate;
+	}
+	else if (strncmp(buf, "bcast", strlen("bcast")) == 0) {
+		ar->set_rate_type = ar->wmi.vdev_param->bcast_data_rate;
+	}
+	else if (strncmp(buf, "mcast", strlen("mcast")) == 0) {
+		ar->set_rate_type = ar->wmi.vdev_param->mcast_data_rate;
+	}
+	else if (strncmp(buf, "ucast", strlen("ucast")) == 0) {
+		ar->set_rate_type = 0;
+	}
+	else {
+		ath10k_warn(ar, "set-rate, invalid rate type: %s  count: %d  %02hx:%02hx:%02hx:%02hx\n",
+			    buf, (int)count, (int)(buf[0]), (int)(buf[1]), (int)(buf[2]), (int)(buf[3]));
+		ret = -EINVAL;
+		goto exit;
+	}
+	ret = count;
+
+exit:
+	mutex_unlock(&ar->conf_mutex);
+	return ret;
+}
+
+static const struct file_operations fops_set_rates = {
+	.read = ath10k_read_set_rates,
+	.write = ath10k_write_set_rates,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 static ssize_t ath10k_read_chip_id(struct file *file, char __user *user_buf,
 				   size_t count, loff_t *ppos)
 {
@@ -1733,6 +1832,9 @@ int ath10k_debug_register(struct ath10k *ar)
 	debugfs_create_file("wmi_services", S_IRUSR, ar->debug.debugfs_phy, ar,
 			    &fops_wmi_services);
 
+	debugfs_create_file("set_rates", S_IRUSR, ar->debug.debugfs_phy,
+			    ar, &fops_set_rates);
+
 	debugfs_create_file("simulate_fw_crash", S_IRUSR, ar->debug.debugfs_phy,
 			    ar, &fops_simulate_fw_crash);
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index ec74429..0718d4a 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4481,11 +4481,12 @@ static int ath10k_set_fixed_rate_param(struct ath10k_vif *arvif,
 
 	mutex_lock(&ar->conf_mutex);
 
-	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac set fixed rate, current: rt: %i  nss: %i  sgi: %i  new:  rt: %i  nss: %i  sgi: %i\n",
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac set fixed rate, current: rt: %i  nss: %i  sgi: %i  new:  rt: %i  nss: %i  sgi: %i set-rate-type: %d\n",
 		   (int)(arvif->fixed_rate), (int)(arvif->fixed_nss), (int)(arvif->force_sgi),
-		   (int)(fixed_rate), (int)(fixed_nss), (int)(force_sgi));
+		   (int)(fixed_rate), (int)(fixed_nss), (int)(force_sgi), ar->set_rate_type);
 
-	if (arvif->fixed_rate == fixed_rate &&
+	if (ar->set_rate_type == 0 &&
+	    arvif->fixed_rate == fixed_rate &&
 	    arvif->fixed_nss == fixed_nss &&
 	    arvif->force_sgi == force_sgi)
 		goto exit;
@@ -4496,16 +4497,25 @@ static int ath10k_set_fixed_rate_param(struct ath10k_vif *arvif,
 	if (force_sgi)
 		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac force sgi\n");
 
-	vdev_param = ar->wmi.vdev_param->fixed_rate;
+	if (ar->set_rate_type)
+		vdev_param = ar->set_rate_type;
+	else
+		vdev_param = ar->wmi.vdev_param->fixed_rate;
 	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
 					vdev_param, fixed_rate);
 	if (ret) {
-		ath10k_warn(ar, "failed to set fixed rate param 0x%02x: %d\n",
-			    fixed_rate, ret);
+		ath10k_warn(ar, "failed to set fixed rate (0x%x) param 0x%02x: %d\n",
+			    vdev_param, fixed_rate, ret);
 		ret = -EINVAL;
 		goto exit;
 	}
 
+	/* If we are setting one of the specialized rates (mgmt, ucast, bcast)
+	 * then we do not need to set the other values, so skip to exit.
+	 */
+	if (ar->set_rate_type != 0)
+		goto exit;
+
 	arvif->fixed_rate = fixed_rate;
 
 	vdev_param = ar->wmi.vdev_param->nss;
-- 
1.7.11.7

