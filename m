Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539B03DA5B4
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 13:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788528255; cv=none; b=snrUqKh4i6qkxnf6V7KGef+7777POAJTDmIowBM3ERkjGSbFS3aO5YKBzRTRk7m64/o194CMDkHGRjvK8EHDtuljwv6ucPP2k/nykexv+7UK6cJg6/ZmA8thYPjlHLmYoyWVdWgkvVymFD8tf/dZtq+LIZ3cKvbSlB8EJY6tsO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788528255; c=relaxed/simple;
	bh=rY/FD17a7G/eWAVvA7Y9WrbqEygpxDfhs21tRyAeJRI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IL2iWGrORvWdGYBWcdo8a4WLQu5vEajKCJQF521nT9L+GrQBh9JEmeiLPQ2waUrKc9SJVVmOIliTvuxW7JH7U1qzZU+NpMlLAyJl5P0TxQzGPbjRwfH8jL/duJsmJ+5VlzQb1gRm74e0T4Vl49Jpbpwfn6xsg/nIbByLQz6LsTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=RwNy9KuY; arc=none smtp.client-ip=209.85.216.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="RwNy9KuY"
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-398b3c37877so935870a91.0
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 06:24:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788528253; x=1789133053;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=gKnbVJWEFk/CLsBUPWolgt07xLoRfVm3ryFkAF5KIOk=;
        b=GdvaGZ/TOTW4WP4yhKKbUUcoDsq7yVJBjDlCi7rQnotjJMef0fH/d+LvyHaLD8BsB2
         IO/ecp4xR9CYRFgKSohO5pDhvU2gcjgbaqbe6gcKeOgsaqOrx6T3ShVFF+tTSH8WB73m
         RJT2ztGJ+AgOsegJYrqWBdzyAXuaUkRPPArxTQO23BZtazD27A/ae3VVH9D9JrAbwzUy
         dq1w3F0YfJ6tickcb/jrQ1a4FTSXfOegtvlmKjiFqSFczTebV5RrLajCEB9Iul8kqDD9
         v4kotKUaAfdpTWuKuc2eqUl5XEdbA8Lp3kcbDLr3BEP8+zCczJTLfnzAyvaRqNlzfwIe
         Bp3g==
X-Forwarded-Encrypted: i=1; AKwUvBxBg19rcjSbpeA+0IOGjefyS8wMDfLvNrR8WatQOjOhvhrwNnkQWp/cQH0BrVHPPg0djluvCOnqr1y7uFWQEg==@vger.kernel.org
X-Gm-Message-State: AFuF++nDPn6VDC05lux1mWoog78rwYOytWI6IJasfnH1FqDrAGobCMVG
	q15msbnvyskPA2gUV2lLW3thzZ952eZXv1d99VrF9SH/4B9w9SeeYEGcl5Zlyesu4OZuBOp/rDD
	R4n6km2jwAE7Xh+sGGnVkTrJPJwRDKT+o0rJEDtJTyhdjUYUX7l4D/ywwddmqpRCkXDdwwxMsPw
	O0iZ08ipQHJ7KTv+qdKI+LUG8kofNTY9WDvcNnMsu/fNZitGfVUFNL/h+AooeOUgY2zsLMFtqC8
	rjcoJeRBBGWQbRuWxPY+VY86tFR
X-Gm-Gg: AYBFou00Rv7Kheq7jcb2YAdYs0sFlI8NI8/5XBwt3Hau8bPeyNMZgjneUfRk5ZxXwh6
	hsz6vUmVqnDe6sbK6EuQU9CaJn6LeDjvpHL5fT5dn/4Iyd9+bL12IzxbuGf80lWcoXr4Uf10vlz
	8qZz/Xvr6DepwY942CObFBOwu8bImTaBZLDP9Lhl5TkjXWGtZM4G3dhlJNKorqAbxseTick7Xn4
	hxRJngcNI/oi7PZCWdaHXNtA2bfQY+DjhnwyJSHIxxeAAvrLIL+JvbrkI8W3rTl73NYFpLToXah
	83Uc85XuJqtMjx3UvmfU/vUrZd2I2W95oBjW0O+5B64c6AMLHJI2+vfcZ1ymiQQ+0xpli1kNStW
	MW18oaI7ceA9Cy4mLCSi/J7XHXYYYatb9R+qnCaC8ghjrzTNqhyxYbNFEzwpo+ADztM3iTvvkCG
	cMmo52byxiqAsJRiMwVP5Iq4aDR9NBmGdMhAvepRTg3A==
