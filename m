Received: from mail-ej2-f1.google.com (mail-ej2-f1.google.com [74.125.228.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365823E7BA4
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 09:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788512810; cv=none; b=mn7pU3OE+ubTj+JYG/YSu/JTC33tfkbkGe5uKBICa0rJ2ho2vUk9A+ZAWquqT/LNYe6YEIDcSClR3xju2TUravaokf89XDqA31cN+cmcWPOcLJbrg0ydL4oiIOkkMnZbCUV8jOIulNeFEJeHZ1KR3lZNoXax9hhFgRL5UEgnPCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788512810; c=relaxed/simple;
	bh=fRUsBC0vRdmA7CghYVQ1yCKfykjRMfmZmTgqkwKPv2E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Nu8QfFpl6wQi+xsh+ZS+KLtuMMfKxzceMAPHdN1+F0Rom5/dad6UUgLFtmBnBhncJkWaejJ4HaPNwQoujrf98kXt24WQZDj4Jl2iexg2KcP3M3iyEQrT8dnk9ivMQtaYf3+zdNETLnM7IP0TBnrC9zImXUxTX0yMmFUbz7Ren98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=G4Hkwcpp; arc=none smtp.client-ip=74.125.228.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="G4Hkwcpp"
Received: by mail-ej2-f1.google.com with SMTP id a640c23a62f3a-c15de09d5c4so36002166b.1
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 02:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1788512806; x=1789117606; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Uo4Rx38QNKC6a2s1UXfvJmSvSpnape+bVE/YMGjtDuk=;
        b=G4HkwcppqokRa84nVKefI4xQIWKT3vDSMtP3IoTAU/za/bqDFRXdnoD18vRUaMYPUN
         HG2sCz+uIHkmAC+3OyllDgOlwPzYqoyZMMxaD2KhcBLucMkMLz4JLhXGzhSmPFbDcCCU
         4W3gB8iTrnkr8o8J+AawTXJKLRASLMnS6w3+e9jh/7ZNhfGWoGLAsBeh2OxggbZyKaxC
         5Pa6OIkfc3R1IPb03kg7qrH9ZSovkO3MymMsD9bJ4f5016qDJc/t4T8FoVGQMm9be+80
         qamYRFoktp7TXKtuVI6D7vKwst4S52ZHWw8gObpaLEbMfNk2CtM4mv/Q5D6fTlknOcPh
         XSFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788512806; x=1789117606;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Uo4Rx38QNKC6a2s1UXfvJmSvSpnape+bVE/YMGjtDuk=;
        b=St0b5yhimaRuP4o9lf93ZeYU588ih23ffYVR2kCVxKkYGXl3GfF+YpDckw2pk6MDVN
         1P95OcxB48a+yDzJ+QMw1k5ZlNG45u2R+PREsFY9KHYhtUPLIrGp0Xj65PCf4jzYVgca
         qZHyhgS15IkZzcWoUWasHf14p/874934D5EFYzlHSYA5JJNa/6wx+cGFOEPA+Psyu9O4
         re9cfKDBNqYWZfp8tDQjsVP+FJhjFi5V9X2cQ5fsqCOCYopwtmxlXDKAnHDPm7HZF42/
         V7gXXDUVYVmCtOMq8s75p+/ynIP17uJX1TJYyqut60o6mXc7B6V8CIG4AXJBuvk7C3lA
         ls5Q==
X-Forwarded-Encrypted: i=1; AKwUvBxTXcqp2VGgkyL74WiCTo3XzB01i3DWE7W4Tn4qLgc42ClYpc7IPARSSihL9wqUHYodrGinxLMOrfId6my8nw==@vger.kernel.org
X-Gm-Message-State: AFuF++n/7NVEJao5UHOGdUaB5H71hPikuBk9Ux10lNyAC5d7lKkkZ6EQ
	/HvQoSGrzxitqf0SMQg2Ffp1a7vI7dSCiEDn1OJGHzCLTBsA/UKsVGLELELLC4Envf2SCg1F89c
	ESMHN0KBFqiA=
X-Gm-Gg: AYBFou142Wn0/yasKp3rbsuqUExrsfZhN/Sjz2yVGNfbYGgFw9m/Mn5Qaab3JZhn+mr
	YJfBo7e3DLqQJ7xTRsW2hvk4899ulJs54IaEq/YNx9SkOxFQdWRxzvw5LEC4mYElDNac8GbzPEG
	0TFxikjZRkT1lG7Ftw59M5e+wShmLiJSumUT0cvGg3QSK5gD0bWwXxjfkt7CBZe9nZ/5Le6s4qy
	ewLabCmCFk5hZMKDi5BVATJZldUOJcQtYgd7xJUCuOsXoh/8z/4PPddF8AmCJ+5r70JNrI0Z6r/
	VpiAdN5URyqWtrN5qTzLrW16JyuBUNMulHomZpFb6OzyicC6RhNRnnUU0iZia7UJTbdKcT16oNB
	qp3x5m0YS3VeK6bgV7iBiWHARD9tN1rVFBNdjAeH21MKZs4hsG6jW5pji/KqSIdjhyLjN+MTQmp
	ZpSsuMf7KV+XuDjARIuzMKj23Xycvm3O6DcqoXIn6j8DTVKstaBeSYSKh5mE9d5+Ye00UEbNm3m
	oXRH//rdulCzq6IEQcTkyHC5pX2Cxig9OZIa5ALtjbYDqSGzTizOiasQVkXgMLiout2VIjCawEm
	hocXoI1sFs5RAdrEASphcvTX2Vp6oDNRKPuyNU2Xu5mlWplKX1RDwb6RnpFia0mQkqqiSTgsPKK
	Bh6PjRZ2qYcpeDmdjcEFC8PN3Lvt5WxlxjXlAF/+aLSNza28eWV0NJWjU7IQkWG0PkixeWzUWGp
	CCWbyyiR6sFo5T
X-Received: by 2002:a17:907:c00b:b0:c25:5fa5:dea4 with SMTP id a640c23a62f3a-c260c9717e0mr336806266b.4.1788512806207;
        Fri, 04 Sep 2026 02:06:46 -0700 (PDT)
Received: from Desktop (pd9513f67.dip0.t-ipconnect.de. [217.81.63.103])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d559364sm77404766b.35.2026.09.04.02.06.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 02:06:45 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org
Subject: [PATCH v2] wifi: mac80211: fix swapped fq_overlimit/fq_overmemory in aqm debugfs
Date: Fri,  4 Sep 2026 11:06:26 +0200
Message-ID: <20260904090626.92727-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The two scnprintf arguments for fq_overlimit and fq_overmemory are in the
wrong order, which results in the aqm debugfs file showing the overmemory
count under the fq_overlimit label and vice versa.

Fixes: 2a4e675d887b ("mac80211: Export fq memory limit information in debugfs")
Reviewed-by: Toke Høiland-Jørgensen <toke@toke.dk>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
v2: rewrite the commit message (Johannes)
v1: https://lore.kernel.org/linux-wireless/20260823195739.49222-1-julius@bairaktaris.de/

 net/mac80211/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index a4d5461f6480..014f3c872706 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -96,8 +96,8 @@ static ssize_t aqm_read(struct file *file,
 			"RW fq_quantum %u\n",
 			fq->flows_cnt,
 			fq->backlog,
-			fq->overmemory,
 			fq->overlimit,
+			fq->overmemory,
 			fq->collisions,
 			fq->memory_usage,
 			fq->memory_limit,
-- 
2.53.0

