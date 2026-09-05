Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34155474E
	for <linux-wireless@vger.kernel.org>; Sat,  5 Sep 2026 19:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788637307; cv=pass; b=oVyr2vI+zuF+WL8uB6Tb8jW0Q49yumsXArW3lGOcornWjNHYs0sixQwcQjsZ0yRUnqdRpf2zwrQFhHocKHpnHcB/SD9poNDsd3hQAEap2Mz8IM3zSRXFa+5auOoVg08m5sb4zyTxJfnmqeJFdfTjtZdnpFYCVlC3g9SR51HZV+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788637307; c=relaxed/simple;
	bh=mPlWpZRi5Eu4mAVG1Y8l412zLMdWeHMbxSFc+qRmK9s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z609vjHPoUIgRDOt+N+zUroGRoET+WxwVAca3SlK/YNmvo7WyYsCq2lTwAriZgh2XBFljIWv9BlYXPTxLkzWYHlEFBb/XUEjMKVS6pHi9nNkwTsLhcJqSalsjDiIuVa7gqOmrhJoKn+JHyDYo27MBB1EXfHi6cGEnErlVypyhHQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VbxaKcPu; arc=pass smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VbxaKcPu"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6a38098734bso3719053a12.1
        for <linux-wireless@vger.kernel.org>; Sat, 05 Sep 2026 12:41:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788637304; cv=none;
        d=google.com; s=arc-20260327;
        b=Wg9LFtwNCPPh4+Q+mrJJJQ7GN4fIJpxFU5qBOpBTKZHT8uZP+UCwJHHFy3Ekwaur9x
         1Ulf1Tuo85vVABYGR1Bhp3A+S8DeXM0BiFxdVnz7EXlIEL33bJTBe/4WViPAkPw1fGNE
         Nfjf/zXGt6yHMmus+9ajnJ6ahJz9MY0oKHy88ym4B4rywtfFF+hx/YOkrKDjWG+WxrTR
         QZ4zszJyJD8pKIDjIwj9Wtx8gh4gyBx9Ty7xQtef8wLO3v5HwWkVEfvfDPdCsKyUGC4b
         fWYCLbC3SwEZmQnlPYqxVFMdtKBjl67fgiozXnR4GlzhQaQGC3+OSoZY4ub7UuxANKJU
         qpcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mPlWpZRi5Eu4mAVG1Y8l412zLMdWeHMbxSFc+qRmK9s=;
        fh=kyUGJxJonLoHZz4Tg9rgEqPngE+pXNKX+MGgT6RbEUk=;
        b=c1y6HT78iN8SXOhRVYce61jETVbxciKsF3jaXNWlzPZ3o9r7ZKobhXhoYcXIMt9Efm
         S2E7w3O3k4p8nNmvI7HKCx1BNSUx074DPHYvvjXSE9Iwc4hdmSez/F/DVL1qfB0CkyvC
         czxjCmQ8DW0R4MQzfbfmUY0eC83IBJy6TO0av7fo5wzGpQ82Fr0lCIGRMqXlwVnpW22J
         OSHW9oNp9WWQB00A47yBG8pXJ7vqem/2/EtAzT+c87Wyl/ttQyem3HKRTLnRxh/ym39d
         HsC6C5+Db700akoubttcQd1kidtseV0ttsVXM1CqrrUHjJ3QD5WDtiFEGA3KSclyxVAH
         RdoQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788637304; x=1789242104; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mPlWpZRi5Eu4mAVG1Y8l412zLMdWeHMbxSFc+qRmK9s=;
        b=VbxaKcPuXqmScnhOHuCsdocsWSBj1NW7N/gduKOBfd1in1ECzMioH5EgdWbb2/Wwia
         C1if73FfiljqrLp6RPgjVDK3pzbMTVpu0tKJW7R5AU0wiaR2vb/WtLKzMWS2Ym9P+uN0
         CtD+AjNvxSWZEIdU0DIJNYDPoEgnprMBRPbcLubxurv+XhJIQ4BFuaHTuJkzUwHAJ3Ls
         pJTM2jQ87OmWM7D0MqrjigbYOn/ob0DfBOvLg2hUzeW/twH10gtqfuG8OHxhU9kdIq7R
         jMWDM964sE/J1Qz9P5N+zehhBNACBSDGgBSgGMyJ/O/bmfn8+uun8iQvFYz/hkXaiFZU
         adVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788637304; x=1789242104;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mPlWpZRi5Eu4mAVG1Y8l412zLMdWeHMbxSFc+qRmK9s=;
        b=TGCL1oqgyiUYLlZ4Eqm4fBsb4JFybnn4ITVdUphMjHYrAWXFHO3M2sh9JkyI35EwS1
         7eFmSb7E6PTaI8nzKOuaMAcUdFExJT6/cIh7bFpOHzzl0EmRrYMukxBaYtz8YygLnrx4
         pijO93e7sMVDyBT2piyYO/heYDZvFvB1XldDnGBK9YVCQ2KVoenyyBrbbNYQGh6CEBQD
         11d28C/MTsA8GyZd0lmPHh25RBwgzy1gWmZwSoQsePMUwDOtV/XCYwXz87sIj454AIaO
         uVhKYxiF956dM7hcsT3amLhG3UCVzxdfWa90O2/9+aGNz76xh+wdCchLTtSGpK6djp1H
         C7dg==
