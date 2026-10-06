Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F72336403D
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 08:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791274500; cv=none; b=fCVLu/l13KRMQ6cpYtIoaC+6LyLZzB5Jf8Wh6tEZ42Bx+JwGUOI2v9Zet7k0MIchaTh3bHCpnL7eQm9un3vkiE9XtWbd0ydWBM2d3WSGAyJEJJFIt6VXoKhIPxmhkeiU5/3X1aKokZcLMBZY5CrwSF7rQgG0v5lqqtAVVfJ22dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791274500; c=relaxed/simple;
	bh=ZdIeqm0+8U2AVI28m87AMqqcNTCkZKpsM4tbyBwBbvc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WpyInlY/6e9UFd8yylx0HPy1D3XVy6GOhqmNcElunjfiOOLU/T7WRPlmT2JgUbHMf5oWRQdG/y34JxUbfuQEiO22r4Rkgd+uAAJnudVVUvmrRuAnMzD6UP/0/PkcyVU8/nWb75y4xtSdkAQd1HS8BfMEwX+OnsnqTgkWxrHQZuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=FvtKEO2q; arc=none smtp.client-ip=212.77.101.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="FvtKEO2q"
Received: (wp-smtpd smtp.wp.pl 41110 invoked from network); 6 Oct 2026 10:14:49 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=s20261001;
          t=1791274489; bh=7XSlqC44GqPwjbcBXB6DJgBXD/38dLfFNtGwcTFguNE=;
          h=From:To:Cc:Subject;
          b=FvtKEO2qqH8LKkUkw2w2bBMLWtcdeI9YVdwPawhcopk3YsC0ymzx/RgMfnAdGoeZQ
           YZt2dwQdHoAz6Xb4ZKS/OiVPUIThtuPVpnhOMn23BAuyrWsP5Q9Pnp8mlYUbqmvtB/
           l5qvTjUL6d4qEN21sIBDxDbkyiuAziV4C0cUCO2cys7KFEc9OPIzVIUWDiGexVSNTD
           nd4T5fEuu0fA4TrzPL9Vl41PYayumDSzOdWzbE+1cvOWAl/vzLX4Lxgr7oTNr8ZVSO
           yPAeZVhH5rQ3EkWuDT6YC9VYZAc7I8vpCLuqXlVd0D9ivN6XhkpqviHYQe1nrUx+cn
           58ZOqFgW5VE+Q==
Received: from localhost (77-236-6-58.static.play.pl [77.236.6.58])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 6 Oct 2026 10:14:49 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 1/3] wifi: iwlegacy: set debug level using debugfs
Date: Tue,  6 Oct 2026 10:14:41 +0200
Message-Id: <20261006081443.28017-2-stf_xl@wp.pl>
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
X-WP-MailID: 0e6b1248b738816d6ce0dfc2c6e5bf58
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000002 [0YHt]                               

From: Stanislaw Gruszka <stf_xl@wp.pl>

Instead of custom sysfs file use debugfs for setting/reading
debug level. Use hex only format since 'level' is actually a mask.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 .../net/wireless/intel/iwlegacy/3945-mac.c    | 46 -------------------
 .../net/wireless/intel/iwlegacy/4965-mac.c    | 46 -------------------
 drivers/net/wireless/intel/iwlegacy/debug.c   |  3 ++
 3 files changed, 3 insertions(+), 92 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
index cbaf250626c5..aec45bcc2446 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -3010,49 +3010,6 @@ il3945_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
  *
  *****************************************************************************/
 
-#ifdef CONFIG_IWLEGACY_DEBUG
-
-/*
- * The following adds a new attribute to the sysfs representation
- * of this device driver (i.e. a new file in /sys/bus/pci/drivers/iwl/)
- * used for controlling the debug level.
- *
- * See the level definitions in iwl for details.
- *
- * The debug_level being managed using sysfs below is a per device debug
- * level that is used instead of the global debug level if it (the per
- * device debug level) is set.
- */
-static ssize_t
-il3945_show_debug_level(struct device *d, struct device_attribute *attr,
-			char *buf)
-{
-	struct il_priv *il = dev_get_drvdata(d);
-	return sprintf(buf, "0x%08X\n", il_get_debug_level(il));
-}
-
-static ssize_t
-il3945_store_debug_level(struct device *d, struct device_attribute *attr,
-			 const char *buf, size_t count)
-{
-	struct il_priv *il = dev_get_drvdata(d);
-	unsigned long val;
-	int ret;
-
-	ret = kstrtoul(buf, 0, &val);
-	if (ret)
-		IL_INFO("%s is not in hex or decimal form.\n", buf);
-	else
-		il->debug_level = val;
-
-	return strnlen(buf, count);
-}
-
-static DEVICE_ATTR(debug_level, 0644, il3945_show_debug_level,
-		   il3945_store_debug_level);
-
-#endif /* CONFIG_IWLEGACY_DEBUG */
-
 static ssize_t
 il3945_show_temperature(struct device *d, struct device_attribute *attr,
 			char *buf)
