Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADD71C69D
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 00:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784766307; cv=none; b=WF9QxCX+QHf+PaL305LZ8tMrWBAr7MuF5ikBzJZwcv6CBAyrrBJcvKQ6DN2LqEyc2fu33MPQXPfTyQ46VB0jdojxrO7d7UYwkpsGmeJujlzUHV+xuOGNWmLr8QoV5XG5vqxhXhgbHe39fqzQq7//aqIa9l8SCWREtSjYf/caiaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784766307; c=relaxed/simple;
	bh=aAxRosYAeIJKwi5wUEZO+2FOaQ5o7NU4oV+OuAGPhAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JRv3EMCwPak4lDAdcnGvuyoIkhrabbA4K/JrSYWBjh3Yk5IIXfq0cZ+nuEwNdAdvYT5JkVLyy96nsmjxBdImNYhE0mGrWDLS3xNQKR4lsnVc178eoDTBZxvwv7MV5Z4hZguxehSuVeCDKpyQn2s9yidgURvDr/MXvyVU0Ax7hoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=fkbiddbv; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="fkbiddbv"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ceb096e675so1017565ad.0
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 17:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1784766305; x=1785371105; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mmhzdIrrAnEmEWegAuMUoP1giQltR6w1dwPZHniwyxU=;
        b=fkbiddbvFjNd/8io9Xaw+vvjxDLN4xxTEXKZExIc96b87ODsGfd5hhWr2Y8dwD6jG6
         5a3kxBqNE7Pvnl0F7+hDo6gj3p/bLnwXk76FEUJKAzDRowcCKtnkCGdsLJ24QsIiQWz3
         ittvj/SafEmgUmpfueFCqO5JpVjUySmdjEIwcfFbif5TqcyB0hoKa53jh4CWPtO0ejJE
         8c1wB/HeN3j/tJrb06KmXa/0vibvyqMitboDO2KUJslHB3NXfIeEOPMCkd14RARyDUYA
         YaorvVUPzSrCyHc4zbd9vw8yRR8jLVedrtmkE5HiJfzBMjlC1+htkaYr5ZsIh59t67BZ
         o5aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784766305; x=1785371105;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mmhzdIrrAnEmEWegAuMUoP1giQltR6w1dwPZHniwyxU=;
        b=UY9fHlm1KDGIr/AArJC/xKNeGj5uFxSTAyN8JdTDgiCkWIwrIp6nQZ+AeMT/NSiW0f
         BptSFtE+QfelCZoeBP91skSQ2BCnebiPi2y/dIgqN1zMd81vDJbVUPlIRJFEMV9odKpc
         MhZSz5LTsRhVnJ+auurEtH3NZC8m7EC9RpGk82sw58zs/ztcwzQRVQXHH/bhZi7aUgZ9
         eZXhpynP2itW+zxKw39/a8U6BHy1Cg38VpDPR0kQirujkTAv7EyKoAr3YJ56gBSELHUA
         BBLWuPDdfY+uamyu7eCuNpNfYuB4S0BFEahfbb0sWZrZRULExNtA2oK6jIUbQlbjWsrR
         amvA==
X-Forwarded-Encrypted: i=1; AHgh+Rq/UyhIAmzJsTn//RDbL+6q2vkjRiGKmG7ipcExxYWAqfjMAYIFHBM/Awc+6FA0vvvifbzypcKpvc/zo6aucw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwHM01CzneenV0qEff+RcUQe+YCIr2Dc+HKcjKrIePA7iIegOjP
	Sw45s3MdU9sevqZLaXS+HK303yQzWgaQJDXO96IihyQhg/PC95ALNYHM0RTP4G12Nf0=
