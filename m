Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172053D9558
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 21:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785877404; cv=none; b=NOrkSpgNWHE+KKvIq5WfB0wfzjwBIZwEk8GPbtHx1l+WNKltTox8EV/ALJ8JQnh0EHIod9RfkUMqDO1MeByQRUt6iUJ5fCTgMUBR/cKSxCLBBMlQH7Nf1RyVWS7Sd3CwrYrK6Q+nkEw5COSdo1qatOk0jBh6UC9kfZMiAzFxTR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785877404; c=relaxed/simple;
	bh=Nq480V9rbVIvPogmTMvxGbvQhA45ynkBc7pX8U92kIw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bp2ngzTczollTBXwzbvzp96/fA1MZrUqjq5SN+peHaXxwwIzW+GpaEBKleHeWMryZM3bWFCxz60uuZeiL4n+YcqCqPfrvdtXUuseNCEUxVsIt2KtXoDE6gbEowcHyW4iwh3fzwkf5tm4+9ujiqN9PMLiNV0awtRd+4IhODbSOC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DZEASqqg; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DZEASqqg"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-47f7872abb6so117732f8f.3
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 14:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785877401; x=1786482201; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tfqi+sPLHjcIbbi7QX6xu9XbeZElNtuKW90eUTRnvgQ=;
        b=DZEASqqgGDvHo122sAN9Xi6tjRbgbLic0UL4Bf4cs3pTkeIRuk/f1lZpHaStjVanCL
         5s9o5TWCiX0Wb72wToH2V8C6keA72sIgn7SA3/630GIwt5v0+6z71AxIGJOTeTDa/1LW
         B8SAtVs2qfTgYo3UaUylmgO3MfTQANufR/RG7MFn4EZyMsDKlnM7JWqOTU/Vo2X6kSyT
         IMTCjsj7WkCtIVGQ78ZmeVerdS8QrfgunDTCZKUsRur2FMGr4Z6n9UfEK1eWDR5vxW0E
         0RUXdLA+m9n31BMkRBLJzPnpr9+gASFV7OAtsZZ7cjJWVPbaJr8FKOK72diWlbk3MiyZ
         Ju2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785877401; x=1786482201;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tfqi+sPLHjcIbbi7QX6xu9XbeZElNtuKW90eUTRnvgQ=;
        b=b82HyiIm8E51mHXHc/huUjtoHDJiix5E4JKvVQb3PwS3oX9KSffyHLoqln8E2mIPAi
         9rq6sjoTaTSd+UfWK6FuGvjVs+8s1Qv0UBow4/JQ3YSsTNfD2yoyhaqj2fvkjOmjhUG5
         TGLgD+qy/1RxC6yDKr9pS1GjkvgN0Q09tYavp6JPAZ+UhGkWP8bhUMhQQEl2upG7tb19
         7y31MK1nzasloam5hwKR5zFeQIOJWsbR+z0dT6MWhkQ+iAQOpQGCMvX8i7CKv4PPyCYT
         7+OGXNpdtkuWlkjN8/j2gPn5srIzwk+wg8bPiai6T8v7L298Jb6PtAy4TWCeihEKHa5X
         TAng==
X-Forwarded-Encrypted: i=1; AHgh+RoEEnOQAUYxVZqxxShXcmyPfErI82+qwyPoIYtwhBDQP5CQUnQbyrVO9b7JK5frymYeY6Qls+CiCga0s+0Rgw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyDLYV/mGxZicV1WJrsUATqq8BDgBztXgC2ebamod8+nB/gb+Ip
	HLh0nwka+/cxV2CWs56ySYKOua5hJ9mRe3oMFbeqsu6yKrOJmXIzXYDL
