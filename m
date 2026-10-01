Received: from mail-ej2-f41.google.com (mail-ej2-f41.google.com [74.125.228.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B33C372EEE
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 07:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790840267; cv=none; b=W6MfVnNDKYlgTDLaT2pzs7gdih6Q8rxS/tMWbiBF+ytmV3aIJaU3k212WrEaLlEVR5DRh3YUIM8LkvAdFGq9NvpkuMQjvOsJ3PmaOkyp1apxCTxdC4xw1XvPqcRCpQmtTVX5uVCNgfs2jUKD3dhSLmiFj5V0Sif+8uFWrcdQBws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790840267; c=relaxed/simple;
	bh=Ze6CRBSJW2k7BKCvDJ3wxrtyl/fCa77TZ0wRC2E4nek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V1D/3vjNqlHvI91MQ4DN/Ny2yKbHxIN3EBV+B+GZoBqZLvKZSmGNkyZQiPDKAI08htPJj/+NpuEADa3GCPCdtB0mlTMtrmKAX6qUgiLBkcxlxYKQSOQtdu7mwiPcWQZDWI6jKd8cDkumupjQbNtWrD2qmVtGLLQcgDcC/kBLBWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KsVxUpcx; arc=none smtp.client-ip=74.125.228.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KsVxUpcx"
Received: by mail-ej2-f41.google.com with SMTP id a640c23a62f3a-c2e30a06b59so151958966b.3
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2026 00:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790840264; x=1791445064; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gsL3ia+o/1e43RyZen5AJRoAaq5/bgRELxN/6vFLbTg=;
        b=KsVxUpcxICBBmtyxkZ+5Itftg0ujtPzq4xiouWZ6UA5M1FkROanZwgkOtgVs0bvIa6
         rXSrTmhzrsY2XpFnpfmNvSgliBMpqayTPk8MqNsbk4Tm0+1XZUeBCnOjMhV835sVlHXl
         R5ikhe6AqwGLiUXCYWQg4vlFWe23GpkAjc5pYmoFjHSHnbLwiJ1/3/8xK5iirtQumcV8
         GlGmvZ4GBZHOZSHcc0nVdu4SPzzCViWP9SjEA8J9hixJuXl3z5FrVbIqOLxy0pzWVBF2
         yvoeWUd6zNgqRykxpOTrRW/iyPk1RV89q4ev9hanwoRouUuiYSqa4V83+mwq1wBgQP5d
         tQyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790840264; x=1791445064;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gsL3ia+o/1e43RyZen5AJRoAaq5/bgRELxN/6vFLbTg=;
        b=HjbHYmBltl54hvLc1XHYeUcdmlGwZF5nnzdfjU95UQ8Un+56qyvkkN32hMhGAWA/er
         /N9qnOr9jyTO+DshGBo4Jd9FUXUiaNz05+KRireHld2Y4e4GWZSyvho2Y4Jtlf5I5hUV
         3AViwvYplOLVa0oH+j/L12ER3+THe7+9R/5cBdd+OqTqqY97utPWSitK+IQRc3LYtK+N
         +vxNRg2SYct9/p/XMH6ssd0WAAiBW3bWTWCZbQW/QmgqXzsZVvO+qvtlvLXIUjpPKdU8
         ajEYcQmtGi3hH2Ghit2IHaK3GX6Bo1f1ftYuTi8GiQYAbT8x7ZB9v+T2zbsAoX6rYTR9
         P9fQ==
X-Forwarded-Encrypted: i=1; AKwUvByOWMcQ4+FPUXelT/IxQSHVd5crtay25Ol1uY+lUxvnV5aDLTXWgZ/978gg+lUslhq3CJKAFMHfangJnUCkmQ==@vger.kernel.org
X-Gm-Message-State: AFuF++nMZXnF6VmxjXNh2MaYL+vRQVheF008hV0v5v0QnimhmA73OlbD
	UQOYLgM4e5/wNqPrYUjnBzcOYu59a5LRgSX3EO/4oBzmefaVft8NOoB7pC4uwXRrKI3UOQ==
X-Gm-Gg: AYBFou3ESV0eJr7BncRf7UzNmlEoMKWvQFSrxB4Feolm8+ki4jWLNBEHAy2MYaD1k5C
	rqzD63/C5/J+m39e/mUaG5gpZHSmLt8dNFmmHAqR2usYFTBSmQQLWcXZP5VZdYQlshjY7qHAxef
	7OK08o9Lf/5+0pUJPKdBi1ADTWujimP4Czz3b5MftAODJFUY1nBVdv8/8KGbZcHe4qt/kCU5hij
	EMJwOkurBqOA39WmXHFPzajZODJIXi5f1T2u/lfvjF4N0Q33lo/LiEtyOQCjaQHuxxhlgIi77dm
	iaUAUrZrLZ3MKy9k6FF6Dii22T3rbGY+WZqTh+gammd09E575Zvf8IkjO2tyaEzrqR1piV+zUj9
	qmNOYuS2bRDrIqBr+FCQ/tuXfMO7dZ0BP+hE6599Yjgc3hZ9gOtu12zmJ0cLJT5HkkVUvwa2haa
	rAZjSUxyBIelSIu+lGU4br2POVzXOETF9FnwSXk82ojtciX1+kQRZTy7mS7MPScuPEF+M=
X-Received: by 2002:a17:907:d8a:b0:c26:1648:a065 with SMTP id a640c23a62f3a-c2e23d94c70mr325917166b.32.1790840264416;
        Thu, 01 Oct 2026 00:37:44 -0700 (PDT)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e31d4297bsm101151566b.45.2026.10.01.00.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 00:37:43 -0700 (PDT)
Date: Thu, 1 Oct 2026 10:37:40 +0300
From: Dan Carpenter <error27@gmail.com>
To: b43-dev@lists.infradead.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org
Subject: [PATCH 1/3] wifi: b43: don't pass unterminated string to sscanf()
Message-ID: <b396713e697c7411b23a2157e2102c347ac900bc.1790839793.git.error27@gmail.com>
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

The "buf" buffer is a PAGE_SIZE and allocated with kzalloc().  We store
a string from the user in it and then pass it to sscanf() in the write
functions such as shm32write__write_file().  Only a few numbers are
stored in the buffer so it never comes close to filling up the whole
PAGE_SIZE.  Reserve the last character of the page for a NUL terminator.

This is debugfs so it's root only.

Fixes: 75388acd0cd8 ("[B43LEGACY]: add mac80211-based driver for legacy BCM43xx devices")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
 drivers/net/wireless/broadcom/b43/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43/debugfs.c b/drivers/net/wireless/broadcom/b43/debugfs.c
index 31a1ff00c1a4..173ef5db90fc 100644
--- a/drivers/net/wireless/broadcom/b43/debugfs.c
+++ b/drivers/net/wireless/broadcom/b43/debugfs.c
@@ -557,7 +557,7 @@ static ssize_t b43_debugfs_write(struct file *file,
 
 	if (!count)
 		return 0;
-	if (count > PAGE_SIZE)
+	if (count >= PAGE_SIZE)
 		return -E2BIG;
 	dev = file->private_data;
 	if (!dev)
-- 
2.53.0

