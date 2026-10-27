Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.77.101.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793118983;
	b=U0vlUYHCOgwDjRDLueuCnpSsCn2ZCSM4faN5SYRNehUEg11zGHCcN89yKn8c3O2foxkM
	 Lsr43Yi1CLDGUPY0VsY8d2PK6CpjG5c5tOEdaF/CLZ6GSZ6Ucl4QrKHN0ybzFOesmXk8l
	 LUlqmFuMLaLAL2obQhUcTmCaEYoJw8Z8MW+GvQvmLiIkfAKVUX3566/rri7lspsJ0dStF
	 ZoOwMNs7g8x0BhArArkJLKV2URq5m7MO6aDcM4gd694E5uE4SeTQrQEvh3Sd7jdQUmjgA
	 zMStuFfx9KF3NrcUbmtOhTvLd4QJOuE3ShZBlWFfD1ncbwXYI5QcUeXRqPPHcxf2AIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793118983;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-WP-MailID:X-WP-AV:X-WP-SPAM;
	bh=CNGMUi83xdQuT4fyaIfSRiMATe/iY3LGX7DDu0EJo2s=;
	b=MTEsQ2JTZPAY0DTt6MmV8QEv3QxVo8lWKBSKLZRK3sBuBVJuPXPD0J/iRHi3NIEtnU7C
	 szJ7wdjz64nMN0mcOX1eItS/CU6lI2U6UX1mjYfATzHPifZw8eRZu1TLZDs+7pTSHo6en
	 Kj+YeaME3wFcdMyMAORJ3Lkz//2WjKSMleikb72OGqe2Xktu5brS1RM8Byt2q1eFa9dZB
	 snHa4hHyisLfUXNaDUSNvWLj9tDuSkHm3S3e2nZrZMDKgPknNwZ+YyUIDj18YDHAVYcWm
	 EIXNC9sdDWuDhpFedoCEg1Ua0yhm/HH5TzBYBS+98RhTlyhBH4x/Tteqny9uc2KBOXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wp.pl;
	spf=pass smtp.mailfrom=wp.pl;
	dkim=pass header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b=KCt2ITGp;
	arc=none smtp.remote-ip=212.77.101.10
Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10E0606A33D
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 16:36:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D10E0606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b=KCt2ITGp
Received: (wp-smtpd smtp.wp.pl 44913 invoked from network); 27 Oct 2026 17:36:14 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=s20261001;
          t=1793118974; bh=CNGMUi83xdQuT4fyaIfSRiMATe/iY3LGX7DDu0EJo2s=;
          h=From:To:Subject;
          b=KCt2ITGpVozED0D6hlZ2ayPxEqMtdZ810caEPz0mHvWSml6b01sNIosPYKycq+3RX
           El7IdOidkB36eC8CPFr1sRs2FDH4M8GpQTO3zaNCFoGl1TCTVG4VeozM1b4UF7H2Ps
           K9OSqobA4qIbjilpL0yVHzQv6EFtzR9fsLiV3SoX4Yv7x/ODIOiZLQ9X/sIhnXP8EG
           RHwlx2JujN8kBs8FNTj1hP2CHATEWE67s0byKz3l9FaDGNjMlJIhboqq/euSlsolxb
           ZP4avmYcRdCBu2SVTp3cUgLGOuP/Dp4UCWQKWuM7p+vq5PENoSc/XjvGwbyu+14TPJ
           8S69LpiM8ffuA==
Received: from localhost (77-236-11-144.static.play.pl [77.236.11.144])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 27 Oct 2026 17:36:14 +0100
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next v2 3/3] wifi: iwlegacy: remove disable_ht40 debugfs file
Date: Tue, 27 Oct 2026 17:36:11 +0100
Message-Id: <20261027163611.5161-4-stf_xl@wp.pl>
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
X-WP-MailID: 260a5f440f492c707b8836a3c6ec8a8f
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000002 [IbFC]                               

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

