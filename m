Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4E8360EDE
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 08:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791274499; cv=none; b=hzmr3pDQ06+fKrGAXmwx4s5Olgd2mAOlJv6MQS6iXsl9UcVICMNFEbMrZ7rpj/YUxaKJ25xLml/bBBADrRB5KLBMPNKWU2zrIGGefUlVhFD2rlsKdRQFbJvvQRpCTaw8ELZ0S5ULMxD7zZ2y3ctmgjzzJJy5Q5QoHD8WpX3otoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791274499; c=relaxed/simple;
	bh=hfsXsKgHb4YXVY2I0EAr+gaiUHDaBm+LXImIrglYy0E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sqQ02hc8kSdFBJIy53xdFTXwPvBOMFvoe3LtRc4EK+HgFESFQQPLm1e63+q9T6mATUz7hdQKdoKGnvyFfj3ZEjTxSm6greB0rtnLiwguUY5UvDw4P9/P1u2hBoMeTLtQXE9BmXQWqH4KktsXBH8tGMBVRmtkTbDVHZelIQ9PdFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=R9lwOpzv; arc=none smtp.client-ip=212.77.101.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="R9lwOpzv"
Received: (wp-smtpd smtp.wp.pl 40913 invoked from network); 6 Oct 2026 10:14:52 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=s20261001;
          t=1791274492; bh=1zThuuY8In4YEGVvq3Yf5UhdB2qcCwiX1MkCelQqkFI=;
          h=From:To:Cc:Subject;
          b=R9lwOpzvpnIyT1nD3ZECICdCwDOgqWTMLiXiJY6otzjv377pDRN/I4m7eYMh9iBx3
           iwSuB/PESAiZPeHuQF64NMKbGvOyRu8Y+gpceisex8XoRLsQfWvCVg95mvYrefcnit
           Jgl0zsKC3oH+gklpYv/uqOLrPjR/Iwqa+oodghd5ESBMDzegzypKabbTXaC7P14VMh
           4im1PQeVgEUvNeSg9Klhx7NAB2gEOxYttAXlg580/Akb1L33E2D3qRGP41zzcfoLaB
           3c9GOSYbtxeKQ/ouQRMwuEk07PRBhMAdBr4tGaCeLzrUjKa4HawFsUH0CrJMztnwPF
           n9bseYzypI2Cg==
Received: from localhost (77-236-6-58.static.play.pl [77.236.6.58])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 6 Oct 2026 10:14:52 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 3/3] wifi: iwlegacy: 3945: remove custom sysfs files
Date: Tue,  6 Oct 2026 10:14:43 +0200
Message-Id: <20261006081443.28017-4-stf_xl@wp.pl>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20261006081443.28017-1-stf_xl@wp.pl>
References: <20261006081443.28017-1-stf_xl@wp.pl>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: c790561671f8bbded37b645aabfa82cb
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000004 [oXft]                               

From: Stanislaw Gruszka <stf_xl@wp.pl>

Remove undocumented sysfs files used for driver debugging and
development.

Given the age of the driver, it is highly unlikely that access to any
of this information is needed, but if so, proper debugfs entries can
be added.

Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 .../net/wireless/intel/iwlegacy/3945-mac.c    | 395 +-----------------
 1 file changed, 2 insertions(+), 393 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
index aec45bcc2446..604317b3dddc 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -634,85 +634,6 @@ il3945_tx_skb(struct il_priv *il,
 	return -1;
 }
 
