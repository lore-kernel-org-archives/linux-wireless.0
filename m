Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4AF2F7462
	for <linux-wireless@vger.kernel.org>; Fri, 10 Jul 2026 15:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783697504; cv=pass; b=qWNOrGPbBD2P+TNxOh8oTCDwXJ8aDKGndMwxDnybaLy6ZWsSIgYP9L2iw0FeAAZ5DNFN8zIPt3XaR14YfWfg2s7HuvraFESzo1+ZTh2dmahR9Znwa+XTylGDvg+7nv99CshxHFmUUMYbm8cofi8GoW4yKKItJSSSxmlO4AyujF4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783697504; c=relaxed/simple;
	bh=6QRP5tVHaK0fAMiLSsPeuvkbRrGnGPqfBvxeG53+SqA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W5WYcc+f/eDuMJPVDFZRXNw9JcbyKH31S9UznhUD/Rgi/Vc0YD53Euxu7VUwp6JAAhJWsWEFFgjecqAm+117y7B39wViTofXZKWzmYOP7JwzQWqd/GBFhYlJUKiVu/DE1aAz4YxfrCgjFAbX4FAJdP4CuV7irXw63Q78f2/75rY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nEcDWhxq; arc=pass smtp.client-ip=74.125.224.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nEcDWhxq"
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-6626b5ace23so3164229d50.0
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jul 2026 08:31:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783697502; cv=none;
        d=google.com; s=arc-20260327;
        b=T7PeyfzOrpl7mTCkaQ1m+zetNEWJtrWjdTn6FbfWOYeVXI//y2+tWy6VhLrUHNVMU8
         iYGJrfIBZfFaeYw98SlUB/jrCj/QTlmm6thhdwVqTb7HPj5Ien15o0ChAsNtYZmRb3+B
         XvmVm4JguiQsLI7oi1Lx1xpcxduj6Wsr8OqhpWVUNqgysvMM99tnrqNz3+sn9b6vuV3Q
         PNbVjcLTEF/koWYYuHCdScudml73GV22nNSLdPEX11TKhWmhv5knvuKPgxbPyaGL4B4+
         5Ph7N0LZDenZivET2ECW/Q4uNdN0kicZlzlozC531xlyIQ44w2Oo37Nw9dnawQhCvyh9
         9ukg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6QRP5tVHaK0fAMiLSsPeuvkbRrGnGPqfBvxeG53+SqA=;
        fh=0ZAJxLL5hxn+FnaFOKqHZy9K8PX42AabhL3axjy+yEw=;
        b=L/TSWf3YbaTSv6wOzROGi7P9POEE20VqYIr82andOh48efdWYU/42MRzA28LFaUPGj
         wdUBNAmplyiM8WJ+Ap3pPq0vhqpc5SYYIJHzxNLnhiOpDWm2H83iZ2Simlwma8v2oSjl
         /gSDOjNPC6rsD6LjV0O23z7a+BsEYg27ouO4Rkg9mnWmreKd6V+Q2haLg5+3vxbSHP0f
         v7bewvxN/OVychYG79xQcjMBkdIOqL4Dm7QVo1rwjwEQHD7XB4Em4+3N7OFTDkJK0B+6
         npqnIYlNqF9A6/8a+0lUxbnABsFUtAIi9GV8fI4lUK8fn8gKdBuKk91dEJLDRARFsSwH
         oeMA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783697502; x=1784302302; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6QRP5tVHaK0fAMiLSsPeuvkbRrGnGPqfBvxeG53+SqA=;
        b=nEcDWhxqPRIReKCY5hgJN4Vx8YxwkZwoWSYLEROSPCVJCfVuZcBBYS8Hnem5maPQ6J
         tp33E5HjbimtHmjNHWlRkx37PHWUEtbYUwUIVpMjFYqh2VzcClJSS8GZD/WBeLtHOlsm
         XzGSwB7HGwQHvH6Addc7/IFMipNDsvlz5KXK647ag9dY/7gPEcvvHWcjgphYakp2HzoS
         xmrHPQW4ytC0ykrnZY1xbZml162MhLTmOQ6naI8jn381si0W3gNRgZBg4zony1PNCsoZ
         PQ52jMI8Vi5KeMBlxGUu0rSXG+l5wwkbrclT6kzZpKejWgFofaNG9bnbs1EK5rgoA069
         ThCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783697502; x=1784302302;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6QRP5tVHaK0fAMiLSsPeuvkbRrGnGPqfBvxeG53+SqA=;
        b=EUqmKD8ManNKhZE4lUtUzpB/7hte/REY2saYpk0k4B5oyc1OOTeQHm/TX+RfXuZmiU
         MzVN08s3WjwaUwCjlNNwz0LnKBS80V3ACGCYQg7LQsE1v5GHJyQYfDIaxplcdDEVOIUr
         vynY0VFExyQB8j43kN4KM1pCFHObqPcLBWcgw90KRyEJULuaZwjjnEQnXuVEknnIH3Fg
         up+iffvIA6SHKhF1m07mKTVRM6togmrLXCQmcrzpZ2ghI4acQEh1fLtz5R9Vy3pDoImE
         C3GVTPlTQT3z5d9JXAUD/EuVYWF/jIbL8CyHPZqSINaRw8enaZMjMK7Rx8sEKfYXCCIi
         P7WQ==
