Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7B53806B0
	for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 16:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787933696; cv=none; b=ianRrK2EmEO25cimgrWwCQi0m4yVAejRxzTuJ47qI2FpqjSgbhrdjpnVqRVnmQYfn6/EakKziqbzcIIwTNHlAQqtD9FSDUAOs8QW2GboHNyXNLfgImzhif2Pg+J5y2jY2FBTBT0fnMqtUdxQiNtinM39PFjPIdfzXWqHrK778AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787933696; c=relaxed/simple;
	bh=d9mdZdI8mE+Rq+cniY8y+BlJXYiRYQNFyxTIXRZPaHk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pz61dw7tcz+SzufnV4mEgfq2AhZYpXIwW1btgi71UR1bHH2XCWacFZGU0rXPsJlxAveTtBb7ewC3rxxE081IuEFi6lhyivbekGiw6SvYJhlfme1qkNz3wVTm5rF8sUZHfNSa9BVu/m2V0UnJT0rb6ZjhVOuBWF8Y6OI5Cx6VhEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FnOQJ0YU; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FnOQJ0YU"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6a5f968ada7so2364571a12.0
        for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 09:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787933693; x=1788538493; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:sender:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ga8LNRiX5i3NUDso3oFwMVOMM4tp2kZF02NR17rC2nY=;
        b=FnOQJ0YU82Q5xX6Cii+PHJGBnkCyvv9V+tzS4W0miQ7Ty7y5KDVgyCVL/HWUWKFa8H
         nsVWpRssu0w6TPpaRPKSPFMoky5kbNxm/r9VLbRWFVkNw36FiALqXFWrh+I4bTwC2G45
         4Vt3dqZH3W5tDuWJ+cE2sdeTd/No8hvurovZn8fMHqXrmkFwtFqiR5F7Nb+gGifx6Dvu
         A85gYbTfxIzfModvU8hM64UaFoJp/6xxa4jdFI+0ByFu44C34n5bxrdsh+JQliLJxcwO
         6JIOD3+DoArsEkSB0p/9XunGlXJnjYR+6Z5956amLSlSJtjkg+IJdsYTrvtfBA97I1nq
         a7uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787933693; x=1788538493;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ga8LNRiX5i3NUDso3oFwMVOMM4tp2kZF02NR17rC2nY=;
        b=aXVo0Rrnr/a26Og2T3GGqRcm/paqzGVYsaj0pUOuk6yi6MuJWFWlGc6FncjC3ae4hw
         WogLF9O+Nk2GyeHmggud4K+H4fnUhALVzL6isYcZ5Lq+sgKjU2VkgjDX9ZxGqKMsUHON
         U/r+n+tocK0kmiF2XEjyECPnhOkiSYy0iN/d0KoRHP9o98eAKT8YdRriV0oPK/5+6hTO
         1ej/YYKnP8jegya37fJxDBEMIplCm9hZrc4/O3d2B7a1Z7rskgeJ7uliSGLO25MGQSKK
         OYoXyHHaGQnu4j1bqjyOCQSjZmCSA8dlBv485AAS174qJWl1Sq7O03WTvJCopBANgddf
         m1KQ==
X-Forwarded-Encrypted: i=1; AHgh+RrP7jXjV7gA5BPALdQD4EbjEf4tc5EhNm6KKekPEYORfpXtTeLrFAKffDx1e2lRD0GN/s/Jiwt4bTtFjPQi/g==@vger.kernel.org
X-Gm-Message-State: AFuF++nMUvNYFMCgpHjFvlBb9uWk46TVMKvA0sMYe/CPoixePTUsflzt
	P7vQiI0XeUqEb5KsZiYgsmQ1VuT3Pzfn5UmlebsHoBHtJVX806yShsA=
X-Gm-Gg: AR+sD11YGjaOvalf/ymSfeXBGUKKBxK+tsGnuh/MUU+Mi1QGJwVDqQA0sjcm7G72LhM
	CjIqTmuSRulZFp5XUE8QQMB/mgBFvjDvejFPqdoruzejhfSXIaOfwfEccIS78eGqAnfSTwE3Olf
	cLm/9bDtSAfGG/A4KuC/xsimDIUIJ+QJyenCrk+/JRv1exZId/DpO6WKhrKzv4cI9TfQ6BKOIDy
	unRJHV4YbEECZrxESNX/Ne2O51mtIrFqLIgqtrVncDg6woRG1neR1nqb3mHhkxzBCZhBxw2QVt0
	Xqk8c5hf/OLVS52ofKagU6NuIVVVc28EdprGGl8vNalRVNV/dV32r/4GTey8QYu8i2XVnWOspie
	PeoDqAyJEs8UM8JCn1XTQztwBEOh7XMYuG1zkuJx8i+nfN9Y+qj7RRwp8NKvLlm9j9RE6hUzVC5
	Omy/K5HDi6F6iQqQyZ3/ramZvl0+gpoAI67AI/fL90/BmLb5G4VjaqhapFYl4ZEl6tpDqGQpyL7
	4TFZbHx4QnS1QICUd4zMcL01MDBlfEOsrz5ubgNK2ugePP/SHi/JFAiNS0cHx0JEzr4sX6hNnu1
	4W5R
X-Received: by 2002:a05:6402:c285:b0:6a5:c47e:8d6d with SMTP id 4fb4d7f45d1cf-6a5f4fef749mr7587362a12.9.1787933692579;
        Fri, 28 Aug 2026 09:14:52 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:5454:f357:ba89:4e22])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a611b5c572sm667210a12.4.2026.08.28.09.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 09:14:51 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@kernel.org>,
	Oleksij Rempel <linux@rempel-privat.de>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: ath9k_htc: fix the byte count of a full RMW buffer flush
Date: Fri, 28 Aug 2026 19:14:07 +0300
Message-ID: <20260828161407.1030798-1-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

ath9k_reg_rmw_buffer() sizes the WMI command with struct register_write
when it sends a buffer that has filled up, but the buffer holds struct
register_rmw entries, which are 12 bytes rather than 8. The firmware is
handed 120 bytes instead of 180 and applies only the first ten of the
fifteen queued read-modify-writes, silently dropping the rest.
ath9k_reg_rmw_flush() right below it already uses the correct type.

No caller is known to queue the full fifteen entries today, the closest
being ath9k_hw_4k_set_gain() at fourteen, so this is a latent bug rather
than an observed failure.

Fixes: 8badb50cfab6 ("ath9k_htc: add new WMI_REG_RMW_CMDID command")
Cc: stable@vger.kernel.org
Signed-off-by: Nerijus Bendžiūnas <nerijus.bendziunas@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 6de78ae85726..0b49d2cc99f0 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -405,7 +405,7 @@ static void ath9k_reg_rmw_buffer(void *hw_priv,
 	if (priv->wmi->multi_rmw_idx == MAX_RMW_CMD_NUMBER) {
 		r = ath9k_wmi_cmd(priv->wmi, WMI_REG_RMW_CMDID,
 			  (u8 *) &priv->wmi->multi_rmw,
-			  sizeof(struct register_write) * priv->wmi->multi_rmw_idx,
+			  sizeof(struct register_rmw) * priv->wmi->multi_rmw_idx,
 			  (u8 *) &rsp_status, sizeof(rsp_status),
 			  100);
 		if (unlikely(r)) {
-- 
2.55.0

