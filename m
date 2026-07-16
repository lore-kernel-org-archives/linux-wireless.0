Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FEC1DED42
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 06:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784184948; cv=none; b=lZ0VqX1T25RXKVXiFWGPSVSPp9MS+ISOENvPwFaiYvD1HhcXjUamudEh5PbPWaen9LXm7SPMpeXSQjCJOlHQ/YBGbCobsPLZGrh2kPGxxxZiItB5MQ9mD0Urbybm/VcV+UMiwLNfhZD2JcH0/+XPu5weGYhfup+DUvhXOA3Uqx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784184948; c=relaxed/simple;
	bh=5aFC7UIJ/0MkSOfFxU38E5MSc5aE2gJ8tn1j4wAS9QE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LsIj6tLMtjj+BY5IPB5E6seCluaKAskKg6AdBA6wCz2fosG/6COGl7l34T41ZGnyRWZ/gVRwD8vgkhX0TWjoxPzYs5WC/BVsBqym58XdurqbKU6RPuyEw4G0p0IrMi7dGzZMyWln/o4GJ+WkEHWS/CzSjurXNxoLI7LyRj0vDSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jZAcXk3M; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jZAcXk3M"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-4a2fdbb7be0so2733197b6e.3
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 23:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784184945; x=1784789745; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CzxD1cLTPriwoM1nM4cGtIKasJcP9ac2Us6YiJuTHfo=;
        b=jZAcXk3MAaUJmUxp74zjuT734o8Er8twcjEMhjwQ0Pi3ZGPLvOfmPPyefcxOqLeBA2
         F5lqsitTzAFoxnZPsGhxMJrLXjIxuFZ4ymGVCm/DY+wmwCEckGd9NeC2s1Uef6NODJ1S
         VaWZ/laXr24jCVzja7+4SbYXmlEJtU+NLvKr/0fN185cnuYkwTpO5F9QqTbOq1RnxRuQ
         XlF7r2OGq9PobprhKlIBnC1fdAGZvAfQLERI54vKR3ooLxYSFaStT9B+ndOLN7EYU8ke
         rj7JWZk2INDuR0tWDxwIJPLhxFlVSri3wSM8yflFs6mbR2w57QsOC3me3BcAk2OAeMCC
         tDWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784184945; x=1784789745;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CzxD1cLTPriwoM1nM4cGtIKasJcP9ac2Us6YiJuTHfo=;
        b=W+bO/Xj3S+C7ui1AVYFEUz+/TBd4VcomodP4yGA5LlHKZM6ezJ+gosHSzrfFws13D+
         K4lonprPrFrQGErildy1KWRMF1jEER32Kqg9ZO3y6pEBoFyNc/hiBrDRGqeJOE3RxOJj
         tQ/sIavy5trGL/8lrZOKd7wymfSwLwcg7hGEohp4XKm+uZBeWEKGy6+uzimguAJCMQXJ
         B/DnTqqFCNZkAZqZc2OQj0PpZrCJu7NCwvDA0PEbxTQfHoAWj4uhTkwTaK2iSeCM2Qm5
         HNaoyDzj2xhfR2brj8uWDQ2Wal0pRort7OMsoft3DJiYO8z3MGw+tLofBucPUIvVOw1r
         Wn0A==
X-Forwarded-Encrypted: i=1; AHgh+Rr0Zo75mtwNZ/uScphKr8Q/sNXyMldFIoywXBdBSsr/RSSapXe1/8hRPgBKCpVTnTqbflQaG7a2b0uLXAmsaA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0eesDHlJwU9/04jEvkQ0vdmI6GV3wO4Vm8VH4d+uZuPzhTudR
	+gzJCuxnD5r/9Axr7v3IlchEjgcfUf49OROa01CvQDpX1ODvUhLvUOcg
