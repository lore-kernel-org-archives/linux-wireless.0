Received: from hqu.edu.cn (hqu.edu.cn [210.34.240.11])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 869151E98E3;
	Wed,  2 Sep 2026 03:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.34.240.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788318857; cv=none; b=giYh1aq/EmxUlJrs5aDJs2ofukGf8OzBoD6KcMRkp7Fj12BiRZfLm5y2r0l0aqyxF2QznnvciamRrGD4Tm0J45xD+EGJGyfYXh3aT+ndB8MneezDtbAmPm6E4WOmdbzzjqS/FcBKhE+ekrSsa+IFKfLxbIsJxPGwqbH12Qiwm/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788318857; c=relaxed/simple;
	bh=jFHv3W2G7YXo76CgZ/Be7FLQW6T2KPEoP89YguzR63U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a00IRnxh4wd3A3S6m8g0DIyFgg7sfPPtcrUAmHeKQk1unKRtbjuFtJBYXZpiamhBqqi2NhpJV8G63hYBYCePRpIvqVrvr2VmhL6SeAx8pW9h0hCPJqxCEPzHNSVC2m2hjtjCRR9ijmcpOvi04dHYChfwql0Cbi/nSnmF8qULBUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stu.hqu.edu.cn; spf=pass smtp.mailfrom=stu.hqu.edu.cn; arc=none smtp.client-ip=210.34.240.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stu.hqu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stu.hqu.edu.cn
Received: from raspberry-nas (unknown [27.42.228.181])
	by cmweb (Coremail) with SMTP id C_Ai0gAXe9qClJdq6ygFAA--.10449S2;
	Wed, 02 Sep 2026 11:14:11 +0800 (CST)
From: YuChia-Kan <raspberrykan@stu.hqu.edu.cn>
To: linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com,
	linux-kernel@vger.kernel.org,
	YuChia-Kan <raspberrykan@stu.hqu.edu.cn>
Subject: [PATCH v3] wifi: rtw88: use firmware MAC address as fallback
Date: Wed,  2 Sep 2026 11:14:08 +0800
Message-ID: <20260902031408.4155609-1-raspberrykan@stu.hqu.edu.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260902024622.4149279-1-raspberrykan@stu.hqu.edu.cn>
References: <20260902024622.4149279-1-raspberrykan@stu.hqu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:C_Ai0gAXe9qClJdq6ygFAA--.10449S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr18tw4fur1kJF47tr1fJFb_yoW8XF1xpa
	y8JaySkFnrJr45ua1fWa1S9F1rGan3JayUAr9Yy3s09rn8XryFvrWDKF9Fvr1jgFWDZF42
	yr15tr9rKFZ0vF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUym14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
	wI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUywZ7UUUUU=
X-CM-SenderInfo: ysvskiyqsqlko6vw3hxktxhvlgxou0/1tbiAQAQBGqVmGMDTgAJsV

Some devices provide the Wi-Fi MAC address through firmware instead of
storing a valid address in the Wi-Fi chip efuse.

This is the case on the Xiaomi Mi Box 4, which uses an Amlogic S905L
SoC and an RTL8723DS Wi-Fi chip. The Wi-Fi MAC address is stored in the
S905L efuse rather than the RTL8723DS efuse and is provided to the
device through firmware.

Try to read the MAC address from firmware before falling back to a
randomly generated address.

Signed-off-by: YuChia-Kan <raspberrykan@stu.hqu.edu.cn>
---
Changes in v3:
- Add Xiaomi Mi Box 4, Amlogic S905L and RTL8723DS hardware details
  to the commit message.

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

