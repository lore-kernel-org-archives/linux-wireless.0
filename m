Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED517487CCC
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 18:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792173956; cv=pass; b=r02/bJ3IJdeRtBUjKYQfNUkJVM2Tpkh652XtYIt0tgel/vwWWNmLhZ0bx7HYqAG8+QX2xg8qaQYERYtGQaqxZvQwxBlzcbcRlsN9fS1v9GC5X+ekf+DsvSXpvrpHj/2ZD7CxcafWAC20fXrX1Oo34TXGLCSCrcBp401o4cY6cBc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792173956; c=relaxed/simple;
	bh=W9zaZCC2PUL05KATE9nrs0p2Ph152nxKDF1hPAKaLv4=;
	h=MIME-Version:From:In-Reply-To:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fLpltAkgBp30J6PHzhEkN/7dp+HdR3uz9wmTJxbhPJ2ksOCBiBjciW0SIJ6lzL//2Gi0KAwn5qKOKVwjr9HmptY2ZFv/allRrtkjIpLOgyRwB9L+57phtp9SW9U2ENUC3ucsM8oWWuKPQskjQRfpY2VqZ3y6mU3/XtPiXS2bk9E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr; spf=pass smtp.mailfrom=khu.ac.kr; dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b=fzLhOxyi; arc=pass smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b="fzLhOxyi"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5ba36cc21cdso216115e87.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 11:05:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792173950; cv=none;
        d=google.com; s=arc-20260327;
        b=mdQ1jnQEHd0/6uJP16eYcRAWyd1VN0zPw7ZEDO3MeroNZU2VjaOvNNAIEYZpk5l/Ur
         ob7qSHyalKuonQLm8W1p4tysdTOVAZ3KLj8CKZUWF6r3unfCXOTWQyvvqWEx7eukounS
         zcv66at6G9Y3Ul0yTWmXVb57SLappPhv8+54VxIA86AJI19LcisMffGXRiXoKONOBvHs
         efEDs1nRjDxCVUhOGi9L6db9OqiY62Qe5p8haURrLFUVPMz9wMBfg9tA39ICOBpsVPfo
         cvvzD8BHnyXqaT16h2IQSrIM5IYK33uxGyVbpVgnrFFFG7XASBZ98/rSuPFdyeB0LajE
         hP9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:references:in-reply-to:from
         :mime-version:dkim-signature;
        bh=W9zaZCC2PUL05KATE9nrs0p2Ph152nxKDF1hPAKaLv4=;
        fh=E5Ei/I1C1+b7ermdx9TItWv6jNZ+aVRPHaWGekLJOr0=;
        b=Lnwe81NFwp+qr7nbv08ccndrzYyCyd5lY+Iv5RMCLHPRU+v3luoinGBprW4AEA/FYI
         Nprv8h1vfUFH59yLRUiC+VmBqztb8PbiJFDUa4/5OJvPQxEcAPgiYioFyS7FhmB0ryTP
         xmFYq91gsxvO1IoGzVZM+T2YMXmrRS/cv5++JtmBE7vAxz5uwdaBS86NNYkcZVKqF0uu
         G4Zw0EkEnalrKr1MWnxOHmfvp1Emp2tZO9Zw4EHf9yeS0FFmGdGhOpE3ZvKe5lQqYsz6
         Bef8y9iYINB/j4ZL5EdSLPkBToYKC7j+VkMRwanxpDcZG8VhAzELAZmk50kEnt4f5kLs
         Bv9Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=khu.ac.kr; s=google; t=1792173950; x=1792778750; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W9zaZCC2PUL05KATE9nrs0p2Ph152nxKDF1hPAKaLv4=;
        b=fzLhOxyiORVjmgoUa4qUBIKtwUGXAagoa/AqN42OkkSIBFACP9lg0PC3ev1/WJteQ0
         NeZmJsP6Y8OGMtweyzoIeOib+fi+6d7hpCcRTDuxDvzjeHVjVqx7eTvJLmsB5fSNR3MH
         eFEJf0SXeVkcaC8XUrPzgMCjd7zxK0YSvdtic=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792173950; x=1792778750;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=W9zaZCC2PUL05KATE9nrs0p2Ph152nxKDF1hPAKaLv4=;
        b=bkODhDZrljjEQTccI5SbdkA4at/XRJgsnyoRDmQa7KSOS2SsxV1UxLZhO2xmFrh4Lh
         cV4I+Z3UWA2y4ISo/zKZXxonIjkYgJzv4QL/4LQm6Yao5rqMBawlj6W9V93UfIN32FPK
         PgQ4jztZsrKfo4bEARZ2pei41Sz/4hFKBmAFOBxMseuoEfMAhug+dS4pVIXS2cU9TtK9
         04ZoCEO4tJpyTV0kmkI6iLZSjKsI6YdiPEwktUxFqVeBXd/Eb0re4SkrZjJ3ZYN5lvgK
         9ogDUb2Tp7rzLwx4vzsu6Z6s6BKMbT30Z0TZ8YhaPe7ndl468OBHCvw/aF4kw21/yi3K
         gbwQ==
