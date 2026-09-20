Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B523E075F
	for <linux-wireless@vger.kernel.org>; Sun, 20 Sep 2026 08:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789892278; cv=pass; b=pKlST1D9vgUtgXycR4ATy8vXBf+a8tDfWDZNTffWz2hSc5bpsfYLPeEKPlUP8Hj7E+1cDrzC9wciov+Ixp2v6smgDWRid9Djec1NlR7eCIiCN0/6Ac8MU4sZWl/bPN44/bgJUUxwqfSBzjwDsr6ka1aZtlNjh4xHYZpyqb7uUZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789892278; c=relaxed/simple;
	bh=WYbMRPXl8tzSxOI6esJNtyz0qMAnN7XzmWLgxEoqUFM=;
	h=MIME-Version:From:In-Reply-To:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CCTXBOZaNwm1mvLUxJ3ZyLFV0ZgLdy14t5u0jZh91CEyA2gpiCUfCLrOq1FRoTTHdta6X9/0Ec98ZByFW+HdWMJgVf/IIw8ejp+RzTwQv3IQIfEhkr07ZRvriV+KKi8sVqVVY6Xh8eiStaZLH/FUBptFHNXo2PYviprA1fRkK4Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr; spf=pass smtp.mailfrom=khu.ac.kr; dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b=dzphQpqM; arc=pass smtp.client-ip=74.125.229.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b="dzphQpqM"
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b5e4f17450so1705915e87.0
        for <linux-wireless@vger.kernel.org>; Sun, 20 Sep 2026 01:17:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789892274; cv=none;
        d=google.com; s=arc-20260327;
        b=WA7xvdj77X13aemzaGryH90jzE1FNilaUcvlgTRRTrXsGKqx4cYxDLWNToX7d7ClvL
         o3sM+xNjwEpB3cLYgmxI09wMQQybCPaV1QR9yiO4cnX0sVKduQiMbAR+56EifBjjCFfQ
         CHyLV5faO68ugLP8tHrPMqI4ys8/n1GbSyCWmyinoIMn8Ce9nQqXHKqJoL4fwdsYOlUX
         YEM+2B6MfEhCHQLEzFGaOgZ1X51rc1tPwk71yDQWeUwjnhKpFiG5Qv6qNZMu+vGmEaJ0
         Pw7j8VZnw+f0GsfYkNoNN4wzmlWFF3C1ZidmEhhiFbcZCQViov6qYxpVH0G3cwKFWLQY
         zAxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:references:in-reply-to:from
         :mime-version:dkim-signature;
        bh=WYbMRPXl8tzSxOI6esJNtyz0qMAnN7XzmWLgxEoqUFM=;
        fh=n5v73YiJzxMAAE5ZePeLdT+lpUtZ9Qo7rWbrpoNNJIY=;
        b=kYzJ4aSzRf05VWVzepE3TDIBa7omJKIJcDZuwyeFi4mcwb046uZm2xBhJ5O5AF5q0g
         Kr0NlDz8aA7xjvyX4MsomWvLTxF8VF0HvPgC+X+9UrXXEnVYjHIn/xbTQj+58J53fNrI
         b0kpzLZkG/IuZXn2yK+6Q7ug6IS/024UXHue0BDkOZfUVHu7ESKIpwsJ6IaPShWgeVt5
         BRlP0H4RbJhac9fNdexTWhG6WD35w+esP1I3Ve7Lg3dVzUV1R0zaUR9wzH2z7dHLCDcu
         r4Xh8zuP5JY5Xc5lX9qMKHNe//12V8ulcDoL6qjyoA5vP3pB7jcV9p7thUbHe9MWt7uQ
         LA4A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=khu.ac.kr; s=google; t=1789892274; x=1790497074; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WYbMRPXl8tzSxOI6esJNtyz0qMAnN7XzmWLgxEoqUFM=;
        b=dzphQpqMM3l3FFpUr05OnohNhO3p696crH6+N1//a7NQ6nVCb0AUdfknTvn6oZNEDP
         lEi7GCBNnmr4/PaTA5ZLnoLvlhD/nAz0cIUJgXtSwhbFKt2aIJNtIehNDAAyRISVis/i
         nttJGeTfVqW/NSFAB+hALeKAJfzfcXDKhlacQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789892274; x=1790497074;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WYbMRPXl8tzSxOI6esJNtyz0qMAnN7XzmWLgxEoqUFM=;
        b=xKT1dl9Ec3ky8BpeTYb6oP5qkwFaECrvvplq+VvNqi2h7St2BVEGN3ANf/0SKUwy0q
         ziPD/Kurcp6AnTnIa0+2YKqDsOJPt1A/vm5K9y48K76lS+mwDTlNZIvs91WgFdEcRV67
         d+faUlZNMvSj8okLedUiBajCyovxYH7BP1WinOEFpnaAqjG/fmqyz1RZmIHUGXnGIsPx
         QbfpQsqbw28Ip/sC1b1ozExzjcef0CkDNaKeywAZTFl67mr/IMAn4zMb+gTsEJA0YPMN
         JxfrIj70/zvsDdsh5Txt1koGj+UTH//LuB0/vFBgFZODa9Kgv5HII7VoJf6RlHBKTYRc
         iG6w==