@@ -3385,9 +3342,6 @@ static struct attribute *il3945_sysfs_entries[] = {
 	&dev_attr_status.attr,
 	&dev_attr_temperature.attr,
 	&dev_attr_tx_power.attr,
-#ifdef CONFIG_IWLEGACY_DEBUG
-	&dev_attr_debug_level.attr,
-#endif
 	NULL
 };
 
diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index 18bb55682643..dc420366dff3 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -4526,49 +4526,6 @@ il4965_irq_tasklet(struct tasklet_struct *t)
  *
  *****************************************************************************/
 
-#ifdef CONFIG_IWLEGACY_DEBUG
-
-/*
- * The following adds a new attribute to the sysfs representation
- * of this device driver (i.e. a new file in /sys/class/net/wlan0/device/)
- * used for controlling the debug level.
- *
- * See the level definitions in iwl for details.
- *
- * The debug_level being managed using sysfs below is a per device debug
- * level that is used instead of the global debug level if it (the per
- * device debug level) is set.
- */
-static ssize_t
-il4965_show_debug_level(struct device *d, struct device_attribute *attr,
-			char *buf)
-{
-	struct il_priv *il = dev_get_drvdata(d);
-	return sprintf(buf, "0x%08X\n", il_get_debug_level(il));
-}
-
-static ssize_t
-il4965_store_debug_level(struct device *d, struct device_attribute *attr,
-			 const char *buf, size_t count)
-{
-	struct il_priv *il = dev_get_drvdata(d);
-	unsigned long val;
-	int ret;
-
-	ret = kstrtoul(buf, 0, &val);
-	if (ret)
-		IL_ERR("%s is not in hex or decimal form.\n", buf);
-	else
-		il->debug_level = val;
-
-	return strnlen(buf, count);
-}
-
-static DEVICE_ATTR(debug_level, 0644, il4965_show_debug_level,
-		   il4965_store_debug_level);
-
-#endif /* CONFIG_IWLEGACY_DEBUG */
-
 static ssize_t
 il4965_show_temperature(struct device *d, struct device_attribute *attr,
 			char *buf)
@@ -4623,9 +4580,6 @@ static DEVICE_ATTR(tx_power, 0644, il4965_show_tx_power,
 static struct attribute *il_sysfs_entries[] = {
 	&dev_attr_temperature.attr,
 	&dev_attr_tx_power.attr,
-#ifdef CONFIG_IWLEGACY_DEBUG
-	&dev_attr_debug_level.attr,
-#endif
 	NULL
 };
 
diff --git a/drivers/net/wireless/intel/iwlegacy/debug.c b/drivers/net/wireless/intel/iwlegacy/debug.c
index 8a9f79ff1c6e..6f95961037d1 100644
--- a/drivers/net/wireless/intel/iwlegacy/debug.c
+++ b/drivers/net/wireless/intel/iwlegacy/debug.c
@@ -1361,6 +1361,9 @@ il_dbgfs_register(struct il_priv *il, const char *name)
 		DEBUGFS_ADD_BOOL(disable_chain_noise, dir_rf,
 				 &il->disable_chain_noise_cal);
 	DEBUGFS_ADD_BOOL(disable_tx_power, dir_rf, &il->disable_tx_power_cal);
+#ifdef CONFIG_IWLEGACY_DEBUG
+	debugfs_create_x32("debug_level", 0600, dir_debug, &il->debug_level);
+#endif
 }
 EXPORT_SYMBOL(il_dbgfs_register);
 
-- 
2.50.1

