Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.77.101.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793118975;
	b=cZgJ+pnQqhZ1xcpbJJmbnP6ZHDvTePvT3YR+TMhHU61KCrfoDKCa61UF2o/iU/MzMwg0
	 cGhF8xGS++7OoGzl8MA3T+QBnAyJ0uG3ZLyqjKG//o9tI1d8ajJlrSsagGnGvwFY+HHwy
	 Z+28fem0umg/mm58QtLfIHnsR8EHwBHsL+lhlSiz1YiSfy2DPAXbRi2zG3vLbyuhjaNGJ
	 ABEEeyEPhYwFxkPw9YreUfNehi5P0rwz5We7yblMaGpcPYPzKPhnXFKyk6B2MY5+5vpWQ
	 QkgXPlqqVu2ws+u97RWuWzZJEefDiCSiYtAPEx+LQ9Ddc+L/KDXkGC8EM5RYXA8BlBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793118975;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-WP-MailID:X-WP-AV:X-WP-SPAM;
	bh=j8X1qAweY7sc5Sjl9IW3C+fu1Sz0g450Li99k0AfoSw=;
	b=MFNVAdXUqPzPOOwAOUgtU0X5cp6IH29RdrTUEv845zsPGuAKhxosbWu27ojcQpcMOPte
	 2agyIG/82H549js5Bx7X2D/SAYASjLWslH1HxcyBYwUrG9iHGKPYflxibspUentKqdizZ
	 gdFU57sPiVsNibvIwiSEuxE79QmrXYB1WtLN8J1ZVu6tAg8srSPaKXDHrm6X4vGHPHkUz
	 dLm3lVX5mtlx7vI+HtWUAoBHGCIUf3apfkQGiy28YJAnRC5u+92WBYlO8A4ePGq+RVLwK
	 hdg7NnsrXxrmKFjfOm92/qB6RufvifFGB0hYcC1d7UVRhB3NaPYC1pziFvWkcqbG7Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wp.pl;
	spf=pass smtp.mailfrom=wp.pl;
	dkim=pass header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b="lcNok/Mm";
	arc=none smtp.remote-ip=212.77.101.11
Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C87606A31B
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 16:36:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6C87606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b=lcNok/Mm
Received: (wp-smtpd smtp.wp.pl 12237 invoked from network); 27 Oct 2026 17:36:12 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=s20261001;
          t=1793118972; bh=j8X1qAweY7sc5Sjl9IW3C+fu1Sz0g450Li99k0AfoSw=;
          h=From:To:Subject;
          b=lcNok/Mm10RgMX6WS5UWLZZqqTfbP2a9h7i3gevoPRL251CUazTXjPs/wPAysy5qt
           H1Izhb2+SojaduN+C/1lWq2pTyYNvUqVsuFA+ob/3t/RATvhDNHuNqzb6nHQYriPv0
           DUXKKHct/gg18IwJ8GrWNQ0T1JFAR1v+igyTaOvKzNlAr9RoEo4mtxyw3XZpIRgId5
           VOKi4sBQCERITfsBsmRVaT0tFbjo88rRKG8WT9TqzYAYpA4R8uezYy5Gtk+SiYMD26
           WG6N4uMOGB2mOnKeyxilkBHIsk113ek6jS+7d2gSIiBYmNW63xM2RfQ7jqrmNAz+jL
           zWa5nEMZKPdsA==
Received: from localhost (77-236-11-144.static.play.pl [77.236.11.144])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 27 Oct 2026 17:36:12 +0100
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next v2 1/3] wifi: iwlegacy: remove configurable watchdog timeout
Date: Tue, 27 Oct 2026 17:36:09 +0100
Message-Id: <20261027163611.5161-2-stf_xl@wp.pl>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20261027163611.5161-1-stf_xl@wp.pl>
References: <20261027163611.5161-1-stf_xl@wp.pl>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: a8a56b59d8a3b228b17885a2c472c1bf
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000005 [cZbS]                               

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

