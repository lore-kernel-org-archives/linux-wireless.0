Received: from mail-yw1-f226.google.com (mail-yw1-f226.google.com [209.85.128.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F3B3242AB
	for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2026 12:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785673486; cv=none; b=OmeMo4KWUMZ4MWVNQyfOwikKF0MZv2Wc25jmY8GPALiQUOf/Mao2uwu1DkmB2rdlpmWOQESVZtopSPibgMHPbhZeAUy5NkVeQdL4EDV6DN5Oe6291u0nsP46WKUwfYUg6vXEqjKWOf/8pkbDiuJzL8PVc2v6lPjiEmVtie/BML8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785673486; c=relaxed/simple;
	bh=IVBACOmNYotUTjgF9C6tiVB81vMoFAfRoriF976EZok=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GZnJN904CQBuYQAeCwWYFGgXvzewc/EAgUlOECfAQHgkTKfcai+XEfKvwjLpC+aq43C8uigCTwHJtAaMn8j0GgnSVDCf9eYbo6GRgqiHJfOlSWkkEwkthfGTo5T1tMAOHTgcDCdEw5uoF6CjfTY4imS4nwIRAl70hikceT3O7LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=EFVqYM0+; arc=none smtp.client-ip=209.85.128.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="EFVqYM0+"
Received: by mail-yw1-f226.google.com with SMTP id 00721157ae682-81e69a2db34so36968547b3.0
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 05:24:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785673484; x=1786278284;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=QNXeMyhkpbk8rwnA0O7uBQvIUEYbGICoPWDBw29OKOs=;
        b=WxQvxuwKcr04/Nh0UPDy0WyHeHSzavAuC940S+5wE/VSe189XMKOKaZak/UdXeGqEJ
         eConS3rsrktX2+eNHwu0/scqslRtblkQsDt410+qyYc8ECrqp4N4++ZVlLCQBYPZ0Dc0
         GTcu9W6ZDfTRY8HhfqFHd+U4j/uGcpeRKQWRzStNCE0LZ+rklJXE3VxZzDnZsVOYjLHO
         XmvEma7QnG1KymetVnEKsNe0e85jlxL4y4yy3dMxC1d/3MCgFh0D3hErXF6OYIgCYGxH
         IBKXNgkvmojj1cJCgfAiMC3MxA/v1b9/7rVysZLx1VpX0b/t45hEUC88LpT0+9Yp+w0L
         RrVg==
X-Gm-Message-State: AOJu0YxZ0hert8VWVAZlG1Sgq3iPIT0TIs/qTy5dZ8rzKixcIeRyBLEb
	iDy017EVQPBI63YiA7uk5svvbylsRy9pXegzeWfAO2PPJYhOqXXjA/2Ax4DBShT8CNKJYT88O65
	7NUqP2j0ewH+5gGp+XGBaT7a8bwXnnymWWtqGr71Zo/ahGVp4TMCZ92NiP3P8Yub28TllgtDoKA
	5gKYugwmS51BbfJfShhmgyhoMfFsw1kKSJ6QRykWv/iogECMJXxBPlYCtP4yJWt8eAAcFZU3REc
	qQnm0Ve8Z7E4wllAKyonMdjO/Rj
X-Gm-Gg: AR+sD12Feqn7gAzgk0220TsuOvd2h9e/4Y/qvMnfVtymyqrHe/bpm3Bk8zgmQRTB+oR
	SdiXWzG1MfBqOGcfCiaPuLE9k/Dp1TknVTHdRZjGuxOqxsWWiAiG3HmzQW9LygQP1JACzvNZ/JG
	FJlWQh23Nf0n3olfixGx1B/Zed+Hp9/wkeoWXNVfJbRv/ApG1DnTPqw4Pbrz3b7pSTes6sXJ/JQ
	JLeAdcObarb+IZseO38gPCjv2Lr2EX2iVhzkykKPrTj9l6R9aaqoeU7F4DKuMt8D3E8KRKZjF4V
	xK3He73InM9VVG5TvZbHV3DuXcLrYUCuSVF+yulfRzdklqE+Z4QEPX0Ub7g1lgYRcOrCImBzVIi
	Ob+dK35NPtPJj7o7BWBI2leutpVQGH9+n1WINv2WbqcxeCATiI5ufoxYk31MalfgJxN7j7U+x++
	UTtF/g4rPeLqHl3RI8qjK0hoh3PxR6UOlIQ54BYuc=
X-Received: by 2002:a05:690c:4b11:b0:81f:3b6d:a0a4 with SMTP id 00721157ae682-81fd4bba5edmr87744417b3.25.1785673483874;
        Sun, 02 Aug 2026 05:24:43 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-27.dlp.protect.broadcom.com. [144.49.247.27])
        by smtp-relay.gmail.com with ESMTPS id 00721157ae682-81fccf1bedbsm3523437b3.3.2026.08.02.05.24.42
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Aug 2026 05:24:43 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-51c1d137a68so46636521cf.3
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 05:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785673482; x=1786278282; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QNXeMyhkpbk8rwnA0O7uBQvIUEYbGICoPWDBw29OKOs=;
        b=EFVqYM0+6NjoE1/o48vIEIOlK/WFaP+c2tlBaJBsgTN82BrpG+vOywIEWIqE7IW0z8
         oAzM01aX1GYOg/u5G6w/bzVOm1pLUoI6H0uPMFQwge9MtkPCOTAwt7UnSAKwUENPiI/m
         itE6qlP/DdeG+4pO6o5pkc0c8bCOympwMkcd0=
X-Received: by 2002:a05:622a:5906:b0:51c:8439:14e5 with SMTP id d75a77b69052e-52b566951a7mr125476451cf.10.1785673481792;
        Sun, 02 Aug 2026 05:24:41 -0700 (PDT)
X-Received: by 2002:a05:622a:5906:b0:51c:8439:14e5 with SMTP id d75a77b69052e-52b566951a7mr125476081cf.10.1785673481411;
        Sun, 02 Aug 2026 05:24:41 -0700 (PDT)
Received: from [192.168.178.26] (f215227.upc-f.chello.nl. [80.56.215.227])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52b4eb6a84csm42125231cf.18.2026.08.02.05.24.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Aug 2026 05:24:39 -0700 (PDT)
Message-ID: <f449500c-74f3-40e0-bbcc-ee560951714d@broadcom.com>
Date: Sun, 2 Aug 2026 14:24:34 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless] wifi: brcmfmac: validate msgbuf flowring IDs
 before use