X-Gm-Gg: AfdE7ckTsjVaaNC0p13HatL1GoDwti8yUPRM7U7wMQ+ULnKuChqv1Hj1Od+8RHoqHbR
	hp5WJalJJlkVbp8x1pJnR/0mZDNYH6C8QqtDg8E7H1C79OJQ5JsF/+pW0qO4ftQTOuzpb8/gWCY
	Ll5eu0ySS3wBIWhGzhSposmpjxrnqke9CYtNmkMw8CMz4P37DivpAARf+tsg9P0CMDI8CydOJ/E
	r5W41HU1shMyZbIa5Hkf+wrZz4zHMyobs9eHsSrZQtrAhjUxgxBvy/B6F/Ya/ybwAMQEoquvmJI
	/Z3Q64YScKme/Nc0pFS9kihCJLj47a/rFg+I0v2E7MexH+p2ZH49O0F/OdCE3O3/64kff1ztsKl
	AO04mAsfYoQXhfIitakh5VeUWndHSHDtrFxa77vkTXoZed+vckJ9ApMFJ1J6FnSW7VNnwAmf7/D
	uXiOPy
X-Received: by 2002:a05:6808:8947:b0:492:285c:4da8 with SMTP id 5614622812f47-4a495eab7b6mr4246595b6e.13.1784184944575;
        Wed, 15 Jul 2026 23:55:44 -0700 (PDT)
Received: from localhost ([74.80.182.90])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4a42ae81f1esm11281900b6e.11.2026.07.15.23.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 23:55:43 -0700 (PDT)
Date: Thu, 16 Jul 2026 09:55:36 +0300
From: Dan Carpenter <error27@gmail.com>
To: Francesco Dolcini <francesco@dolcini.it>
Cc: johannes.berg@intel.com, Georgi Valkov <gvalkov@gmail.com>,
	briannorris@chromium.org, kees@kernel.org, bhelgaas@google.com,
	s.kerkmann@pengutronix.de, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] wifi: mwifiex: replace one-element arrays with
 flexible array members
Message-ID: <aliAaHF3NgwAZ60v@stanley.mountain>
References: <202607150932.F2A0836@keescook>
 <20260716001728.57799-1-gvalkov@gmail.com>
 <20260716061638.GB9973@francesco-nb>
 <alh5y74H5bJyDSSP@stanley.mountain>
 <20260716063246.GA17850@francesco-nb>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716063246.GA17850@francesco-nb>

On Thu, Jul 16, 2026 at 08:32:46AM +0200, Francesco Dolcini wrote:
> On Thu, Jul 16, 2026 at 09:27:23AM +0300, Dan Carpenter wrote:
> > On Thu, Jul 16, 2026 at 08:16:38AM +0200, Francesco Dolcini wrote:
> > > On Thu, Jul 16, 2026 at 03:17:28AM +0300, Georgi Valkov wrote:
> > > > Replace deprecated one-element arrays with flexible array members.
> > > > CONFIG_FORTIFY_SOURCE reports the following warning when
> > > > one-element arrays are used as variable-length buffers:
> > > > 
> > > > sta_cmd.c:1033 mwifiex_sta_prepare_cmd
> > > > memcpy: detected field-spanning write (size 84) of single field
> > > > "domain->triplet" at .../marvell/mwifiex/sta_cmd.c:1033 (size 3)
> > > > 
> > > > Convert affected structs to use flexible array members.
> > > > - Preserve existing wire layouts.
> > > > - Use DECLARE_FLEX_ARRAY() for structs inside affected unions.
> > > > 
> > > > Tested-on: WRT3200ACM, OpenWrt
> > > > Signed-off-by: Georgi Valkov <gvalkov@gmail.com>
> > > 
> > > Cc: stable@vger.kernel.org # 6.12+
> > > Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> > 
> > Are we CCing stable for this sort of thing?  How many FORTIFY_SOURCE
> > warnings are still remaining?
> 
> Yes, you are right, my mistake.
> 
> Johannes, please be sure to not have the stable tag in once you apply the
> patch.

Wait...  No no.  It was a serious question.  I guess these warnings
are pretty annoying for a real user on WRT so it's fine to CC stable.
I just assumed these warnings were more common still.

regards,
dan carpenter

