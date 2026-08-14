Received: from forward200b.mail.yandex.net (unknown [178.154.239.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68FB720D4E9
	for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 05:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786686633; cv=none; b=ZYtjekp1MttC0eUEUJ7DQ88m45itAZpObNjXPVYXX04VjmKrgNCf9Q8v40nE/9V6ENN4pfDLAQUdbBLslOqDy/T06kRJE2GQWA9vOdZiOJOsESVB+eeJw+Pauepr1fUod3Wh90TaBiDCx7rVOq0rY+xr+K5cg4j+0/S1frXllXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786686633; c=relaxed/simple;
	bh=3pb25erNsAMZm5Dnnan/WuwHxJ4oJctMwpxWDzccXN0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dl2WnYFzloa9YArqTAtN6waYJngj9nesWlVV6xBzFFaz+KRwcgzyc24wNA3Wel43fi8BkcJlMLIDk4zuHowZ9xBEP2qyd37I5zDBmOkt1EVCvD7SoAhRECxkKaD2MxwUEWD4fE1j/wa1VYaQ9QE2tbt6LKy9eQr5e0hF66fr+lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=UUlkUSyw; arc=none smtp.client-ip=178.154.239.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="UUlkUSyw"
Received: from forward102b.mail.yandex.net (forward102b.mail.yandex.net [IPv6:2a02:6b8:c02:900:1:45:d181:d102])
	by forward200b.mail.yandex.net (postfix) with ESMTPS id EE4FD830D6
	for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 08:44:43 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-57.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-57.sas.yp-c.yandex.net [IPv6:2a02:6b8:c23:313e:0:640:a643:0])
	by forward102b.mail.yandex.net (postfix) with ESMTPS id B4C70C012E;
	Fri, 14 Aug 2026 08:44:35 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-57.sas.yp-c.yandex.net (smtp) with ESMTPSA id YiJPNvafAuQ0-25pXqyHy;
	Fri, 14 Aug 2026 08:44:35 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1786686275; bh=/GbLHi/tz0JPqqfKUjq9ND3+VZVdSsFrUOqI7xDNwNU=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=UUlkUSywvcs2Yimxm87ca8MA2wCx14OqQ9W7kHfm4u3uM9lgLFehAL4fwtG9rhe81
	 dAUls2sz+T8W6YkcbMcCfKpyunM9yR/iSQXMGj+jmq2RGZdi4vILuVeeQixTW3ciKi
	 jonwIU8BEfFy1AaFhnOPVSfsnCaXUyKJ8AFk51Vw=
Authentication-Results: mail-nwsmtp-smtp-production-main-57.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>
Cc: linux-wireless@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] wifi: mt76: mt7915: simplify mt7915_sys_recovery_set()
Date: Fri, 14 Aug 2026 08:43:35 +0300
Message-ID: <20260814054335.1237804-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Simplify 'mt7915_sys_recovery_set()' by using
the convenient 'kstrtou16_from_user()'.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 .../wireless/mediatek/mt76/mt7915/debugfs.c   | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
index 4d0854fe785b..4e9dd9f65e2f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
@@ -52,23 +52,12 @@ mt7915_sys_recovery_set(struct file *file, const char __user *user_buf,
 	struct mt7915_phy *phy = file->private_data;
 	struct mt7915_dev *dev = phy->dev;
 	bool band = phy->mt76->band_idx;
-	char buf[16];
-	int ret = 0;
+	int ret;
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

