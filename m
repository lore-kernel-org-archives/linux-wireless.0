Received: from hqu.edu.cn (hqu.edu.cn [210.34.240.11])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EB6B4CCDEF;
	Wed,  2 Sep 2026 02:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.34.240.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788317198; cv=none; b=Yo4HDZTL/N5KyBjQ2JGaQuaEN6VK2iJjk5EC9BNZ2JrK5eGxXKisU6LwT5x3FjhBrSijdl3dSkqo6vt4LswLYuwe+fqC3Ia1tX3DQinzXydmFPnQ2sTU22eYdzbtpGYGIXg2ti65MlGyPafaB1fX11JSTbliXlhtqIahj+FnIiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788317198; c=relaxed/simple;
	bh=vf3rGOCPnf8EqbL3gDKUJV6Z+XhAKY4Q5qICBD9eRc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDAFAdwSlTcmYdaEh2TH8Z4dE19cytvLVlHPMO1w0aA5Q900n/J3fZh1ZvVts4pkaWY1c77mO0eTwuTY/3NibHXy4jv25N6WLYW73+QWhXJp+s2Qj4/wS1xs/2sBDVZoXwJff+YaCSIo2t6HMpP8/rmFT7aW03fidYJMACgfIis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stu.hqu.edu.cn; spf=pass smtp.mailfrom=stu.hqu.edu.cn; arc=none smtp.client-ip=210.34.240.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stu.hqu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stu.hqu.edu.cn
Received: from raspberry-nas (unknown [27.42.228.181])
	by cmweb (Coremail) with SMTP id C_Ai0gCH6tkBjpdqiSAFAA--.10504S2;
	Wed, 02 Sep 2026 10:46:25 +0800 (CST)
From: YuChia-Kan <raspberrykan@stu.hqu.edu.cn>
To: linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com,
	linux-kernel@vger.kernel.org,
	YuChia-Kan <raspberrykan@stu.hqu.edu.cn>
Subject: [PATCH v2] wifi: rtw88: use firmware MAC address as fallback
Date: Wed,  2 Sep 2026 10:46:22 +0800
Message-ID: <20260902024622.4149279-1-raspberrykan@stu.hqu.edu.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260901124551.3921506-1-raspberrykan@stu.hqu.edu.cn>
References: <20260901124551.3921506-1-raspberrykan@stu.hqu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:C_Ai0gCH6tkBjpdqiSAFAA--.10504S2
X-Coremail-Antispam: 1UD129KBjvJXoWruw1DZrW8ZFW8tF4fGFyfWFg_yoW8JF1Dpa
	yDGa1a9FnxJrsrua1fWa1ruF1rGan3J34jyr9Yy3s09rn8XryfZFyUGF9FvF1jqFW0yF4U
	tr15trZrGF9YvrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyv14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r1j
	6r4UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4j6r
	4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4
	vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IY
	x2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26c
	xKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAF
	wI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbrMaUUUUUU==
X-CM-SenderInfo: ysvskiyqsqlko6vw3hxktxhvlgxou0/1tbiAQAQBGqVmGMDTgAGsa

Some devices provide the Wi-Fi MAC address through firmware instead of
storing a valid address in the chip efuse.

Try to read the MAC address from firmware before falling back to a
randomly generated address.

Signed-off-by: YuChia-Kan <raspberrykan@stu.hqu.edu.cn>
---
Changes in v2:
- Fix the undeclared mac_ret issue by checking
  device_get_mac_address() directly.

 drivers/net/wireless/realtek/rtw88/main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index cd9254370fcc..0f23498b5c96 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -2060,8 +2060,11 @@ static int rtw_chip_efuse_info_setup(struct rtw_dev *rtwdev)
 	efuse->ext_lna_5g = efuse->lna_type_5g & BIT(3) ? 1 : 0;
 
 	if (!is_valid_ether_addr(efuse->addr)) {
-		eth_random_addr(efuse->addr);
-		dev_warn(rtwdev->dev, "efuse MAC invalid, using random\n");
+		if (device_get_mac_address(rtwdev->dev, efuse->addr)) {
+			eth_random_addr(efuse->addr);
+			dev_warn(rtwdev->dev,
+				 "failed to get valid MAC address, using random\n");
+		}
 	}
 
 out_disable:
-- 
2.53.0

