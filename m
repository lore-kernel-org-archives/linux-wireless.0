Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAAA33A9CF
	for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2026 05:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781067975; cv=none; b=dv9zc2IV88qqPNm5iEzIAwLDWW93HU9Grgej8VrhJxO99pZg+wUN+VFI43xzywz0b/nXqjMJVLzfcarYHpIAChQlYkCpyc5QgrZOabaYuYsgk47BX9DMqpcs0LB3xleAqdLG8bAbkiWWgl58+/Tf5voACczRXkY36pJxk0Gx9f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781067975; c=relaxed/simple;
	bh=LUIC2B9QMtIuEEnto3alhS8CCkN2+np5oTgQiL0tVu0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GiF7TYpiut2nw/PyaBKgsQZ5fHM8J9CxRspQQmT5Z8dv0+GUhHFYoUbxtOI5KMfsSE7jc6GeJdObq7SaneHECaIiE3US6uMLSN7LBebaZ5qRtAIFYsxjFtRJJ8aXxgQWwqxS3mCusZtQ3halzppzAuF25x3j+QtEqryMaJTD2dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=UkschsSW; arc=none smtp.client-ip=74.125.82.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="UkschsSW"
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-13827115452so4346c88.0
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jun 2026 22:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1781067973; x=1781672773; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UKCkc90FILJZQ+NUUUiS9fXXtaaJVoUZKxysQ0Hi+RU=;
        b=UkschsSWHcrt109XcHaHIXKPvSN+1U6/I9elTpHuG1s1mWgGUAZEtagsvcxWmL45MN
         Vv6r4UlWGytyG1n3Gu+7zGlgxvAC3EPeFkIrl3cyICLIcxVs9YMtP7jON6rS0NXbuTVA
         LTJQym7enA0InMbJmKWJaJBgX2irQlihjgmu0khJFW2qZ+jubVuBV4OIeQPPivgO0Rsp
         6PpSIje+J/cuc3utaMlgp4PI0tOgQKeHLZ1cRVVn/U0OqxiQI0x9oz9AbFpxhagU3ZHV
         OErqL7V7mpQI4/Lh4+tiLZXGhOUz8alBbm8p0RKuinvJvH+O2jF2GLHdcv0fBZ3qaWJ2
         hS7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781067973; x=1781672773;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UKCkc90FILJZQ+NUUUiS9fXXtaaJVoUZKxysQ0Hi+RU=;
        b=BIceZb7IXgPtH1T6zL1B2jUc7enQWLNIyEq3keUrw67wGPwkI1UzUXYYF3gVjByJqR
         zYS+1Tgo7c/m9zarih07ZJj2SYXplxA02Id11mkAKJMWVzeRZRtEWYkQeCAIG/M6PnNK
         QNfVrtIzxeacm7QLI1cJAb9LRJ/03EcdiqzYS8IeKdvR+CLOGOpnOrFzXOXMsl9hpWi+
         H9Fp/8n3aKkxN0pEx0E92fBFbDl92f/p44vmFafKEtbLqd5GgfbPUfaATD33r8H+LaNG
         LXOVcy4ez+1YQF+3oUNkuvOcSLHrYlPRs2tWhHQqFNOaUfs5LsXaLn610+eDQnGSaFW5
         gKdA==
X-Forwarded-Encrypted: i=1; AFNElJ+rn2pGbAL2dvnau5Cep0N/C6qSXAbCKLM9reRxIG0GzalnLUsFGunqH0+ix9LUSC7Qezj+3VBROIvSBnsjGg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyIvO9iI6W6G2Mo4K0Q2nnPScG7nkW+YZPFOhlN9cgNfkRHbMmN
	O8K/YfCrdtM/ymQ4qEJIXKE1/UkGIbDD/2dlQNTUJ7SR9GFv99+O6CTwD9b3aqLlit4=