-static int
-il3945_get_measurement(struct il_priv *il,
-		       struct ieee80211_measurement_params *params, u8 type)
-{
-	struct il_spectrum_cmd spectrum;
-	struct il_rx_pkt *pkt;
-	struct il_host_cmd cmd = {
-		.id = C_SPECTRUM_MEASUREMENT,
-		.data = (void *)&spectrum,
-		.flags = CMD_WANT_SKB,
-	};
-	u32 add_time = le64_to_cpu(params->start_time);
-	int rc;
-	int spectrum_resp_status;
-	int duration = le16_to_cpu(params->duration);
-
-	if (il_is_associated(il))
-		add_time =
-		    il_usecs_to_beacons(il,
-					le64_to_cpu(params->start_time) -
-					il->_3945.last_tsf,
-					le16_to_cpu(il->timing.beacon_interval));
-
-	memset(&spectrum, 0, sizeof(spectrum));
-
-	spectrum.channel_count = cpu_to_le16(1);
-	spectrum.flags =
-	    RXON_FLG_TSF2HOST_MSK | RXON_FLG_ANT_A_MSK | RXON_FLG_DIS_DIV_MSK;
-	spectrum.filter_flags = MEASUREMENT_FILTER_FLAG;
-	cmd.len = sizeof(spectrum);
-	spectrum.len = cpu_to_le16(cmd.len - sizeof(spectrum.len));
-
-	if (il_is_associated(il))
-		spectrum.start_time =
-		    il_add_beacon_time(il, il->_3945.last_beacon_time, add_time,
-				       le16_to_cpu(il->timing.beacon_interval));
-	else
-		spectrum.start_time = 0;
-
-	spectrum.channels[0].duration = cpu_to_le32(duration * TIME_UNIT);
-	spectrum.channels[0].channel = params->channel;
-	spectrum.channels[0].type = type;
-	if (il->active.flags & RXON_FLG_BAND_24G_MSK)
-		spectrum.flags |=
-		    RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK |
-		    RXON_FLG_TGG_PROTECT_MSK;
-
-	rc = il_send_cmd_sync(il, &cmd);
-	if (rc)
-		return rc;
-
-	pkt = (struct il_rx_pkt *)cmd.reply_page;
-	if (pkt->hdr.flags & IL_CMD_FAILED_MSK) {
-		IL_ERR("Bad return from N_RX_ON_ASSOC command\n");
-		rc = -EIO;
-	}
-
-	spectrum_resp_status = le16_to_cpu(pkt->u.spectrum.status);
-	switch (spectrum_resp_status) {
-	case 0:		/* Command will be handled */
-		if (pkt->u.spectrum.id != 0xff) {
-			D_INFO("Replaced existing measurement: %d\n",
-			       pkt->u.spectrum.id);
-			il->measurement_status &= ~MEASUREMENT_READY;
-		}
-		il->measurement_status |= MEASUREMENT_ACTIVE;
-		rc = 0;
-		break;
-
-	case 1:		/* Command will not be handled */
-		rc = -EAGAIN;
-		break;
-	}
-
-	il_free_pages(il, cmd.reply_page);
-
-	return rc;
-}
-
 static void
 il3945_hdl_alive(struct il_priv *il, struct il_rx_buf *rxb)
 {
@@ -3004,290 +2925,6 @@ il3945_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
 	    FIF_BCN_PRBRESP_PROMISC | FIF_CONTROL;
 }
 
