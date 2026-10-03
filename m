Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F5D3B0AD6;
	Sat,  3 Oct 2026 09:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791021581; cv=none; b=cBgMt+i+IYbiRK3KgMAhvdvyctdR+hKwvEqEN+LJHX0GJQmy2HhvJ6YtEXfj2nvPBF9CnY//hfbDoA1e9fngf4uXRlloC0e6E3Z6lZse2lCTOUUa28MC8g2PIaFfUV/6qJdaIeY5+C6jfAYLBXLWOTzp8da0msxyae9HLYne6OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791021581; c=relaxed/simple;
	bh=xoqqc/e6RBc1ZqduwnWzbNUHv3mjvmDbFqpOTKYYhjQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=csZ7LdqAjcI2AmLc2EXxSVpwP6U2meCfHes8JLMSPC/N6y9d267QheOP056BBf4nuXtyfIQfT6h38r1Gj50zO+VETOtYkUG0khXc1exqI3aUPcz4zt/sOKTd28vnFYvSgxnwiuqQz8S8xKcDoBX9cr2uELD+3aYOXgo1KqOsyOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=SCyKpqTS; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="SCyKpqTS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=hM
	+05E1a1mh/WwKjkgJQR1/fatfBwyc/hZAhxEXV5ac=; b=SCyKpqTS4lzBXhg49u
	dsjRTbSCKLzcNtC1nBNh1krBsMb1mQUPvIqwDJfiLjKiCgylJc69lRrfqSe5X9yR
	tqivRJcqh3xiam/3Cw7AhvZ48lx/roZO9Jj/N8dOW/JmOLQlqtUxsZPq3SIlJURU
	D/lqRwAUNM3JEmNyyHkMxWndI=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wDHl2Dy0cBq4TNFCA--.53805S2;
	Sat, 03 Oct 2026 17:59:15 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Jeff Johnson <jjohnson@kernel.org>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Dan Carpenter <error27@gmail.com>,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Subject: [PATCH] wifi: ath12k: Reserve space for a string terminator
Date: Sat,  3 Oct 2026 17:59:13 +0800
Message-Id: <20261003095913.575108-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDHl2Dy0cBq4TNFCA--.53805S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7XrWDWFy5GF1kWry5tF4kCrg_yoW8Jr4kp3
	ykWw129Fy8ur17G3s5GFn3Za4FganxWry2gFWqv34ruFs5Zr1Fqr1YgFW8Wry8Ca98uF1j
	9a1jkr1xZr95t3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pitEf5UUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzhN7tWrA0fMG-gAA3j

ath12k_write_htt_stats_type() accepts count == size, which fills the
zero-initialized buffer without a terminating NUL. sscanf() then reads
beyond the buffer.

Reject input that leaves no room for the trailing NUL.

Fixes: 8c7a5031a6b0 ("wifi: ath12k: Fix buffer overflow in debugfs")
Reviewed-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c b/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c
index b772181a496e..f84f1828275a 100644
--- a/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c
+++ b/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c
@@ -6190,7 +6190,7 @@ static ssize_t ath12k_write_htt_stats_type(struct file *file,
 	const int size = 32;
 	int num_args;
 
-	if (count > size)
+	if (count >= size)
 		return -EINVAL;
 
 	char *buf __free(kfree) = kzalloc(size, GFP_KERNEL);
-- 
2.34.1