X-Gm-Gg: AR+sD11FaoPLmj8R8jugFDW/2zH4SpBucyawMqpVOAE2gPG18KnBzFnhF9lHe5zj7pB
	Ore3UQ+Br5X++7SsbFawzMH2joFEgy9Y8qQk9Qbb97ty6L2KxzIFZ2Vu65jJYf2tWxkorWegYVN
	40OJOD/XfwGr15Wsj1HOLXCQgNilpzFfnsTGJi2L9+9SazLy/5zZqpHUMgTvZj2YSImmQyvLXcu
	AhWxlfUBQyz6GNS+f3TBtr2e+LGVmUj5YyV3wjxuUeqigCgv47Hbz5mBfqKotgLXDaPsqWNg/B7
	Qgapux2i74oAoxc6wgTzNRu8sXyY914+ezcTv4Yt+uUpWoK8AAS2mUegm811XrqTl6lq6+4p+s3
	YaXwCIOMUHfb5kKOqcjokO38q6y4RX0Z3YSqL87JU1R6/+P1CRk9W6tSHsMLKYCRv1GLxN08alz
	sWxmxwxJ4T5bxkIo7D4IGz3hlSpoNxPOQxV8rnL03R5Uu2520lo8U9JQ==
X-Received: by 2002:a17:903:124c:b0:2cc:6018:f030 with SMTP id d9443c01a7336-2cfa6b7dbcamr11793195ad.14.1784766305288;
        Wed, 22 Jul 2026 17:25:05 -0700 (PDT)
Received: from localhost ([60.227.167.223])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147e088d3fsm13662707eec.25.2026.07.22.17.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 17:25:04 -0700 (PDT)
Date: Thu, 23 Jul 2026 10:25:01 +1000
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Zhao Li <enderaoelyther@gmail.com>, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Miri Korenblit <miriam.rachel.korenblit@intel.com>, 
	Brian Norris <briannorris@chromium.org>, Francesco Dolcini <francesco@dolcini.it>, 
	Jaewan Kim <jaewan@google.com>, Daniel Gabay <daniel.gabay@intel.com>, 
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>, Benjamin Berg <benjamin.berg@intel.com>, 
	Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>, Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.com>, 
	Lorenzo Bianconi <lorenzo@kernel.org>, John Crispin <john@phrozen.org>, 
	Avinash Patil <patila@marvell.com>, Cathy Luo <cluo@marvell.com>, 
	"John W. Linville" <linville@tuxdriver.com>, Aloka Dixit <quic_alokad@quicinc.com>
Subject: Re: [PATCH 0/8] wifi: fix PMSR lifetime and frame validation issues
Message-ID: <tbjmdwm22yxqcslsgi2pakemlv46fx76uhkwogcn4kfpsbq6hc@yxmlgjwzyoyn>
References: <20260708195911.84365-1-enderaoelyther@gmail.com>
 <573e7a49f4e9763b0cdb22bb4fc875bca1335c70.camel@sipsolutions.net>
 <209a011cf5f87881881cd338e1d3ec6baa75bef6.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <209a011cf5f87881881cd338e1d3ec6baa75bef6.camel@sipsolutions.net>

On Wed, Jul 22, 2026 at 04:37:55PM +0200, Johannes Berg wrote:
> On Tue, 2026-07-21 at 18:00 +0200, Johannes Berg wrote:
> > 
> > >   wifi: mac80211: validate probe response countdown offsets
> > 
> > I think this one is falling into a typical LLM pattern patching trap, it
> > describes [0] as being out-of-bounds for some allocated data, and
> > neglects that the offsets have already been checked by cfg80211. Please
> > describe more why it's actually an issue beyond "there's a similar
> > pattern elsewhere".
> > 
> > >   wifi: mac80211: validate S1G TWT params before driver setup
> > 
> > I don't know about this, you should probably resend it. Anyway I'm not
> > loosing sleep over it since there's no driver with the callback, tracing
> > is mostly not enabled, and while a potential 12 bytes OOB read at the
> > end of the SKB is a bug, it's not a very important one since there
> > should be stuff there anyway.
> > 
> > >   wifi: mwifiex: validate action frame fixed fields
> > 
> > Francesco should look at that - again, sending it all together makes
> > this really hard - but it seems to me it should use MIN_ACTION_SIZE()?
> 
> Also in addition - please resend these, the s1g should go also to
> Lachlan I think who wrote it, and I don't think anyone is paying
> attention to this patchset :)

The twt stuff has been in for a while and was added by Lorenzo [1]. I'm
not sure why it sits in the s1g.c file, I assume because it was first
added to the standard for S1G then expanded to other standards? Might
be worth moving all these to a separate twt.c file (I can if you think
it's worth it).

[1] https://lore.kernel.org/all/257512f2e22ba42b9f2624942a128dd8f141de4b.1629741512.git.lorenzo@kernel.org/

lachlan