X-Gm-Message-State: AFuF++meh0YAQesTycBc7XBnh2fRl//8NJCmm5DyslX9b9xlJ0ZA/mgM
	pQMxDvHL9zjMuBiXFNLX8JT3onyedkvAqKspigfvbs4oK28mbrN+g2U7lUhxVxOgUlaYNiTklCT
	bOOp00X1mNrwb8mnl3xzlNQ7Bf226ouh/11QVAoBVig==
X-Gm-Gg: AYBFou2LJlHL98rvaAzjzWyH1Yx9i8aQShxvBRNOqoOmCblu7EJ5bTC/wmyXA2m4kQo
	QGo7O/lIV+/b1j2nUokhzmzHyRy21G3Bsg8yo5hgZdMPBlhlYmqZUwKrh+Whl2U/dI3QlTjJwXd
	Q/IePZByk2weAUKdWD08+zFlhjT4lw76yH3rg4cgmX2MveEfg75cyC3SInlHh2PPJikao1R39y1
	RMXHBxxBjViOIW/NuDppwlcoRK/Pt2esE+CfhNFbSF44Tya005R47KhSdmjsrXKCGGrdVo1quxQ
	LU03KMY1ckYAhlgz/947rvm+O4MBukVuX9tzjcGGX5TyO0gGKAUW
X-Received: by 2002:ac2:4e11:0:b0:5b6:183c:5ca1 with SMTP id
 2adb3069b0e04-5b8c195bff5mr2095691e87.63.1789892274506; Sun, 20 Sep 2026
 01:17:54 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sun, 20 Sep 2026 03:17:53 -0500
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sun, 20 Sep 2026 03:17:10 -0500
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: from 77377267392	named unknown	by gmailapi.google.com	with HTTPREST;
 Sun, 20 Sep 2026 03:17:06 -0500
From: Kim Wooseok <5mghybrid@khu.ac.kr>
In-Reply-To: <9b5c31541fc8430b9d4205dcdff9e76e@realtek.com>
References: <20260920-codex-rtl-rx-v3-submit-v3-0-883d11351963@khu.ac.kr>
 <20260920-codex-rtl-rx-v3-submit-v3-3-883d11351963@khu.ac.kr> <9b5c31541fc8430b9d4205dcdff9e76e@realtek.com>
Date: Sun, 20 Sep 2026 03:17:53 -0500
X-Gm-Features: AcwNN1VmswgGtvp5aGOT3uasAhXGdEW1BzQipYCZHO9YFjYbPQcISGcZH6olLpc
Message-ID: <CAH1Bc_yTizX4Cex+GRLeRUtaBdp8jEc2XEyawMzkQsZFpj1QGw@mail.gmail.com>
Subject: Re: [PATCH rtw-next v3 3/3] wifi: rtl8xxxu: preserve RX requests
 across recoverable transfer errors
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, Jes Sorensen <Jes.Sorensen@gmail.com>, 
	Kalle Valo <kvalo@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Ping-Ke,

> 'retry' --> 'defer_schedule'?

Agreed, I will rename it to defer_schedule.

> Not prefer using bare system_wq.
> Can both use schedule_delayed_work()?

In v3, the error path uses queue_delayed_work(system_wq, ..., delay),
while normal completions use mod_delayed_work(system_wq, ..., 0).

I can replace the error-path call with schedule_delayed_work().
However, the normal-completion path is intended to bring an existing
delayed retry forward when the pending count exceeds the batching
threshold, which schedule_delayed_work(..., 0) cannot do because it
leaves an already pending timer unchanged.

Would it be OK to retain mod_delayed_work() for normal completions,
changing its queue argument to system_percpu_wq?

With that change, schedule_delayed_work() would select system_percpu_wq
internally, and mod_delayed_work() would use the same queue explicitly.

> nit: a blank line

I will add it before the switch.

Thanks,
Kim Wooseok
