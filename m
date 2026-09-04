Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9215D4A0EEF
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 18:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788547997; cv=none; b=UGbRWgZGm6dr2005RDp56l3We8P5GWeqpnOs9Ng5jSWKlc871ETRFLsqCH8tG3XUJZWZMwROA8skBEo2Mu4tMiQT0wotdRerxdTEoMfxzaU5eXs2EuXFGkBe+IUoLrMfMI9CkBOAJ8GVhLrnWUqbkA36+72HWL83AeO4b3dP5WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788547997; c=relaxed/simple;
	bh=17rdg2ScjqmUoZ6yaWeSJKrB9uYV4e5mZ++WUCStIms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eY2NnsdAefyWlc4ZksIAlqdBgJf1uVhPZ54JhlNHLbIiJaiTNwDiUV+lgirCvzbK9jsQ0BfEJzGHqLSbx4owkkeLEfgZoOoI9ghExsAscYHwVaSgS9Zb5xmOgwhTYUK64pCEJmEfO+NgfCxXhqxGGtE+cPcwxnctffchaIL3sqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z4503FNX; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z4503FNX"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-49556f97a9dso11797145e9.1
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 11:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788547992; x=1789152792; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LnQaP9fPO2THdkTrCSNb+dwWcnrhsGIaZubrRTYDQ/0=;
        b=Z4503FNXkuPuzcJ9dclOhnJu9k9r0TLSOAn1wWgHuENAYpV23BekzBCnAc2Cdy7Zy/
         AtDRa2MetG8DxB1PPTORDCqD2M5TirvowFAVuxbJ8Yvs5mKfToLnzf2G6666c07zonsl
         blccJKJzUkw2SNKo3in22TcSzCoqXUkLddgPL8Xv6Xjuo8xp/R56gZPkR/zIG6/c7/on
         brH9Joi/0hZUN8bJXuqSaWxsQKpk7qqSETSEBxeJZCsIIXn8ZeoBTihEqx7rWWtC+1sF
         R8sRUklojEb2O+oHy/xj+/D+hesH+buFg9TR9NsTXMauYcUMw932wJRQW+aVuR/mb08P
         1oWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788547992; x=1789152792;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LnQaP9fPO2THdkTrCSNb+dwWcnrhsGIaZubrRTYDQ/0=;
        b=gFZnr+jNkrSfH2zz5xfDSx8tPwf+qIExwC1ZF5FbdlpkoewqczUcftKQ1rFGuteJLC
         RrbFmyJlUCCTokz0EdMq/ZYrp0djgTdYqeCFslu5xtsVodYBd77yHNYWvEF+YCIy8NAf
         s0DHeNJpKZWZcRMEOZSgepA52bLHRQ+KWDQQ1fwwmw3w0M6hgHcIhqNLcdLVPFd8Qn4H
         qYQEZmXmWPGbclG3H1/OTeUEoCBVeyyqFJXnmkR8kvtgAo3lwXGltxiXF1g0n+z9HZ3m
         BHAB/ZhVPtrtHYdSezJFUCzb6uaV1vHU/HKhR5RyKlbDNkOMVvqOe4iDjpIg9MFMdH5z
         WjEA==
X-Forwarded-Encrypted: i=1; AKwUvBzpOCqFGalFeG7pBG55VSusCqtIM8k8yPZh2tcO0Nu7Z+SdypYSr68d1mPXkPGO+EV8/kJtq8aL1TxGaqfR1g==@vger.kernel.org
X-Gm-Message-State: AFuF++kI8H12+C1C1JaTvPB69QhQC6LWxlJKFY/tkx8eq/jfx52vPxRw
	TqxLMgNqS1Ul8UoyBPtfoeoa2tnbN+ifacrhqeIRY4VAdwH3iYcFKtnlDz+W
