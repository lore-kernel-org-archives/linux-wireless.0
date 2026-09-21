Received: from mail-yx2-f43.google.com (mail-yx2-f43.google.com [74.125.224.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3746136196B
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 06:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789972383; cv=pass; b=PgA2b8fIobK7sgkGSUuViN5yz2vA/ltW6oKrTbIbigun3WUVTSrzLk9FDwSHGxE/mJlk5NWlqVjeYX13kkRUejzFM0NsNKWU21wzT7LRRnn+AdVRbZNz41fyey9bJLtvN/GnuFLH8A3NAGgePdyQbypth5xsxt73RsxuamgvirM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789972383; c=relaxed/simple;
	bh=ezw3oz3pOs7dtmVE5AzB+SlQNlOgHO47M5+Fpf49XE4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d3Q/KAjeYXbmdlciQz81IJXWt6IVM/NKN4WOOF6u14WxYrI6lYd5BvZCT1brty74YoVTZklYVDk2tHwXbsr2rOD00ifBF76TZBibO/wSRC8FF6ggbMib3ZrIA5bP6fGJUNKvaenfWvo09yTY4d4nkYm9nZfTW2jFdimBP+nP760=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=Bc81KleK; arc=pass smtp.client-ip=74.125.224.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="Bc81KleK"
Received: by mail-yx2-f43.google.com with SMTP id 00721157ae682-895eaf30817so25913647b3.0
        for <linux-wireless@vger.kernel.org>; Sun, 20 Sep 2026 23:33:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789972381; cv=none;
        d=google.com; s=arc-20260327;
        b=XOgGm7fMUdThmTTK2BIXETENo2m46NjWv+CV5ZVKPVwrjz+J2rNGqptPpMoaz/OVQv
         WDkmHniZrnlh3nnxJUTiBC78dd71s6bSxYbwLDdZjBjTAGQrP1h+ITJvxMbiRIv2ZyPw
         H39XkMhwg6wkmBbXmkT45TVxLlWLAYgf9CUH+N7DGSJUYaOWzMzfCBc8ZRfzzeaHgcql
         Iv0csQ7mpxZHUNpO0Az4jagQQeLsK4qqo7K2E9VWdAHQxikjf4/GAQHk1rjKpXD/POSk
         jB1s5rIb2A2zvgL/J128GbkKoCYgVgX2b8/Txos+UInryA3qxD7yHligBsxRiojlhqHA
         cJfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ezw3oz3pOs7dtmVE5AzB+SlQNlOgHO47M5+Fpf49XE4=;
        fh=HOctUTNIHc9XCUig5ovJMNIWkZU47LzQmGxDUo+KB/k=;
        b=niqTllROpgX807/W+QqcYcKgTfeclDO/1A2zuHYbgHTm7bfLMwBRl38rCSRbgJpFs6
         OWKNLtZ42Mpi3sN0f4GqwE1lgxB1H95/J/MDMYeoje6jvJIdOEgXUzmBq8+aOi9aGC2f
         Jyv8fSHF8pr/5ETFqj/xPyp7QQotPaN+ZIfPumjxlRKHlPrGsm3lL4G1qCjNRnJiB9+N
         NREIOkH0SHoIcdDopW/PqE0MEVNzKdOjC00VEVPU1GZFPhr4bez9Vy63XltNOtrhi+gG
         V8btcKD+wYQl1X9davJsa7y/+ljOmiJ1dEZI7r58zgg4Fa/DEA7f4yw4g3QINx9kaqoG
         oNYQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1789972381; x=1790577181; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ezw3oz3pOs7dtmVE5AzB+SlQNlOgHO47M5+Fpf49XE4=;
        b=Bc81KleK/ue3vQg0VqebfLCghMrb7/bz+wj9GCkczTBE4JV/czsyy0cjvHCAnNotl1
         EK7bZ9bMxEtvW2WEC5zy4Wi7Zy14HjqPY8b2ukwS5Mgd39Q46j/DYiRJpoKvQIZKZaKI
         W5mnBeJ/dzVWhZtMP1laRHUYgSjnzqVQq9TvJWQ15v061+MJCLDdJegKeZ2FTxiUi4zr
         a5i4vTUbg9sAg265lZFpXxDa15rMkeVHtYEDRoGyI92Ri2m65eWlrdx9Cu1XTF2vNemL
         Q54VD/KnzsAAC8SB/1uVKGQevOprfUqWfPHX7uIQBcxOI3AmdmXZGdLX2DxMLMLsAggw
         mPLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789972381; x=1790577181;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ezw3oz3pOs7dtmVE5AzB+SlQNlOgHO47M5+Fpf49XE4=;
        b=JYmmeOQOUnQ+HAJpu1J+JYj3qQSR1zYde1vqRQYH7RVaUL1UpDc9/RgCRA3Zic7MFz
         6sbzsyk+Ej0Qh+bsQz6JfT4vfKsu04OTiXfCKZxuk0Akzy+7IEMJ3g2okzrVrcFk1dUK
         XTXju8OsQGwKlJHLUjLhARzIFA3eFn3UMfQifFtRE204BvWymJQ5KyXGqDk3DKa6JjJl
         joqNqwSuCAS63gqK3HTmwyVbEXVh6ZZ3I0UyGQUGhVFchObEknNX0EXNw+JEJletLr00
         orFwg5srxovGsr98i5wwamPVMASdHTsv8g1LGUfCio/in4kguvhvTSWCrgClHV5PjUdz
         nXoQ==
X-Forwarded-Encrypted: i=1; AKwUvBz8fY/e3EcxRPBi73O4dQdiEBo+xulYtpWdh8FMwDJgLd9wYQrXCgo0SslfMrE8A+9If8vKuvpaKT2npAiKLQ==@vger.kernel.org
X-Gm-Message-State: AFuF++kcPycthYXGVm2Cuz9znDHFw7mT9bAXQnEUF2UGjNhQr7TTW16j
	ney38z/AkumdyC2LdkfAeYLciFOtbR4CeLbGx0LTR85JUnlj5rOcl4TSMUz/jLA/DtljO6iv8tO
	3tdwHr27UWjr0ncqBmabhD/dCRcWqmyhH/axmQcRCF/Ia+3cc/3sM0RUTy4A=
X-Gm-Gg: AYBFou002Z7hEVrLW8TMhB6EapyCLY/341c8axjkb3h/a6HBpHiGvIYuZ+bK60Nqnn+
	cf4bxBxuje277RXnXD5jWjLWouunvNXr3nWW12B7bfp+w/gQONsXrS7tH/nEMKWIqDAnYO/fuvG
	5CyCDxtffPvD3cH/wHkhYbq5tF7qJo7wfI0ipbTdvdK56D0FdAey2VGH+bDKRTBr2hjPBVu8Ahq
	jav8zb2ef1+6QM3RPRgvGgxI5uADeucPlWdmVxJg/2PhXs+lgB+2TGObRgWl5cWJnA5xNObGqB6
	WhurIbJbQ36cgiOlMROO0eQ6qJokl3oVicir1OsoEh8kIARiAzN50OdZUd/Fjh0eiIaAzm3216h
	7EINaEWHt7qmO9cf1JFeE21gIcluZg/3aXAUtHe9Yj8uxxtsyHDdUbFOTR5OhxuJdCCg+5QKKnz
	JW7kRQh17liw5/ilzSa8SE0XUZOpV38LioNaKQv/84UUt8Q0B5Akppvi2wRKrUBCCzUT+1CGc+z
	sL9pUotr/HJZoGt4lm3bct7kCwvB+gEHgwxtySQJqoOjPWNHf143YGzYSujOMG4Caceu9OoURZl
	YpQgLNcKOAdpHw==
X-Received: by 2002:a05:690c:6e84:b0:873:5bd1:98cb with SMTP id
 00721157ae682-89738590444mr27664057b3.61.1789972380819; Sun, 20 Sep 2026
 23:33:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260726221908.104873-1-julius@bairaktaris.de>
 <20260726221908.104873-3-julius@bairaktaris.de> <CGME20260911075315eucas1p1b4ffb1f57ef187e0a055072ccc0983e3@eucas1p1.samsung.com>
 <a068a857-a549-4cc2-ae0f-3ef119d3a859@samsung.com> <dd342f3d-36d3-4a85-95ca-6cacb7b834ad@oss.qualcomm.com>
 <10491411-b500-4e89-bf85-5142ced60aaf@samsung.com> <CAC1t37Ltrh+BBaEPi8grXnMrDt3qGDH8BA56av-h7=yPCCk0Nw@mail.gmail.com>
 <358d7dd0-20b0-44ee-8b1e-a0cc6cb40abe@oss.qualcomm.com>
In-Reply-To: <358d7dd0-20b0-44ee-8b1e-a0cc6cb40abe@oss.qualcomm.com>
From: Julius Bairaktaris <julius@bairaktaris.de>
Date: Mon, 21 Sep 2026 06:32:24 +0000
X-Gm-Features: AcwNN1VYrMKW7MY0qI4o0V65psGhOM1MxhN8fHN4VCpGkg_iFv4IKVsZlw5pgJE
Message-ID: <CAC1t37LqZCpnjfjpZUGDHOiMMEfGtZoSCPio737VFKs2vaOSEg@mail.gmail.com>
Subject: Re: [PATCH ath-next v2 2/2] wifi: ath11k: disable interrupts during
 firmware crash recovery
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, jjohnson@kernel.org, 
	ath11k@lists.infradead.org, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, vasanthakumar.thiagarajan@oss.qualcomm.com, 
	rameshkumar.sundaram@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"

Yes, sure

Am Mo., 21. Sept. 2026 um 03:17 Uhr schrieb Baochen Qiang
<baochen.qiang@oss.qualcomm.com>:
>
>
>
> On 9/21/2026 12:42 AM, Julius Bairaktaris wrote:
> > Hi @Baochen,
> >
> > tested 5 times and it solves the problem. Thanks!
>
> Thanks. Can I have below tag when I submit the fix ?
>
> Tested-by: Julius Bairaktaris <julius@bairaktaris.de>
