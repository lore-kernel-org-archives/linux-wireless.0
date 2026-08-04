Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A14635AC09
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 07:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785828324; cv=none; b=VeQoC0gUEMvotJLf3JObxopf7RZuTdH4T3q4Iin+r41RNviBJuzeIab/kio4q06v8mRq8flFRKu115H3imZrfDxGo0hghVJjHIHLSkGwDCItWcVGra60DIrsqmxJMtFnovM5XfuZSnIYHBbS2a5l6SNuoOSOx0DSvVTRNdiodBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785828324; c=relaxed/simple;
	bh=CmmKILoUf4Nc1iA9ndr87Xgs46tBgUoaAOdOPtTjMok=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qzeo9tWdtMDX6I0ZE7mNpMgMRaUi6/Q1rsei6peU7639tO4Iew6iLPIUX1K5ecrAgdEeGlYcCmr0tRFCDmnDeLfMfP2qSfDuZQhXpKcRujkvIGM4F1ergI0Qaaj+wFkbOtv/oqeGw6Mgpw6Lol1RiMsFnwE8NnAGsZYrCU4v0wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HGpLCbtD; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HGpLCbtD"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c9e607d81fcso2423499a12.2
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 00:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785828323; x=1786433123; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=D8wLoGKL62KWsMJjZ0jpxf6dNKR9Bv91d9plaxwlCI4=;
        b=HGpLCbtDWLpb4lnej4u3cwZcDFq4XPNd7ds8wdulA7Tsorc1CEuT2/I8y2lcy3ZoTm
         19fot9ItnKdvRN+TIL3ydolqDeNrpuIyIXvjV2Sk1nHRoGBtYK/NzjMFLsJR3XFutWzf
         VF7s7KI8UT3oFE70ahjGFb4uJsjz7X9ykMzwGQCeFpaUVKQEBaBu5FlBiGUTFdEy1ssj
         Ot4cKmjwA2nzrFDISeqMhK9vp7ObwtNzZ9QEeaKuMdc2uFlIgAGNm3zGqzD8I0EVzdYR
         YsAIbrHmIGp+R3mVCr7Tj+iSOpUYYyJucWeXmLyYkd1OB4ygG05kABzCeugFMlpBJ9q9
         1tqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785828323; x=1786433123;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D8wLoGKL62KWsMJjZ0jpxf6dNKR9Bv91d9plaxwlCI4=;
        b=NGw5shMVSHDB6jM3deJ/74ISAfRC8lfQ4cC+av2NV/j6kSy9jXLDQv2RZbD6LFxcVs
         QFRQXMCN1H4uIoEfkMNq7gGCsoSz4MI4nCUfFSDOPIa5t3AE/ZQyjRyCY50EALWdmcll
         9muJn9LUfZTEmWGUMbkaACTKT9LxtSTDbheAa8+66Q7OQ6H54JEoGlb11hIxLczKbiTs
         qIC9uH1Kiud5VGlLAnStkFHTVEwcdBJ7x6S0QVf64EeiNlSfWATlrnEoKI04qab/NkLR
         0xwzMZGGYKGFqLlIMfbP+nwnei7lQDuXjc62woYwSh2Bc5EN6TH29leBsPyR8wqAunR0
         Bd1w==
X-Forwarded-Encrypted: i=1; AHgh+RpSztmZUwaMgdQOOypVjxJJr6EZ4CstkfoXefm9DhUQxL7mq/zx7ruHiBewDQWl/IA2HiFAmmerf+OBarpGSg==@vger.kernel.org
X-Gm-Message-State: AOJu0YypTkTDNY8Yy6ReGTzKZ/vXIUW7BAR3rRjRULyL3m1Iu5M9gLXc
	nBGo+cFdtYFiXyzOBmvMrhotf2HZbiSYiKZvFsP2lfSPfHuUymZTFfV6
X-Gm-Gg: AR+sD12oIWPK2Gkatm08aJ+s6TozhfliEEAdDSJ9N7zqmhsndnfLqDqcgMn5YeUUeAA
	RlH6iKFgJzqEbT2dZIcdkTu2r9CjHijVdE9lqINkfZHwBru2yIKposAmCRhMyEOYNqT8HH/U1AC
	ybnUvp7c71Z+ejDAEMxci2eE74ydUXEZ/4y1VeKF8F/cS5f2DJZBJDXgqPknCloFFg4q3fmGrQ3
	0nurcKWVjf3Syy9Vh2Tr3DTh61Ti3VkB+YuZZm9GtOSL7Y061UUpXns/IhnojnuPXD3vEcQTSLH
	j+LgAczddY/WShD0rD/rXAO5rD7mwNN/rIn+umf8I9qJGrhrtmnXFQYX/Rk8YQDc/BUpIhYu6kf
	dewakaNMrpbFbIkYNySjhQ7xJXqfcMJd8RQ4/VdXfArgXlKmmqOnNTwWdBk10Ic+Wibv7xFvOr2
	bptRWMk5RfA0CiJZwRB3y35PkZyG8nsUa4+h0djcqiT1tkswHrUBPZfvnl5SUI2sUopifprkf4E
	TfGsz0mgkE6a2gb5q79MYSPimoaCJEVA4Dxf8Pf6SEJjGPPGr6VHQ==
X-Received: by 2002:a05:6a21:7002:b0:3bf:7ab7:98a4 with SMTP id adf61e73a8af0-3c92a833c05mr13846710637.27.1785828322718;
        Tue, 04 Aug 2026 00:25:22 -0700 (PDT)
Received: from nxpwireless-Inspiron-14-Plus-7440 (61-228-234-35.dynamic-ip.hinet.net. [61.228.234.35])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbe396ea598sm4746025a12.19.2026.08.04.00.25.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 00:25:21 -0700 (PDT)
From: Jeff Chen <chunfan.chen@gmail.com>
X-Google-Original-From: Jeff Chen <jeff.chen_1@nxp.com>
Date: Tue, 4 Aug 2026 15:25:17 +0800
To: Linmao Li <lilinmao@kylinos.cn>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: nxpwifi: bound uAP association event IEs to the
 event buffer
Message-ID: <anGT3QbxuUSLCvCe@nxpwireless-Inspiron-14-Plus-7440>
References: <20260729082457.1897303-1-lilinmao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729082457.1897303-1-lilinmao@kylinos.cn>

On Wed, Jul 29, 2026 at 04:24:57 PM +0800, Linmao Li wrote:
> nxpwifi_uap_event_sta_assoc() exposes the association request IEs that
> the firmware reports in the uAP association event, which the driver
> copies into the fixed-size event_body[] buffer.
> 
> event->len is supplied by firmware and is not validated. A value smaller
> than the header underflows the subtraction used for assoc_req_ies_len,
> while a larger value can make the IE range extend beyond event_body[].
> Subsequent IE parsing can then read past the adapter object.
> 
> Validate both bounds before using the firmware-reported length.
> 
> nxpwifi was derived from mwifiex before commit f0858bfc7d3c ("wifi:
> mwifiex: bound uAP association event IEs to the event buffer") and
> retains the same unchecked length. Apply the equivalent bounds check
> here.
> 
> Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
> Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
> ---

Reviewed-by: Jeff Chen <jeff.chen_1@nxp.com>
