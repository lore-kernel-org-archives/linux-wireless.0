Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2095F2D2394
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 06:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791266825; cv=none; b=XkAGp4ChUZUySnHAMly66QX2oVM0QoIlnwO/ibBG8cH1kEVBt50csH8KxAXTCm+f7s8nBmR8LarCT/vnDjekFZNsbMF0vqSKrvfKVQfj4u7THgmg9Gr6/MbD1Q7IFeeDbc/P0lA+2S/q3izP8/qet8gZ8nUgPR53ZlCpjQWsr1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791266825; c=relaxed/simple;
	bh=17P5Hs/lV+mbUDdyiyeGJu60W4itGS0u2/XcJK415qo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rRLH9SwXoqo3edWwz5XOfUQcUBVCCpUasyfQ9zl6VJKpqIYuA1563TbMXaEDz5nyY7IWYJXTjtut5YOIuqQO3Kta8UdGBuVu2nY0SDJ3hwJ897N0+n+9UjU/pOYDcEygUnwf/nORpE0RdmE+UF4LJQG6wm0PeDtpqC9O8N/q/mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=KHQ3DgMr; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="KHQ3DgMr"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3a813079a55so164509a91.0
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 23:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1791266823; x=1791871623; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9FjCCulmOBZkxKv2Rx89VTM7WOvTYZFoREE1tHLMK5Y=;
        b=KHQ3DgMrSuOEcnsOKVLr2BiM5vYFWZUuERfBV1cXd4vcL1sqqFqiKvJmFTyoD8bSCJ
         3a10VUCoiq4z6zrgC1X9eGVMkKwc/W9DElLYy2UcaLMEt1QLZbnNF3L3si6IBTby92lZ
         AIs5nqf4YkgeJp7WZYBXqWEP55WrIil0lrOx4ERRNjYib5NR4khyuLM+88YLv4hAR1rf
         oCZDwn0TnLw5O0rX0k+yZfWcdvWrGJayCE2Bph27WkmmvF2CywIK73ecgIfwAZm0pzvh
         ydHm/ymE2eVBmJNKC1hsGKMkiAtlWi5QNPy4OZK6tohbkAzGYP7qQHCuZYcQJCG2apJM
         RM3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791266823; x=1791871623;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=9FjCCulmOBZkxKv2Rx89VTM7WOvTYZFoREE1tHLMK5Y=;
        b=D3ukpeqx6INVHU3fk9bDl7WPVBEmiVpNdqA3Fi+54CWQ3LNdPB5seEVGzEeSbzAxQU
         GNLEMm5hWbM3SjhyOSNv7IpS5rgo6p4mSClWd/QngBhP4MDlG2U4gAmsij03JWZalsAO
         xg1xoWGTsWCOP7FwDilO3kOQ8X/EPQTn+CMcZdmSah9KCiUDXbQmQ/siimt74gkvR1Ye
         /J5fLqyWhNUlBwa1aOUetDzRU+ftC65olye7oBYJ8ktIvJGdo6M+sis8UAP2TFGAkDXf
         dGSU9BBjNonZ1WDMjdtvI1pNH6/VZ+VPIcqdnbpYxWRdjqmoyN4rdpw7OhJpYcDhxwxU
         lqOg==
X-Gm-Message-State: AFq9FYKxjNd/mSJ9+bbVZrwTz7OQKLgx9ZQvYvZwCgMrcyon5tq/SEQU
	tg2rgHyHVQjUyFIEQwyQLApx+A3AJMtzsnSfoNjseecAYUSJRNKiyrBmWJt5WcJuE3dvtFguukO
	ovbvJ
