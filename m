Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B373B83F9
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 09:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790934893; cv=none; b=k/68hA9rn/rNcG40wutlOxHAFyeuU+zyVSc9URUEN4aEE9gOTd226rzQR1+nYqgHsHumlTJbSbQYaT4P1FoD2lFe1djVG5yTyWSHYqq44FHitvtWmEL6dPn2tMXdJKSWWih9MOBlSU+nL9wU+XBjD414hvbT4AnDb76M1o+eBZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790934893; c=relaxed/simple;
	bh=jQZqynsFsAkKr3g22qFrjpihbPUHS2jPWxhb9fsM7lY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ra6+OG5ZaaiKkkhn2Qv7H0yYbl/mgoX36diZkjODN41Je4V0wggGC1kuNY6HIh/+mmDW34pa3e3268nKM0R0ePwmFLnontiBJfh9JS82AtbD4uH0K3vOmIe69iwoPT/V+N/EkdF2v67YZ7z1meOztja20eu8WDpDeu0vwcPvc+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=oF4XWfYo; arc=none smtp.client-ip=74.125.227.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="oF4XWfYo"
Received: by mail-pj2-f42.google.com with SMTP id 98e67ed59e1d1-396ccd5cf02so3890137a91.3
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2026 02:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1790934891; x=1791539691; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PAjwYyB3klWJ2BmPwotAOMMi5BJyy2ETn3tEjd9Gz70=;
        b=oF4XWfYoZxWXlUDQBaKOnQbW1Jej9r557EED5Mo+2YPXVo3gjIQ/BFyoahPSHTthjy
         4tjASnOGKhwhOT2UrPG9g6OkGBPwh1FsKLoM3pVJiaMlvY9tScihEJ8l6oPQKI7YRueH
         mC3LxHN17+9WQ/E6YE4kKgbqh5NDVAM1+B9Gkb4SDOAHYc/Gle9p3bAUFj/MD2f0XPSP
         vkL3fEFpwaQ+MlnQspN8X7uwZkm5EvaYrtMNFdCyEm92kF1HZA/R7uF0JocYjLHKXgU9
         UdQyrv7/wkCHxOTIFYJYbuiU3uDWaQ7ziZYJCrsrz/ZguYeD2hTWI1mH+GRRLbZ+rGxZ
         0nug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790934891; x=1791539691;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=PAjwYyB3klWJ2BmPwotAOMMi5BJyy2ETn3tEjd9Gz70=;
        b=LxD5jM5xocxwxQ/IvFsYaRlMLjvG1M1sElsAupStRQJiyKXGA2B/soxw1LoBwbTTjH
         xJx4fDULTG+k2k8dZUDRdMX2Ke2Q4OBIhILThGqMeHRsTVVkzDLPpAOGIIx/0h+yNC/l
         OEzYzlWSn7rABJ25ZaaEJKPl5+IWrfK5OnnEDIC/cpMtpWZ/kBjfuVUTWYqzDAAF+cLl
         n29rTuOXhRzBrkHUbLRQ4LkdXazwAESl8eMWSLIKgvj0pTgPz0ox52Hw6AGhAoq2UE7j
         gktix9Nb4rWB/XHcnW7EqzJPvEH1yfwiRG2FfaHh9iU8gZYRAONuTFbDiTbU3COGlpve
         9ODg==
X-Gm-Message-State: AFq9FYIywXnPY9fx2nY+jTbFfO+xAdmhlaFz3fRvkwsAh5unP0ARjRQx
	g5geVcJ3SrFwZRrLWpT9lr5CR0LLsDw5U4RpIpzZ40zxc5h150Mxb4Mh27KZ842LhG0Ih6KdmEd
	gGOzoavc=
X-Gm-Gg: AYBFou35p9wEoZhL+pV87miDJzj+cqWsSuassdIyikO/Ero0M7D4apyZEKAPJVg3rPW
	80WF6P5QrIA0/i2BlL4jZrHQqRxwpeukWzGX+3ATcg6yGts9xAsXWnS2kozVwOGEaOs02DrexYK
	fXIsrNEbHKDg+X9d96QI3kSzF7b6l5SkzULKusloRMTUce4ARXqMOeQkjwWnK6puxn3hGsp0iqF
	snNPyY+HHmd+2lKXRNAn50MKWT1t5XHRTLQhNCKOLCJoxdPG4J4MREN9rRSasMa2BalAndKlL55
	j2rhbJ5SrgyFxWt1tBOi9IFbhF+cKBb53FicBZWsaf7Nou3BmnSoz9gBVmV9HUwt1PTOuGk/qDq
	2N+hdrYj0w0pSTyDhEL5wh4tY/1wCdR62c5Y9zkB0fhGMsl0ZjpYf3iK3ANeiZqFbMqalhzzcNa
	dptEMmxu/kQKGq9/RRJjZj/M9Zsh4DBO72NNO8ZF6fBH54Bvoh7jwQL48UczqaXfuOpU4mIDD5N
	viZQAqOaBSLyOKImwGMn9oTVs3RJslGG6QmQnQeVkAJ3gaD
X-Received: by 2002:a17:90b:3cc7:b0:3a0:abc3:afb5 with SMTP id 98e67ed59e1d1-3a6cead50b6mr1914426a91.34.1790934891122;
        Fri, 02 Oct 2026 02:54:51 -0700 (PDT)
