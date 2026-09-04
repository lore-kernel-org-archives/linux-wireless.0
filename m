Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD3C36606B
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 10:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788518171; cv=pass; b=F4L2NslnQOa2wTucg310iwPzoaN9D0hR4fUMj2sPc2hy1GH7vXuXPICuakv2lGQPEBo4nxUAtJu6W8zjD2D68Cek0eeoaoKPL/pAy4iffGvSdXkWyJ4SCtAAkbl2zmENhRSNnV4BgKS/vPVQzYKmrXqS7bR6+uxBfHfTCUnqH8g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788518171; c=relaxed/simple;
	bh=XfirP5cZ3W27NPzqWna/cWFsGXc0agU1AKVk5Co+XMg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fFJIbjBhYaY/YyKbGpbXUH5+Tucw4EsOox7ZrujhklU4EoEk+wxFi69Mt1Kv5/yXDTJRmrQSNd814QEw906YVnjQUahnQjcO2C0LvgCySEL4xykVIQRidLZsyLi3hE+0ANss7RfSSpjlPOZlDsDfYXH/4KXsdoaMuY2Az2hRV/Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=ulghcW1N; arc=pass smtp.client-ip=74.125.224.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="ulghcW1N"
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-66e63c2c9e1so2031435d50.0
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 03:36:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788518169; cv=none;
        d=google.com; s=arc-20260327;
        b=hOS06a/b5k1RwGDQX8ipuI1mnneVOQKOrrAyDiSAIxbdaVMAsY886hLqBXfTwr8IM4
         cDILYmf4lshN9iht7T3X7jR55P0m/spxtWHWYimSYP7KKeKQi9b2WqrMMWtuMy2ufC5i
         mz8/ag+OlJnU/9y1WN7kaetUn9hq1NKNjj+MNHpI3gcnuZozYuS6NkYiMuKzW93xXzgs
         6ZttV4JwlIPBmr+h5XUi59jrdLbSMqAOKU3QqihfSTElmTQ2JtOhpRmMjIIlzz4SYI7z
         VYSpHppFWDBsdc+cq58d/prKV11HVRM8j/2/qoAExWMSRTLjWb7eNXc1wBqJkdy+Hfj9
         Rc7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=QWr5cOtQM5GOzAi3jY+ATiRyu3ycLBDgQWy+ia6YTlw=;
        fh=i847w8/GjPHkxOu2eKCyAxBvYHGhotaJJtx/YY1Gn7E=;
        b=FpJ/erk9ZTUzKm4qQpsg/l4o6GohQTQRRzeHA0VmGEDiEyfNaubzbdhYcAfTs6vuYK
         aCOHnogOktznGENtbm77hsyKxXWwqQPDwObqvroPdrI6rGqww55AiqcFQg2qRUuO/KYS
         7HubM4fuLK6yga+WEwRddy/nlqvac0SAs+HT3CIyw0pMkDnNWpNS23gOT7S9w8hPKpLG
         daqcIrm5Vg2OKM/+r4iOge3QafekvkcyZ6aAgpljvWsaJtcsaT4Q8DWT9vfDzQWBan8a
         HV9f25lEL9/v4d5d7xnpJNSru2k51Lyokn86+teYmryo8du0PMDxqMV1GJhMfka9aiHw
         n+Pw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1788518169; x=1789122969; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QWr5cOtQM5GOzAi3jY+ATiRyu3ycLBDgQWy+ia6YTlw=;
        b=ulghcW1N8mrAmEx7P3aW6ZGdUhNsZzMfh9pojMyuXSfB9k0FNEeho3UJI0PqufPB/D
         5BEVvzrOhb3r9Nb5dEPwpCa23GWEzBz1ab9N24oSKDZkO41tGNv8IRVnc4EUwqeszUwK
         dr28VaIleQ+sRprYFMlHjiSuiC/NuvEbJ3NPBUCcHdxsTDiptOa50jncsc3+nDWRS7oj
         aEJ8Pc1qMEKq8OU9VWw8JrdK0faqjJdLJIFtiviusPxRohtDoiF5drzLcJxWhrf2cO6T
         sVOaoZ3geATwYvaFjofBncyoCRrccILiSmZLIviZ2DoyZkJsY8UPCnVwamaU0whY+AHo
         t7Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788518169; x=1789122969;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QWr5cOtQM5GOzAi3jY+ATiRyu3ycLBDgQWy+ia6YTlw=;
        b=sVvfN0qp1jv2jaB0oVd9Cz0AOE3bWJIzESBtBwBXvrUCZk8m6jIg78XqIDRybG7bnS
         kvKgK8qTHXhnVitfAO5WTyHGN5CC5uLVIMSmJY2FtpPEuZNahZYZ0REQVkHZagjXSc3N
         yDetOkPRudUBd+Fx433/5gwhnyIE8TwoitD/WAMkE9XDrAwU8yMNKWhvmAE4MLy6lDyq
         1GxK4CAzuCnm0n2eRKHw3N2LGFYBV2cCCck6Pd0Cyf0JkvDJrKkIYCJyJQy1neFTRo9f
         tLlxkalluDyfWPmVqp1ltCz3rVSb5aLEpDkZORHYU/B7T61xZJwyY/n3lqvlUQQKp7LC
         pgbg==
X-Gm-Message-State: AFuF++m0781EMMDOUE2L1td9kly/cF+oyj+GucToGyiZPPSDE9Yyex4H
	m3UBPqmvVRj+lOaTNpUtvvadSdPkvNpNnVpzfD81E5OMEsAPtB7+GPdXuVFBT/7V6VE0CBrrKHd
	+/c+iM2WcKGA7UmpniZ9ryo8trwzKfvWMaxj0Ejc3
