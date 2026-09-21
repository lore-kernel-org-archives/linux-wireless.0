Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com [74.125.229.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15FB14883F
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 07:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.205
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789977545; cv=pass; b=G68NV/BKbKW++BZh2Yn0Gu3yJXTlCqbNEMOx2c/ev4r/RYxvsPcpUvjzK+2xGAu4bOQw9OxZZnMU6OfaJrb70hwNycHsXdm1ODpHpWOvCKOXquHHtp0hVowOSxdvCHtEqklFC8FaF0PvYII8vbZmwBiwWEad0kjTGqNhiCwdea4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789977545; c=relaxed/simple;
	bh=NegY6gtmqum1Gxdq8ZWRKydUtJDoGcrkBSunDsp63z8=;
	h=MIME-Version:From:In-Reply-To:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lWV8xqMLlYRjQNHLZ0+LAMVvp090Z982zbMPTcRM3sizNSyLw6P1C3YTnyVgyutWbmVeLgKTBtihfkMsiFEl3EJF0QjGKPT5SqBR5wH2SDN+K8NWr3RSRYbTUOVxUmPviGd5ZznrW05ejTvzgWwcVdmqvlJSWngHOe1RmVMq7HI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr; spf=pass smtp.mailfrom=khu.ac.kr; dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b=BOtt60UA; arc=pass smtp.client-ip=74.125.229.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b="BOtt60UA"
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b5e4f16f12so2264302e87.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 00:59:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789977540; cv=none;
        d=google.com; s=arc-20260327;
        b=ohFInTdnCldage6wDcGoaPQx7i5RM3n2b7rIJGhTy6AEbqjzqGDLZ4kr/tm/O1Hjm3
         fagq4ATtffI4BL5SaTxIa9KXdF48jcl3+mkPEFS7arfVleUzrAE36y/FL9wnXDFeZzFy
         Sg/wQrir3XzIlj/z/bAaWK+x51E8AlJTyQdF+NzIbgSGdt63zg6CpFFIQjf4KBg3s1BR
         TvL6FJAVsKo0zpLVWrdCDg9aI+lkhVqxB60zJAdI3t7N+PSOkDx+d4gXyE8CkD1Vb7z3
         vbVE/w2AZ/1dhYZCCkdlbJLUZ9XNht1f/R1+qJNqd25knLtMWYaj+5clX2VMgFXteitR
         oyGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:references:in-reply-to:from
         :mime-version:dkim-signature;
        bh=NegY6gtmqum1Gxdq8ZWRKydUtJDoGcrkBSunDsp63z8=;
        fh=n5v73YiJzxMAAE5ZePeLdT+lpUtZ9Qo7rWbrpoNNJIY=;
        b=gSAoybajSTHKoLswJbWbbBAn/qWohZL9p70yJNlMdfDhHFVSfvNnj9j68w6b3PJSeH
         83pAvwfdlMLtXcyNvEDj9iATs2KWpC8YFJqVFpOjayDZZfGW/xaQA81yBjaQcUF9u3Es
         DFv/wlckLCN5YqHLQuhF+HXc8ZoKqFWNP1SOPgNeCqAvzK1r0+sro4s3EXwX/bFREEdt
         wxQlCpN7V3H46Tde8rSskMrYClGnp9lff3XnPGiM36IdPiHdyAXNoP9hNprjqdZn5JT8
         tqyOeaHoWWyIPs4fR3XlN+WKZJlaU06cOFn1O5fV1Ag5vCYFPGZRiHuVf17vx7LheXqw
         EQ6A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=khu.ac.kr; s=google; t=1789977540; x=1790582340; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NegY6gtmqum1Gxdq8ZWRKydUtJDoGcrkBSunDsp63z8=;
        b=BOtt60UAtoDcImNOpXkwQWOZyvVNQHqDiWriaisV717UFMRyOPZwd+xdWWXf+xPA0l
         M5vkSB00/m5dHCAVM+F+7M2avl0LsHgKy1L/EfrlIGe1c6wFlSzGnw5BUYtvd+jgcvEq
         ljnnDbbdANsgQ09hNEwaG1EXLmEJMaPh6kC60=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789977540; x=1790582340;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NegY6gtmqum1Gxdq8ZWRKydUtJDoGcrkBSunDsp63z8=;
        b=nhHqxkd77KycF6eTAhWvR2b7lVyPfbYIRnj6MwXYXQRC7W/T+KUHzOisd3r36aIsla
         CamLaW4dtp/fsK6EWvIfocewZdfH84JE5drl6Npzj/K/UmwJBcjRHZ4t4FzD+7uS1Sjz
         UDHjRaVpF27eKaHR8wwUjA1bMEO+fXRgY9Nf9EmH6YiXs8CAmMl8ad4J6IOGshSzbLov
         +QI2Z0eG6PXh86HxvdMUoYVUk43xGsT1SSwATbPfZGDDOcJ6E3o6KITsVf7YFS29eFuG
         JBfHMQQm/VSY79OkLgv1W42292yEOjlByrJZzy/4kXZQNAbMKVVXPueQJeY+/wsWonpv
         KvnA==
X-Gm-Message-State: AFuF++mxCj6zhO6U15wW46KbnpYHsXgDXUHl4Ga0rxFqm/zgVkycbazf
	4vJl2jXYnoTIiECMcgZOCnjfvsC5bb5qxxmXQI5XAqMLw1/SPnWFo4lypDiYgrJe3pW9Gpja/aE
	3xUYBRlCb5VhtVPQEG+RA4fjS0atLiZC+09/DCxkRLQ==
X-Gm-Gg: AYBFou3VCYV+mHgGD5n6IsOCfRiurUN01xB0O83VxfBaWuJhWYZcz6liDmjXR2/Yhnv
	98YVFg4l8dEnvih4ZDGA9KMB0DBbly9XBDNu0+CkvQiPo82JiepkEmlD/B+NrkA491dkDey0YUV
	+ym0sbQNYt+WBRseEWwsDSesW0kbRzGDfCvVpQZ6LfyIL2Qc28nymXqc6gtrbZcUmISld+hRcqI
	ZDI7nRggTg25aRfijgT+TNWrlxMW9Q7hXIUDifzLi/yLRgZgHzcx4oVRKJCxnOpH9y7w78Yefxo
	g+TyZa5rw2AWme2dxCoO12mcMmgRGRNSy8X0ErQ9KN9Doym3dol9xn/6JpEnm/5bxshlI10NJQ0
	O/kXSQs8n4IlG/kMMbhUHco9BM8QBky7B
X-Received: by 2002:a05:6512:669a:20b0:5b8:c230:1192 with SMTP id
 2adb3069b0e04-5b8c2301450mr1851316e87.31.1789977540085; Mon, 21 Sep 2026
 00:59:00 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Mon, 21 Sep 2026 00:58:58 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Mon, 21 Sep 2026 00:58:58 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Kim Wooseok <5mghybrid@khu.ac.kr>
In-Reply-To: <8d8e60e260254dc2a2cc1f37cd1b3832@realtek.com>
References: <20260920-codex-rtl-rx-v3-submit-v3-0-883d11351963@khu.ac.kr>
 <20260920-codex-rtl-rx-v3-submit-v3-3-883d11351963@khu.ac.kr>
 <9b5c31541fc8430b9d4205dcdff9e76e@realtek.com> <CAH1Bc_yTizX4Cex+GRLeRUtaBdp8jEc2XEyawMzkQsZFpj1QGw@mail.gmail.com>
 <8d8e60e260254dc2a2cc1f37cd1b3832@realtek.com>
Date: Mon, 21 Sep 2026 00:58:58 -0700
X-Gm-Features: AcwNN1Uwfsw7ISFdbAgxmEh6c9ozvNd2-hswQt1dlcyjf0ujJ_bdW0MXQ2mOb6g
Message-ID: <CAH1Bc_xo+ubx97jGXdR4_d8duO+9x3ACs22eG-SaXHiCbzKTMw@mail.gmail.com>
Subject: Re: [PATCH rtw-next v3 3/3] wifi: rtl8xxxu: preserve RX requests
 across recoverable transfer errors
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, Jes Sorensen <Jes.Sorensen@gmail.com>, 
	Kalle Valo <kvalo@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Yes. I want to preserve normal RX replenishment once the batching
threshold is reached. The 100 ms delay is intended to limit retries
when normal progress is absent.

In the mixed-traffic test, normal progress brought the worker execution
forward to 18.773 ms after the retry was queued. I would let that refill
proceed instead of holding the available URBs for the remaining delay.

For repeated errors, I want to keep the first retry deadline rather
than restart the delay with each error. That is why I would keep
schedule_delayed_work() for errors and mod_delayed_work() for normal
completions.

Thanks,
Wooseok


On Mon, 21 Sep 2026 00:24:47 +0000, Ping-Ke Shih <pkshih@realtek.com> wrote:
> Kim Wooseok <5mghybrid@khu.ac.kr> wrote:
> > > Not prefer using bare system_wq.
> > > Can both use schedule_delayed_work()?
> >
> > In v3, the error path uses queue_delayed_work(system_wq, ..., delay),
> > while normal completions use mod_delayed_work(system_wq, ..., 0).
> >
> > I can replace the error-path call with schedule_delayed_work().
> > However, the normal-completion path is intended to bring an existing
> > delayed retry forward when the pending count exceeds the batching
> > threshold, which schedule_delayed_work(..., 0) cannot do because it
> > leaves an already pending timer unchanged.
>
> I knew this point. Does it matter to schedule a normal case immediately
> after an error case (defer to schedule) happened within 100ms?
> (Just an open question)
>
> >
> > Would it be OK to retain mod_delayed_work() for normal completions,
> > changing its queue argument to system_percpu_wq?
>
> OK if above question is yes.
>
> Or both change to use mod_delayed_work()?
>
> >
> > With that change, schedule_delayed_work() would select system_percpu_wq
> > internally, and mod_delayed_work() would use the same queue explicitly.
> >
