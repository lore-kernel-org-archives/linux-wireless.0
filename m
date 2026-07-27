Received: from forward203b.mail.yandex.net (forward203b.mail.yandex.net [178.154.239.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B1C3F54B7
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 10:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785146854; cv=none; b=ecj2XXmQ0npXcGITOfNYWslq7IITumbMzgKCkvoyG88Ujn4hPS5pz+OzYOiiB1A7RtjYFvVkYfl4WP3yvvnxu9IqAaXXpBJ4ezWFn3sxTvyCxiAQztts4BtNF3n2qB1r8DxmUHVT7HfcoHXJdAn/GZkhd6KWuC+V1GgcDZYvf4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785146854; c=relaxed/simple;
	bh=B1Sh+Pe+CvLuhQgEeDAtadl8PfYqspkA4rZzYSCgwdE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jH0e/dqVrClMHYYNFLjRx4f7ZpIYFoi65hiP/GDM8lkHbkqP+ZC8rN3aXCR/JA4FWS6a8cmPBt8XujYaJ/vhsWTOklXIeUOdFsoBKCo6fiAYX/9L9FeJf7tiZokcjT020ddAicCz5ElD5ldz9v3OxeZtaxeZyevLUSzs03qBvls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=js8Sc5Z4; arc=none smtp.client-ip=178.154.239.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="js8Sc5Z4"
Received: from forward100b.mail.yandex.net (forward100b.mail.yandex.net [IPv6:2a02:6b8:c02:900:1:45:d181:d100])
	by forward203b.mail.yandex.net (postfix) with ESMTPS id 03BF4831E4
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 12:59:29 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-70.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-70.sas.yp-c.yandex.net [IPv6:2a02:6b8:c11:e97:0:640:f294:0])
	by forward100b.mail.yandex.net (postfix) with ESMTPS id AD4FF80DFF;
	Mon, 27 Jul 2026 12:59:20 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-70.sas.yp-c.yandex.net (smtp) with ESMTPSA id JxY6sNth7W20-OcUgNA8H;
	Mon, 27 Jul 2026 12:59:20 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1785146360; bh=uOApjRZFC4Gu4YXw5aUvmTUosT4WCvjRVuyAuPjIJjg=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=js8Sc5Z4qlI8qCCzMfa7aoL+oAJruRZBrnAPbXjXKjJcfVX/S2Toa5KfUS3Wk6Bby
	 uMZfF6q1eR208gHbtc3n5BcggJTRKvsjsgsDc4AKmhGRtvk2me9d+CCQfHB4+4PkIK
	 undpM+/L8A+7Uf22Z9Alv54B+BZSW0VykjWG3RrA=
Authentication-Results: mail-nwsmtp-smtp-production-main-70.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] wifi: mac80211: simplify airtime_flags_write()
Date: Mon, 27 Jul 2026 12:57:14 +0300
Message-ID: <20260727095714.347039-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use 'kstrtou16_from_user()' to simplify 'airtime_flags_write()'.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 net/mac80211/debugfs.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index a4d5461f6480..081dd6e8037e 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -171,23 +171,10 @@ static ssize_t airtime_flags_write(struct file *file,
 				   size_t count, loff_t *ppos)
 {
 	struct ieee80211_local *local = file->private_data;
-	char buf[16];
-
-	if (count >= sizeof(buf))
-		return -EINVAL;
-
-	if (copy_from_user(buf, user_buf, count))
-		return -EFAULT;
-
-	if (count && buf[count - 1] == '\n')
-		buf[count - 1] = '\0';
-	else
-		buf[count] = '\0';
-
-	if (kstrtou16(buf, 0, &local->airtime_flags))
-		return -EINVAL;
+	int ret;
 
-	return count;
+	ret = kstrtou16_from_user(user_buf, count, 0, &local->airtime_flags);
+	return ret ? : count;
 }
 
 static const struct debugfs_short_fops airtime_flags_ops = {
-- 
2.55.0