X-Gm-Gg: AR+sD11NpYzH8RmQLMYiAefHbXKYs2ysS+Pq8pQsRkjw9AC7Fvv7SAjIYQtrBqNiMdN
	9j8jEB1ue4ww+iPqggAcU9rIqpUkwfybv4GbklIgn1O8e5n5dA7ljSfKXYt1311SLPkJigp4Ryz
	BmFuYSiNwk4q+v5DKcsm6zDgO+mf2WRsTvuc9YGInrqebkCApdbpEKBAlyPg/sP2HdmD5rrOh3W
	s7WnSO9ss4LJ+U5+D4TQG15Xa0VQ7oWKeXSqgsnjovF/tYrEk+OfZ8ZnQI3//SWVEMRvOWNOsdr
	vf6EzGNWPITGxTz4oPSXF4dXslljKB2eqnmto65D/QvSpHIHOn5a6oYvOsWlzToJH5IZFzdrSdn
	mPB4TPMP+WGxC+ZVuF/gLBIlT3dCzK060w8XPxl2Ii4jeXBqSWjf1rAlv5jJUpoxgSELs+8eoe/
	rL+h2s6aJIgsLflqgUZK4dZ0iCtcrRR3ClelsRzjSHHImg2Uy01yjg8fze0HV/1cFZNq+vESti
X-Received: by 2002:a05:6000:2486:b0:47f:80df:3ba4 with SMTP id ffacd0b85a97d-47fec62aec8mr3010273f8f.28.1785877401253;
        Tue, 04 Aug 2026 14:03:21 -0700 (PDT)
Received: from debian.local ([2a0a:ef40:e13:1601:335c:b8a1:fe26:15c7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47febfda11csm2897658f8f.1.2026.08.04.14.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 14:03:20 -0700 (PDT)
Date: Tue, 4 Aug 2026 22:03:19 +0100
From: Chris Bainbridge <chris.bainbridge@gmail.com>
To: "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: Re: [REGRESSION] iwlwifi IO_PAGE_FAULT and Master Disable Timed Out
Message-ID: <anJTlyrKsASh9gZg@debian.local>
References: <amzVtgQb2p-_nShU@debian.local>
 <DS0PR11MB78800B96A0FE637DC5390E4AA3D62@DS0PR11MB7880.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB78800B96A0FE637DC5390E4AA3D62@DS0PR11MB7880.namprd11.prod.outlook.com>

On Sun, Aug 02, 2026 at 07:24:04AM +0000, Korenblit, Miriam Rachel wrote:
> 
> 
> > -----Original Message-----
> > From: Chris Bainbridge <chris.bainbridge@gmail.com>
> > Sent: Friday, July 31, 2026 8:05 PM
> > To: Grumbach, Emmanuel <emmanuel.grumbach@intel.com>
> > Cc: Berg, Johannes <johannes.berg@intel.com>; Korenblit, Miriam Rachel
> > <miriam.rachel.korenblit@intel.com>; linux-wireless@vger.kernel.org;
> > regressions@lists.linux.dev
> > Subject: [REGRESSION] iwlwifi IO_PAGE_FAULT and Master Disable Timed Out
> > 
> > Hi,
> > 
> > 0eaa1f245ac0 ("wifi: iwlwifi: mvm: don't support the reset handshake for old
> > firmwares") introduced an intermittent boot regression on my laptop:
> > 
> > [   15.974991] iwlwifi 0000:01:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT
> > domain=0x000a address=0xbe9f5000 flags=0x0000]
> > [   15.976184] iwlwifi 0000:01:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT
> > domain=0x000a address=0xbe9f5400 flags=0x0000]
> > [   15.978501] iwlwifi 0000:01:00.0: Master Disable Timed Out, 100 usec
> > 
> > The commit only contains:
> > 
> > +       /* Those firmware versions claim to support the fw_reset_handshake
> > +        * but they are buggy.
> > +        */
> > +       if (IWL_UCODE_MAJOR(mvm->fw->ucode_ver) <= 77)
> > +               trans->conf.fw_reset_handshake = false;
> > 
> > The if condition is evaluating true on my laptop despite using firmware ty-a0-gf-
> > a0-89.ucode. So I suspect this is not the correct way to check the firmware
> > version?
> 
> Yes, seems like you are right.
> Thanks for the report!
> 
> I am attaching a fix candidate, I'd appreciate if you could test it.

Thanks, the fix is working fine.

Reported-and-tested-by: Chris Bainbridge <chris.bainbridge@gmail.com>
