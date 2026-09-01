Received: from hqu.edu.cn (hqu.edu.cn [210.34.240.11])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A15493A6B8D;
	Tue,  1 Sep 2026 12:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.34.240.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788266843; cv=none; b=Yt66ekYl+bAp8DO8Yr7dqWEFF85I2Ea+3zxd6FubVH7OeUFoVKMMRHxZL7iOdxc7f/7oGeDndQm2B+SL/wREl631JfCkjw+jQv+7TmU0H+fafJ8yGKyi1fCi+6KnTokOL0TYKqUQbrgHYSX1gwdjz5rtqYUou8NLDcr+x6SxzkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788266843; c=relaxed/simple;
	bh=pLnwTvDRjVvusLgNDGg0U0/KU2wvU+6ZSTzyly2JB5o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pkO0NLbKiEcGlo4UVNY36aMO24eHBz9VJR7fmIVLQW1QTnNT8HnCYWdMffjsfLzQfqm5Haj90KCWHqR7JkDD3kctkgDecqBYZLvBqeTk3V9xE/HSePLOGjxDvmYdImxJ7Jz4P1k5kk6syNvwBrJwxzmVjzGXehZmY8iLIPxp/as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stu.hqu.edu.cn; spf=pass smtp.mailfrom=stu.hqu.edu.cn; arc=none smtp.client-ip=210.34.240.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stu.hqu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stu.hqu.edu.cn
Received: from raspberry-nas (unknown [58.253.174.36])
	by cmweb (Coremail) with SMTP id C_Ai0gAXetkByZZqhVcEAA--.8887S2;
	Tue, 01 Sep 2026 20:45:54 +0800 (CST)
From: YuChia-Kan <raspberrykan@stu.hqu.edu.cn>
To: linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com,
	linux-kernel@vger.kernel.org,
	YuChia-Kan <raspberrykan@stu.hqu.edu.cn>
Subject: [PATCH] wifi: rtw88: use firmware MAC address as fallback
Date: Tue,  1 Sep 2026 20:45:51 +0800
Message-ID: <20260901124551.3921506-1-raspberrykan@stu.hqu.edu.cn>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:C_Ai0gAXetkByZZqhVcEAA--.8887S2
X-Coremail-Antispam: 1UD129KBjvdXoWruw13tFW3GryDJF17tFW8Zwb_yoWktrgE9F
	1jkF93AFyUGw1SkrWYkFZ3ArWFkayjvrn7W39Fq393J3y5XFZxZr1rZ3ZxJrn5ZrsrCr1D
	JryDX3W8Z398AjkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbsAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr
	0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r126r1DMxkIecxEwVAFwVW5JwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJV
	W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
	1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
	IIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvE
	x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnU
	UI43ZEXa7VUjjNt3UUUUU==
X-CM-SenderInfo: ysvskiyqsqlko6vw3hxktxhvlgxou0/1tbiAQAEBGqGKVQBbAAEs5

Some devices provide the Wi-Fi MAC address through firmware instead of
storing a valid address in the chip efuse.

Try to read the MAC address from firmware before falling back to a
randomly generated address.

Signed-off-by: YuChia-Kan <raspberrykan@stu.hqu.edu.cn>
---
 drivers/net/wireless/realtek/rtw88/main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index cd9254370fcc..b9d8e0f5d15e 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -2060,8 +2060,12 @@ static int rtw_chip_efuse_info_setup(struct rtw_dev *rtwdev)
 	efuse->ext_lna_5g = efuse->lna_type_5g & BIT(3) ? 1 : 0;
 
 	if (!is_valid_ether_addr(efuse->addr)) {
-		eth_random_addr(efuse->addr);
-		dev_warn(rtwdev->dev, "efuse MAC invalid, using random\n");
+		mac_ret = device_get_mac_address(rtwdev->dev, efuse->addr);
+		if (mac_ret) {
+			eth_random_addr(efuse->addr);
+			dev_warn(rtwdev->dev,
+				 "failed to get valid MAC address, using random\n");
+		}
 	}
 
 out_disable:
-- 
2.53.0

