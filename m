Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854E54D954F
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 17:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789580088; cv=none; b=CLog2Szw2w5MaD/He7RxKX2oUGeUBxLB6kQ4eUkgPCsWrR0TI5vvajWDnCtR9L/5dP1qLEVU9F5yrAqwB+kGgOdTUO39tjUEEhMf7j6M//v2wOVXeW8jFvyoJUZa3dW+UPN4UhkKnYEeDbYOtD/QvkRGA90SSOZOwyW/oVxIKDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789580088; c=relaxed/simple;
	bh=O4fQFptbwIWGrP3i51so22Moy8UsJAxa2WB25LmlnH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F0bwebl5txIQ39WhqMgdTJpb+v0g9X5CHshuoWhPs0twWnCIKQZAIny1CDER64STRNEQN6jmICayjDwPiJPtr+BsOzcPzYeBxDJymopsgyU2zrco7cd6uvzDzf0jajn/kX4mGUKdqEena15X2axHg7YybbM2R+jBq4Qn8lzBvCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WjakcTaJ; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WjakcTaJ"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49ccfd61ecaso11066735e9.3
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 10:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789580076; x=1790184876; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=b//GgrHPthUrwrYixVrlFYT/x+uXt+xKgBiSW3+vKf4=;
        b=WjakcTaJvDEo/tboaKFdS/cl9UWHlASfpBtfKZ2v/EmgDeCmOpisQSX48nh5ssgl/3
         Sboh6dMEBy3CHONGqvXLqL3PW14/XuWDlc2KAXStseUXqrGTH69hESqvLU/fmJpZgQcl
         0fH6GCGFr5pm/BNqEIuSykBmX/e7eQIwLXwpa5w2Wxp6tBRFOjKUBiSPggl3GNvLHfTm
         77MiTYzQcJktCzMEL7dEDm21FrRIFTAbUmuo5r6xQ9h8OeBHhBtHFFVhnQZb5Sckkm4Q
         5TIxsHur4ORMPxrzbfD8qHwkRYmuU4sqVsDE3eoRaDumeaArLtSCTub1d520DV+Z3WJb
         1eVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789580076; x=1790184876;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b//GgrHPthUrwrYixVrlFYT/x+uXt+xKgBiSW3+vKf4=;
        b=L/4lBQ+/MMP+Tn1GWS1DBsSsKzx0Yhw8xrpH7eX3QN1yuc9iOGV2RWHSThhvP9RzP9
         UIdmlaFHbvn2cS2Im0I9fg6ITq4OM8+stp0NrgdZRHacvmzcQmUMvggLaWt+GLdUhjxH
         P+O/m+s4LdPw5qFD0vc7jcZrAWXisjIwDVXTVmnTqZ8cZhOgSTE9/HyNKJI7ocGBN0FQ
         zKavhTLFM5cj01x7Yte97DBfcZkqAAUyvCSHWPmokbE9zABkl1Z4mt6O7KgKROEAjB3o
         SGjpogr4uir1iNdIzFB8W+9o7VXs44jtRPR7dVamD2UWEmrhHN1le1lFGzlW0uKfyD3Z
         UEoA==
X-Gm-Message-State: AFuF++nWbYfCgysPbaXPDhMxSqhLVrL89adNbziMfR8rzPXu9WHuPnqm
	qXWMRr1BG6AKtZfUMDg4+AH+18Bs2HYfmxNMn2P8Pa7itgoE578QQlk=