To: Can Peng <pengcan@kylinos.cn>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260723055618.550834-1-pengcan@kylinos.cn>
 <20260802083905.3819981-3-arend.vanspriel@broadcom.com>
Content-Language: en-US
From: Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <20260802083905.3819981-3-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 02/08/2026 10:39, Arend van Spriel wrote:
> On Thu, 23 Jul 2026 13:56:17 +0800, Can Peng <pengcan@kylinos.cn> wrote:
>> Firmware messages carry flow_ring_id values which brcmfmac converts
>> to an internal flowid by subtracting
>> BRCMF_H2D_MSGRING_FLOWRING_IDSTART. The resulting value is used as
>> a bit index in txstatus_done_map and as an array index into
>> msgbuf->flowrings and the flowring state.
>>
>> Validate the firmware supplied flow_ring_id before using it. This
>> prevents flow_ring_id values below BRCMF_H2D_MSGRING_FLOWRING_IDSTART
>> from underflowing and rejects values outside msgbuf->max_flowrings.
>>
>> In the tx status path, complete the packet with an error after
>> removing a valid packet id so the skb is not leaked when the flow
>> ring id is invalid.
>>
>> Fixes: 9a1bb60250d2 ("brcmfmac: Adding msgbuf protocol.")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Can Peng <pengcan@kylinos.cn>
>> ---
>>   .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  | 46 +++++++++++++++++++---
>>   1 file changed, 40 insertions(+), 6 deletions(-)
> 
> One nit: there is a double blank line between brcmf_msgbuf_get_flowid()
> and brcmf_msgbuf_dequeue_work() in the resulting code. This comes from
> the pre-existing double blank line that was between
> brcmf_msgbuf_remove_flowring() and brcmf_msgbuf_dequeue_work() -- worth
> cleaning up to a single blank line.
> 
> Minor enough that I will take care of it while applying if you do not
> send a v2.

As I do not apply anything anywhere maybe Johannes will, but feel free 
to send that v2.

Regards,
Arend