X-Gm-Gg: AYBFou0bLu8RWJ+Y3KaeWZqIiE3YwxyBRs8FgYirtJ5ITWkvHiBWXEGOHM7N38PSOYR
	IgvpkG11xB9G/Mfu2wEiMHMUkdLe1RGoV4U3bhWnOD1JcmWxbmKaIVTB3bOv76sIG6+WRRJ5jeu
	mC0VnN16KZ5Bd5HHEQsTnmJ7wqLesvIYx/aHHqnpliuJvcJSt7v/sCOa7XwohZ5uQMtvqpUJNls
	pWP8Gvw4m8C9iVGeCfOIofQAi/Fr9/Xzvxm5w9y/e6OJ7p1BwGBsIApe1o+75dUSE2RidcnTICO
	ExJb+KppvCr7fAPCVgkZHOWHwo6uIyYqeStbLhuUbtEJNLs0aRYWhDSNBcMJWnRkPbzGKnl4/wC
	MZZKfsspoDaUqFtAlQYHd8AIr4YAL3Udse2DkdNv0184ZWW5q7ZIkDPTj5ARWyjlyt3AwTgoK70
	Wx8maPGrSRszZVPXYZuUAKizaiDUqTea/rkKE0RwGYzmuFxAV9gkhV4Ju80wBjd19ahOwsDvNVw
	b2qznUc5DuqWzGMEK8DiFYILALTCVaklktj1UeW6Apl9uIX1F94lxa6WFqTHj79qm5EQcj2CnbF
	lgKb
X-Received: by 2002:a05:600c:540f:b0:49c:d293:70c8 with SMTP id 5b1f17b1804b1-49cf81fb1e3mr75634765e9.3.1788547992181;
        Fri, 04 Sep 2026 11:53:12 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:5454:f357:ba89:4e22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cfbe5b252sm58607715e9.3.2026.09.04.11.53.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 11:53:10 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/5] wifi: ath9k: name the register multi-read limit
Date: Fri,  4 Sep 2026 21:52:50 +0300
Message-ID: <20260904185253.809209-3-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904185253.809209-1-nerijus.bendziunas@gmail.com>
References: <20260904185253.809209-1-nerijus.bendziunas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

ath9k_multi_regread() converts the addresses and the results through
fixed 8-entry arrays and does not check the count it is given, so every
REG_READ_MULTI() caller has to stay at 8 or below, which nothing
states. Two callers ask for exactly 8: ar9271_hw_pa_cal() through
REG_READ_ARRAY() and ath9k_hw_usb_gen_fill_eeprom().

Define ATH9K_MULTI_READ_MAX next to REG_READ_MULTI() and size the
arrays with it. A larger count warns once and is reported as a failed
read, all ones, instead of writing past the arrays.

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Nerijus Bendžiūnas <nerijus.bendziunas@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 9 +++++++--
 drivers/net/wireless/ath/ath9k/hw.h           | 7 +++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index f5844e9bdd2d..3d4c6f9f6e95 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -258,10 +258,15 @@ static void ath9k_multi_regread(void *hw_priv, u32 *addr,
 	struct ath_hw *ah = hw_priv;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_htc_priv *priv = common->priv;
-	__be32 tmpaddr[8];
-	__be32 tmpval[8];
+	__be32 tmpaddr[ATH9K_MULTI_READ_MAX];
+	__be32 tmpval[ATH9K_MULTI_READ_MAX];
 	int i, ret;
 
+	if (WARN_ON_ONCE(count > ATH9K_MULTI_READ_MAX)) {
+		memset(val, 0xff, sizeof(*val) * count);
+		return;
+	}
+
 	for (i = 0; i < count; i++) {
 		tmpaddr[i] = cpu_to_be32(addr[i]);
 	}
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index b942b8303d8f..211d42c92796 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -83,6 +83,13 @@
 #define REG_READ(_ah, _reg) \
 	(_ah)->reg_ops.read((_ah), (_reg))
 
+/*
+ * Maximum number of registers one REG_READ_MULTI() may ask for. The ath9k_htc
+ * implementation converts the addresses and the results through fixed arrays
+ * of this size; callers must split larger reads themselves.
+ */
+#define ATH9K_MULTI_READ_MAX	8
+
 #define REG_READ_MULTI(_ah, _addr, _val, _cnt)		\
 	(_ah)->reg_ops.multi_read((_ah), (_addr), (_val), (_cnt))
 
-- 
2.55.0

