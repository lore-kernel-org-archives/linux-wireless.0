Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0585B25B088
	for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2026 08:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789807708; cv=none; b=HJGxOnStBqbq/qLuf6j3SqwhfMCaYIRtwdAbjsZCipsKfHC5lmBAPSuvWwuKXDKCnX2GLsZ8jGzSLxUCi4vt3TsVOoWSFa8Ej1ajsoH2Lb6okdMOmfxJdxe8pLML9TJeUIdGapitFCEax4s8a22GvkEm3hISQmU2aYfVco9sAq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789807708; c=relaxed/simple;
	bh=Wwfwaq+nW8mfhRlD+C37V8Lb80RxLePNjSXqrLP7JuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iu4bLtN5X25RqtlJ9XP2OB1j0lrfK1DIKQgAILuLW5e0dXVzyFBKgZ4hTAN9pFumLl4JhCrkrWzLXiss6+tTcTscGQIXhpmCIpC3+uECb4dKgtdAFcHIHrCDkK2PSTJVyfvV9X1u9ygX5kZ1Ku1/55naq/Gr+L2ew1yaC02ukgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VAi31YNn; arc=none smtp.client-ip=74.125.228.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VAi31YNn"
Received: by mail-pz2-f42.google.com with SMTP id 41be03b00d2f7-cc1cebcb8d7so472504a12.0
        for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2026 01:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789807706; x=1790412506; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZyqLaIHtEPPgv5nm9pHACuuTsuILPHXyQpbjXoDoYnU=;
        b=VAi31YNnQU7sEAuCcQxiMiP441GqyBGfnMLlBiLF9GdcRUrXDn+ffdB7pn1o9AEhTT
         Z0kFMgWVT82E5jNsnG/mI+CTf2dhYuSvnGgeg7ydxAdnKisEj4Z/GSvoDEc3xYa0MnH1
         MwBqABQ8C/+KkQUF4zXuJXFXovQ+rjM/xE3Yf0e7t7wxw71+nGy2L/9jLcW/uLEgn7RB
         R7fy2f63VlUC+CUMIFp5ehoxUpxOZC86OqCaCRR9jlkR/99eu+0rp3KdgMjn8ns49p/F
         gdsp8Ro++S3PsfPvgbsFGYRxDJ7zhuadNlTX7bRh2F70Vo2lbLuMJU3gZ+xVMdhHvHTO
         aNwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789807706; x=1790412506;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZyqLaIHtEPPgv5nm9pHACuuTsuILPHXyQpbjXoDoYnU=;
        b=Jvn2C0KPsMBy9Os4FbZXx0aM8K3r++5UjpI84iJKQb0BHRg0610US/7Bqd+uVAc6mH
         UTB1N2gHmko7qlIOGQDMoPOqo9QmWkTDftqs4+Vw62yWAWKV6GQn8cMJPRcD0FY/bs4G
         kvwTuioYxZnmmHsz8ew1S0GXeGINxS+cV7ZOoLJJkTPx1G1JjEXuwTVg/69DNYOFW8vE
         cw/NcfIg82bY2c46uWY7rsUqF4CjB8uxBH+ly46ZnzyKSCjPTCAeVevw0q8iC42dLkmP
         pAqn8yfFbMtkLMf4GeKfsgg0So07QhAP246keu1cGQ/YxSXNCL548OlbHdNjP5y/H6x7
         rl9g==
X-Gm-Message-State: AFuF++k4PnWSIuXkSWbk7s1pm5iVIGkC7ODBd34FLAOi60K+010ITAWr
	MaqtXwVRJpXmnc9l3lP93baQqi33lXSDEt3oX8haNJxIDRrEJCV+dSLN
X-Gm-Gg: AYBFou02MDAk2fGRRy6XtASy9HJZa5kXxby8vAOrAYxhX8j+nc61V3HNFfAopQMErTn
	hfUafFiNKg8oYBe3f0hzjTs0NGPZthxuDNxgF5N3g7QwotzMj5BV1/O3jWV2e67AzQuEjRRqD5U
	MkRVQXfbgxc/lDDU1wKB8XKvRQ2imyJs3A37jONbcW87GBgux+QrK33ErsxqBrEQvN41QuC2gme
	qykQaerPeNKS0Oc55e4/J7+8/SOU/uFeA29esQgHi8QsEiOoCuNvcN7RbcguUqztC82+wC/lMax
	pHHvRoAKPjIaCVGznpBgLoXDSnBLxDc3OjuLHXPekrdQbm8hQm0TsqssS/w0IxzGj+nRjvWvfV8
	+5yzKA0dq3be90TSwSMHdWeszDeh8vELP7ZXNSKQxc9D0BAq/9/xQZ9YRXDZ+5KI6kPU1uiMbIG
	hX/zBSFi+j64Wr6phm96ZRQRtU5oD7lnM/NPKoEa064xqF5bnhgZ+l8gLwD+6951K/zuUQwQcu4
	CDMLkdmOAvjVdSqS6nw5TYXn3CDFx/ay7H8qsQbfT9yeN5d22l7Vz64tA59rOYCzVrCM4I=