X-Received: by 2002:a17:90b:2687:b0:398:9c0c:7c71 with SMTP id 98e67ed59e1d1-39b26277b88mr8792710a91.24.1788528253312;
        Fri, 04 Sep 2026 06:24:13 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39b2610af72sm1437726a91.5.2026.09.04.06.24.12
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Sep 2026 06:24:13 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-9375d92d8cdso200358085a.2
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 06:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788528252; x=1789133052; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gKnbVJWEFk/CLsBUPWolgt07xLoRfVm3ryFkAF5KIOk=;
        b=RwNy9KuYMMb+fi6QdRt0NtpDzPp5liF9hVHX5hR6mxQXYficPSc3R/ONSI4Wc4LJIV
         PuA8maAGz63nY4BLuWUT7/MelOEbhLTrEnnTEtIxfpN8KkotoyjRLHjZsLh6pINMBMGc
         jFfTmT9iUJMG5PxZLOzJYHqM53V4wPwzOg7Yo=
X-Forwarded-Encrypted: i=1; AKwUvBwGaL8LrsXi7+XVNjubQx1UGnvRNsWuGAdOHZceqD0T6eqEOTDWGv46GRNbEe98gPTntXxrgYaTTIx1AIOTIQ==@vger.kernel.org
X-Received: by 2002:a05:620a:d95:b0:936:bc40:cae2 with SMTP id af79cd13be357-9398072a8c0mr585323985a.39.1788528252076;
        Fri, 04 Sep 2026 06:24:12 -0700 (PDT)
X-Received: by 2002:a05:620a:d95:b0:936:bc40:cae2 with SMTP id af79cd13be357-9398072a8c0mr585318485a.39.1788528251581;
        Fri, 04 Sep 2026 06:24:11 -0700 (PDT)
Received: from [192.168.178.26] (f215227.upc-f.chello.nl. [80.56.215.227])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9397fb33619sm210778485a.22.2026.09.04.06.24.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2026 06:24:11 -0700 (PDT)
Message-ID: <6e946b7c-50f1-47e4-9073-1dcee4f141a7@broadcom.com>
Date: Fri, 4 Sep 2026 15:24:04 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: fix typos in comments
To: Hemanth Selam <hemanth.selam@gmail.com>,
 Jeff Johnson <jjohnson@kernel.org>, Jiri Slaby <jirislaby@kernel.org>,
 Nick Kossifidis <mickflemm@gmail.com>, Luis Chamberlain <mcgrof@kernel.org>,
 Christian Lamparter <chunkeey@googlemail.com>,
 Stanislav Yakovlev <stas.yakovlev@gmail.com>,
 Stanislaw Gruszka <stf_xl@wp.pl>, Michael Buesch <m@bues.ch>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
 b43-dev@lists.infradead.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, libertas-dev@lists.infradead.org
References: <20260904124353.6183-1-hemanth.selam@gmail.com>
Content-Language: en-US
From: Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <20260904124353.6183-1-hemanth.selam@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 04/09/2026 14:43, Hemanth Selam wrote:
> Fix typos in comments, reported by scripts/checkpatch.pl using the
> misspelling list in scripts/spelling.txt.  Only touches comments, no code
> changes.

For the spelling corrections in brcmfmac...

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
> ---
>   drivers/net/wireless/ath/ar5523/ar5523_hw.h               | 2 +-
>   drivers/net/wireless/ath/ath.h                            | 2 +-
>   drivers/net/wireless/ath/ath5k/dma.c                      | 2 +-
>   drivers/net/wireless/ath/ath5k/pcu.c                      | 2 +-
>   drivers/net/wireless/ath/carl9170/fwcmd.h                 | 2 +-
>   drivers/net/wireless/ath/carl9170/main.c                  | 8 ++++----
>   drivers/net/wireless/broadcom/b43/b43.h                   | 8 ++++----
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c   | 2 +-
>   .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h   | 2 +-
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c   | 2 +-
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c    | 4 ++--
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c   | 4 ++--
