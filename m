Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC9042467C;
	Sat, 26 Sep 2026 12:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790424815; cv=none; b=Fk7+Q30VtmYkMyn+GbUORQz+hXigac5riu/8RG6YWh5LrjzRIuL75tPo612ZPic4ZoWLvgp5QzTY70IabTetqDFyTyRr+yFmvoQhIbR58kRgcxhIicQazb3RehT9WGhK3Ffl2cbos8Syr/CZ3mtJOg5pKiZJ2fmruaW0m1WLfvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790424815; c=relaxed/simple;
	bh=3MvbyZSpaZRlMfFdaNz5WbZVISM8btpYzjd7U+W/xmY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TjbUSzOLxgAO2rCqqi+A8gysb+hZBxHyWjHQBGlf368GAI4R7pxQiICYHoQ2W8pxJsbRSLJf7W/SECaAXyD3oq//Fq9ZR4KJMf2VCCKpLdIbe0xyt2WaFasbCro5QJ6BJkavfdZyQtuxeUIKEkxrca/W2cgpKy15bp1DTOkh19Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=mWshQn5a; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="mWshQn5a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=5O
	5WX6Ju+BA8sTDcfWfc/DMBswAguDXrunWPXvGBFRY=; b=mWshQn5aDYXgv8GStu
	jCnazaaT+qbi8BMT0omrLuNZnKElrHKRzdVmzR8jrAvqYCiSAmFf7dwrNTX6pDgB
	F6MJDpIeqq7F2gM9etlEW7dUROqzVscerpDgiwmzD7bZR4VxjKdv89E6i6fnT45j
	OnJj2DS7hXdQranKalU4+x3Lg=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wD338nKtrdqfXOcAw--.9011S4;
	Sat, 26 Sep 2026 20:13:02 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Jeff Johnson <jjohnson@kernel.org>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Dan Carpenter <error27@gmail.com>,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 2/3] wifi: ath12k: Reserve space for a string terminator
Date: Sat, 26 Sep 2026 20:12:49 +0800
Message-Id: <20260926121250.3258285-3-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260926121250.3258285-1-yaojiale02@163.com>
References: <20260926121250.3258285-1-yaojiale02@163.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD338nKtrdqfXOcAw--.9011S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7XrWDWFy5GF1kWry5tF4kCrg_yoWDCrbEqw
	4rtFn7Zr4fGF4jq3yxAayavrWvkas8XF1kWrnaqrWfC3y3JrZ8Ar95ur18XrWI9ry5JrnY
	kr9rJF15X3yq9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRKDGYDUUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC7w9po2q3ts8f1gAA3H

ath12k_write_htt_stats_type() accepts count == size, which fills the
zero-initialized buffer without a terminating NUL. sscanf() then reads
beyond the buffer.

Reject input that leaves no room for the trailing NUL.

Fixes: 8c7a5031a6b0 ("wifi: ath12k: Fix buffer overflow in debugfs")
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