-/*****************************************************************************
- *
- * sysfs attributes
- *
- *****************************************************************************/
-
-static ssize_t
-il3945_show_temperature(struct device *d, struct device_attribute *attr,
-			char *buf)
-{
-	struct il_priv *il = dev_get_drvdata(d);
-
-	if (!il_is_alive(il))
-		return -EAGAIN;
-
-	return sprintf(buf, "%d\n", il3945_hw_get_temperature(il));
-}
-
-static DEVICE_ATTR(temperature, 0444, il3945_show_temperature, NULL);
-
-static ssize_t
-il3945_show_tx_power(struct device *d, struct device_attribute *attr, char *buf)
-{
-	struct il_priv *il = dev_get_drvdata(d);
-	return sprintf(buf, "%d\n", il->tx_power_user_lmt);
-}
-
-static ssize_t
-il3945_store_tx_power(struct device *d, struct device_attribute *attr,
-		      const char *buf, size_t count)
-{
-	struct il_priv *il = dev_get_drvdata(d);
-	char *p = (char *)buf;
-	u32 val;
-
-	val = simple_strtoul(p, &p, 10);
-	if (p == buf)
-		IL_INFO(": %s is not in decimal form.\n", buf);
-	else
-		il3945_hw_reg_set_txpower(il, val);
-
-	return count;
-}
-
-static DEVICE_ATTR(tx_power, 0644, il3945_show_tx_power, il3945_store_tx_power);
-
-static ssize_t
-il3945_show_flags(struct device *d, struct device_attribute *attr, char *buf)
-{
-	struct il_priv *il = dev_get_drvdata(d);
-
-	return sprintf(buf, "0x%04X\n", il->active.flags);
-}
-
-static ssize_t
-il3945_store_flags(struct device *d, struct device_attribute *attr,
-		   const char *buf, size_t count)
-{
-	struct il_priv *il = dev_get_drvdata(d);
-	u32 flags = simple_strtoul(buf, NULL, 0);
-
-	mutex_lock(&il->mutex);
-	if (le32_to_cpu(il->staging.flags) != flags) {
-		/* Cancel any currently running scans... */
-		if (il_scan_cancel_timeout(il, 100))
-			IL_WARN("Could not cancel scan.\n");
-		else {
-			D_INFO("Committing rxon.flags = 0x%04X\n", flags);
-			il->staging.flags = cpu_to_le32(flags);
-			il3945_commit_rxon(il);
-		}
-	}
-	mutex_unlock(&il->mutex);
-
-	return count;
-}
-
-static DEVICE_ATTR(flags, 0644, il3945_show_flags, il3945_store_flags);
-
-static ssize_t
-il3945_show_filter_flags(struct device *d, struct device_attribute *attr,
-			 char *buf)
-{
-	struct il_priv *il = dev_get_drvdata(d);
-
-	return sprintf(buf, "0x%04X\n", le32_to_cpu(il->active.filter_flags));
-}
-
-static ssize_t
-il3945_store_filter_flags(struct device *d, struct device_attribute *attr,
-			  const char *buf, size_t count)
-{
-	struct il_priv *il = dev_get_drvdata(d);
-	u32 filter_flags = simple_strtoul(buf, NULL, 0);
-
-	mutex_lock(&il->mutex);
-	if (le32_to_cpu(il->staging.filter_flags) != filter_flags) {
-		/* Cancel any currently running scans... */
-		if (il_scan_cancel_timeout(il, 100))
-			IL_WARN("Could not cancel scan.\n");
-		else {
-			D_INFO("Committing rxon.filter_flags = " "0x%04X\n",
-			       filter_flags);
-			il->staging.filter_flags = cpu_to_le32(filter_flags);
-			il3945_commit_rxon(il);
-		}
-	}
-	mutex_unlock(&il->mutex);
-
-	return count;
-}
-
-static DEVICE_ATTR(filter_flags, 0644, il3945_show_filter_flags,
-		   il3945_store_filter_flags);
-
-static ssize_t
-il3945_show_measurement(struct device *d, struct device_attribute *attr,
-			char *buf)
-{
-	struct il_priv *il = dev_get_drvdata(d);
-	struct il_spectrum_notification measure_report;
-	u32 size = sizeof(measure_report), len = 0, ofs = 0;
-	u8 *data = (u8 *) &measure_report;
-	unsigned long flags;
-
-	spin_lock_irqsave(&il->lock, flags);
-	if (!(il->measurement_status & MEASUREMENT_READY)) {
-		spin_unlock_irqrestore(&il->lock, flags);
-		return 0;
-	}
-	memcpy(&measure_report, &il->measure_report, size);
-	il->measurement_status = 0;
-	spin_unlock_irqrestore(&il->lock, flags);
-
-	while (size && PAGE_SIZE - len) {
-		hex_dump_to_buffer(data + ofs, size, 16, 1, buf + len,
-				   PAGE_SIZE - len, true);
-		len = strlen(buf);
-		if (PAGE_SIZE - len)
-			buf[len++] = '\n';
-
-		ofs += 16;
-		size -= min(size, 16U);
-	}
-
-	return len;
-}
-
-static ssize_t
-il3945_store_measurement(struct device *d, struct device_attribute *attr,
-			 const char *buf, size_t count)
-{
-	struct il_priv *il = dev_get_drvdata(d);
-	struct ieee80211_measurement_params params = {
-		.channel = le16_to_cpu(il->active.channel),
-		.start_time = cpu_to_le64(il->_3945.last_tsf),
-		.duration = cpu_to_le16(1),
-	};
-	u8 type = IL_MEASURE_BASIC;
-	u8 buffer[32];
-	u8 channel;
-
-	if (count) {
-		char *p = buffer;
-		strscpy(buffer, buf, sizeof(buffer));
-		channel = simple_strtoul(p, NULL, 0);
-		if (channel)
-			params.channel = channel;
-
-		p = buffer;
-		while (*p && *p != ' ')
-			p++;
-		if (*p)
-			type = simple_strtoul(p + 1, NULL, 0);
-	}
-
-	D_INFO("Invoking measurement of type %d on " "channel %d (for '%s')\n",
-	       type, params.channel, buf);
-	mutex_lock(&il->mutex);
-	il3945_get_measurement(il, &params, type);
-	mutex_unlock(&il->mutex);
-
-	return count;
-}
-
-static DEVICE_ATTR(measurement, 0600, il3945_show_measurement,
-		   il3945_store_measurement);
-
-static ssize_t
-il3945_store_retry_rate(struct device *d, struct device_attribute *attr,
-			const char *buf, size_t count)
-{
-	struct il_priv *il = dev_get_drvdata(d);
-
-	il->retry_rate = simple_strtoul(buf, NULL, 0);
-	if (il->retry_rate <= 0)
-		il->retry_rate = 1;
-
-	return count;
-}
-
-static ssize_t
-il3945_show_retry_rate(struct device *d, struct device_attribute *attr,
-		       char *buf)
-{
-	struct il_priv *il = dev_get_drvdata(d);
-	return sprintf(buf, "%d", il->retry_rate);
-}
-
-static DEVICE_ATTR(retry_rate, 0600, il3945_show_retry_rate,
-		   il3945_store_retry_rate);
-
-static ssize_t
-il3945_show_channels(struct device *d, struct device_attribute *attr, char *buf)
-{
-	/* all this shit doesn't belong into sysfs anyway */
-	return 0;
-}
-
-static DEVICE_ATTR(channels, 0400, il3945_show_channels, NULL);
-
-static ssize_t
-il3945_show_antenna(struct device *d, struct device_attribute *attr, char *buf)
-{
-	struct il_priv *il = dev_get_drvdata(d);
-
-	if (!il_is_alive(il))
-		return -EAGAIN;
-
-	return sprintf(buf, "%d\n", il3945_mod_params.antenna);
-}
-
-static ssize_t
-il3945_store_antenna(struct device *d, struct device_attribute *attr,
-		     const char *buf, size_t count)
-{
-	struct il_priv *il __maybe_unused = dev_get_drvdata(d);
-	int ant;
-
-	if (count == 0)
-		return 0;
-
-	if (sscanf(buf, "%1i", &ant) != 1) {
-		D_INFO("not in hex or decimal form.\n");
-		return count;
-	}
-
-	if (ant >= 0 && ant <= 2) {
-		D_INFO("Setting antenna select to %d.\n", ant);
-		il3945_mod_params.antenna = (enum il3945_antenna)ant;
-	} else
-		D_INFO("Bad antenna select value %d.\n", ant);
-
-	return count;
-}
-
-static DEVICE_ATTR(antenna, 0644, il3945_show_antenna, il3945_store_antenna);
-
-static ssize_t
-il3945_show_status(struct device *d, struct device_attribute *attr, char *buf)
-{
-	struct il_priv *il = dev_get_drvdata(d);
-	if (!il_is_alive(il))
-		return -EAGAIN;
-	return sprintf(buf, "0x%08x\n", (int)il->status);
-}
-
-static DEVICE_ATTR(status, 0444, il3945_show_status, NULL);
-
-static ssize_t
-il3945_dump_error_log(struct device *d, struct device_attribute *attr,
-		      const char *buf, size_t count)
-{
-	struct il_priv *il = dev_get_drvdata(d);
-	char *p = (char *)buf;
-
-	if (p[0] == '1')
-		il3945_dump_nic_error_log(il);
-
-	return strnlen(buf, count);
-}
-
-static DEVICE_ATTR(dump_errors, 0200, NULL, il3945_dump_error_log);
-
 /*****************************************************************************
  *
  * driver setup and tear down
@@ -3331,25 +2968,6 @@ il3945_cancel_deferred_work(struct il_priv *il)
 	il_cancel_scan_deferred_work(il);
 }
 
-static struct attribute *il3945_sysfs_entries[] = {
-	&dev_attr_antenna.attr,
-	&dev_attr_channels.attr,
-	&dev_attr_dump_errors.attr,
-	&dev_attr_flags.attr,
-	&dev_attr_filter_flags.attr,
-	&dev_attr_measurement.attr,
-	&dev_attr_retry_rate.attr,
-	&dev_attr_status.attr,
-	&dev_attr_temperature.attr,
-	&dev_attr_tx_power.attr,
-	NULL
-};
-
-static const struct attribute_group il3945_attribute_group = {
-	.name = NULL,		/* put in device directory */
-	.attrs = il3945_sysfs_entries,
-};
-
 static struct ieee80211_ops il3945_mac_ops __ro_after_init = {
 	.add_chanctx = ieee80211_emulate_add_chanctx,
 	.remove_chanctx = ieee80211_emulate_remove_chanctx,
@@ -3632,16 +3250,11 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_disable_msi;
 	}
 
