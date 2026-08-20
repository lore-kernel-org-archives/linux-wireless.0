Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E953DD866
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 08:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787214633; cv=none; b=kWLuoQF0MJNYZrqic25IL+90nYAB/8nD+nRTiXwcb1ULH3mH1hj/Yc/3/MbGy4joJ0XtElpQBS82Y1jVy4hhQdMZGF8pKkhL1+sG+VIZSR3YpNXar0k5pVzQVtSbVaeNqJ0FiveDdoYRU1wwZ/v8pouDB6vURGxQHj3S17DjxLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787214633; c=relaxed/simple;
	bh=OS8QQfKfa52Fm2hu/CMn6ziZOz3INaWk58IbQhN59Ys=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=NQqXWuRNN1F37ZHo/Tl9eAUzbrAa1qZDemH/NiRKsC+eHxEJORZgT8KHu5LiLHyoaGIKV4M3WOZy9WxIoPh7Yu993/ogadTwvdhMbFQZbRWSMXY9i9ZCQ6kalPt39SFQ4trZkIQd2ayLSyOeMbSFg/TgC4UsjGloEc5+QRWZPg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EdXroyqZ; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EdXroyqZ"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6a156627e22so1346141a12.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 01:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787214630; x=1787819430; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iCcFkuEwxJmH5FDcZ+ruFk0YOfoCkOWRnbqGE9ZnWD8=;
        b=EdXroyqZ6MKa2GnjFrgrAnP9coGENvXVvI4lALJiCjVxDERjqjEEYMUG/KzyReqG+1
         sgqbe+B/it15ZKsMJPVEZ1MqEMSj02ICi/xyGR5/002tvPeKMHRtiaLR2xT+YQ2erLtc
         AhVGSekyQTT7DR6BjdQNl1x7XhgdwHE7aioFyXxjZQ1j3B9Z70mwFR7OdRcQJQ2Le2mL
         Uz+XROpeNBtAQW6GLg6SfGJtfUdu5y5W2Q1/VwHpQXy7cTw6KOBOPGbNi5FjxrdYrJxK
         UpqHZAYz77ylV082B8YkzUrBBLlDAtrrQn05aEsFH9Zhe8vPIqryK2hfVDMSxd9ZwqXV
         gP8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787214630; x=1787819430;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iCcFkuEwxJmH5FDcZ+ruFk0YOfoCkOWRnbqGE9ZnWD8=;
        b=pIymXukdOZ2/6dC974Go7t1k6P4DcOsutQ8eldQo4y9ndB+lEJFomTcb8WTxRPHWMx
         Pn3xGJqNtRX+sPcOfnFks9jqhV3K4JZ0Os+jJZMLmJbH8SCWhPSV3QQe4SsWKX+XLiSk
         O7myRkuk6GWufzv8sXFLcbAwogtMTkBKiD8mMnYcXJyf9e6XueBUAzgMdQbD/QvaYGmj
         74BEwQjT1ekx8MrGavMUg8t/Lh92WWyAn6cQicpzs7/J+CTBAGvGmziIsswR1rEtqgms
         OC3cQ/30KiRTtb59sXik+Lv0iZs9epV//UPNpXgKERuMU9mbxvLvJWvnsrJaVmyB/HZC
         Lt+Q==
X-Forwarded-Encrypted: i=1; AHgh+RqWVyFecP9NaqPKCtU7amESZ81bDe0F9ENMAnsCQuXYBXSQQJCgwh1/3PaRlUd+veYf8hGyfe5wQWjpxkHGfQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxaCcni1Zig6OVZndCeEv3w47ZFdbgLIJYJzFclIqfgNp6B1MXY
	NOlhoHIBuuAio51+pdGOQJiYxzWIMZ80qFf3KsHUlaiIY1Jxi3maOF2G
X-Gm-Gg: AR+sD130siRB2dRwWCLD9hbmLle55IpYGhFcy9Rcf6+YDaAPsRLAKwhpZ5EsEAN/UFj
	beU3Yy96ONYzo8IV36GBYotYUPsg0IkpCjVGZ313mbN8+Y/Dh3SjsfARKSgVad/kjosfEY1sQcq
	hDi8dyas9wn/8rbpRiOQYUbQ1weoZQ8pwor/IXoiaY8EI/5XOK9+wlKZ8BPB/56zwOA+VOnT99D
	Xbt4eLGMXfjdOn396gmL3KVEuKX0gB1JZBp/eK3VeyaRRuq0WGd2l6nraAbMMRziv3y4k+P4twz
	M5UA3I2AXm8mQXgpDFMOEstRl6U1t6Hzqofm15Ku5mtLtGZO4hsBH8JFOzWo1gdx49O25yvv81e
	edJOJllNoaAw+Dx8Sy3UYZIcN35lOSQPoTw+GrrvT+hn60sFwKW3MK9ShJPG5KCSvC48HEdOMRC
	hkfVwPwYH2FQlpbXxSWcR3I4+YyiBVoMmQuB0QI6jVgIEEK+oSDfta51MU
