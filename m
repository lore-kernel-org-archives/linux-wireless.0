Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6DF25A359
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 06:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784183256; cv=none; b=tiWW06CFxssqb/KMasZ6r4XPUjUMUQipt5SNu5cbXPj8i6ERcyLwWZXWQ1Z3y0JvuCEfdSXkMjuqJxY4bq+bZBeK9ULGLFjiBE6zuo/T8YcFT0zZL64qFIX99tJGF4CHiqxO5qi89NKIK/bHxSVWSFIsaD3NbPkl879np5Gh7s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784183256; c=relaxed/simple;
	bh=NRmZN6kBrUZzlGpzarB9t5FQkrrI+SYFTT7heTbf5dc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=agUT55KiaEINd21irDoj5G7SpXhH2DPxSHKYSTCb2q8AjUNK9Jlg/oNIWvSIlqeRmmpSSx804rhB8pzcy9+ePkb+KdTaYLcl4FRZWA8Ng0Gziv6HeGG8Id1OiELIBXZvLpCqEceJC3IS072P8pzZkgJVnwGa8irTUs6KwcEf8DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D2mVZ8J3; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D2mVZ8J3"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7e9f829d75aso1834331a34.0
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 23:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784183252; x=1784788052; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=efE77uhj9nQCyKWP12csM1pAoAvN9Mzss6mQMwg8AtY=;
        b=D2mVZ8J3KnuQwVnUNjKlV5DkACX7enxbYP7iwPS4hfgSQA7MR9n3cEeiUdX3xvvSmP
         AqayJm3uAwWwg1s36IfaVaZrm6JiIa7OLZulc7GrVSZHy4A6G5jnebfiRY4usSTvyWnx
         KOYIvsHO9jjo4acWOF9EOV6CKdW7qZ+x/eYcirv2cCe6CRqH64cubWCjD613+BiTUx8u
         t6EJv7Dv935sp9mbXd6+TqKwtlBrZVcyfP5MxlAecep2KpOH3HxffGArDCVQFtDsI7+2
         R85MHk8Fn/obMCcDncG+A7+qTFYj3r9npb4b+FFdAlPAoasHz4OFiJ41og6pCXCXlTab
         e/mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784183252; x=1784788052;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=efE77uhj9nQCyKWP12csM1pAoAvN9Mzss6mQMwg8AtY=;
        b=Q2uZiKW3CG/TLCSHIZeY8nvF+5+28TOpE093szLHcvwRJScYyjbiLeNuhL5X6Ngnfb
         Vans0l4a7DSkRA2njVbsvpDKb4yc78TwaUET+nGAkAa074EJr5Uz33Q8AZP1usoPy7OQ
         l7I8cf5lpWiHU9VKQlq9qsJCDG3cfpNE6HBWCzXOH5BIyxriBI1Cz6Epm0DBJwh5POu5
         7nSYyZg2SM7PG0ZZKjQwsi8dj0awx+pQ90350IdroFZXmJR3cAld96tHvUl+SalvhWhn
         RSHPpdsZAYmen+G9jRZl0X4E2moF1af1lEhjfo9wlaEWX4/owUdJxrCcgpEIXxqSDaL4
         YlZw==
X-Forwarded-Encrypted: i=1; AHgh+RrnNAYAF1JnVL9Te4mnyhEyPFH3rsKkdXA/Tf5G+kj2g+o3ZVb4T31IOQp/2BGxnDdWO0fb7F16V3duSp2ufg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyIwWT2Bn272ba1DptcbOpw4nEau1xgzUaiLGSDN3DphAksOXr/
	jA6zYt7CTU2fURRXEaDpyGo+7+g8i6Y9yu8sGePLRZr9HbUHM/Ypgkoe
X-Gm-Gg: AfdE7ckEol69Yufny3ZSGK0gfRAvkK1PFfaRMNQtPoxbKYvovAnyKP39B6bv+8dIRuD
	SjAVRGJ9r0Ws+mWrw12OGy2OmDd5bZSjmKTO6+JyT25rXi3H3ij0do8JI9ltgqkyTj65gygm29r
	9VIobNOuHOrm4rxF4YXPxzJzvWvFhpHNca/CT59gZC7H+HzCmBh3p/0H7asMupzhJ9ExWRWtZFU
	YkV9a8fSdqSI/r2QlsYxZuSBPGKaio5VNWHY1LGlqY++2ybhzrMVk/QahqOEDO/yKs1RsdeXcZZ
	l1uPFlcuhkqhngyjH/mFyZhN2qof8Ejh0xlSMgp0Px3uE97c/KLPFC8ScVIM5nTzu3+kj9FWwdv
	gxL/3O73lTtaNwEowcZ2LJvVnunuCg7zlB/WLU96O1SR/hK/EhDe2xp14mzbIDqfeHRq/Lg==
X-Received: by 2002:a05:6830:83af:b0:7dc:e37b:b5d3 with SMTP id 46e09a7af769-7ec096001bemr14090360a34.7.1784183252499;
        Wed, 15 Jul 2026 23:27:32 -0700 (PDT)
Received: from localhost ([74.80.182.90])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ec31ee6e1fsm7525573a34.4.2026.07.15.23.27.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 23:27:30 -0700 (PDT)
Date: Thu, 16 Jul 2026 09:27:23 +0300
From: Dan Carpenter <error27@gmail.com>
To: Francesco Dolcini <francesco@dolcini.it>
Cc: Georgi Valkov <gvalkov@gmail.com>, briannorris@chromium.org,
	kees@kernel.org, johannes.berg@intel.com, bhelgaas@google.com,
	s.kerkmann@pengutronix.de, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] wifi: mwifiex: replace one-element arrays with
 flexible array members
Message-ID: <alh5y74H5bJyDSSP@stanley.mountain>
References: <202607150932.F2A0836@keescook>
 <20260716001728.57799-1-gvalkov@gmail.com>
 <20260716061638.GB9973@francesco-nb>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716061638.GB9973@francesco-nb>

On Thu, Jul 16, 2026 at 08:16:38AM +0200, Francesco Dolcini wrote:
> On Thu, Jul 16, 2026 at 03:17:28AM +0300, Georgi Valkov wrote:
> > Replace deprecated one-element arrays with flexible array members.
> > CONFIG_FORTIFY_SOURCE reports the following warning when
> > one-element arrays are used as variable-length buffers:
> > 
> > sta_cmd.c:1033 mwifiex_sta_prepare_cmd
> > memcpy: detected field-spanning write (size 84) of single field
> > "domain->triplet" at .../marvell/mwifiex/sta_cmd.c:1033 (size 3)
> > 
> > Convert affected structs to use flexible array members.
> > - Preserve existing wire layouts.
> > - Use DECLARE_FLEX_ARRAY() for structs inside affected unions.
> > 
> > Tested-on: WRT3200ACM, OpenWrt
> > Signed-off-by: Georgi Valkov <gvalkov@gmail.com>
> 
> Cc: stable@vger.kernel.org # 6.12+
> Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>

Are we CCing stable for this sort of thing?  How many FORTIFY_SOURCE
warnings are still remaining?

regards,
dan carpenter