-	err = sysfs_create_group(&pdev->dev.kobj, &il3945_attribute_group);
-	if (err) {
-		IL_ERR("failed to create sysfs device attributes\n");
-		goto out_release_irq;
-	}
-
 	il_set_rxon_channel(il, &il->bands[NL80211_BAND_2GHZ].channels[5]);
+
 	err = il3945_setup_deferred_work(il);
 	if (err)
-		goto out_remove_sysfs;
+		goto out_release_irq;
 
 	il3945_setup_handlers(il);
 	il_power_initialize(il);
@@ -3666,8 +3279,6 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 out_destroy_workqueue:
 	destroy_workqueue(il->workqueue);
 	il->workqueue = NULL;
-out_remove_sysfs:
-	sysfs_remove_group(&pdev->dev.kobj, &il3945_attribute_group);
 out_release_irq:
 	free_irq(il->pci_dev->irq, il);
 out_disable_msi:
@@ -3732,8 +3343,6 @@ il3945_pci_remove(struct pci_dev *pdev)
 
 	il3945_synchronize_irq(il);
 
-	sysfs_remove_group(&pdev->dev.kobj, &il3945_attribute_group);
-
 	cancel_delayed_work_sync(&il->_3945.rfkill_poll);
 
 	il3945_dealloc_ucode_pci(il);
-- 
2.50.1