X-Gm-Gg: AYBFou3vWSM/5GJYwOLa4hOeperkibiLpk35b9U8k3ZJGGwgdsi9sSsz/HFgi7ziFhH
	zl1p2g/9kJeTottiZUPx+Srm9In/ouToAmztXC2EGlWPZr9IrXUNrYB7mDl4DlYUOiHKQVWmZGP
	HPAcASxVkg3mfLww9XMaPZlRI4CPKa/SYQy/B47ulnFCZJZrkP3k7/A8K+fpToVxclhQRrr6rf3
	IVAVeseyNCU7PkhMYdmuBKTmbaT03hnO6lo7exH3fkrOj3PacZ4ufr6zohEx4cxX0F4x9c0XSdO
	fB1pL5xHc2RqPRJkhxa4jCwO8c/kyZFD043ecCjjs9rIdASrBYlsp+zGPmKzjGVIMYnZfftN3eL
	oM7m607kTXGo98OgB4UINmZJKPSkpSBcmwXwCqmLH+EvoVKk7+UdVD/mBPKkvJhQBKgmOZaZN6N
	EWKoFGIs5RtnnxInHZ1sp6WkuH3wxd1XajDVGh3vPPQPCuaD9VKrscC4spEIjuQdBvAF4d+ktJH
	IIHAOOO1BuHQBBXdGJRSJBNzvWKDSXX2Hqg5lbGY6TSYknk2AWc9okmBfs2u9algP/caAXUXIqp
	qQtI1q/4e3g3HwQ=
X-Received: by 2002:a05:600c:1909:b0:49e:715e:ec1f with SMTP id 5b1f17b1804b1-49eb7339c99mr38436865e9.30.1789580076159;
        Wed, 16 Sep 2026 10:34:36 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:f23c:f0c3:c09d:d6d6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bf27ce2sm8987544f8f.20.2026.09.16.10.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 10:34:35 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"John W . Linville" <linville@tuxdriver.com>,
	Simon Wunderlich <sw@simonwunderlich.de>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Kalle Valo <kvalo@kernel.org>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	stable@vger.kernel.org
Subject: [PATCH ath-next v4 2/8] wifi: ath9k_htc: fix the byte count of a full RMW buffer flush
Date: Wed, 16 Sep 2026 20:34:23 +0300
Message-ID: <20260916173429.403889-3-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916173429.403889-1-nerijus.bendziunas@gmail.com>
References: <20260916173429.403889-1-nerijus.bendziunas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

ath9k_reg_rmw_buffer() sizes a full-buffer flush with
sizeof(struct register_write), 8 bytes, instead of
sizeof(struct register_rmw), 12 bytes. ar9271_hw_pa_cal() queues
exactly 15 read-modify-writes, so the AR9271 PA calibration has been
losing its last five writes since the buffer was added.

The corrected command is 192 bytes, three full 64-byte USB packets,
and the firmware ends a command only on a short packet, so the device
stops answering WMI on the first interface open. Send the whole buffer
on a full flush and cap it at 14 entries; 15 is the only count within
the buffer's reach that fills whole packets.

Fixes: 8badb50cfab6 ("ath9k_htc: add new WMI_REG_RMW_CMDID command")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Nerijus Bendžiūnas <nerijus.bendziunas@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 2 +-
 drivers/net/wireless/ath/ath9k/wmi.h          | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 3798d3375158..2d9c14006972 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -408,7 +408,7 @@ static void ath9k_reg_rmw_buffer(void *hw_priv,
 	if (priv->wmi->multi_rmw_idx == MAX_RMW_CMD_NUMBER) {
 		r = ath9k_wmi_cmd(priv->wmi, WMI_REG_RMW_CMDID,
 			  (u8 *) &priv->wmi->multi_rmw,
-			  sizeof(struct register_write) * priv->wmi->multi_rmw_idx,
+			  sizeof(priv->wmi->multi_rmw),
 			  (u8 *) &rsp_status, sizeof(rsp_status),
 			  100);
 		if (unlikely(r)) {
diff --git a/drivers/net/wireless/ath/ath9k/wmi.h b/drivers/net/wireless/ath/ath9k/wmi.h
index 5c3b710b8f31..f9c0fe54a884 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.h
+++ b/drivers/net/wireless/ath/ath9k/wmi.h
@@ -126,7 +126,7 @@ enum wmi_event_id {
 };
 
 #define MAX_CMD_NUMBER 62
-#define MAX_RMW_CMD_NUMBER 15
+#define MAX_RMW_CMD_NUMBER 14
 
 struct register_write {
 	__be32 reg;
-- 
2.55.0