X-Gm-Gg: Acq92OE4juhLnDJu/BeExnbF2nckvZTLEtst/AF5pY/uFFvux9IIld6XY1gsSS96L+d
	pp1PhBeGKtVRFC7HCYHWBheefKasobHtjQW/6wEJTjZFmqMHYuUULKABAW/YQjtI4XFpM6w9k10
	6SHqWH8HVUn9NQxLUPSgbfKL9pbt5RvgXoEJncHNvYYyU9LexhaPLXWhEpUtI1d8MXNcHs0PT8E
	736UOuG8aeNDe19TuCl2aBn9zeZn7TaDqDdEI266zEFPeBBpBU+gDTVAEbzy59Ujl92N85NSlBM
	t085FrtzZQXlvtHeBYlqx7EXLVKkINiTfBlOrxwxEDHSaD+choQLsH6t9YwCZxED5jXB5v65ALv
	L8hTYVixTlsVSqJYLsMK9TCeMEvbDQTORcpoZObcU7MAEO49+XbxJhlJM8rZDVTbkDewp+WvIp+
	N4eqap/Oj0tVkhJvlJIn7v93Jb/EZm3qjT8KLHgjgyQIlocuL9m31U35T+uqiX8Px9mKAMVcqDp
	6zaFFpg20hTa+ovXXpeZeZaGXmIEYRzMg==
X-Received: by 2002:a05:7300:a886:b0:304:6448:dfea with SMTP id 5a478bee46e88-3077b358974mr12906015eec.33.1781067972782;
        Tue, 09 Jun 2026 22:06:12 -0700 (PDT)
Received: from localhost (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3074df75ff6sm25415040eec.26.2026.06.09.22.06.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 22:06:12 -0700 (PDT)
Date: Wed, 10 Jun 2026 15:06:06 +1000
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Callaghan <dan.callaghan@morsemicro.com>, 
	Arien Judge <arien.judge@morsemicro.com>, ayman.grais@morsemicro.com, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless-next v2 06/31] wifi: mm81x: add core.h
Message-ID: <iqcuzdgftpv2zymapftokqycuvqoelef6zbhm2eufki3345mqw@rut3iurehpet>
References: <20260430045615.334669-1-lachlan.hodges@morsemicro.com>
 <20260430045615.334669-7-lachlan.hodges@morsemicro.com>
 <f6dbd068437564e18695b1ef263ebba27ad7fab0.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6dbd068437564e18695b1ef263ebba27ad7fab0.camel@sipsolutions.net>

On Thu, Jun 04, 2026 at 01:40:09PM +0200, Johannes Berg wrote:
> On Thu, 2026-04-30 at 14:55 +1000, Lachlan Hodges wrote:
> > 
> > +#define KHZ_TO_HZ(x) ((x) * 1000)
> > +#define KHZ100_TO_MHZ(x) ((x) / 10)
> > +#define KHZ100_TO_KHZ(freq) ((freq) * 100)
> > +#define KHZ100_TO_HZ(freq) ((freq) * 100000)
> 
> Maybe not right now, but at least the first one seems fairly generic and
> could be elsewhere.

There is a function:

static int mm81x_tx_h_get_prim_bw(struct cfg80211_chan_def *chandef)
{
	return chandef->s1g_primary_2mhz ? 2 : 1;
}

which should definitely be in the cfg80211 since its a generic chandef
helper and will probably be needed at somepoint in mac/cfg in the future.
I can probably just have it as a patch prior similar to the SDIO id
as part of v3. Then I guess I can also do the same for the helpers above
and place them alongside:

/* convert frequencies */
#define MHZ_TO_KHZ(freq) ((freq) * 1000)
#define KHZ_TO_MHZ(freq) ((freq) / 1000)
#define PR_KHZ(f) KHZ_TO_MHZ(f), f % 1000
#define KHZ_F "%d.%03d"

Unless you have some other preference :)

lachlan
