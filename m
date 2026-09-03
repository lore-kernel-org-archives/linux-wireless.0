Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEBE4E1413
	for <linux-wireless@vger.kernel.org>; Thu,  3 Sep 2026 15:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788449797; cv=none; b=GFY7npXSeiJBbyz31Cv3H4bQcAYJ1mU7kBoHYx2oNsHY6xLm4FZu50C1hI6yl1qZvgzfDWTGy7Vki1zOG5a31oPeJUiNBBI6mK+20S3ZpqrfIaYDcH6smYrTne9F2FIYRa9NRQpRSZ1gEopzIgeDPrkoQLW6pgyITuR80+JnU64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788449797; c=relaxed/simple;
	bh=Sx82Mbp5lO5DjoKy80dsNlSHsxmeRD7u8l6pGGCMoDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YT+phmfxBbR9CDJ6LMODgzFqCJ8F5HEnPHudqfLSr9bZMU67tmSsju8a82PMB3kO1R9T4mHXq1q4d2nzCvGb4V6DYwUGcEK9g31MSg/u3PFoaZS7Ml7NmJwGEOzrU0zRZSeJrCRrJx4+Qd2xuP9I95k2h8XlCKAcpWTPuLXNAb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ADrn3gjh; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ADrn3gjh"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-49b0d78a801so20745e9.2
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 08:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788449794; x=1789054594; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=mKYBlq5Au3+HGNkg1vfOBKHH7P2alX9eeNg+UdnZVyg=;
        b=ADrn3gjhi5wv5vwR25msD2CWjArgICNkDeFwl7Syi0TpNKNigyIWRYRGm9WyzL/Vaa
         Qq12xKNthoBC1kGUgYinYA8CtJaTlabUUbsNgkm4tZZwLB7pihJCascnebpUbbhsP6MQ
         Nav/98pj6BfgHMJJgFnp85blaYLITZluPm1rXaQbmHH7XUb9y9+LjZcJ+5l1io0Sbg/Q
         7WqDVphYkW9fpu3ws4GqpwQJqjyMjUcPy95AkJiQIgVx4jWPsjzrXtm1oSd22Yf3CMa6
         AmWdEIxsZai+ofRBWX44mSns2esbQqnEVn0j1LHrkT4nID7CCg7MoeIA1ABu+ecU1u0f
         n/ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788449794; x=1789054594;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mKYBlq5Au3+HGNkg1vfOBKHH7P2alX9eeNg+UdnZVyg=;
        b=PAloCmC789PZdiLKsaxozoehjRYDQvm84ooFUSQaHf59zzDfgQ4mXuOjpgccPuQnLB
         RxhcvEXWN7tWt/aR/iTt1UYIBlC1mQDU4i/QybQ9ysEjKW1oRSp84jR/U3cN0LZoS8c5
         P2U7lKCNxK0sYl6Hqit382JbL0rRcNBtn1XuVoPsGEhbo3xlAM7pCuScrwv0KdpziSA6
         ZKU7aeBrUg4pr+xoaTO+jYJYq1W7nU72kp+RSCjlwpTSktMbt1SJimB2SOxtOrveO24d
         H0gFkjOIAaVlsCh53pRVtHV3tu7AgQw7Cm3t6zq3ri4OFrZsWXBMi8WVMrhf/ZLvO6up
         vB5Q==
X-Forwarded-Encrypted: i=1; AKwUvBwfbYyH/iFcTHqUHYhEEs6Rdid64DYayyS7uD+iJGxtfgVP8ndF0mdMnWvHCjmwOFtF0FTHiV/NIOpYYXuv6w==@vger.kernel.org
X-Gm-Message-State: AFuF++kVJdQtWjY+VDwBggLlljot93OOHKi2YckOKL4lv3aGKGNS9voA
	v2lT4Zoz9cH+KDJlFAjcRkfv6n0Gr5y1kroW2JwksW04siiMgNR2l88jlXrd
