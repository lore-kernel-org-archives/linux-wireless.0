Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3393EB7F8
	for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2026 12:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790426038; cv=none; b=ecLvB7UhA0+aFYVVjHDU6QODZD3jmBJWfnWaZqsId0ReR0ROd4yQbWbQuXWPn8z3Tc7S285BprtzHRNHfQuV26j3ES+uURH9LuBMT6rk1Wa59VknP+brjjVZk5uYSzW2M1AncOJR5nIx7gRDQ4IIWVNEmjyRCSZja/Df3I4k/mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790426038; c=relaxed/simple;
	bh=/4j4hh9IfSjHBiMji1LzXBY4+qvVL/UoD1uCiHyYsag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aj0pIIPeOzdy/mjsy8iu12TD6aJNr5g+XAoBFa5q9MqjzL0m+2KarRG1tSWYpHzuAXirUm1E6vBtTNfPj/PoXhJUUgqBJ7Ypabhw9ZFi+gJirGricGWfq1cqtE0D4HSIWzqLg3ZXQ9wQylQDWs9sANqb3ifuBVD3JUoF5nqXHNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FDc96USJ; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FDc96USJ"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e83a388f8so11960095e9.1
        for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2026 05:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790426035; x=1791030835; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RzMeIs9tBh62lQd6dZPpENkTHWEmBkK/bt48HVj5kkc=;
        b=FDc96USJwb/N2b/3ENhK44ELnp/7J8D6X9fahPG7k9HZQ04OV5jXJ8y2g4P+mQFFo/
         IYMxVOj3vXziRi7ngEB1eM6c6bC4adWi38GPcyGz55FTjdFwt5vuPiAeoEsuyAGcWHV9
         8SSRs9psVKpHmr0JQkZznx0AFGa39azVat7du1i+8k/7HFxltdscYl5lbI4Bq98KEYGr
         KS9BAzIyclkPZfGrQwMSX6O94uad06r+tF0IpEEO5lTmoHwLs7HJhdzBke+5zHyaQFIz
         Rfjkf8txBMFlbCtfdHF1BqQwgO3NAFT1O9nNWTV/BmviN4tnF9XAGTR3iX2E3f68OEdT
         0bsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790426035; x=1791030835;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RzMeIs9tBh62lQd6dZPpENkTHWEmBkK/bt48HVj5kkc=;
        b=0ghS94jviVWE9YHbFnfMbf0fwjRpSseH3Tb4s7/n1+tZnoTq1dSjpynOa9S3GVeuL2
         jceCDzvlUXywSuw2myJ2I8FgvzvmZwfSdHOFBmpx+kvDWbh0ofxqSwX7yV/Rum4Bb0tC
         JNqkpvl63FhUyZG3tlmMTxUayyCjNQzCCceDmiLw8QHepLw9QEbrWUspWnV9wCT2qbWW
         nHMrYc2czDSUTP9AQ9PLu+D0dL+0Z2dAzhcSOEVON83A81iipJHx/H9QTiow+baa6MTj
         q3DWeuHiyzbGqpQ10So5KD7tZIaLOPOllgckXoiS8/WRXly3Z8Q9lSatYI051jtQ5CUT
         EQdw==
X-Forwarded-Encrypted: i=1; AKwUvBw5mJQxvVALsBu+a01cbgYgdnIayD6qZ5sDiO8wTW5xz0DWNFItarwZrw2m+hg+D90U/e1qBxB7tHrwQjy4pQ==@vger.kernel.org
X-Gm-Message-State: AFuF++kIZNix6hQ++vgw2UFGB0tolzr2RDL1PeqMWenthvpZK08Cv7Zq
	UlYTfchlPdDAhYpH87cW1LJK8hidN9qdf7iR0hW3CJeEydXypXJfUiGR
X-Gm-Gg: AYBFou1tviqZnTx9T+uvFyNcrSO6fHR6l01FR0iw2ugW3XRwlB+16JvnfryDXiWVMP6
	KGrQNsLSGjMMfBpzeJBO2z6pPmrErgBKLdflfnnrEXBfm1CudK2P9Bj3WMFYXxd6jCPbDXUJ7V6
	k3cO/4ETQZwaDW+dLz6ivmMgxl4nDyw4uwRQNMZbk0x33C9Zaxov07aWNRCjVWICyQF6LbBI654
	WTvsP6IpnEF0mr4p6FKGtqoZYZonZIDus38nZaRgwwMWVNdJsOnjzl3qrdX/QLJUaLdrWlri42Q
	S6Vri+7XrGeV8d6jbwR5ae2svd1q5nUqf57uSCYoVLcyjvNDWD2Fhi4PyPrFZlwrbsYfEAb31ZQ
	JVCWeE1UJGpTrhsibAGUsye0VmyvPrjxt6KqqUbIG93dwxQcr+wwA0u/BIFgJ7EtYqZmgaYWzYc
	HqaAENJt0KQINXAhh+tXNL6miZkxbkf4oPmRfJvJtWSSTaBCvoHpzasySKiZdQ5NdynS8=
X-Received: by 2002:a05:600c:c114:b0:49f:fe79:62f1 with SMTP id 5b1f17b1804b1-49ffe79648fmr12725635e9.27.1790426035118;
        Sat, 26 Sep 2026 05:33:55 -0700 (PDT)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fe5debbf4sm264713115e9.9.2026.09.26.05.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 05:33:54 -0700 (PDT)
Date: Sat, 26 Sep 2026 15:33:50 +0300
From: Dan Carpenter <error27@gmail.com>
To: Jiale Yao <yaojiale02@163.com>
Cc: Jeff Johnson <jjohnson@kernel.org>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] wifi: ath12k: Reserve space for a string terminator
Message-ID: <are7rrYpcnzocHNi@stanley.mountain>
References: <20260926121250.3258285-1-yaojiale02@163.com>
 <20260926121250.3258285-3-yaojiale02@163.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260926121250.3258285-3-yaojiale02@163.com>

On Sat, Sep 26, 2026 at 08:12:49PM +0800, Jiale Yao wrote:
> ath12k_write_htt_stats_type() accepts count == size, which fills the
> zero-initialized buffer without a terminating NUL. sscanf() then reads
> beyond the buffer.
> 
> Reject input that leaves no room for the trailing NUL.
> 
> Fixes: 8c7a5031a6b0 ("wifi: ath12k: Fix buffer overflow in debugfs")
> Signed-off-by: Jiale Yao <yaojiale02@163.com>
> ---

Reviewed-by: Dan Carpenter <error27@gmail.com>

regards,
dan carpenter

