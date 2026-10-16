Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE513D9048
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 07:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792136512; cv=none; b=YyDKACZ7tiTcVkhR+ABqa3xd89vuFY9uR/1QBLZpJSlLsVJV6BgK2+0YfEdgkH5pz6oDGJmaGQbOcDzrpne42yLjsrEMugXWTertRwQ35s9OeJ0xivIuEm+y/9WARPwj8AhDLiZFOPsQjE9sGnUzJY28WLzdLhDZVR8ia44R3Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792136512; c=relaxed/simple;
	bh=dQesIHP4WsBNK7aGhgMxr1fZ2OzS2kZzyn+Qoz89Bok=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j1CD4A/NBKQ2K7FE0vbgNxHBbqdMtRX9EoIBFF4PE1wfIGIWwbtz11uE0928yyseWywmoOq4PKnLv/6bN9FnaoIYHcJG0sw+uF3Z/q51GniaFGU354FBxMCsKWud7ymL65/WTl1ck0Xp39EgkUANDSRZSh4qG5qd2VyvCl9NaKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=ADijznzD; arc=none smtp.client-ip=212.77.101.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="ADijznzD"
Received: (wp-smtpd smtp.wp.pl 23785 invoked from network); 16 Oct 2026 09:41:47 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=s20261001;
          t=1792136507; bh=CNGMUi83xdQuT4fyaIfSRiMATe/iY3LGX7DDu0EJo2s=;
          h=From:To:Subject;
          b=ADijznzDrlxMq2DTCN8inSJ0368WF+Fh097vka23TyH/v9ZnhRNT1avc6kjIH7dH6
           YzKWSQiYlRVvDm7cStsfrIJXQSlgfWTsIsu6wpKflV0GoXHLY4Emfzp7Wmw79jXZFL
           DMxIFp7rdStAjuD6ekGCSdsXbiAI3TBMw19N1o+iYw21ZGnpqytin0//32z54ifWvX
           3+y43lmateeUvfkRGeUHmHRXSiRfVpKoBZoIeC0I5OZg5HlpsdT5iOBvczd2Z0QLCk
           GX0XHBOuFG2UiXrWKZhwP+nYpbD1+6SX8DpQ8StE9sbdFn/O2tIAWaz8yMsXUIZCub
           tcupBWh4Js2Bw==
Received: from localhost (77-236-6-58.static.play.pl [77.236.6.58])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 16 Oct 2026 09:41:47 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next 3/3] iwlegacy: remove disable_ht40 debugfs file
Date: Fri, 16 Oct 2026 09:41:43 +0200
Message-Id: <20261016074143.71057-4-stf_xl@wp.pl>
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
X-WP-MailID: 2c12363877bd72ab1b450d0c1f6bbaed
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000002 [YeF9]                               

From: Stanislaw Gruszka <stf_xl@wp.pl>

The disable_ht40 debugfs option was used for narrowing issues when
developing the driver, it's no longer needed.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/intel/iwlegacy/common.c |  5 ---
 drivers/net/wireless/intel/iwlegacy/common.h |  1 -
 drivers/net/wireless/intel/iwlegacy/debug.c  | 42 --------------------
 3 files changed, 48 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index c6a593e9cea0..ab9dbc53e01c 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -3583,11 +3583,6 @@ il_is_ht40_tx_allowed(struct il_priv *il, struct ieee80211_sta_ht_cap *ht_cap)
 	if (ht_cap && !ht_cap->ht_supported)
 		return false;
 
-#ifdef CONFIG_IWLEGACY_DEBUGFS
-	if (il->disable_ht40)
-		return false;
-#endif
-
 	return il_is_channel_extension(il, il->band,
 				       le16_to_cpu(il->staging.channel),
 				       il->ht.extension_chan_offset);
diff --git a/drivers/net/wireless/intel/iwlegacy/common.h b/drivers/net/wireless/intel/iwlegacy/common.h
index 260e6b971d00..542519bce242 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.h
+++ b/drivers/net/wireless/intel/iwlegacy/common.h
@@ -1418,7 +1418,6 @@ struct il_priv {
 	u8 *rx_traffic;
 	struct dentry *debugfs_dir;
 	u32 dbgfs_sram_offset, dbgfs_sram_len;
-	bool disable_ht40;
 #endif				/* CONFIG_IWLEGACY_DEBUGFS */
 
 	struct work_struct txpower_work;
diff --git a/drivers/net/wireless/intel/iwlegacy/debug.c b/drivers/net/wireless/intel/iwlegacy/debug.c
index a8cc01ce293b..5c8378740cee 100644
--- a/drivers/net/wireless/intel/iwlegacy/debug.c
+++ b/drivers/net/wireless/intel/iwlegacy/debug.c
@@ -679,46 +679,6 @@ il_dbgfs_qos_read(struct file *file, char __user *user_buf, size_t count,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
-static ssize_t
-il_dbgfs_disable_ht40_write(struct file *file, const char __user *user_buf,
-			    size_t count, loff_t *ppos)
-{
-	struct il_priv *il = file->private_data;
-	char buf[8];
-	int buf_size;
-	int ht40;
-
-	memset(buf, 0, sizeof(buf));
-	buf_size = min(count, sizeof(buf) - 1);
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	if (sscanf(buf, "%d", &ht40) != 1)
-		return -EFAULT;
-	if (!il_is_any_associated(il))
-		il->disable_ht40 = ht40 ? true : false;
-	else {
-		IL_ERR("Sta associated with AP - "
-		       "Change to 40MHz channel support is not allowed\n");
-		return -EINVAL;
-	}
-
-	return count;
-}
-
-static ssize_t
-il_dbgfs_disable_ht40_read(struct file *file, char __user *user_buf,
-			   size_t count, loff_t *ppos)
-{
-	struct il_priv *il = file->private_data;
-	char buf[100];
-	int pos = 0;
-	const size_t bufsz = sizeof(buf);
-
-	pos +=
-	    scnprintf(buf + pos, bufsz - pos, "11n 40MHz Mode: %s\n",
-		      il->disable_ht40 ? "Disabled" : "Enabled");
-	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-}
 
 DEBUGFS_READ_WRITE_FILE_OPS(sram);
 DEBUGFS_READ_FILE_OPS(nvm);
@@ -726,7 +686,6 @@ DEBUGFS_READ_FILE_OPS(stations);
 DEBUGFS_READ_FILE_OPS(status);
 DEBUGFS_READ_WRITE_FILE_OPS(interrupt);
 DEBUGFS_READ_FILE_OPS(qos);
-DEBUGFS_READ_WRITE_FILE_OPS(disable_ht40);
 
 static ssize_t
 il_dbgfs_tx_queue_read(struct file *file, char __user *user_buf, size_t count,
@@ -1226,7 +1185,6 @@ il_dbgfs_register(struct il_priv *il, const char *name)
 	DEBUGFS_ADD_FILE(status, dir_data, 0400);
 	DEBUGFS_ADD_FILE(interrupt, dir_data, 0600);
 	DEBUGFS_ADD_FILE(qos, dir_data, 0400);
-	DEBUGFS_ADD_FILE(disable_ht40, dir_data, 0600);
 	DEBUGFS_ADD_FILE(rx_stats, dir_debug, 0400);
 	DEBUGFS_ADD_FILE(tx_stats, dir_debug, 0400);
 	DEBUGFS_ADD_FILE(rx_queue, dir_debug, 0400);
-- 
2.50.1

