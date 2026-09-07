Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BE740F72D
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 07:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788766606; cv=none; b=mngVkxTxhmCXQDwKIF8AKFwJ0jBdTaz50CBI9skNyBYNF9q8E33JK8afDGLlWkwEpwW+WNxvvr0cF80kayONmdaEzauw4RBY8h1aLsvipzZgCDz4abR0hdKBrUmOSxX4bxO7ertChJ/8IFGtjCvk5P5IMhGyeiVoxwCkx6zADPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788766606; c=relaxed/simple;
	bh=kqRj2jv0I4NF+6lcuVjNt4/LQfIjlcmrqnDtPGeJGaE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WNMOqtHNtvXTUxbn4UmwSCCl2dmZ42VRDlOKegD/lMVnu7amnuH34ApQpsPtsyw/X8x2A5htY52WMXylRy65ThqKRux5mhAB4bcn3TMo0bm0Kk3R3JyQiesEOFGiPUbrJ/bGH6kWYPXBQSVDWHLJDpJOxaHrGTZBobnCsqhMrNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=fdeIbMsy; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="fdeIbMsy"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ceab75934dso30814915ad.2
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 00:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1788766603; x=1789371403; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CJAEmWsVGDbSLSKyKhYWFjK15+CCWIug5ocm4DzmU90=;
        b=fdeIbMsyP6l8lBEChrsEoYG9HDS49FjwKR2ZFvkWGjUw5rQapHv7+Hn+6yiX66uUXJ
         7aN8WfDpDXkIzlz1wdO5LEXVHmk4RVZ8eDpsox4pgCWF/ML+Z9GJIKuJAsGsSc66gboF
         df222QdCwQG2p8pogJ7crMC+3Az41mbslQJcPYIULww5qKrDPxBf/c411qfdkR8YCUPB
         dYwexTWA6Ul9tI43S11L7oIRM5dtZhFoZT8/G7Q2KOdj9fxF+G7Qsa162jaeWz+yBQ37
         mZsz2EAPApxtccHy3zKazxbxeKXS/QkTodn2/1958L0bKhvKCoEV8tMEwtMqC5MQNH3g
         6HRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788766603; x=1789371403;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CJAEmWsVGDbSLSKyKhYWFjK15+CCWIug5ocm4DzmU90=;
        b=It37o0/u73yozTCFkGt1CJior5GY6zxG+JzSbcrB1JXXSse1iVPN5obuxNsW+ifC+B
         R/Sj5KKTyiJs93HaK2dlD3iGpQMw1OI5e4Hv7v0c3X/+pMMnlCmuskz4OkefEJQTH9gF
         oAx4a8hB2/LyVd+nGq+Wy/e5goBiOCM69xgyiZs8LFlLL3b+kaxH2f38yiMcodcYwFEb
         GrzU77NvguXlueWpP/7WKXLKeC7OGBB0pYp4K8vCpuLSF75jVB14Z99ISMJnrtvbPPfB
         PdCHLlMgLmHmJBgayXVMh5yox1lWUtW+C4ls90z9HGeE6SkFYknFOrFxJ1Hi4z5IiN8N
         RvmQ==
X-Forwarded-Encrypted: i=1; AKwUvBwF0zjJZppwm2poBrvZmyYqyfEFzQsRxts1X8hounRbWynNeVGv2jy57bnkywK2NjokzsI7erDkcy88HFG4FQ==@vger.kernel.org
X-Gm-Message-State: AFuF++llWw1HR+hn2Bi3WZLo8Dzhk8VTHe7i1e8/8hp/qRKDtvEFibqN
	ixBsNF69qXrsd+el0qzCVTPvsrJxAvwNbaowvHMmVJ7WxM+iALem0/3jPWWOmLEAlNI=
X-Gm-Gg: AYBFou0uAxN42dBZV6jtj8kLdz0OlpY2hWp0rDADQtcXp1i1bJiJWhYTGxvX4KG792/
	CUe80oEX06IjgZX4Okp6Bq+KFK4ypFko2M6CV3gbeElVlQSxv253jgsihCfDFy8O9zXRQ0/pPO2
	JTWOqYFqlZTUZRaHbSZZC56NWxmCy47k8UhcuO30BYb80MTNXIvpyMG/BE7W9YOrJWWIxAOrOrb
	BFE7nT0a4/8ohcNYrqjgs8bM0eN6NmN0313VqfpP9lv4nvRTKc2ZzjBLrlhyKeuiaP/25AxR8VE
	+igBQGVuBtyp0CUV24zD19pwHrP584VixXg9H2QXHdlzGsHrV4OAxLyEPJ6RwGsKDwvz1se8hDB
	IdtJZgnaiQ5EevEII2hYidPToPMMh4YXX8F/IKtNInvS9Tv8pkPqrTqX4U7y/VI8oTR2TCsTkld
	N9fbe+tVrJi1bruTnFxDgScpuq60iUncs4IoRqiHiC/Y5PrqXfLInCqRpv3IxwYvPGiwXyBu+6v
	P82x3eexbxVj9EGPpgxSLQlBXbMfuMS7RQncRTADuZSCS5FT27HNWiyUclNStoRnfqDIPM=
X-Received: by 2002:a17:902:ccca:b0:2c9:aae1:a61a with SMTP id d9443c01a7336-2db127cc2afmr320032415ad.14.1788766603510;
        Mon, 07 Sep 2026 00:36:43 -0700 (PDT)
Received: from localhost (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db1497d455sm41607175ad.30.2026.09.07.00.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 00:36:43 -0700 (PDT)
Date: Mon, 7 Sep 2026 17:36:38 +1000
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: Aamir Ahmed <elb12345@hotmail.co.uk>
Cc: Dan Callaghan <dan.callaghan@morsemicro.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Arien Judge <arien.judge@morsemicro.com>, 
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] wifi: mm81x: validate n_channels in disabled channels
 response
Message-ID: <if3rynkyvmxep4jadpqvbxei2j4ta3tkm56yvpolwnxwv3bckc@mtax5yg5yugz>
References: <AS8P251MB0001BD39926B78E73D53A439C8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
 <AS8P251MB00017F5BF791EA475A60A6CCC8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AS8P251MB00017F5BF791EA475A60A6CCC8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>

> Place the check before the loop that clears NO_PRIMARY flags
> so that a bogus n_channels does not cause incorrect flag
> clearing.

This is not really helpful. The point here is we are validating
the response length against the array size.

> Fixes: b1906cea00b0 ("wifi: mm81x: add mm81x Wi-Fi HaLow driver")
> Assisted-by: Claude (Anthropic)

I'd prefer if you placed this before the Fixes: line and use
Assisted-by: LLM instead.
 
> -	if (le32_to_cpu(resp->n_channels) > ARRAY_SIZE(mors_s1ghz_channels)) {
> -		ret = -EINVAL;
> -		goto out;
> -	}
> -

Your v2 is based on v1 so it doesn't apply. Please respin v2 based on
the wireless tree. Please also include in the subject the target tree,
in this case wireless-next (i.e. PATCH wireless-next) so the NIPA
bot runs.

lachlan
