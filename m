Received: from forward206d.mail.yandex.net (forward206d.mail.yandex.net [178.154.239.215])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15824734C2
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 18:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.215
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784830286; cv=none; b=Vkp9b3mBFdPz64zjfg8qIxU2Zq8kZe8oQJnMxZ6OLCFVhyUoAVWG6MvQLkmDL4bWB7BLo0t90r5GdMFl01xPIlCDeU9DzfqWoXtMlEKF2fF3ywixzYC5f7fcLDN6pxTpjwvVAfn+11TRKXrjmfe1DeCFvKFeBZL5VCgmDnORU44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784830286; c=relaxed/simple;
	bh=nN2rmeDqtuJLBAwFomzmrJGf4f2S6Xj/kYwRXrhX5N4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k+GX90SflR02DLjo+znugmC/u5gldE52By5BW2ivGpWUBMqNXC89QaeSx5lNHEo8LtKvgMcqoWePAdaGj0SV9H4dCYz/vpxaeXEF3Ao8CxaTW7KBsaA1mx2MQl39TPEDJYOxfK/IQMS5mG65YOpVCoYs4P3iMCDIWJR9xJ51Azc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=pCQOtPbC; arc=none smtp.client-ip=178.154.239.215
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="pCQOtPbC"
Received: from forward100d.mail.yandex.net (forward100d.mail.yandex.net [IPv6:2a02:6b8:c41:1300:1:45:d181:d100])
	by forward206d.mail.yandex.net (postfix) with ESMTPS id E9513813A2
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 21:05:03 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-77.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-77.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:2007:0:640:5fb2:0])
	by forward100d.mail.yandex.net (postfix) with ESMTPS id 726A8C0065;
	Thu, 23 Jul 2026 21:04:56 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-77.iva.yp-c.yandex.net (smtp) with ESMTPSA id s4dcgYDfHqM0-UpKgTCD0;
	Thu, 23 Jul 2026 21:04:55 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1784829895; bh=2KdwqloDW2pTVUmGqHmXmt34ydml6Ogyj9Ke41PfZmk=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=pCQOtPbCNTCMuGGHsnhum4UYE0Iw5OaQIsXY8ToXudMNiF3h8o0RbXYbWCGM4aeBf
	 kDJyyZmDeKaDBhSr6jLDTdRqXZYFT4G77UbKuQrj2h6RVESR2U2ZQuutQ/uEdruG8D
	 OKvdr7qAld+6OzfYPZto1qYeV+73ESPV1p8J8LB4=
Authentication-Results: mail-nwsmtp-smtp-production-main-77.iva.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>
Cc: linux-wireless@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] mt76: mt7915: simplify mt7915_sys_recovery_set()
Date: Thu, 23 Jul 2026 21:04:30 +0300
Message-ID: <20260723180430.747789-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use convenient ' kstrtou16_from_user()'
to simplify 'mt7915_sys_recovery_set()'.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
index 4d0854fe785b..0413b4fd2d9c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
@@ -52,23 +52,12 @@ mt7915_sys_recovery_set(struct file *file, const char __user *user_buf,
 	struct mt7915_phy *phy = file->private_data;
 	struct mt7915_dev *dev = phy->dev;
 	bool band = phy->mt76->band_idx;
-	char buf[16];
 	int ret = 0;
 	u16 val;
 
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
-	if (kstrtou16(buf, 0, &val))
-		return -EINVAL;
+	ret = kstrtou16_from_user(user_buf, count, 0, &val);
+	if (ret)
+		return ret;
 
 	switch (val) {
 	/*
-- 
2.55.0

