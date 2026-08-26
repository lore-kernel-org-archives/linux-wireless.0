Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4891EFF93;
	Wed, 26 Aug 2026 03:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787714426; cv=none; b=HKfLDCsjtUuCLl4IMZE+Rve4xeGMrZpqHO//+/wXZvqFxgzlUFvVFafTXEBEyhm6jF3cMtomqWgq/gatZOeAnqsh1G7Zp6hDxKUepDgopYMFYV+0CBv4QGfQyZ/pwFWLXbNmjAgH/cY7h2aRMmfzi+zLaW2/YFmzaj1pIksBuk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787714426; c=relaxed/simple;
	bh=d5S70Z0JNv9i60NTjjnY83FsMQQjgE0uXfP3ZeagOnI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Rl2JKa1KIR2jbM1L7iyVD16U50LOMfNtxjw+qQKTeVKpLEynT8Bw2A8z1fC5ua2zKsa5lU2ViM6WDLDYTss96LQvy0S6ZcmB2GBPOvfMafJ79udIZl2F7TyexbK2jO7Oaq1MUCM/E+EDcdLfcvM1SoSg34H29sToYZQKw6LkP/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=lDUZxiEp; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="lDUZxiEp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=RH
	tqps1vBVwjWmOc8WkcJYJjjIQ7Y/9gK1GokKDwyBg=; b=lDUZxiEpijUChC7Exh
	+mbBlQ3HIUXU/pAtWaPPoeR2Wr9Ex6RlEQDXPeHwLXI8UTi57XNO/OXehYjdVhvw
	Aj9bZtsI3Q6jk4fpeGz3XzaqVNSRo3uFDneofnFyvS9BDD+3mv9hIl9sx0ITSH6v
	mkrd7n00BRRxqHrGFRQ83Pgxo=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wBHsfloW45q1ABmRg--.49706S2;
	Wed, 26 Aug 2026 11:20:09 +0800 (CST)
From: Gongwei Li <13875017792@163.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Gongwei Li <ligongwei@kylinos.cn>
Subject: [PATCH] wifi: rtw89: coex: Fix wrong constant check of GPIO MUX signal
Date: Wed, 26 Aug 2026 11:19:59 +0800
Message-Id: <20260826031959.2555359-1-13875017792@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBHsfloW45q1ABmRg--.49706S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Zr1UAFW8Kr4fKw4UZFWkJFb_yoW8Gr48pr
	45Ga4FkasxJF9Ivw48Xa1fuF1UX3Wrtr4xK395K34rurW8Xwn3JF15Wa43XryjqFW0gFW3
	ZrWIqwsrG398A3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U_uciUUUUU=
X-CM-SenderInfo: rprtmlyvqrllizs6il2tof0z/xtbC-gkv6WqOW2m+FAAA3N

From: Gongwei Li <ligongwei@kylinos.cn>

In _fw_set_gpio(), the check for an invalid GPIO signal uses `sig == 0xff`.
However, _get_gpiosig_for_ver() never returns 0xff. Both of its failure
branches return BTC_DBG_NUM (defined as 32) when the requested signal is
unsupported for the current firmware version.

Check the result against BTC_DBG_NUM instead, the same as _show_gpio_dbg()
already does.

Fixes: 5c90259b9748 ("wifi: rtw89: coex: complete GPIO debug configuration handler")
Signed-off-by: Gongwei Li <ligongwei@kylinos.cn>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 5a9dc4d8a00b..12bd5539e8c6 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -3365,7 +3365,7 @@ static void _fw_set_gpio(struct rtw89_dev *rtwdev, u8 type, u32 val)
 		gpio->mux.data.dlen = CXDGPIO_SET_L2;
 		gpio->mux.data.sig = _get_gpiosig_for_ver(rtwdev,
 							  FIELD_GET(GENMASK(7, 0), val));
-		if (gpio->mux.data.sig == 0xff)
+		if (gpio->mux.data.sig >= BTC_DBG_NUM)
 			return;
 		gpio->mux.data.gpio = FIELD_GET(GENMASK(15, 8), val);
 		l2_h2c = gpio->mux.fmt;
-- 
2.25.1

