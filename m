Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC5E371889
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 18:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790879503; cv=none; b=FPDfS26v7rBmYF9k7hX/wQMKbU96OVTlb2092OxXUfremmkf6Brbw/D3rEY7QrLfIHi/rgPUaudu2uhnN5KXf0jakNDQw/+4IqBJ2lu3e9l+1Zi5I0WOsMrx6fuHULTsG7jC/XvBagiM+XhBipY+yJoxyAJGzqAX4134BFFbOxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790879503; c=relaxed/simple;
	bh=0oyauBl6iy2ZifpKVasUhDF7aKF+oAlAHo3gCFAS77o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OSp1y2N161sB1fBRNE/20joCkXGc52ZYpCwA9IXM73ldFyo4WmcGMde8aIksHPVwG5oPZkOe73+6p+BDsTUM0hYJEJ9lvLyz2r7qiwdGGw1dbfvX7Bb8xASnSpSu5NVwqSEzq5G7ZUqO1CbDUXqSUPTEdY2I3qwlV0rWf1CVR+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oo1gJUnv; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oo1gJUnv"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49e66390995so40180925e9.2
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2026 11:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790879500; x=1791484300; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eiEvPw1UURfB7Z9K+obJnHUM1Q1nDrcGFgGMmLM91NM=;
        b=oo1gJUnven3N4EIAhstIr4cR5rqfJefm9M+BiINbmPgorao4zAzA2k51kCoECsH3AC
         TGbTXY32nsueZypbTzFr5JOq5h4bu+uQod370JRsQyD0GrVaaZ5e5rw70Ho98zz2qb3b
         WKBYoAgSt4FnymHuBXAKCBiVI7cHOCWcHdYHF/BdfBXV5YDMJfbygbhM0TA+o15lXEft
         KUDILORE8PyDwIYGxKNgaeKv+rmPoyOLLPqmyRco0bMv+UbNLewNxMNKFfcbgPi0SEJM
         n1yXvvPmG00CDcyWoAFDKqgxpK3zUdvfDzwFqNi9fePIRB+ltSo+2egVDy0l53Ncyn8B
         JJbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790879500; x=1791484300;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eiEvPw1UURfB7Z9K+obJnHUM1Q1nDrcGFgGMmLM91NM=;
        b=aKB4vtGAKBVNWaqWezC/t70fGwmOnELVGhdhmRH60TapjAngtULRdj77hdegc2Vhww
         1BULjtYPClxhsvxGH4xlYHc/lKQnunnZtlrAM5GzGPbJnWqz6gQRjPIHx7igK97tmXdS
         Xt12YqCuJe//HZCLiiEjU0OONFNIkYFF9E+t5s11/ByTqbanT2fVLeFJzkAvD0LRI7ln
         uqFLGy27z2wGQSwZ4IlpGeGMyugCvyrXNJS1zZCGVe4KgjPZSvpv8dUpa236vMfjGAmI
         Z/u/eZFdsksQ00ZJNTJlRCWtCBvv2nxVMNzC5v9a2rFacfEed54PkUWMlS+/ZeKnOwwA
         6UQA==
X-Gm-Message-State: AFuF++nmO8X7Jv/DrfTgZNbVwHmndIWrtUttU+bP9rGNPs0oViG8mwjR
	9UozSi9sTX8boMc5QsKoFIKJGfPqigepB/tN72NU5pqIdKRt/bJ3trqU
X-Gm-Gg: AYBFou1DamHNdxdYmLZurAnLkaeNC189Y3YZbywDhxn3BYeV+VGko0cXhWXgZsgmrun
	KD8Fwq6MnX6CdfR+UlW9ZBNK5QexmKV4HIdK7BqVPiUrhdUPWVGXd8DNctndWhB50jO8LXh71ZX
	o1wibl9uzSuAHapbuqQder/DecavoCr9nEEt6NsIuyjJf4LaA76nvJPiVjDeMnVl8rUTv1g++hp
	vI2dgh7gqjCoTAIM/ylQena4Vure4O0IJiOfXqHUPN8iWZLhWDMl5jWAXXnz75Yv79h/dIuOy1l
	UV40l13jJmSktpqHojyjeFpjBFXu+Bt6hDoFKeEQVscDTlNcjnBcURH0mlFVTNih0ACNZ2Xaja1
	S2wVOh+06Q0/caKco76xo0Ay9G2zLT0AjEbnnvC9cJk8l/D/Yb6MUuo2u+KgbdERI6Um06NUJp9
	aBf1seFFBFcHsAHUCCf0L/3h5lE8b6bz3SF7z5wYVK685p+CMXEhw50HLAcaPwYTlzsUg=
