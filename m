Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B081426D13
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 07:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792136511; cv=none; b=VmJPajnZrRjKsjGskEZEEFF74zvrs+WdtKfcVVjJq1zPJVZxqbvCKKSOS26eitH2xd5rVr9pM4pySm3tHvIMQHYexwr2bVdR+txf4MI8tDdClxfimiK5N0NbIu7ZScmDVC0wb/B8B4vdQ6iCtqyBDoYBJYbMXB9G0yd+pJPKyBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792136511; c=relaxed/simple;
	bh=ZcDiigyhA8DiPyCri/T4ambS8lEIG7BNG/I2YFLMLTQ=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q+vjXSr/MISqwmpS3Q/l44rBwPyDSDJuwrZ3UUcfUmphtaRnZVKXQ9xlbkR9DAquwt6oY8ksUQ1mifgqCkYue9fj8X120J+S66zluaezH3rbwQ7xJMCrvXciHYscl+BYmHlnu1PYfu1eJLFiYmubax7hmT5dgUrVJ3r2TK/ikKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=L5kbpi9F; arc=none smtp.client-ip=212.77.101.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="L5kbpi9F"
Received: (wp-smtpd smtp.wp.pl 15063 invoked from network); 16 Oct 2026 09:41:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=s20261001;
          t=1792136506; bh=bNaitiMftrcUgvAWO5KJfFiJ83UfouD8XPsZxRP35GI=;
          h=From:To:Subject;
          b=L5kbpi9FYxOF0zRiHY3VyD2R0qegM65fq6nfFsiwPfq7TzT3EhptqCr083bFoYcfW
           FB+QVwXRfC8K0M36qBVELutPJQQwOssZNRIkQJoHngM1Cy1jCe4J44VIaptvmF78UK
           I5Og3l8t8CssugmBCVZOUHpoNn1KkJigKx7U6ARhOC306TF1WfgeQLNdTVEuUdtzc3
           IpQaxcixDrxHATydZG5AVZOKisbTNjUtNWg4DQdYTcaBhGUFXWhX129c1hESGZPuuf
           0BcgOwGPqgmsFqUCkKEVwy5MwofxmND9M0tTR4wVw2TQDL1VDun5YYB2O+26yK2n6g
           ghqyf+QpzzO4w==
Received: from localhost (77-236-6-58.static.play.pl [77.236.6.58])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 16 Oct 2026 09:41:46 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next 2/3] iwlegacy: remove channels debugfs file
Date: Fri, 16 Oct 2026 09:41:42 +0200
Message-Id: <20261016074143.71057-3-stf_xl@wp.pl>
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
X-WP-MailID: 7ab14e86221cd0bbe09ce6e7cfdca0df
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000004 [gfcd]                               

From: Stanislaw Gruszka <stf_xl@wp.pl>

Remove the debugfs file that lists supported channels and their
properties, as the same information is provided by 'iw phy'
command.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/intel/iwlegacy/debug.c | 81 ---------------------
 1 file changed, 81 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/debug.c b/drivers/net/wireless/intel/iwlegacy/debug.c
index a7db62f75d7a..a8cc01ce293b 100644
--- a/drivers/net/wireless/intel/iwlegacy/debug.c
+++ b/drivers/net/wireless/intel/iwlegacy/debug.c
@@ -493,85 +493,6 @@ il_dbgfs_nvm_read(struct file *file, char __user *user_buf, size_t count,
 	return ret;
 }
 