X-Gm-Gg: AYBFou16ZgX2grWwpUqZkaWDb0E1KgEY0DheDaoIg2A/aJkSmelHoGp6MZW5GdSt+F6
	zccwCpkKN2BEcD5QDQw+FT+GuGq3aoZsCZy3EyDijK74lHoftopvO3MC2B7BAaVGQT9Nrd/3g2/
	QxtoSS3opRbSMoZRlWc9xoXAKSHUBE69OQtKtXhEywH1xF+u/8d4XsfCapAiOB3qr/lqQq8PQ/q
	JS9vfTyKrmUYcYJ3ZzoPi3eoo11EzQmt4OjtEVQ43kQ1nvcajiYvcUrFXWiwblFVZJw9CvCHmEv
	E/H6u7wyV2ZMWcxgZhWMIl0aKg6ksJ0hkV7FBijF7bLvrsUe1DOm9tdG3nCkcHa5A/gP2t9bj27
	miBHoSONgI0jIov2KAmVEHNS3UBnhxcLjk9tLncjfVh/4ZoGgfzzo+ovnYKG0+NBy0kbKnirHep
	fqZJcuXgNQrb6OFQkZl5al0mqsvKW5GA8ykSaE7njuCkrDCxmovKU5LgGURH0ydKBPQNACqWHqB
	JgXTqahoZT2INDAFTlEmOyKGINCvMOei7nPPwcwRa0FBZ94X4Xwy6uyIV0+Mu+t7Lm3OUu98Qh/
	pg==
X-Received: by 2002:a05:690e:bcc:b0:664:b559:d524 with SMTP id
 956f58d0204a3-66fa90a34bemr4465410d50.4.1788518168768; Fri, 04 Sep 2026
 03:36:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260824142435.1757391-1-julius@bairaktaris.de>
 <b61760b0e284898db3dc3c7856da128ba637330e.camel@sipsolutions.net>
 <CAC1t37JMHWHNfEfK4+2uMj59+rkQATftmohmxnYM63crYGWysw@mail.gmail.com>
 <6d033c71732e8ad2df4abcde1d38d89e2536609f.camel@sipsolutions.net>
 <CAC1t37LF9Y=s23DNXmg9WM6sV+ENg+hTNgRNiW5ZMEwqx9CZJg@mail.gmail.com> <b1fee6e45c4e2d215437f112c8819d74547ac11a.camel@sipsolutions.net>
In-Reply-To: <b1fee6e45c4e2d215437f112c8819d74547ac11a.camel@sipsolutions.net>
From: Julius Bairaktaris <julius@bairaktaris.de>
Date: Fri, 4 Sep 2026 10:35:33 +0000
X-Gm-Features: AcwNN1X8qBMqxa-wSeDWudzelWuUGSakcehYucLVlifAz1wX19So5A0zVeuBOZU
Message-ID: <CAC1t37KSg4rHmWBWvF1OkGfjYjVuQ44oDu-F=s4-7RXpkZD7kg@mail.gmail.com>
Subject: Re: [PATCH] wifi: mac80211: scale the airtime queue limit by the
 station's weight
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, toke@toke.dk
Content-Type: text/plain; charset="UTF-8"

> Now I'm confused - I was thinking it'd be wrong _only_ for ath9k etc.,
> but you just corrected me and said that ieee80211_next_txq() is called
> anyway, so then wouldn't it also be wrong on ath11k? Or not wrong on
> all?

Both run the DRR:

ath11k drains the selected queue until AQL stops it

    net/mac80211/util.c, wake_tx_push_queue():
        while (1) {
                skb = ieee80211_tx_dequeue(&local->hw, queue);

so every station has a full queue in the chip and the firmware picks
the next one. The DRR order doesn't get exposed to the fw.

ath9k hands over one aggregate per selection

    drivers/net/wireless/ath/ath9k/xmit.c, ath_tx_sched_aggr():
        if ((aggr && txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH) ||
                return -EBUSY;

so there the DRR order is the air order and the weight already works.

mac80211 can't tell those two apart, the driver would have to say it.
Would a hw flag be ok?

Julius

Am Fr., 4. Sept. 2026 um 10:07 Uhr schrieb Johannes Berg
<johannes@sipsolutions.net>:
>

> On Fri, 2026-09-04 at 10:02 +0000, Julius Bairaktaris wrote:
> > > ath11k doesn't appear to use ieee80211_next_txq(), so it doesn't get
> > > this and then AQL doesn't really work, I guess?
> >
> > ath11k is using the generic handler
> >
> >     drivers/net/wireless/ath/ath11k/mac.c:
> >         .wake_tx_queue                  = ieee80211_handle_wake_tx_queue,
> >
> > which runs the ieee80211_next_txq() loop itself.
>
> Oops, my bad.
>
> > What is missing is
> > the AQL feature bit and the airtime reporting, which my series on
> > ath-next adds. The numbers in this patch were taken with that series
> > applied, so AQL and the DRR were both active when the weight did
> > nothing.
> >
> > > But for a driver that *does* use it, I believe this change is wrong.
> >
> > I agree with that. It would have to be gated so that drivers like
> > ath9k don't get it.
>
> Now I'm confused - I was thinking it'd be wrong _only_ for ath9k etc.,
> but you just corrected me and said that ieee80211_next_txq() is called
> anyway, so then wouldn't it also be wrong on ath11k? Or not wrong on
> all?
>
> > There is also the possibility of dropping this change and letting
> > ath11k pass the weight to the firmware's own ATF, for which the WMI
> > commands are already in wmi.h but unused. I haven't tested this yet,
> > it's just a theory, but mac80211 would stay untouched. What do you
> > think?
>
> No idea, sorry.
>
> johannes