X-Gm-Gg: AYBFou0Askgk4rEEF3vDBCHlCZvXYckm+cUOsP69yzQjXteTXk4oFJA6XEPIvhyQxoe
	Nz+0vP0SZqcPjKVRyHHgBRM/NT4RpM4qeVZOK2oeCWQZXAmYVecw3fV4AbkiN+IJcgWEsaI21Gj
	1q3EA+kAjIgSl+kEnDbGgZWJvlWXvPQ8m9adRFkinR7CVwgzNfwVHeWqlumLLs0oIsr4OwCW3ED
	kC6BFjbq5XE51IY0PIKdTg8+sJKZDnNUs4XELg6tzlPR0tByiCesAuOh1D1CQ+YAoYUiPzfHBH+
	aymb2tDHgmGvGCOGQocsLO6QRSuZXBaLxP3xl1T5sm+4r6LedHiCLu5PFxvjpiNJ+rp3oyoaG9A
	A9cmCmGWqQKbM6588EZWA7jNIQN+1J6MoP34yWuJZJjCdXJXHf2l/K9RHs+YlF0CIgK0pufOjFg
	PdCbvFCIWxvsCHo7wiYESvIIEeN6fiABopt7S60x3dQTt63VZnHcWq9S3vs1wJRvjb5IrRFScSW
	v44cXOYqHeMsC6fDh8e/vq8LmSsZNfZfWBADYLSDzHnmeE2bD3pbprmMhF+rMzDjlUXGNoujqhx
	cswMz35lproYYTY=
X-Received: by 2002:a05:600c:6992:b0:49a:a101:4157 with SMTP id 5b1f17b1804b1-49ce58034admr264450575e9.7.1788449793861;
        Thu, 03 Sep 2026 08:36:33 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:5454:f357:ba89:4e22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ce831af89sm75568425e9.1.2026.09.03.08.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 08:36:33 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/5] wifi: ath9k: name the register multi-read limit
Date: Thu,  3 Sep 2026 18:36:13 +0300
Message-ID: <20260903153617.990995-2-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903153617.990995-1-nerijus.bendziunas@gmail.com>
References: <20260903153617.990995-1-nerijus.bendziunas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

ath9k_multi_regread() converts the addresses and the results through
fixed eight-entry arrays without checking the count it was given, so
every REG_READ_MULTI() caller has to stay at or below eight to be safe
over USB. Nothing says so. The only caller that exists today,
ar9271_hw_pa_cal(), happens to ask for exactly eight.

Give the limit a name next to REG_READ_MULTI(), size the arrays with it,
and warn rather than write past them.

Signed-off-by: Nerijus Bendžiūnas <nerijus.bendziunas@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 7 +++++--
 drivers/net/wireless/ath/ath9k/hw.h           | 7 +++++++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 6de78ae85726..7fdec25c76ef 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -258,10 +258,13 @@ static void ath9k_multi_regread(void *hw_priv, u32 *addr,
 	struct ath_hw *ah = hw_priv;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_htc_priv *priv = common->priv;
-	__be32 tmpaddr[8];
-	__be32 tmpval[8];
+	__be32 tmpaddr[ATH9K_MULTI_READ_MAX];
+	__be32 tmpval[ATH9K_MULTI_READ_MAX];
 	int i, ret;
 
+	if (WARN_ON_ONCE(count > ATH9K_MULTI_READ_MAX))
+		return;
+
 	for (i = 0; i < count; i++) {
 		tmpaddr[i] = cpu_to_be32(addr[i]);
 	}
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index b942b8303d8f..946c4d307b91 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -83,6 +83,13 @@
 #define REG_READ(_ah, _reg) \
 	(_ah)->reg_ops.read((_ah), (_reg))
 
+/*
+ * Registers a single REG_READ_MULTI() may ask for. The USB transport carries
+ * the addresses and the results in one WMI command each, so its buffers put a
+ * hard cap on the count; callers must split larger reads themselves.
+ */
+#define ATH9K_MULTI_READ_MAX	8
+
 #define REG_READ_MULTI(_ah, _addr, _val, _cnt)		\
 	(_ah)->reg_ops.multi_read((_ah), (_addr), (_val), (_cnt))
 
-- 
2.55.0

