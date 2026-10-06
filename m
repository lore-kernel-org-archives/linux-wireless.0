Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1853B14B3
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 08:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791274499; cv=none; b=TP1vu4zAbKRuYDFOLPcDsN/EQF5kH6K1UqW2REqUmLP8VOuo3jG48QyC5Du/ILLIGrXsuTUoAJMhcFFcYEfv4HLl9ybTJSj7lZHf3TKH24eakGYNfqHiKN1UmExJ0wZlof5FfRq+/DdgcZrsD3IJvKvHG7ZM6OhR9pFMtudftxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791274499; c=relaxed/simple;
	bh=M/O9AkmOz7TaWPbJLN0NlYG3WHrN0NAMpNJ+C5OeYZs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JpBvlikf/6ahUNzlBI7xAyPt2QkwWYYqWA/+yWBqIUJjDHCi+vt69xpFEnVGiYrB6IheAEO4BQYQnTFM6ftbbPRCSi9DjGqSLAyKjxRgE1WwGCjAm1h9PVZfk75jsk/PknAyhHwDV71+s0ZXJXYz4YUcEOcHMdyvUSX9rHc0NNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=akJOrFcg; arc=none smtp.client-ip=212.77.101.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="akJOrFcg"
Received: (wp-smtpd smtp.wp.pl 13880 invoked from network); 6 Oct 2026 10:14:51 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=s20261001;
          t=1791274491; bh=a1tIenjxGAVWv+WReVE+5ZPKsJsBwe9pOH7VeDhNh8g=;
          h=From:To:Cc:Subject;
          b=akJOrFcgeHeCN1HhuKltoIWa4MvpofBd6k9kYZTstUWXpRDP0daicci0CjSzfa0Oh
           f4YukFaGznAeCt/ES+9NVTigYIVpr94NbwhkfSswk0dQS66zWx0bWj1VwoZ3zvX0FO
           J4iBTPymLsfVDjGB8HtzgSrS/mWpBofHhIbvgJOzmJzFhSrQJxnDxMwfPQ/4v+vjkc
           ClmgGxpmk3ZDZD7nNYfKI3X5tfVf1DMPH3mFBD1zs35oYN8sTMm0PeD3/PDGWU4gIx
           iaGu7TbULRO9P75ZQlT2u8boX3qOsyU/DcCLpngTwW7DQaTmdD8pymG/8ORmXBLvTF
           7LI4R5wGP1Niw==
Received: from localhost (77-236-6-58.static.play.pl [77.236.6.58])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 6 Oct 2026 10:14:51 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 2/3] wifi: iwlegacy: 4965: remove custom sysfs files
Date: Tue,  6 Oct 2026 10:14:42 +0200
Message-Id: <20261006081443.28017-3-stf_xl@wp.pl>
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
X-WP-MailID: 1fd798cb56fdcc14979977a93ce49c3f
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000004 [AWdN]                               

From: Stanislaw Gruszka <stf_xl@wp.pl>

Remove undocumented sysfs files used for driver debugging and
development.

Given the age of the driver, it is highly unlikely that access to any
of this information is needed, but if so, proper debugfs entries can
be added.

Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 .../net/wireless/intel/iwlegacy/4965-mac.c    | 75 -------------------
 1 file changed, 75 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index dc420366dff3..621a6ccdaaa6 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -4520,74 +4520,6 @@ il4965_irq_tasklet(struct tasklet_struct *t)
 #endif
 }
 
-/*****************************************************************************
- *
- * sysfs attributes
- *
- *****************************************************************************/
-
-static ssize_t
-il4965_show_temperature(struct device *d, struct device_attribute *attr,
-			char *buf)
-{
-	struct il_priv *il = dev_get_drvdata(d);
-
-	if (!il_is_alive(il))
-		return -EAGAIN;
-
-	return sprintf(buf, "%d\n", il->temperature);
-}
-
-static DEVICE_ATTR(temperature, 0444, il4965_show_temperature, NULL);
-
-static ssize_t
-il4965_show_tx_power(struct device *d, struct device_attribute *attr, char *buf)
-{
-	struct il_priv *il = dev_get_drvdata(d);
-
-	if (!il_is_ready_rf(il))
-		return sprintf(buf, "off\n");
-	else
-		return sprintf(buf, "%d\n", il->tx_power_user_lmt);
-}
-
-static ssize_t
-il4965_store_tx_power(struct device *d, struct device_attribute *attr,
-		      const char *buf, size_t count)
-{
-	struct il_priv *il = dev_get_drvdata(d);
-	unsigned long val;
-	int ret;
-
-	ret = kstrtoul(buf, 10, &val);
-	if (ret)
-		IL_INFO("%s is not in decimal form.\n", buf);
-	else {
-		mutex_lock(&il->mutex);
-		ret = il_set_tx_power(il, val, false);
-		mutex_unlock(&il->mutex);
-		if (ret)
-			IL_ERR("failed setting tx power (0x%08x).\n", ret);
-		else
-			ret = count;
-	}
-	return ret;
-}
-
-static DEVICE_ATTR(tx_power, 0644, il4965_show_tx_power,
-		   il4965_store_tx_power);
-
-static struct attribute *il_sysfs_entries[] = {
-	&dev_attr_temperature.attr,
-	&dev_attr_tx_power.attr,
-	NULL
-};
-
-static const struct attribute_group il_attribute_group = {
-	.name = NULL,		/* put in device directory */
-	.attrs = il_sysfs_entries,
-};
-
 /******************************************************************************
  *
  * uCode download functions
@@ -4922,12 +4854,6 @@ il4965_ucode_callback(const struct firmware *ucode_raw, void *context)
 
 	il_dbgfs_register(il, DRV_NAME);
 
-	err = sysfs_create_group(&il->pci_dev->dev.kobj, &il_attribute_group);
-	if (err) {
-		IL_ERR("failed to create sysfs device attributes\n");
-		goto out_unbind;
-	}
-
 	/* We have our copies now, allow OS release its copies */
 	release_firmware(ucode_raw);
 	complete(&il->_4965.firmware_loading_complete);
@@ -6653,7 +6579,6 @@ il4965_pci_remove(struct pci_dev *pdev)
 	D_INFO("*** UNLOAD DRIVER ***\n");
 
 	il_dbgfs_unregister(il);
-	sysfs_remove_group(&pdev->dev.kobj, &il_attribute_group);
 
 	/* ieee80211_unregister_hw call wil cause il_mac_stop to
 	 * be called and il4965_down since we are removing the device
-- 
2.50.1