X-Received: by 2002:a05:600c:46cc:b0:4a0:1c0e:b057 with SMTP id 5b1f17b1804b1-4a0274e9935mr8840615e9.4.1790879500118;
        Thu, 01 Oct 2026 11:31:40 -0700 (PDT)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a0280dc6e7sm5532535e9.15.2026.10.01.11.31.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 11:31:39 -0700 (PDT)
Date: Thu, 1 Oct 2026 21:31:32 +0300
From: Dan Carpenter <error27@gmail.com>
To: Christian Lamparter <chunkeey@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] wifi: carl9170: NUL terminate string in debugfs
Message-ID: <ar6nBMGUaqRPnRv_@stanley.mountain>
References: <cover.1790839793.git.error27@gmail.com>
 <674270ab4aeefa1982362c0ea4132427e14f15eb.1790839793.git.error27@gmail.com>
 <e550f231-87cd-4220-a17e-d0288516ef9e@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e550f231-87cd-4220-a17e-d0288516ef9e@gmail.com>

On Thu, Oct 01, 2026 at 07:58:13PM +0200, Christian Lamparter wrote:
> On 10/1/26 9:37 AM, Dan Carpenter wrote:
> > The "buf" buffer comes from the user.  We use it to store a number or
> > two so it doesn't need to be large.  It gets passed to sscanf() in the
> > write functions such as carl9170_debugfs_erp_write().  Ensure that
> > buffer is NUL terminated.
> > 
> > This is debugfs so it's root only.
> 
> Sure.
> > 
> > Fixes: 00c4da27a421 ("carl9170: firmware parser and debugfs code")
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> Acked-by: Christian Lamparter <chunkeey@gmail.com>
> 
> > ---
> >   drivers/net/wireless/ath/carl9170/debug.c | 5 +++--
> >   1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ath/carl9170/debug.c b/drivers/net/wireless/ath/carl9170/debug.c
> > index 0498df2a2160..bc6c8e0b1d16 100644
> > --- a/drivers/net/wireless/ath/carl9170/debug.c
> > +++ b/drivers/net/wireless/ath/carl9170/debug.c
> > @@ -119,7 +119,7 @@ static ssize_t carl9170_debugfs_write(struct file *file,
> >   	if (!count)
> >   		return 0;
> > -	if (count > PAGE_SIZE)
> > +	if (count >= PAGE_SIZE)
> heh. It's unnecessary to change this for the max. two numbers we get.
> But I'm curious if this is a change that an AI tool added?

No.  The other two patches used kzalloc() to allocate their buffers so
changing "> PAGE_SIZE" to ">= PAGE_SIZE" fixed the bug.  But as I was
writing this, I decided that there was no way I was going to let people
allocat PAGE_SIZE + 1 bytes...  :P  Plus, since I was adding a byte
later it kind of maintained the status quo to subtract one here.

I did use AI to write the Smatch check.  ;)

> 
> But yeah, it's still fine.
> 
> >   		return -E2BIG;
> >   	ar = file->private_data;
> > @@ -131,7 +131,7 @@ static ssize_t carl9170_debugfs_write(struct file *file,
> >   	if (!dfops->write)
> >   		return -ENOSYS;
> > -	buf = vmalloc(count);
> > +	buf = vmalloc(count + 1);
> 
> I think there's also a vzalloc...
> 

I was more considering changing this to kzalloc() but I decided that
was too much change.

> >   	if (!buf)
> >   		return -ENOMEM;
> > @@ -139,6 +139,7 @@ static ssize_t carl9170_debugfs_write(struct file *file,
> >   		err = -EFAULT;
> >   		goto out_free;
> >   	}
> > +	buf[count] = '\0';
> which would eliminate that. But yeah, this is fine as well.

Thanks!

regards,
dan carpenter

