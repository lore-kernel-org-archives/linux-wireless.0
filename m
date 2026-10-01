Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97A93DA5A3
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 07:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790840278; cv=none; b=a3L5kU/Mwg4sY+hhkrrSbUX48gTSyCX5TjCUuiuGcLp1VYZBLAV2xVOljBCr6INGhrl0XY2vH9bYvBMTl808oRq5hQWxOXRAa2ze2mWhg5BA/OGhNua2CVa86Bf3vnKNLoEdQQCeCwZx3f8B5csdiP2lAvh1lpsIw2tE4VgdOyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790840278; c=relaxed/simple;
	bh=W2kJ+VA7ScS3jFFv4KwbxFuQSzAnbyi3I1AvzQwgNZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AyTXXfsKhNxxDy0b2d4qH29mNZg76ZdzeeEP87PO9Cqup8io+pvIJOHJgrly+oCGhOc2KkAxkvm7MOY3NIae4Tngv1MYUbZa1vGiR36pr1msaFef+h4WNM0TWgQn85blKiaH0bdlxC2zvYIc5j6v8OTAiO5CEjKWDBexXTDHKVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lx42GEFU; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lx42GEFU"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c2940ff2313so207303266b.1
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2026 00:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790840275; x=1791445075; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=k7K0wFr9r/mBROwQqZXWfQ7Cm/zdFo7ZNk/QP3UWnE8=;
        b=lx42GEFU/xyFCAmxcPY4bNyoxaZetseVxuXyS1TIi/N3jHxmxCd+Xe0eVDN3m1pPnk
         eKC48sqwRllbIBFhZVM+bchgRO7IwvaNzSKa3IEOEk4iZ0YKqT/Q48iwvl5V7EiVIdtg
         wmaIzjz1yh777Dep5kWtHnFAHsj9ZBP4m9Vig5xsZzsyMBJx4skG8ADrUVyE45ERk1xh
         8miQqvi07ggj2g6GHkKUZ7NLjI2WifPLIABksCi+yxgaeAEgCcbsWYkf7P+fAPSfGMgl
         J6BISp41SCOYQ0uquEF5NZKVxfMrF2reXnpLZuGMwJ9Pcd9DkDJRi80CkWLl8APervv9
         WPtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790840275; x=1791445075;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k7K0wFr9r/mBROwQqZXWfQ7Cm/zdFo7ZNk/QP3UWnE8=;
        b=TkfkHIE/IirmeB4n0CUKdezJP7zUJNx4w65WzWiPmw3asJRgS9LOf3WJSyZjjPC22X
         dWkXopxPF3WgOeQMIPcczeevaV3kY/HZDwoZVBytT6qScs1WMKMA+7bzq9h+l5PKd8NB
         CXu4lHAfxccaprj3pHP7ExasyoN9vuenn+nLIfTAQNybuqiyhnWl97JIUc8yfL0rUmwb
         x56Gy/cWlgOHlD4aEjjyOWO8ckshQVj7J9SSoDaykfK+3ftirb+k3jTU7yn0YlOfKrPr
         128c2B1qVfOFfksV+gD9bt2d4Fjl0j5JTiqm1S5AG/oQgPlM5l7JRF9wUR5k7ALdcNCe
         QoZg==
X-Gm-Message-State: AFuF++mgBsLkzf6CsE1onZniSddIACBWN2xououYdMosmsN/X0EbkVYX
	63xaHqeOP3VL/pRVO/x63nBFgStlj0iXyC/0Ncz+NzfE8P7wURkzkLQQ
X-Gm-Gg: AYBFou3MtT5wCjdvl29p8/qLxKiQIHVcTL2vbc5fAG7sdf8Iz/4fUnz3JwMiDnnV0hc
	JO/yRZ+0OzWuIh/nqpK38UjdfUZvZr52ndcKgJBlhuCP9qEaKYeoSPA/Xh82Tbx4SIwArfgMBtK
	6jBREXR38p6pwczgfk803UNbwQROJwti+/Y6/256zlHtRE06FDsaJQ/OQysjnfFw/2rBvEwKKlr
	bJGU7c1sHSo0ncOuiECKwaNeQPpYsOTHTjl4CEghxCau7/oNTwq+CSIxO3wXsyjv6KfuSBZAISO
	xMEOqSkzjxqTFDvFizkTJGBe+RPIWaQg3vZ2U7HhTJ+V4NAonHWCVzE21HwY3XcL46KR10BPsoz
	0YAU7lVzlFa6FxJmQXEoYjRgWJQ2sf/hdgCDQHB4toiGa8KpGryG8mKFnVoitESozD9xkGmotGZ
	3Yy+DOyWSl2u9MQ/bWJ02R5rMkZhtxJZOJAKrOG7MVVJ6/2tUFrMtt/pXslB38cxZbt2g=
X-Received: by 2002:a17:907:2d25:b0:c25:f7db:4be9 with SMTP id a640c23a62f3a-c2e33da5cb8mr182955766b.15.1790840274706;
        Thu, 01 Oct 2026 00:37:54 -0700 (PDT)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e31a3eb32sm102927066b.3.2026.10.01.00.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 00:37:54 -0700 (PDT)
Date: Thu, 1 Oct 2026 10:37:50 +0300
From: Dan Carpenter <error27@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] wifi: carl9170: NUL terminate string in debugfs
Message-ID: <674270ab4aeefa1982362c0ea4132427e14f15eb.1790839793.git.error27@gmail.com>
References: <cover.1790839793.git.error27@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1790839793.git.error27@gmail.com>

The "buf" buffer comes from the user.  We use it to store a number or
two so it doesn't need to be large.  It gets passed to sscanf() in the
write functions such as carl9170_debugfs_erp_write().  Ensure that
buffer is NUL terminated.

This is debugfs so it's root only.

Fixes: 00c4da27a421 ("carl9170: firmware parser and debugfs code")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
 drivers/net/wireless/ath/carl9170/debug.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/debug.c b/drivers/net/wireless/ath/carl9170/debug.c
index 0498df2a2160..bc6c8e0b1d16 100644
--- a/drivers/net/wireless/ath/carl9170/debug.c
+++ b/drivers/net/wireless/ath/carl9170/debug.c
@@ -119,7 +119,7 @@ static ssize_t carl9170_debugfs_write(struct file *file,
 	if (!count)
 		return 0;
 
-	if (count > PAGE_SIZE)
+	if (count >= PAGE_SIZE)
 		return -E2BIG;
 
 	ar = file->private_data;
@@ -131,7 +131,7 @@ static ssize_t carl9170_debugfs_write(struct file *file,
 	if (!dfops->write)
 		return -ENOSYS;
 
-	buf = vmalloc(count);
+	buf = vmalloc(count + 1);
 	if (!buf)
 		return -ENOMEM;
 
@@ -139,6 +139,7 @@ static ssize_t carl9170_debugfs_write(struct file *file,
 		err = -EFAULT;
 		goto out_free;
 	}
+	buf[count] = '\0';
 
 	if (mutex_trylock(&ar->mutex) == 0) {
 		err = -EAGAIN;
-- 
2.53.0