X-Received: by 2002:a17:907:a88b:b0:c1c:2218:f317 with SMTP id a640c23a62f3a-c244d45ad2amr244163366b.2.1787214629611;
        Thu, 20 Aug 2026 01:30:29 -0700 (PDT)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24591df465sm39637166b.48.2026.08.20.01.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 01:30:26 -0700 (PDT)
Date: Thu, 20 Aug 2026 11:30:22 +0300
From: Dan Carpenter <error27@gmail.com>
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Cc: Dan Callaghan <dan.callaghan@morsemicro.com>,
	Arien Judge <arien.judge@morsemicro.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Chetan Mistry <chetan.mistry@morsemicro.com>,
	Sahand Maleki <sahand.maleki@morsemicro.com>,
	Simon Wadsworth <simon@morsemicro.com>,
	James Herbert <james.herbert@morsemicro.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH next] wifi: mm81x: fix type bugs handling sdio_readl/writel()
Message-ID: <aoa7Hj1W7ETOrOzO@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The sdio_readl() and sdio_writel() functions, instead of returning kernel
error codes, instead stores the error codes in a parameter.  These caller
functions pass should pass an int pointer to store the error code but
instead pass a signed long.

This will not work on big endian systems.  On little endian systems
passing a ssize_t means negative error codes are converted to positive
values near UINT_MAX.  This doesn't cause a problem at runtime because
in mm81x_sdio_reg32_write() the error codes are discarded and we always
return -EIO.  In mm81x_sdio_reg32_read() the high bits are truncated
away so the positive value is re-converted back to negative and the
code works as intended.

Either way, passing an int is the correct thing and is a cleanup.

Fixes: b1906cea00b0 ("wifi: mm81x: add mm81x Wi-Fi HaLow driver")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
 drivers/net/wireless/morsemicro/mm81x/sdio.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/sdio.c b/drivers/net/wireless/morsemicro/mm81x/sdio.c
index 96fce187dd35..65277399bf18 100644
--- a/drivers/net/wireless/morsemicro/mm81x/sdio.c
+++ b/drivers/net/wireless/morsemicro/mm81x/sdio.c
@@ -381,7 +381,7 @@ static int mm81x_sdio_dm_read(struct mm81x *mors, u32 address, u8 *data,
 
 static int mm81x_sdio_reg32_write(struct mm81x *mors, u32 address, u32 val)
 {
-	ssize_t ret = 0;
+	int ret = 0;
 	u32 original_address = address;
 	struct mm81x_sdio *sdio = (struct mm81x_sdio *)mors->drv_priv;
 	struct sdio_func *func1 = sdio->func->card->sdio_func[0];
@@ -391,7 +391,7 @@ static int mm81x_sdio_reg32_write(struct mm81x *mors, u32 address, u32 val)
 
 	address &= 0x0000FFFF;
 	sdio_writel(func1, (__force u32)cpu_to_le32(val),
-		    (__force u32)cpu_to_le32(address), (int *)&ret);
+		    (__force u32)cpu_to_le32(address), &ret);
 	if (ret)
 		goto error;
 
@@ -411,7 +411,7 @@ static int mm81x_sdio_reg32_write(struct mm81x *mors, u32 address, u32 val)
 static int mm81x_sdio_reg32_read(struct mm81x *mors, u32 address, u32 *val)
 {
 	u32 value;
-	ssize_t ret = 0;
+	int ret = 0;
 	struct mm81x_sdio *sdio = (struct mm81x_sdio *)mors->drv_priv;
 	struct sdio_func *func1 = sdio->func->card->sdio_func[0];
 
@@ -419,8 +419,7 @@ static int mm81x_sdio_reg32_read(struct mm81x *mors, u32 address, u32 *val)
 					 MM81X_CONFIG_ACCESS_4BYTE);
 
 	address &= 0x0000FFFF;
-	value = sdio_readl(func1, (__force u32)cpu_to_le32(address),
-			   (int *)&ret);
+	value = sdio_readl(func1, (__force u32)cpu_to_le32(address), &ret);
 	if (ret)
 		return ret;
 
-- 
2.53.0

