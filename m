Received: from mail-ej2-f19.google.com (mail-ej2-f19.google.com [74.125.228.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B17A19E7F7
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 07:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790840273; cv=none; b=EvY+7VPzkXgOuDZoqmBEg4aLxs//1gv1w59wbWZe+TjcxufdEHxtIyuscQ1W/ccotDoQabSew5kxDV50kvIJAKHS3g7hxMNJC8DjxYKVie3bc8TeSL0Lk74/R8PEMyNSsHVvM8GZMihw+N/pauqGk2eTTO4RObvynNdLrc84LtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790840273; c=relaxed/simple;
	bh=tjGG11lmdDaT9PIpg38hWLrc09o/qM9JDnUBjvclsus=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RMsCFHzL2Z04pVRlSccSiqMjUGh7v1JZDrtQR6eLvBxnsMGs3XLEnm4PQgqkjoJpXuNwur1qKW2sjlkQg1zHTsOfUJ0Cxf6SiNPZOerC50gDSiOZZK87YPVUZ8scg2InTQbVe2O2DFIHiOVSEW/G8DoX/x6rMKqQ7jWY8gQO43I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NRxvra7+; arc=none smtp.client-ip=74.125.228.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NRxvra7+"
Received: by mail-ej2-f19.google.com with SMTP id a640c23a62f3a-c2940ff2313so207299366b.1
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2026 00:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790840270; x=1791445070; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OAi7fW4JIXTaTIa0/z3chJgYpw360FBeTuGIpfI5tbI=;
        b=NRxvra7+40JNUenHRbYWtnibRBGJr5/Cjwma1yCAUL1aBQu2BwPFhPpCa80AyMxo+S
         zKb3an9pWhtxBQaErgv4OaDUd5tPDvvqBati02EuYl2b2zskPyzw1ELs6FcdquQEFZaZ
         +rzXqIrEh19p8NaesUajxEGcSFRLhrUeU7nmPUVg63AqlO9PpMc6LmU8cv8ofFhMLZhw
         bqZgfR6N/K/Y3dIHzqXfnEwPEnG4dMQZy1xiHRNEqOj1DZ0RHhRchgWAKc5QrxRdTQWf
         Z2mRnCvwRSSyBKT/KJ06H9sjwD/gYM1QKDa7CbAfG+EvAEqX+uL+7TLEu5RUuzV4CZeG
         JboA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790840270; x=1791445070;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OAi7fW4JIXTaTIa0/z3chJgYpw360FBeTuGIpfI5tbI=;
        b=yCglI42ZgezF2bY6Ue0L9rbx3I/954ld5x7Pi3OniMrlLrNkZshKCPsidCopPAwqZS
         FyPnX722Rekcsln6ncaORwM7Xd2gBwVMjCznDbGbJhPqkM2HLhb55cXItFf58aOdvSv4
         GX0atBnFFMUCmbUundPjiV8ugQJwuXHPzwb4A8fkARgL9yxNSSKGw1sS2ri3VUwbhmEt
         H8pxyZQtTJb54dAL4or5w6TQ2sSK4d+V/JOuiK78ddaFirFTTcShf7XLR+IP7tO6Uomg
         U+P8F4m0E6nX+/frGHnBN18FDKWlXrNa6iFzHZRrLmsAk1tOQRn3V3L4ME9FXFE1XYhs
         n9MA==
X-Forwarded-Encrypted: i=1; AKwUvBytgD+pImWhQItbmIRG2AHB2ryg6Skz4GqConeV+sp+VBvZ5aJfQj3e4b4bKG+HF5s23NJ9Ox6MKj+9xvlduQ==@vger.kernel.org
X-Gm-Message-State: AFuF++lGWJxCFQXHeTJ3Tdp+PnHYbs8NXEx4A8MeZVKapEYhloDbqbuf
	RdAqtXI2ioz49Rk8pwLlYVNLs1x/koUq4LLp2SEXTtvb44xX7vK9j+KM
X-Gm-Gg: AYBFou0ZN6rKS1BIQCo7eKU/G++AgkNM9PHyrCt1ETXYKDqXfD1EJl/Mh8xDZd3gjW8
	nJif4PdfkEZkKTFeME/eelvPPx9qZLorqu8o1N5MN/38c1usDtVFZSnQHMN1oMkxcWHb097YNX8
	aJPp33VPk3y+CgZKG1ZbCs+gv+8pdq0hNNwlP0ElFwQHTStGg5NyCDX58KejGfWGfvGlLBuhv1E
	mtVo2AqjY94uS27GFE2VdMNOc3N0umBx1gx8kh9iZfhKwulPGiw/yG3m06+9P8o+fPEcFOeUiaq
	vuv0++KyuTWRsH8g6YFBJsjPrDextc9OX5tofM8L8GGuvLB3x4UD9YWlDWhEcqBCUvqnfmc4mEz
	iRQ6zLoYQ/rRi3w0nc6kTduEJ9Qz25GQMXm76kVEr1aJI9jsrUqF+7/MtE9fwStJNCw+Z2OCbTY
	24w0f+BaA4jvw4ksf1eKVlzL9RfcxivcpYtkqL/KvwHVGJpeGbTNzl5n4LZvWXpQXjhW7wze0Ol
	1MuNw==
X-Received: by 2002:a17:906:c14c:b0:c25:f7db:4bef with SMTP id a640c23a62f3a-c2e33e7d4f3mr162862666b.21.1790840270349;
        Thu, 01 Oct 2026 00:37:50 -0700 (PDT)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e31c8edfesm100394566b.15.2026.10.01.00.37.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 00:37:49 -0700 (PDT)
Date: Thu, 1 Oct 2026 10:37:46 +0300
From: Dan Carpenter <error27@gmail.com>
To: b43-dev@lists.infradead.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] wifi: b43legacy: debugfs: NUL terminate string in debugfs
Message-ID: <909ea7a88658b5e7c183bf0fda31687a91d73818.1790839793.git.error27@gmail.com>
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

The "buf" buffer is PAGE_SIZE and allocated with kzalloc().  We store a
string from the user in it and then pass it to sscanf() in the write
functions such as tsf_write_file().  The buffer is only used to store a
number so we never come close to filling up the whole PAGE_SIZE.  Reserve
the last character of the page for a NUL terminator.

This is debugfs so it's root only.

Fixes: 75388acd0cd8 ("[B43LEGACY]: add mac80211-based driver for legacy BCM43xx devices")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
 drivers/net/wireless/broadcom/b43legacy/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43legacy/debugfs.c b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
index a04d90d7307c..7ce8bcf12f0a 100644
--- a/drivers/net/wireless/broadcom/b43legacy/debugfs.c
+++ b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
@@ -259,7 +259,7 @@ static ssize_t b43legacy_debugfs_write(struct file *file,
 
 	if (!count)
 		return 0;
-	if (count > PAGE_SIZE)
+	if (count >= PAGE_SIZE)
 		return -E2BIG;
 	dev = file->private_data;
 	if (!dev)
-- 
2.53.0