X-Gm-Message-State: AFuF++mjgXQF/rG6mBJMBtAJnvPplsTRDsVe1X5mL4MG5OOwwOsWrvnw
	1FZSp/kJObp0MADVpwihC3EWZI2od4hrn1z6ZB8WMwdYNAIZHMcLVUwDmx5gcCjNGdNUju7PAJl
	MVlVIGbmtkWLytq94pYTU3kALBA6vAog=
X-Gm-Gg: AYBFou17DL4JpO+xH68UCN4BTa66pYprI6Kgb4mKBz4j/GpaZCpTZYjnAMz1MJ7dS//
	gfJ1LKMaLrqk7ibZhulNy91IqQgh6LVcOtm1LGckZ/psJQOFjmWRzMy9CtGFVsw+sKVl0Pa/X4F
	fdbOo8ncBISZyHRCJCkAA3dMwVzPV9yn12v0M/Qfq/0FpI8g4iObA98ZN9fssq+vl0ZKZYVJgkc
	0Vy9zDKaG2BAA/s8Z1X76nL08lGvWiZPo0ZZtyc7gOAASfBIyig+JtaP7vI6ANGFfaeRYuha7xS
	i3yRxbNuwSqtPX+0urbL+inHNdu+ZdaXOT9eycKqqP3MiYUH6ZgRrUkeYJ4PBb4OgA3vDSqiEWp
	BniGiGRfWudf3cGrTVxSsALT6e/+a3KaSac6v6VC6j16bXmaH0ehHHv+g/T2NY+F/+yKYKPYqs3
	+p6FtId4zBPTOAoRdlyXorgs7h1Nmg1gMvEIhP2yzjJ6AWUmz3XLZqzBs=
X-Received: by 2002:a05:6402:e94:b0:6a6:6346:af03 with SMTP id
 4fb4d7f45d1cf-6a7e8d4b476mr4371139a12.5.1788637303610; Sat, 05 Sep 2026
 12:41:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260815190724.16943-1-rosenp@gmail.com> <12f4b21bb334a49c88bf28428b92589adecfa53a.camel@sipsolutions.net>
 <CAKxU2N9ZPRSotiPhayrQFyzbf=sPcU7X3o6ozRECOibhCj_kbA@mail.gmail.com> <9d91e1719383f8ba6dfc45650a92b1f2c2bc2f6b.camel@sipsolutions.net>
In-Reply-To: <9d91e1719383f8ba6dfc45650a92b1f2c2bc2f6b.camel@sipsolutions.net>
From: Rosen Penev <rosenp@gmail.com>
Date: Sat, 5 Sep 2026 12:41:32 -0700
X-Gm-Features: AcwNN1XlVa-aVDPxhTE7IGJSf7r3navhvcK8Dd6Vt7emBm5JYrbRuD3ygTdt9L8
Message-ID: <CAKxU2N8Of2h2d5BOVkTQKjtmNuNo8x2DpFjC2pFjDCOb8Cm==g@mail.gmail.com>
Subject: Re: [PATCHv2 wireless] mac80211: stop tpt LED trigger timer before
 freeing trigger
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, 
	"John W. Linville" <linville@tuxdriver.com>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 4, 2026 at 11:15=E2=80=AFPM Johannes Berg <johannes@sipsolution=
s.net> wrote:
>
> On Fri, 2026-09-04 at 12:16 -0700, Rosen Penev wrote:
> > On Fri, Sep 4, 2026 at 12:41=E2=80=AFAM Johannes Berg <johannes@sipsolu=
tions.net> wrote:
> > >
> > > On Sat, 2026-08-15 at 12:07 -0700, Rosen Penev wrote:
> > > > On a hot unplug, the device is torn down
> > > > through ieee80211_unregister_hw() without ever going through
> > > > ieee80211_do_stop(), so the timer is never stopped.
> > >
> > > I don't buy this.
> > >
> > > Also, missed wifi: prefix.
> > >
> > > Please don't just feed me LLM garbage. Do you have a crash reported o=
n
> > > this?
> > Not formally no. However I am able to reliably panic the kernel. After
> > this patch I can't.
>
> Then you can probably enable debug objects etc. to figure out why?
>
> I don't think this patch really fixes the cause, just the symptom.
>
> Maybe it's related to this:
> https://lore.kernel.org/linux-wireless/20260904165722.044aa432f873.I601a6=
7a2cd558b8ef8416a07554ae7efe896e9d8@changeid/

That... might have done it.

I rebuilt my kernel with that patch and cannot reproduce.

LLM seems to think so as well:

Probably yes =E2=80=94 the oops is the exact bug that commit 29e3d27 target=
s.
>
> johannes