-static ssize_t
-il_dbgfs_channels_read(struct file *file, char __user *user_buf, size_t count,
-		       loff_t *ppos)
-{
-	struct il_priv *il = file->private_data;
-	struct ieee80211_channel *channels = NULL;
-	const struct ieee80211_supported_band *supp_band = NULL;
-	int pos = 0, i, bufsz = PAGE_SIZE;
-	char *buf;
-	ssize_t ret;
-
-	if (!test_bit(S_GEO_CONFIGURED, &il->status))
-		return -EAGAIN;
-
-	buf = kzalloc(bufsz, GFP_KERNEL);
-	if (!buf) {
-		IL_ERR("Can not allocate Buffer\n");
-		return -ENOMEM;
-	}
-
-	supp_band = il_get_hw_mode(il, NL80211_BAND_2GHZ);
-	if (supp_band) {
-		channels = supp_band->channels;
-
-		pos +=
-		    scnprintf(buf + pos, bufsz - pos,
-			      "Displaying %d channels in 2.4GHz band 802.11bg):\n",
-			      supp_band->n_channels);
-
-		for (i = 0; i < supp_band->n_channels; i++)
-			pos +=
-			    scnprintf(buf + pos, bufsz - pos,
-				      "%d: %ddBm: BSS%s%s, %s.\n",
-				      channels[i].hw_value,
-				      channels[i].max_power,
-				      channels[i].
-				      flags & IEEE80211_CHAN_RADAR ?
-				      " (IEEE 802.11h required)" : "",
-				      ((channels[i].
-					flags & IEEE80211_CHAN_NO_IR) ||
-				       (channels[i].
-					flags & IEEE80211_CHAN_RADAR)) ? "" :
-				      ", IBSS",
-				      channels[i].
-				      flags & IEEE80211_CHAN_NO_IR ?
-				      "passive only" : "active/passive");
-	}
-	supp_band = il_get_hw_mode(il, NL80211_BAND_5GHZ);
-	if (supp_band) {
-		channels = supp_band->channels;
-
-		pos +=
-		    scnprintf(buf + pos, bufsz - pos,
-			      "Displaying %d channels in 5.2GHz band (802.11a)\n",
-			      supp_band->n_channels);
-
-		for (i = 0; i < supp_band->n_channels; i++)
-			pos +=
-			    scnprintf(buf + pos, bufsz - pos,
-				      "%d: %ddBm: BSS%s%s, %s.\n",
-				      channels[i].hw_value,
-				      channels[i].max_power,
-				      channels[i].
-				      flags & IEEE80211_CHAN_RADAR ?
-				      " (IEEE 802.11h required)" : "",
-				      ((channels[i].
-					flags & IEEE80211_CHAN_NO_IR) ||
-				       (channels[i].
-					flags & IEEE80211_CHAN_RADAR)) ? "" :
-				      ", IBSS",
-				      channels[i].
-				      flags & IEEE80211_CHAN_NO_IR ?
-				      "passive only" : "active/passive");
-	}
-	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-	kfree(buf);
-	return ret;
-}
-
 static ssize_t
 il_dbgfs_status_read(struct file *file, char __user *user_buf, size_t count,
 		     loff_t *ppos)
@@ -802,7 +723,6 @@ il_dbgfs_disable_ht40_read(struct file *file, char __user *user_buf,
 DEBUGFS_READ_WRITE_FILE_OPS(sram);
 DEBUGFS_READ_FILE_OPS(nvm);
 DEBUGFS_READ_FILE_OPS(stations);
-DEBUGFS_READ_FILE_OPS(channels);
 DEBUGFS_READ_FILE_OPS(status);
 DEBUGFS_READ_WRITE_FILE_OPS(interrupt);
 DEBUGFS_READ_FILE_OPS(qos);
@@ -1303,7 +1223,6 @@ il_dbgfs_register(struct il_priv *il, const char *name)
 	DEBUGFS_ADD_FILE(nvm, dir_data, 0400);
 	DEBUGFS_ADD_FILE(sram, dir_data, 0600);
 	DEBUGFS_ADD_FILE(stations, dir_data, 0400);
-	DEBUGFS_ADD_FILE(channels, dir_data, 0400);
 	DEBUGFS_ADD_FILE(status, dir_data, 0400);
 	DEBUGFS_ADD_FILE(interrupt, dir_data, 0600);
 	DEBUGFS_ADD_FILE(qos, dir_data, 0400);
-- 
2.50.1