X-Gm-Message-State: AOJu0YycaHWbMSXyUapLkEP8X2VVSwiOuAmkLm5LTr5nIXiMfFJQ3/PG
	VhuEyiyQQBaklS43LugTvTA6dPMiNDv+1XgfP8tplkeGmeZz+VcsbW24ZhqPs+ED+IYDE4MiLeu
	JAJ/RTJ9DGwZtjQo111bPeD+7kcekJOU=
X-Gm-Gg: AfdE7ckseKXFGvFpxuZ4DXVqgXAl4j3Nh7k3NcDYx8Dqx0/5QTHOy5i8QxnE05DvOMr
	OPhbgsvZ2FdXV/M1l7aOZIakSnOOkaoLlJjXgmrtUd805F6eRrPYaUl5t7KjIeS1SFOvXehCCFt
	zzZxwLIqfsWAIcHoGAPwk9rSmebV7k/RE15LpuVY8C2zIeki4culV+1isVR28iJp8nESaj1vi9i
	bRNyMaAWAZQPMMYRpzSkyLMprbZCkQc7o23Pwq/aboz+jqx/s/iWhQB2YjMOB81Tmhr8qgwJhkK
	mNMVcPInykU7uev06+lrtWA+JmGgU1pIjv7sUuY=
X-Received: by 2002:a53:b3c7:0:b0:665:1074:b85f with SMTP id
 956f58d0204a3-667c6233ceemr1765197d50.40.1783697501864; Fri, 10 Jul 2026
 08:31:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260710024637.16729-1-kartikey406@gmail.com> <6be574903752d95ae7125461c38cc30b8a641d24.camel@sipsolutions.net>
In-Reply-To: <6be574903752d95ae7125461c38cc30b8a641d24.camel@sipsolutions.net>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Fri, 10 Jul 2026 21:01:29 +0530
X-Gm-Features: AVVi8CcL-YmNPFgYQepDe9wnXyWwvpDbYyrGnbsg8ANY_fJZrMulP0v4yUcQPp0
Message-ID: <CADhLXY4bpoaJAnh6KVe1fU9J_wCihgM3y-LQoXz0Snrmknc6eQ@mail.gmail.com>
Subject: Re: [PATCH] wifi: cfg80211: validate IEs in cfg80211_wext_siwgenie()
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+cc867e537e4bd36f69bb@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 10, 2026 at 12:09=E2=80=AFPM Johannes Berg
<johannes@sipsolutions.net> wrote:
>

> I don't believe you'd need to even export this, and we also already have
> validate_ie_attr() in nl80211, written in a better way too...
>
> johannes

Hi Johannes,

validate_ie_attr() takes a struct nlattr * but the wext path
works with a raw char * buffer, so it cannot be called directly.

I have reused the same approach using for_each_element() and
for_each_element_completed() instead. Is this acceptable?

Thanks

Deepanshu
