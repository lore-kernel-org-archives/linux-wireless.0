Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.77.101.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793118976;
	b=m93FuwhfCFnK1CXKIW/ULGd04nCf0YYbN0diZM6ylnwtCncf2pGI1x2VUFECmstlK9Jn
	 IYCJQ2fsXDEMZnMAj+vjHNTC532BvYQfSx0N4p9c28Cm5FZNywFuOGCfiw/jXaMwYiwa2
	 X3zgXQAQR5XWeFhkyljQJVENs1MYg5eZ5VfHCHYZnEk/NO/318UorqF00eoa2k6D2dGw7
	 okcobzdrIIOWsn6uuqtdrSTVUSDSYrQ6bKcR0WeRwMcd2IF3Mybh1X9CxURdDi+D1zbpq
	 Czf1Tyy+WSSqHuz3ryPPeOmpmAC4nttWtQUyvInC0prx1t9LwlrWcgo8mVai8X+bgMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793118976;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-WP-MailID:X-WP-AV:X-WP-SPAM;
	bh=bNaitiMftrcUgvAWO5KJfFiJ83UfouD8XPsZxRP35GI=;
	b=RmA/YxpsiavHAJZ9BZ2Y0WTnxEC0rFIKGonY4x1xSt+ahGvuuvnTV7KcX8hMB0+fTcXW
	 hefwtuWYaBu/6wVEriNIKRMHKT/JJ8/jY5prxO3JQl9lAW4OeGD3LxULIaoSco0vp7ViV
	 /msod3tk9xJPNZ0dzNUGv6akbt5RnatSn3dbc9sbndGP4yLmnq5fB+vALTIFoPtvlHs05
	 zb8JLBT0A+nIZ8tO8JKwROrIbnp0ojJY33JVLB2BSReIRjCh5ic4wFd8zunSW75q6Mv2w
	 nk7J/tbXrhOoQy4+e3Tarvcyet/+sZSzQaNhStSm83qbr5JMv6Hez6B2O+QoBq1C4NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wp.pl;
	spf=pass smtp.mailfrom=wp.pl;
	dkim=pass header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b=AKjrUicS;
	arc=none smtp.remote-ip=212.77.101.12
Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BF6606A32C
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 16:36:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C0BF6606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b=AKjrUicS
Received: (wp-smtpd smtp.wp.pl 14902 invoked from network); 27 Oct 2026 17:36:13 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=s20261001;
          t=1793118973; bh=bNaitiMftrcUgvAWO5KJfFiJ83UfouD8XPsZxRP35GI=;
          h=From:To:Subject;
          b=AKjrUicSxFyDBuNQ+ZAi6AUrY0MMOx6ALv4qXPcX3GsFvVnb8fXeGN60p93d1b+ti
           gWN+2C2mNy7eK29hYD071nDtbLIQ6Z5Qf2pyokAFtUCrntlGaSntSlPRaN3eSSIwAG
           AexjiJdIL1KWikEMak/0SjyOhn5JeQjuoVQmNcJh9TJjnuTVNeSgvF09VI7dg8C+Zq
           f5KGlf0dXu1a/NydmLVclo67Ykavc5PClWRF1dOrbkFb7hX1dauvElmIr4BtZczBYB
           8F+CCQ5wlzuUepvoyztCzFZdeeVGkiky52L2wFLOx+TBLFoxB8ww7T1/0L3HvFEUjr
           /WQ8uI4Au2YIw==
Received: from localhost (77-236-11-144.static.play.pl [77.236.11.144])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 27 Oct 2026 17:36:13 +0100
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next v2 2/3] wifi: iwlegacy: remove channels debugfs file
Date: Tue, 27 Oct 2026 17:36:10 +0100
Message-Id: <20261027163611.5161-3-stf_xl@wp.pl>
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
X-WP-MailID: bebc78d2897f440dfa77d987048c3815
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000004 [Acei]                               

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

