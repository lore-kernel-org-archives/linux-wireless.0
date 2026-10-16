Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C76941836E
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 07:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792136511; cv=none; b=H8PP3XbZ3uLVk+KnwIh/ndSpYlmkQt5GuwqLyixuUtPE6g6dMTKi9C3djvh1Khrmszi2bSEyYg+CVC+vOD+ILo9CoUeb7ia/Hnt2mt7diE+QyUHs8NqaPL61j8x061aV9gJEJoKIa8SQB+10H37MiACU+6M0wjGIYcz2CtS0cw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792136511; c=relaxed/simple;
	bh=xqkDl0/sxn9NEAntmQ8aFj3KlvInGC7bq4hsNG3C9go=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qw27B4MVd/iVkTTyAJfMmEq5bAjQZR/eWrwOVru8eTqiTL9t+U1PbPHusuVSUP8nGPUehQqQmLefyR/6LVmv6R67XYEiSPxnUBIyXk8IRkWdbXZjXLrwhcm5u5977wCuFdxNTM6D1d8N1DN/sqfXbiCnyQ0kYMFtq6+6e8cFe54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=FbhBaSXw; arc=none smtp.client-ip=212.77.101.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="FbhBaSXw"
Received: (wp-smtpd smtp.wp.pl 6981 invoked from network); 16 Oct 2026 09:41:45 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=s20261001;
          t=1792136505; bh=j8X1qAweY7sc5Sjl9IW3C+fu1Sz0g450Li99k0AfoSw=;
          h=From:To:Subject;
          b=FbhBaSXwBvgAZPEKiHLr7VkKJkCn13HDVNFgrDSh6R+R2Q8NFd5aGufTSiG4arz0a
           0HR6lKv/vyNo/sZITKNNSSrCzItW6gud77uiW6TX1i8pFkoS7iwEXWSqcCNfQ73feh
           2NPskZW6IZlDnXqELu8yo3ENtd8UPJdWT5D7/IGy5HdVitdKGWErKIGDRaRdF4h4Cp
           vDrUwD5NKi56HejLvE2CQysEKeRnGMa0oSF1edpQeEZWFhB+9FZavc6N9dDwFCF3op
           nUXad35PJpD9gOcF43sBUmH/LqnGm01gmMkhFFzhHB746PsOsRCwiWZGshRQzqW9U0
           oJdVxbod4/x+A==
Received: from localhost (77-236-6-58.static.play.pl [77.236.6.58])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 16 Oct 2026 09:41:45 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next 1/3] iwlegacy: remove configurable watchdog timeout
Date: Fri, 16 Oct 2026 09:41:41 +0200
Message-Id: <20261016074143.71057-2-stf_xl@wp.pl>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20261016074143.71057-1-stf_xl@wp.pl>
References: <20261016074143.71057-1-stf_xl@wp.pl>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: c836bd51fd589b204fc84f1d382f3b6f
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000004 [EffN]                               

From: Stanislaw Gruszka <stf_xl@wp.pl>

Remove the debugfs file used to configure the TX queue watchdog timeout.
It was used to experiment with different timeout values to determine a
suitable default, which is no longer necessary.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 .../net/wireless/intel/iwlegacy/3945-mac.c    |  2 +-
 drivers/net/wireless/intel/iwlegacy/3945.c    |  2 --
 .../net/wireless/intel/iwlegacy/4965-mac.c    |  2 +-
 drivers/net/wireless/intel/iwlegacy/4965.c    |  1 -
 drivers/net/wireless/intel/iwlegacy/common.c  | 31 ++-----------------
 drivers/net/wireless/intel/iwlegacy/common.h  |  9 +++---
 drivers/net/wireless/intel/iwlegacy/debug.c   | 26 ----------------
 7 files changed, 8 insertions(+), 65 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
index cbaf250626c5..a3b81badabfc 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -2132,7 +2132,7 @@ il3945_alive_start(struct il_priv *il)
 	set_bit(S_ALIVE, &il->status);
 
 	/* Enable watchdog to monitor the driver tx queues */
-	il_setup_watchdog(il);
+	mod_timer(&il->watchdog, jiffies + msecs_to_jiffies(IL_WD_TICK));
 
 	if (il_is_rfkill(il))
 		return;
