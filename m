Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AC22E7375
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 03:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788753288; cv=none; b=XgnXJvRz59pU6H9vN/aNts7mPRi3ky3RCL+GCj47o4nEyI6o0K4Z87CK27E7H/ujjxLDcEfIQdLG3DBcLerPXLl0rCAYaxB7ZQvTJ+to1b0vFnq6DYJMoAEq1QTWddHl/vXTWJdwg96WFE6UzdqWem3uuh6qc1+EEPJOvwq4Ang=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788753288; c=relaxed/simple;
	bh=GZVBBmeFqxwYT71GX4TctZ49vIOOBe+lTxvXYNFUw+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=COOYl7dbUIv3Wo+qHUnYkHzzXjHISM0QME6ePUM6BtWSTErGk97sr5YV3YTxQJQTO/cY+SkxbA6CbB8b8xDzQuAwdhWXSw8vGiQBMLQkeo/I5I6lzFGrO0wByQ2nIQjdzki2nqXLbcOPVq5qs/d3MXubrMx1QJFgZpqX45h6KrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=pwunB2gF; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="pwunB2gF"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2d942c7cc2fso23933925ad.3
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2026 20:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1788753286; x=1789358086; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YwFTU9DGxIbLpOSpn6SjG8b5qEPfh2a5dv+JDDxbYe8=;
        b=pwunB2gFq250CPWW3O0MfXXLM7waEtRYdaL0kED1VEJ9Kyyrnk9GK/TL/6Rtc5LiOr
         KRNX3POWN8qSpLolqGmHPgNWal0Y+algXZeDMBIYGQP8CB6FZUSr7iWmqwAO4yfTVlgt
         oo9sB266vmlZAdJCghqDs46AgOM//vxeu/lRMbm9xIiuKcBx2IGxWarAGImU2hUnsS9+
         6r1XKkm1bWolhAmhvqLiNWvf9FXv7unbzdLcmxRB6xRgwSqam9YKSmNhNl8FBAjPpasd
         TMkq3xiN+KnhIPkUUg6PqDICn7cGMpuuOuORBhiROhouNBQMrxmw7lQNJ9tNOgzi8Lvq
         +BhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788753286; x=1789358086;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YwFTU9DGxIbLpOSpn6SjG8b5qEPfh2a5dv+JDDxbYe8=;
        b=CUKj/nes2CN2Ss2F4JmUYwiS+cG4uYq4rh+mpfCcnjwnUU2k7z2nQN/u+vyz2u9qEi
         NZsnQtlkMk89fxXlkc2FyNl1o+XU89thfaUQF2D01Kk63K1kPYmD8uVwcprc1EIMPsxP
         wOtUlmonU07JPAqnlec5JwZCVo72BoXykuvqJ4rW9l/3zCxarAkw/Bf6Yb03CBeEcWrl
         jpr4v+TrmN67gN+HuorMGSZ4G2mLnIj2Q8o9+VTtAx72iLnO82EdMqwPargTi8LkSQ/i
         g+ZemUBN9STqinV9t0ZHqiItx3PSQFHcmoK04J1MlRTkTVykGN3P74SM2tuB1uN0mose
         sUCw==
X-Forwarded-Encrypted: i=1; AKwUvBwn45zhC7pw+bFkOb0Mu+iY0BaJqm9tTM0bjKhOLndwQOSAalooakDvHjFm4z3qnUjizzRUqATrkfoP85AjQQ==@vger.kernel.org
X-Gm-Message-State: AFuF++lVYf89BAS5xKR6VHtmMexbzonCA/+N3z7j8hL4bKRO3DrzjjoK
	yBbYaaHRfELKoovKHZIZ9r4zMeYhaHEmguIwKV6U+DvBzjSHfIUGodKxKpad/y1vS0E=
X-Gm-Gg: AYBFou1LQTj0Gf2C96BdFoZNsPLtYW0sO+6m/5kw+Bym7icmkXRvBNNUBaew5RApBvj
	18NYedpafdo5EwfSNSnniN9RKUfCL93miIBtEFeUCnuCOD5KM8NTx/KwuAIJiNBFD5auM4QHj3o
	wX51VCTiqkGfPR41oka940isAGWhkFiq7n5C+gpf9Yf+MEPdCC8hdVZ0P8rPhfo2p62k9eMzEU6
	+aqlatdWYwaWrZyV+a1lD140m4MKB6S+53H0n9CrJL47iSipWQUu4BQyq5x9/vaKaBWyToOkN6Y
	tHIh6t5c9r7MsczJ/i0MIlaERke6YrYvqu7roT9iKoveAYvmv7c38vFDjIwAL3uMjGi3wXlLCbw
	yJ5ypIEBEnOh+AmoL8mpy1paU1H6GUJl7qL2JNnKcfZRSaHyw+mXjKQ+83qYSwDQcWDlHZSWtPa
	iP90q1MwFhek8fE0EZYn0VTmU5W5nd2Seqf4SYVFxRFmz6gnvIuVqLLqN8C/tPTB3SE7jho2wF6
	P4a00SDlH5aNNKO/ZEKU/jDNuLIWG2nkp5nK3sgZWMM6cCvCNYY6Jz9mcIR
X-Received: by 2002:a17:902:758a:b0:2d6:e4ff:9cad with SMTP id d9443c01a7336-2db1250d832mr228413905ad.3.1788753285588;
        Sun, 06 Sep 2026 20:54:45 -0700 (PDT)
Received: from localhost (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db149ccb2bsm37885875ad.71.2026.09.06.20.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 20:54:45 -0700 (PDT)
Date: Mon, 7 Sep 2026 13:54:39 +1000
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: Aamir Ahmed <elb12345@hotmail.co.uk>
Cc: dan.callaghan@morsemicro.com, linux-wireless@vger.kernel.org, 
	arien.judge@morsemicro.com, johannes@sipsolutions.net
Subject: Re: [PATCH] wifi: mm81x: validate n_channels in disabled channels
 response
Message-ID: <hkev7i2nbiohxsgir5k6dycbfibli4wdppmvaadhepdwkcmg3u@k3mimegwq6ox>
References: <AS8P251MB0001BD39926B78E73D53A439C8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AS8P251MB0001BD39926B78E73D53A439C8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>

On Mon, Sep 07, 2026 at 03:25:52AM +0000, Aamir Ahmed wrote:
> mm81x_mac_check_fw_disabled_chans() iterates over n_channels
> entries from the firmware response without verifying the count
> fits within the allocated response buffer. A firmware response
> with n_channels larger than the channel array size causes
> out-of-bounds reads from the response buffer.
> 
> Validate n_channels against the array size before iterating.
> 
> Fixes: b1906cea00b0 ("wifi: mm81x: add mm81x Wi-Fi HaLow driver")
> Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>

I think you need to disclose your use of AI [1]. I think the preffered
approach is to insert Assisted-by: LLM and not worry about the model.

> +	if (le32_to_cpu(resp->n_channels) > ARRAY_SIZE(mors_s1ghz_channels)) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +

I think this needs to go above the first for loop right after the call
to mm81x_cmd_get_disabled_channels. If we were to get into a situation
where this somehow happens, we would strip all NO_PRIMARY flags and
leave some edgeband primaries that should be marked NO_PRIMARY as not.

Also since you are looking here, might want to change the uint that
mm81x_cmd_get_disabled_channels takes to a u32 or something.

lachlan 

[1] https://docs.kernel.org/process/coding-assistants.html