X-Received: by 2002:a17:90b:2803:b0:3a0:2614:2077 with SMTP id 98e67ed59e1d1-3a026142468mr640974a91.41.1789807706266;
        Sat, 19 Sep 2026 01:48:26 -0700 (PDT)
Received: from lenovo-thinkbook (42-2-127-248.static.netvigator.com. [42.2.127.248])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6c4ba12csm3589887a91.11.2026.09.19.01.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 01:48:25 -0700 (PDT)
From: Yuqi Xu <xuyuqiabc@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Vega <vega@nebusec.ai>,
	Ren Wei <weir@nebusec.ai>,
	xuyq21@lenovo.com
Subject: Re: [PATCH v2 1/1] wifi: mac80211: validate minstrel tx status rates
Date: Sat, 19 Sep 2026 16:48:12 +0800
Message-ID: <20260919084812.28846-1-xuyuqiabc@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <a1381c4a4c12eed998707cdf730b1b0c67f9a26e.camel@sipsolutions.net>
References: <20260529143446.1374404-1-n05ec@lzu.edu.cn> <a1381c4a4c12eed998707cdf730b1b0c67f9a26e.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Johannes,

thanks for the review, and sorry for the long turnaround.  I have
reworked the patch along your comments and sent v3:

  https://lore.kernel.org/all/cover.1789801378.git.xuyuqiabc@gmail.com/

Replies inline below.

On Tue, 2026-06-02 at 15:26 +0200, Johannes Berg wrote:
> So ... I'm not really very happy with this.
>
> First of all, I think it's kind of overblown with the CC stable etc.,
> can you actually find a situation where a driver reports such a thing?

You are right, and we could not find one.  The only in-tree path we can
demonstrate is mac80211_hwsim together with a userspace medium: the
medium has to register with the driver (CAP_NET_ADMIN in a user and
network namespace) and can then return forged TX status for the radio
it serves.  We are not aware of any in-tree driver or firmware
reporting an NSS of 0 or an out-of-range MCS index, and driver-side
work is validating the same kind of metadata before it reaches
mac80211 (e.g. the proposed "[PATCH wireless v2] wifi: mt76: mt76x02:
validate TX-status rate index before mac80211 handoff", 2026-08-26).
v3 therefore drops Cc: stable and no longer describes this as a
vulnerability; it is defensive hardening of the driver metadata path.

> Secondly, I don't think it's the right place to be checking, we use
> the data a lot for other things in status handling, and might expand
> that, so it seems that instead of having specific checks for
> minstrel, we should have most of the checks in general (e.g. nss==0
> is generally invalid), and only have the things that matter for
> minstrel specifically (say bandwidth) there - if those even matter,
> because surely we don't expect a device that supports 80 MHz to start
> reporting 320 MHz, and if that really seems important maybe we should
> just validate that elsewhere as well.

That is exactly what v3 does now.  The generic checks live in
net/mac80211/status.c and run for every TX status before any consumer
sees it: ieee80211_tx_status_ext() and ieee80211_tx_rate_update()
sanitize both the legacy ieee80211_tx_rate array and the rate_info
based entries (HT MCS 0..31, VHT NSS 1..8, VHT MCS 0..11).  Entries
that do not describe a valid rate are dropped, so rate control,
statistics and radiotap all see the same sane data.  minstrel_ht only
keeps the checks that depend on its own tables: the number of spatial
streams, the supported bandwidth (no VHT groups for 160 MHz and wider)
and the MCS range must map to a table entry.

> But I also think that if this stuff really comes from firmware rather
> than being built by the driver, it should be the driver's
> responsibility to not report nonsense.  I doubt we can protect
> against any driver nonsense here in mac80211.

Agreed, this is not meant to take that responsibility away from
drivers.  The point is only that one bad status report must not corrupt
mac80211 state, no matter which driver or firmware produced it.  We
deliberately do not add a WARN_ON() for the invalid values: with
panic_on_warn that would turn a driver bug into a denial of service,
and the values are not something mac80211 can act on anyway.

> > Changes in v2:
> > - shorten the subject line
> > - align the From/Signed-off-by address
> > - drop the Assisted-by tag
>
> Why drop it now, when before you were saying it was?

That was a mistake on our side while reworking the From/Signed-off-by
addresses for v2.  The Assisted-by: LLM tag is part of our workflow
documentation for LLM-assisted patches and is restored in v3.

Thanks,
Yuqi Xu
