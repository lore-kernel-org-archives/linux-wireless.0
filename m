Received: from forward100a.mail.yandex.net (forward100a.mail.yandex.net [178.154.239.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712BD2F7F17
	for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 05:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786685648; cv=none; b=tUKccnsX4Ya+O1XUiy07st+rW0wNXzF/fTDUlT/+Kh3N2WZdqUY9M7jOyQNmIFfrR+32+3hm972mGg5j7ALw71FC4YE1lyED8qM34h4qe1Bny+NIoygiTEXLSiA6Vu5KIpF6WBFA+uJ/5sA+1JywN5iqtd3SP5ftkLpbbCgJvjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786685648; c=relaxed/simple;
	bh=JnIE7Xfv66lR32/FEPWUlzk5KVOL3IG3cV/0XrrPo9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LzEms4t/Mjuf9Vz+/+NCCwwws9wGyZUYMoagQ0FqI7siU/lucwcPAJ6rvLjmlfJG0Bhm13UtqeW/Zt0gPvM07n8C84TwHlpTddUkVqINZky+l+wY/ztKeGRV/cqcEkCaIsvzX6WOcdE9Rn65TfAV+f3RZyvEq5mQPCJfuoDkJm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=Ru0UkxDO; arc=none smtp.client-ip=178.154.239.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="Ru0UkxDO"
Received: from mail-nwsmtp-smtp-production-main-59.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-59.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:41e:0:640:522e:0])
	by forward100a.mail.yandex.net (postfix) with ESMTPS id 9BAB7C04A9;
	Fri, 14 Aug 2026 08:33:55 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-59.iva.yp-c.yandex.net (smtp) with ESMTPSA id sXJo1TUf8Gk0-DMubZbd1;
	Fri, 14 Aug 2026 08:33:55 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1786685635; bh=z2k8J0MNOnHitffoJUArmm5MO8+GdmR0ru2CfqH2ZH8=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=Ru0UkxDOkaKmZWMv0SSHT5zp6xRz7YWMNbiMqX8qFrJPuLj+zPPfjwXCisc7W7IKY
	 0s+CXSbb/eKVDhJigxLXNgHA8Vw18Itiah48OvIq2sluuOrlicA2orkPmZMJtvNDYu
	 rJktPhuSRMbE9jlL7CvoEGd/2+CmeO7+EkpwQtpg=
Authentication-Results: mail-nwsmtp-smtp-production-main-59.iva.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: linux-wireless@vger.kernel.org
Cc: Tristan Madani <tristan@talencesecurity.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] wifi: ath6kl: simplify ath6kl_bgscan_int_write() and ath6kl_listen_int_write()
Date: Fri, 14 Aug 2026 08:32:54 +0300
Message-ID: <20260814053254.1231954-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Simplify 'ath6kl_bgscan_int_write()' and 'ath6kl_listen_int_write()'
by using the convenient 'kstrtou16_from_user()'.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 drivers/net/wireless/ath/ath6kl/debug.c | 26 ++++++++-----------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 84403aab21c0..e002848090d5 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -1622,20 +1622,15 @@ static ssize_t ath6kl_bgscan_int_write(struct file *file,
 	struct ath6kl *ar = file->private_data;
 	struct ath6kl_vif *vif;
 	u16 bgscan_int;
-	char buf[32];
-	ssize_t len;
+	int ret;
 
 	vif = ath6kl_vif_first(ar);
 	if (!vif)
 		return -EIO;
 
-	len = min(count, sizeof(buf) - 1);
-	if (copy_from_user(buf, user_buf, len))
-		return -EFAULT;
-
-	buf[len] = '\0';
-	if (kstrtou16(buf, 0, &bgscan_int))
-		return -EINVAL;
+	ret = kstrtou16_from_user(user_buf, count, 0, &bgscan_int);
+	if (ret)
+		return ret;
 
 	if (bgscan_int == 0)
 		bgscan_int = 0xffff;
@@ -1662,20 +1657,15 @@ static ssize_t ath6kl_listen_int_write(struct file *file,
 	struct ath6kl *ar = file->private_data;
 	struct ath6kl_vif *vif;
 	u16 listen_interval;
-	char buf[32];
-	ssize_t len;
+	int ret;
 
 	vif = ath6kl_vif_first(ar);
 	if (!vif)
 		return -EIO;
 
-	len = min(count, sizeof(buf) - 1);
-	if (copy_from_user(buf, user_buf, len))
-		return -EFAULT;
-
-	buf[len] = '\0';
-	if (kstrtou16(buf, 0, &listen_interval))
-		return -EINVAL;
+	ret = kstrtou16_from_user(user_buf, count, 0, &listen_interval);
+	if (ret)
+		return ret;
 
 	if ((listen_interval < 15) || (listen_interval > 3000))
 		return -EINVAL;
-- 
2.55.0