X-Forwarded-Encrypted: i=1; AKwUvBznOAC307TdDEiVXqc/gRY3di8i55v9F4fBiXnw68CZZV93NJNU7YGrfacuv/zHRsnQLzqsZyqqUnPdBnAUEA==@vger.kernel.org
X-Gm-Message-State: AFq9FYJUME5QKRKxNolxWwHFDoxUv5fLAvcHBkHCFyIYMMc8C/sqUOl9
	xXGGgYlaCZn0joviYw4jR93vMj5Gp5skKnQnxbhtwiCmNBvgMfVnMr5aE9E359GN+xYooNx00oD
	/649lTaJo+2lICCXbweQwhaeuDEvhjv1fWzGV6ExOCA==
X-Gm-Gg: AYBFou1BV1MR5nNqFqeVxDtjl1+PG3PiOy+e1o6AnRq7FUd6pndRhsKEGpN8TEfyC+O
	3MMFJo0sEeBdV45iAAk11Zp7qDyceD7ZKylWq8pmfMkzCtEkaEbZgO0+KOrh1NCDi2L461L6TIP
	yR6AaEr1GArJtzTl6c+SXDjJZLwJEurW3RwUiiDVr8AYQoiYz0B2OQu+q54c04Yh6QVJyZbpGVp
	F8qo/H5y8fwFPJ2iHcfhNXjM1QW0bTjy6rg3+UYwZRtlAEibPdhrTqm5GOujxjR/DN+1MgNvxx4
	VzpzuKkCY+JOBnFTGs9F2if5nLlBPT+WgdIkkYhfR6knMMCMljdSeJMB0QRSDudakX2H+KlkXgd
	MdPu6BDtuGhhe45y2X/i3VwMeyPX+YlHteTvp5jahXv1Y
X-Received: by 2002:a05:6512:124a:b0:5bc:e472:12fb with SMTP id
 2adb3069b0e04-5be50a74cb0mr92020e87.63.1792173950529; Fri, 16 Oct 2026
 11:05:50 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Fri, 16 Oct 2026 11:05:49 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Fri, 16 Oct 2026 11:03:29 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: from 77377267392	named unknown	by gmailapi.google.com	with HTTPREST;
 Fri, 16 Oct 2026 11:03:19 -0700
From: Kim Wooseok <5mghybrid@khu.ac.kr>
In-Reply-To: <fd91ff33-d8a1-4ab0-83da-c15816c148cd@gmail.com>
References: <20261010-rtl8xxxu-usb-dma-v1-0-e670d9c08fdf@khu.ac.kr>
 <20261010-rtl8xxxu-usb-dma-v1-1-e670d9c08fdf@khu.ac.kr> <fd91ff33-d8a1-4ab0-83da-c15816c148cd@gmail.com>
Date: Fri, 16 Oct 2026 11:05:49 -0700
X-Gm-Features: AclHuK9ZwgypZrng-PnEqwREU_wxzMOVesmRvYGZ8m4Qdc2U_H8EMyixUe0zrSQ
Message-ID: <CAH1Bc_w89ymu+E1Gx13M9JD7ZNmdQ3=y_zFwVvMkQMKk4m6NAA@mail.gmail.com>
Subject: Re: [PATCH rtw-next] wifi: rtl8xxxu: isolate the USB register buffer
 from CPU state
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>, linux-wireless@vger.kernel.org
Cc: Jes Sorensen <Jes.Sorensen@gmail.com>, Ping-Ke Shih <pkshih@realtek.com>, 
	Kalle Valo <kvalo@kernel.org>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Bitterblue,

> Perhaps it's a silly question, but doesn't this just move the problem
> elsewhere? Or does kmalloc_obj() guarantee that nothing else will access
> the memory near usb_buf?

With a separately allocated kmalloc buffer, the kernel ensures that
CPU accesses to other objects do not corrupt the DMA data through
cache-line sharing. It provides the required alignment or bounce
buffering, and usb_control_msg() uses this DMA mapping path.

The patch turns usb_buf from an embedded member into a standalone
kmalloc buffer so that this guarantee applies to the buffer itself.

> An allocation for every register access was not happening even before
> this patch. I guess your LLM wrote this...

I did not state that the previous code allocated a buffer on every
register access. That sentence describes the allocation strategy for
the newly separate buffer: allocate it once in probe and reuse it.

If any part of the explanation is unclear, please point it out and I
will clarify it. I don't think speculation about how the text was
written is necessary.

Wooseok