X-Gm-Gg: AYBFou0v+WnBElj6KFGDLHGEuAQWLHQEDeMfxftFcEo/7S+AF2APcLfV+MSFEBnIf4e
	Cuzy3goZyIzzcNpRqGdbrzYRlm5feNbcrkewTK802cFA0yDPyF/va9kYoV+dqpl4ey4dCUXCmCc
	tEKF6nE4kedAwXI2zSoT4yAm8Xyg/ASBX3LiLZTlFwSZAZ5MLWNg8DccmkXAZ3VXK8kUJ5lbgAQ
	YrpmSsGJC+eopDO0xtT1lAnDeDufqQMbS80ktkK0LSVIebrqLwGiNCl7vMtrCeIIa0cc64uZYmZ
	QJEOByO0MlwrT/ZmQJhIaHyOHdztz6BmuTDAdLf2f1Z2nJdo2M8QR5Y+wezBk0JO1hF3iO6OEfh
	n/MKgaBf7u7LKVP2bOwqHjz0iK4P7GbBw0K5WDAzou0Qzdr0GLSJAQ0wqUNxcrME4LBG/R3LK4u
	lv34uhPNA5/cWEVQbh9WSlseHGKRe2CX43/0Jy/0vQkDb505NrZaKq8+/l4uYve8MyNPfv+SJGB
	OZqwc5StylM2peRD4kp29LBE89F4+h/PP1ttA==
X-Received: by 2002:a17:90b:3b8f:b0:3a7:96d:feaf with SMTP id 98e67ed59e1d1-3a87368575emr220187a91.16.1791266823277;
        Mon, 05 Oct 2026 23:07:03 -0700 (PDT)
Received: from localhost ([60.227.235.15])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a853889388sm3584337a91.2.2026.10.05.23.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 23:07:02 -0700 (PDT)
Date: Tue, 6 Oct 2026 17:06:59 +1100
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, benjamin.berg@intel.com, 
	arien.judge@morsemicro.com
Subject: Re: [PATCH RFC wireless-next] wifi: mac80211: correct rx freq
 handling for S1G
Message-ID: <wuvncofp5z6iugj6gu7uvfj2d7fra6ymikyfnwfmwoyok3lys4@p65d3ycvnub2>
References: <20261002072954.1168872-1-lachlan.hodges@morsemicro.com>
 <640a58333ee31c09703cf6f591d96933374093df.camel@sipsolutions.net>
 <yobzz5gqn2mb2mogqlxmwrilrzp5orz7up656p7zgvjukfp4jy@kv4f2szn2gkl>
 <fecc3de9ceec2ca6dbd49194c1963cc3456fe566.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fecc3de9ceec2ca6dbd49194c1963cc3456fe566.camel@sipsolutions.net>

On Mon, Oct 05, 2026 at 03:53:01PM +0200, Johannes Berg wrote:
> On Fri, 2026-10-02 at 19:54 +1000, Lachlan Hodges wrote:
> > > 
> > > >    For
> > > >    management frames obviously makes sense but for data frames
> > > >    sent on a wider channel wouldn't this be set to the operating
> > > >    channel? Especially for i.e sniffer? The mm81x driver reports
> > > >    it like this but maybe it should just report the control channel?
> > > 
> > > So .. are you saying you always report the _overall_ center frequency,
> > > even for 4/8/16 MHz widths, or just for 1 MHz vs 2 MHz primary?
> > 
> > Yes, our firmware reports the frame at the overall center frequency,
> > even for 4/8/16 MHz widths. Looking at our out of tree shim driver
> > (5G mapping) it does the same thing i.e report the center frequency
> > of 40/80/160 channel which is probably why mm81x does this.
> 
> I guess that makes some sense.
> 
> > Anyways this is not really a big deal knowing that we can just
> > override it with the 1MHz control channel.
> 
> Sure, but should you?

Okay so I did some more testing (sorry for all the back and forth :))
and I think hard coding the 1MHz control actually has some tricky
edge cases such as scanning while passing traffic, since while we are
scanning we'd need to pass the correct channel we received the probe
response on (since we do hwscan).

Additionally just thinking about the problem as a whole, it would be
more correct to just let mac80211 actually handle this whole scenario
of 1 vs 2MHz primary since after all they are both "control" channels.
We already do this for beacons so moving the logic such that all
management frames are handled makes sense to me. Then for data frames
the station can just be passed so this is bypassed anyway.

Let me know what you think, maybe re-review the original patch and I
can resend if needed.

Thanks,
lachlan