diff --git a/drivers/net/wireless/intel/iwlegacy/3945.c b/drivers/net/wireless/intel/iwlegacy/3945.c
index b0656b143f77..60506f7914a2 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945.c
@@ -2670,7 +2670,6 @@ static const struct il_cfg il3945_bg_cfg = {
 	.set_l0s = false,
 	.use_bsm = true,
 	.led_compensation = 64,
-	.wd_timeout = IL_DEF_WD_TIMEOUT,
 
 	.regulatory_bands = {
 		EEPROM_REGULATORY_BAND_1_CHANNELS,
@@ -2699,7 +2698,6 @@ static const struct il_cfg il3945_abg_cfg = {
 	.set_l0s = false,
 	.use_bsm = true,
 	.led_compensation = 64,
-	.wd_timeout = IL_DEF_WD_TIMEOUT,
 
 	.regulatory_bands = {
 		EEPROM_REGULATORY_BAND_1_CHANNELS,
diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index 18bb55682643..1a553ef0c04f 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -5291,7 +5291,7 @@ il4965_alive_start(struct il_priv *il)
 	set_bit(S_ALIVE, &il->status);
 
 	/* Enable watchdog to monitor the driver tx queues */
-	il_setup_watchdog(il);
+	mod_timer(&il->watchdog, jiffies + msecs_to_jiffies(IL_WD_TICK));
 
 	if (il_is_rfkill(il))
 		return;
diff --git a/drivers/net/wireless/intel/iwlegacy/4965.c b/drivers/net/wireless/intel/iwlegacy/4965.c
index b63e29590b04..3418fbb0e003 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965.c
@@ -1913,7 +1913,6 @@ struct il_cfg il4965_cfg = {
 	.use_bsm = true,
 	.led_compensation = 61,
 	.chain_noise_num_beacons = IL4965_CAL_NUM_BEACONS,
-	.wd_timeout = IL_DEF_WD_TIMEOUT,
 	.temperature_kelvin = true,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index 0bb807ff8edf..c6a593e9cea0 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -4772,9 +4772,7 @@ il_check_stuck_queue(struct il_priv *il, int cnt)
 		return 0;
 	}
 
-	timeout =
-	    txq->time_stamp +
-	    msecs_to_jiffies(il->cfg->wd_timeout);
+	timeout = txq->time_stamp + msecs_to_jiffies(IL_WD_TIMEOUT);
 
 	if (time_after(now, timeout)) {
 		IL_ERR("Queue %d stuck for %u ms.\n", q->id,
@@ -4786,12 +4784,6 @@ il_check_stuck_queue(struct il_priv *il, int cnt)
 	return 0;
 }
 
-/*
- * Making watchdog tick be a quarter of timeout assure we will
- * discover the queue hung between timeout and 1.25*timeout
- */
-#define IL_WD_TICK(timeout) ((timeout) / 4)
-
 /*
  * Watchdog timer callback, we check each tx queue for stuck, if hung
  * we reset the firmware. If everything is fine just rearm the timer.
@@ -4801,15 +4793,10 @@ il_bg_watchdog(struct timer_list *t)
 {
 	struct il_priv *il = timer_container_of(il, t, watchdog);
 	int cnt;
-	unsigned long timeout;
 
 	if (test_bit(S_EXIT_PENDING, &il->status))
 		return;
 
-	timeout = il->cfg->wd_timeout;
-	if (timeout == 0)
-		return;
-
 	/* monitor and check for stuck cmd queue */
 	if (il_check_stuck_queue(il, il->cmd_queue))
 		return;
@@ -4823,24 +4810,10 @@ il_bg_watchdog(struct timer_list *t)
 			return;
 	}
 
-	mod_timer(&il->watchdog,
-		  jiffies + msecs_to_jiffies(IL_WD_TICK(timeout)));
+	mod_timer(&il->watchdog, jiffies + msecs_to_jiffies(IL_WD_TICK));
 }
 EXPORT_SYMBOL(il_bg_watchdog);
 
-void
-il_setup_watchdog(struct il_priv *il)
-{
-	unsigned int timeout = il->cfg->wd_timeout;
-
-	if (timeout)
-		mod_timer(&il->watchdog,
-			  jiffies + msecs_to_jiffies(IL_WD_TICK(timeout)));
-	else
-		timer_delete(&il->watchdog);
-}
-EXPORT_SYMBOL(il_setup_watchdog);
-
 /*
  * extended beacon time format
  * time in usec will be changed into a 32-bit value in extended:internal format
diff --git a/drivers/net/wireless/intel/iwlegacy/common.h b/drivers/net/wireless/intel/iwlegacy/common.h
index 21f1c7702add..260e6b971d00 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.h
+++ b/drivers/net/wireless/intel/iwlegacy/common.h
@@ -1085,9 +1085,9 @@ struct traffic_stats {
 #define IL_DELAY_NEXT_FORCE_FW_RELOAD (HZ*5)
 
 /* TX queue watchdog timeouts in mSecs */
-#define IL_DEF_WD_TIMEOUT	(2000)
-#define IL_LONG_WD_TIMEOUT	(10000)
-#define IL_MAX_WD_TIMEOUT	(120000)
+#define IL_WD_TIMEOUT 2000
+/* Discover the queue hung between timeout and 1.25*timeout */
+#define IL_WD_TICK (IL_WD_TIMEOUT / 4)
 
 struct il_force_reset {
 	int reset_request_count;
@@ -1683,7 +1683,6 @@ struct il_cfg {
 
 	u16 led_compensation;
 	int chain_noise_num_beacons;
-	unsigned int wd_timeout;
 	bool temperature_kelvin;
 	const bool ucode_tracing;
 	const bool sensitivity_calib_by_driver;
@@ -1764,7 +1763,7 @@ int il_tx_queue_init(struct il_priv *il, u32 txq_id);
 void il_tx_queue_reset(struct il_priv *il, u32 txq_id);
 void il_tx_queue_unmap(struct il_priv *il, int txq_id);
 void il_tx_queue_free(struct il_priv *il, int txq_id);
-void il_setup_watchdog(struct il_priv *il);
+
 /*****************************************************
  * TX power
  ****************************************************/
diff --git a/drivers/net/wireless/intel/iwlegacy/debug.c b/drivers/net/wireless/intel/iwlegacy/debug.c
index 8a9f79ff1c6e..a7db62f75d7a 100644
--- a/drivers/net/wireless/intel/iwlegacy/debug.c
+++ b/drivers/net/wireless/intel/iwlegacy/debug.c
@@ -1265,30 +1265,6 @@ il_dbgfs_force_reset_write(struct file *file, const char __user *user_buf,
 	return ret ? ret : count;
 }
 
-static ssize_t
-il_dbgfs_wd_timeout_write(struct file *file, const char __user *user_buf,
-			  size_t count, loff_t *ppos)
-{
-
-	struct il_priv *il = file->private_data;
-	char buf[8];
-	int buf_size;
-	int timeout;
-
-	memset(buf, 0, sizeof(buf));
-	buf_size = min(count, sizeof(buf) - 1);
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	if (sscanf(buf, "%d", &timeout) != 1)
-		return -EINVAL;
-	if (timeout < 0 || timeout > IL_MAX_WD_TIMEOUT)
-		timeout = IL_DEF_WD_TIMEOUT;
-
-	il->cfg->wd_timeout = timeout;
-	il_setup_watchdog(il);
-	return count;
-}
-
 DEBUGFS_READ_FILE_OPS(rx_stats);
 DEBUGFS_READ_FILE_OPS(tx_stats);
 DEBUGFS_READ_FILE_OPS(rx_queue);
@@ -1306,7 +1282,6 @@ DEBUGFS_READ_WRITE_FILE_OPS(missed_beacon);
 DEBUGFS_READ_WRITE_FILE_OPS(force_reset);
 DEBUGFS_READ_FILE_OPS(rxon_flags);
 DEBUGFS_READ_FILE_OPS(rxon_filter_flags);
-DEBUGFS_WRITE_FILE_OPS(wd_timeout);
 
 /*
  * Create the debugfs files and directories
@@ -1353,7 +1328,6 @@ il_dbgfs_register(struct il_priv *il, const char *name)
 		DEBUGFS_ADD_FILE(chain_noise, dir_debug, 0400);
 	DEBUGFS_ADD_FILE(rxon_flags, dir_debug, 0200);
 	DEBUGFS_ADD_FILE(rxon_filter_flags, dir_debug, 0200);
-	DEBUGFS_ADD_FILE(wd_timeout, dir_debug, 0200);
 	if (il->cfg->sensitivity_calib_by_driver)
 		DEBUGFS_ADD_BOOL(disable_sensitivity, dir_rf,
 				 &il->disable_sens_cal);
-- 
2.50.1

