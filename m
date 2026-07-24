Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC1141DDF6
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 09:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784886952; cv=none; b=lD5Zn2c7BmrFyQRRb2bi1pQIno72oZNDC7uUO983ARBAH/QEjRjLMY6SU1PhRE2HyNgn7VlCFFuuq304KCQZlEQ2YYg/ypL0mVEqeVODwQCEU9HrfkqnNVVBBxkbyNy9IFrXGMXjrWvKG+pXhzZq+VT1SvQ58bSSD84tUOfqFoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784886952; c=relaxed/simple;
	bh=jI1n47RpNNejcH4SOlOwA/KtDnNOVmfB6Gg1xBZL4I4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=syzZcGcbAFNdDOggJqSaNXBSyQzp6/IAAb3XoM3D1Mf09kVLasTonNSxzIosa1mAy4ZvDAEm5e+nkEEwcF9lPDtn3FEoHKlTSvHfqOjqdvd+GitCuh7Y8W+5JX44MIj1cFYp66sYQMtbpo80H7iwszgKUHwXhbc55UzQn0oWtGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=Y7oAfXfc; arc=none smtp.client-ip=212.77.101.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="Y7oAfXfc"
Received: (wp-smtpd smtp.wp.pl 18014 invoked from network); 24 Jul 2026 11:55:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1784886946; bh=O6IsGZtAEXs0+n+pzO2WNxX2Bcfwoav9CaKGPNBE6jU=;
          h=From:To:Cc:Subject;
          b=Y7oAfXfcbX2N9ZG2KNfHpwK9yQlfORDXkR08R06rEXCkbmNluWhaimDvQjwMfFwoU
           1aTtwAAb/8K8pNclWYIa7ki2Yg7vAfv2HZRJlYxAwx9LPRHpteCWg6has6dhYdeYeC
           bciORZNSDGd4xkM0F/A7aGXsZuejwPLqkRPhdmPzGkbsd8LXtMx4Cyo36Vpn1q/URR
           LpY5fABrGSz2NvlUctRh8588/YrgUGS67lQNbhVwMMKjWmdoaY/gJ6xoKJ9Ckox3Hg
           euEYn9daOcuY74f094bhiCxxOhTt5IekLYOgjXZu48noYqSteT5YHYjEbtqkS3aeNb
           NhjEUHRAYEeDQ==
Received: from 77-236-11-167.static.play.pl (HELO localhost) (stf_xl@wp.pl@[77.236.11.167])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 24 Jul 2026 11:55:46 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: martin-eric.racine@iki.fi
Subject: [PATCH] wifi: iwlegacy: replace BUG_ON() with WARN_ON() on num_stations check
Date: Fri, 24 Jul 2026 11:55:45 +0200
Message-Id: <20260724095545.33647-1-stf_xl@wp.pl>
X-Mailer: git-send-email 2.25.4
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: b58354c86236c08990ab6c47f9ed8a94
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000001 [oUJH]                               

From: Stanislaw Gruszka <stf_xl@wp.pl>

BUG_ON() for il->num_stations < 0 can happen in real word, see
https://bugzilla.kernel.org/show_bug.cgi?id=221733

Replace BUG_ON() with WARN_ON() (and reset the counter to 0) to
do not put whole system to inconsistent state on the condition.

Also allocate debugfs buffer for all stations (32 or 25)
to do not use num_stations since it can not be valid number.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/intel/iwlegacy/common.c | 7 ++++---
 drivers/net/wireless/intel/iwlegacy/debug.c  | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index 8d0ff339ad08..0bb807ff8edf 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -2179,8 +2179,8 @@ il_remove_station(struct il_priv *il, const u8 sta_id, const u8 * addr)
 	il->stations[sta_id].used &= ~IL_STA_DRIVER_ACTIVE;
 
 	il->num_stations--;
-
-	BUG_ON(il->num_stations < 0);
+	if (WARN_ON(il->num_stations < 0))
+		il->num_stations = 0;
 
 	spin_unlock_irqrestore(&il->sta_lock, flags);
 
@@ -2328,7 +2328,8 @@ il_dealloc_bcast_stations(struct il_priv *il)
 
 		il->stations[i].used &= ~IL_STA_UCODE_ACTIVE;
 		il->num_stations--;
-		BUG_ON(il->num_stations < 0);
+		if (WARN_ON(il->num_stations < 0))
+			il->num_stations = 0;
 		kfree(il->stations[i].lq);
 		il->stations[i].lq = NULL;
 	}
diff --git a/drivers/net/wireless/intel/iwlegacy/debug.c b/drivers/net/wireless/intel/iwlegacy/debug.c
index d998a3f1b056..8a9f79ff1c6e 100644
--- a/drivers/net/wireless/intel/iwlegacy/debug.c
+++ b/drivers/net/wireless/intel/iwlegacy/debug.c
@@ -396,7 +396,7 @@ il_dbgfs_stations_read(struct file *file, char __user *user_buf, size_t count,
 	int i, j, pos = 0;
 	ssize_t ret;
 	/* Add 30 for initial string */
-	const size_t bufsz = 30 + sizeof(char) * 500 * (il->num_stations);
+	const size_t bufsz = 30 + sizeof(char) * 500 * max_sta;
 
 	buf = kmalloc(bufsz, GFP_KERNEL);
 	if (!buf)
-- 
2.50.1