Received: from localhost ([60.227.235.15])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4f46bc991sm8133473a91.4.2026.10.02.02.54.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 02:54:50 -0700 (PDT)
Date: Fri, 2 Oct 2026 19:54:47 +1000
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, benjamin.berg@intel.com, 
	arien.judge@morsemicro.com
Subject: Re: [PATCH RFC wireless-next] wifi: mac80211: correct rx freq
 handling for S1G
Message-ID: <yobzz5gqn2mb2mogqlxmwrilrzp5orz7up656p7zgvjukfp4jy@kv4f2szn2gkl>
References: <20261002072954.1168872-1-lachlan.hodges@morsemicro.com>
 <640a58333ee31c09703cf6f591d96933374093df.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <640a58333ee31c09703cf6f591d96933374093df.camel@sipsolutions.net>

> > S1G has a unique feature where the control or primary channel can
> > either be 1MHz or 2MHz. However there is _always_ a 1MHz primary.
> > S1G drivers advertise these 1MHz primaries but it means if a 2MHz
> > primary is used the control channel inside the chandef may not be
> > the channel used to pass management frames.
> 
> Yeah, so I think part of this is also related to how we through the 1
> MHz vs. 2 MHz in S1G. I feel like the spec thinks this differently,
> while in the chandef we basically think it almost as if 2 MHz was
> equivalent to 40 MHz HT, combined out of two 1 MHz channels, except we
> added the flag:
> 
>  * @s1g_primary_2mhz: Indicates if the control channel pointed to
>  *      by 'chan' exists as a 1MHz primary subchannel within an
>  *      S1G 2MHz primary channel.
> 
> To also answer your question first:
> 
> > is rx_status->freq always meant to be the control channel? 
> 
> For HT/..., yes, that's how it works. Not sure that's really *by design*
> as much as by historical accident, but I don't think we will (even can)
> change it now.
> 
> In some way it makes sense though because otherwise you'd see this
> flicker around all the time as frames with different bandwidths are
> transmitted, which would be strange too in a single BSS.
> 
> Note it also affects how radiotap is reported, so S1G might be in the
> opposite camp now, wanting to report the 2 MHz channel center frequency?

Yea that is true, Ill respond to radiotap stuff below.

> >    For
> >    management frames obviously makes sense but for data frames
> >    sent on a wider channel wouldn't this be set to the operating
> >    channel? Especially for i.e sniffer? The mm81x driver reports
> >    it like this but maybe it should just report the control channel?
> 
> So .. are you saying you always report the _overall_ center frequency,
> even for 4/8/16 MHz widths, or just for 1 MHz vs 2 MHz primary?

Yes, our firmware reports the frame at the overall center frequency,
even for 4/8/16 MHz widths. Looking at our out of tree shim driver
(5G mapping) it does the same thing i.e report the center frequency
of 40/80/160 channel which is probably why mm81x does this.

Anyways this is not really a big deal knowing that we can just
override it with the 1MHz control channel.

> I note that even S1G radiotap didn't really specify where the channel
> is: https://radiotap.org/fields/S1G, so I'm not sure it can even report
> everything correctly? The "Channel" field can't even cover the 1/2 MHz
> centers.

Yea this is on the TODO list.. Once initial monitor mode support lands,
which I was going to send today but this bug has appeared, then we'll
be fixing up the radiotap standard to better convey everything.

> So I think in some way this is almost more of a question of what you
> want/need for radiotap than anything else.

So another question then, Im looking at a poorly sourced 802.11ac
wireshark capture and in the radiotap header it has:

802.11 radio information
    PHY type: 802.11ac (VHT) (8)
    Short GI: False
    Bandwidth: 80 MHz (4)
    TXOP_PS_NOT_ALLOWED: False
    User 0: MCS 7
    Data rate: 292.5 Mb/s
    Channel: 36
    Frequency: 5180MHz
    Signal strength (dBm): -40 dBm
    Noise level (dBm): -96 dBm
    Signal/noise ratio (dB): 56 dB
    TSF timestamp: 1911262072856970
    [Duration: 53µs]

Where this is just a QoS data frame.. channel 36 is a 20MHz control
channel @ 5180MHz and a width of 80MHz. I am assuming then, that if
we were to follow this (as mentioned above) in the radiotap portion
it would show as the 1MHz control (for channel + freq) and the width
being the operating 4/8/.. ?

Just a bit different to how I've learnt but that should be fine :)

> > As a result, the rework
> > causes the following two issues on an S1G link:
> > 
> > 1. When data frames are passed to mac80211 without a station (for
> >    example using ieee80211_rx_ni()) the frames rx status frequency
> >    is compared against the 1MHz control frequency used by the link
> >    via ieee80211_rx_valid_freq. Since the rx status reported is of
> >    the center frequency of transmission (i.e either the operating
> >    channel or the 2MHz primary in the case of multicast/EAPOL etc.)
> >    these frames are _all_ dropped.
> 
> Of course if you're using rx_ni() now then you could possibly arrange to
> call ieee80211_rx_napi(hw, link_sta, skb, NULL) with the correct station
> looked up beforehand, and entirely bypass the question, doing whatever
> you want with the frequency?

Yea, as you mentioned in the other email that works for data but
management frames and is something I tried first before running into
the ADDBA problems.

Anyways, it seems like a small patch to handle freq_offset and then
just changing the driver to report the 1MHz primary should hopefully
fix all this up so Ill send that once I confirm.

Thanks,
lachlan
