Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDF54D6C52
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 19:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791400780; cv=pass; b=mQQ0T2Kb/Sm5xGOPA0vWO2KfHBmvNFcyd7aisz281UrXiWaDgwSXuphuGR16Rxg7GaAhlfX1GGMoCufWJvi1OQJZSOoMkUrZYyh22RxZkBhtlhiZFskG3nsDiYHOz+OtGmhgDeeVj5M9USxqOETSuN6d6PErhXrsGaNV/ipamBQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791400780; c=relaxed/simple;
	bh=riS6O7qfu5o4tnJtWq3y2bkC9QfPO5fBJLYT/m81Y+s=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sZnrNvfpE1GUxTI0qejYgEz2ArYFJ4iHnhhroGcgiMeU/PDOEi+2t6kETHAC8IyvuFxXGHvsYtq5sCHFVrsQzgC/2Hes8yhGL4UKn0HCp/1pvbhB0jYPePyDF0qdHBXH7kqyWtC1eHZVJi1MCXu4BH6/EDtSFzR3Ej2ksQVd2XE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MR/rr0Tu; arc=pass smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MR/rr0Tu"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6ae305e3bd9so1351717a12.0
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 12:19:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791400771; cv=none;
        d=google.com; s=arc-20260327;
        b=X0NuvY/HjyXxqjhr2FVNQh1TWp8/gVogI97ywyfknkdjusndKsx6mC/w8uK6l1exRs
         aYQySnRewgr/NdU0Rq9UrszZDvXE4vphPnSwky0nBTmSHzOE7YSTOr6dJNJUZVn88Oe1
         Xc/aVugz9QDp0nwZlb9A48ssqBEP63tzFRqF9OxoJ+X0ZNfT64JmquXGOoEYocU5xJml
         kl0DaLj+vX64PxsSXpbNXhN3MNDWK/vtww+KUOibffiYZf4499brH0sdnB9BeWiZV9HB
         SxOe0IMHHxOAESKCxNetSZ/vLnjal/utJNqUoaD/a49J/fBzCgLV4liyGg1Upy/f8zXI
         vVag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:dkim-signature;
        bh=KayE3/SyjjFQOr44Kz1JboHOCn8bY3ikVmPC3EhEDNM=;
        fh=W+1F/U/dOxyECfyibPEXjCEU1GrFf4Ol9+kjKW9T1pY=;
        b=eptREgLTC1LIL4J629Ns83CcPRvdPLmFVXxQx/DUA9qOlHfIScnpxFd0bpKgkSRAFA
         T95g3zhJmG4VoZ6qDQAfVURkGHzVXXvxaCdiY4o8FYnBO7F9Q5JCNEs7yLLgkT8Fg7m8
         0GspnrnlItYrTESLXS6/B8ZFvTwYMvl5OKOhudZ+GIpyG/L4dIm+/IESXfapmhqeBzF6
         H53gmBIZhyzpD/DNM28KwbEruvB1kQDgHeCvzc0Es5nL4z3XZJ6omMKKRYUFeprixFVz
         ZejDh2RnLdTzFsVR9Xtmm/4lzD43DLoeC/GC0qCNGWpyYzkx8ZzA50AzHGmRChY0V04U
         vlWg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791400771; x=1792005571; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=KayE3/SyjjFQOr44Kz1JboHOCn8bY3ikVmPC3EhEDNM=;
        b=MR/rr0TuScVC4Xa/ak1DM6U8oMoQWqTE2vwwO+7OWLWvd6rR3AQPI8RiEMYySZ39R0
         qx9N3Phm74qi4IecCjnHO27cNFgQfpo+doxPxV7KjJIozkaeQRmYCZ1Aqlh7iWHBHTEY
         j/6A3dwbQgbE3Rvp4gnQBDgFQzQ6Uq2j5QvhFw9IVTYo2g83MWYdnmh9EJLp6SrxpLFh
         FPMh3CEcWQ+OGDcQF9AE/LlF42VmgdkgCG34kSlISk2bAD56Gnrv523NZItSgWWwpbzU
         nYccvOcVZljQsu5gENA1MGIxQ4ftoSx4YJuR6Iv2tTh6HOxesID/YS2EAqSejaHMeqwq
         64Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791400771; x=1792005571;
        h=content-type:cc:to:subject:message-id:date:from:references
         :in-reply-to:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=KayE3/SyjjFQOr44Kz1JboHOCn8bY3ikVmPC3EhEDNM=;
        b=qxI5lCtZgulj9g83bgPFxS3Ob4wyhC4mabPvOk6kUh6r+MjWLa+8tJRn+EsCGVisnB
         wWm1zMFb4LzLuWV0+7KffItK5IOytgXdFnmu1KMgqLS/CDyT+mld94yrCg7ci8f5nbnc
         alsRs7DVNhHr1a4jScPtGf0rQdiYgS9NCvA4oo54TFIhKMlfw2JNWbmtSABzyIdYUy3r
         YjlMAt9ZWB9/Y3cnNcUfhkGmJpZ25LQJk58dHoSXml9q1TcHP0IBbBVk3Fb/TblTa+0Z
         g6rgSfGCxKTmmyHsbAHzdL9F7cWHRMcpU3wlyEtd5UkF/E5dxHX3JMvE/Z/OmfNDUDZC
         oL1g==
X-Forwarded-Encrypted: i=1; AKwUvBx5EcpRBUxraNsIxVoJcIIwfDvT/JqBw/8KJiw8zZJIEZnxEvU2Zf/1A11SvquVVU2viL+nSmeotpqobPBgBw==@vger.kernel.org
X-Gm-Message-State: AFq9FYK7Kdor8+PzLALVtsZUcF1EbzbUD8r+ZnnIO8EFR4MVpLS4A0gt
	HFUcrwzOX9YgtUb/TCz+cccUN8oPqpCv3vwzQn67fVz8JiP/1QJJ+faSmGA2Y3seTf/G8AYfaZw
	0QxBzPf3WZUbiBBYxyPL0g/eC3tTN3Lc=
X-Gm-Gg: AYBFou2VenWsDMRe7Oh4HQgvDjuwbs5rfnnMoNFUszPyiHXFUf3FRBNAyVijCJ0svV3
	YUEyyWSQajzWR48d7bNk+i0qaBHHmBbYF5w/nUBcQ3kEHg8lg6UFdgzjlMAWc/DSnm3xZq29frX
	e3f5IcxTUm/avoxzWJOVY+rqn/MC1UajUh13YP6ycZtAdSmXLq0idGMsFW9ZxOOTCu19p6WeKDr
	oUcczhhWI8DsC9N2mXlz+3yqmRcN0rNJ3D2ELrV83LIwugwEPDUU0ETq7jNgMcyNSnfCT8eNIsc
	DT8JpsDV1cI3dvRzKa8BP8MudJJO5i5/SrtHWXB63SQJ9Gk99HxXiw==
X-Received: by 2002:a05:6402:a0ce:b0:6aa:f198:4e39 with SMTP id
 4fb4d7f45d1cf-6aff576f60amr2667054a12.44.1791400770578; Wed, 07 Oct 2026
 12:19:30 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 7 Oct 2026 15:19:29 -0400
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 7 Oct 2026 15:19:29 -0400
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <d9eb2d99-79f5-4e18-8c6d-4877c73cd5c6@oss.qualcomm.com>
References: <CA+KzPsr13czsH=k_UWJqj48C4Vsb-diQ-tiCh7W4XW31E8WzHg@mail.gmail.com>
 <d9eb2d99-79f5-4e18-8c6d-4877c73cd5c6@oss.qualcomm.com>
From: Zephyr Madera <dencity7@gmail.com>
Date: Wed, 7 Oct 2026 15:19:29 -0400
X-Gm-Features: AclHuK_g5qHDRfiZYY84WU4i1SUHzmfE868se7RvisRstKlGrgaT1DZ9gGbbo1U
Message-ID: <CA+KzPsrPsUjqo95wrtvwJOYtdoNBejyzuYk09B71r-rND_D-ww@mail.gmail.com>
Subject: Re: [RFC PATCH] wifi: ath12k: service all RX rings in an interrupt group
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Jeff,

Thanks for clarifying the need for QCN and WCN coverage. I understand
the concern about changing a shared datapath.

I have access to QCN-based hardware, but no WCN7850 device. Could you
clarify the minimum testing you would need for this particular RX-ring
change?

Since the initial submission, I have checked the patch against ath.git
main at 17e4b9ea527b6c9491bed60f646bb2eff7d8db7b. The baseline and
patched x86_64 driver builds pass, along with source-matched
regression fixtures covering multiple rings, a single ring, an empty
mask and shared-budget handling. These are compilation and
host-fixture results, not a substitute for hardware testing.

In particular:

- Which QCN/WCN receive-path differences or failure cases should the
tests exercise?
- What traffic tests, operating modes, duration and instrumentation
would provide sufficient coverage?
- Is there a preferred firmware version or kernel baseline for that testing?
- Could a maintainer or community member with WCN7850 hardware help
test the patch and provide the appropriate testing attribution?
- Can source review continue while that hardware coverage is arranged,
with the limitation stated explicitly?

I can document the testing performed on the hardware available to me
and provide the focused patch and reproduction details. I want to meet
the acceptance criteria without claiming coverage I cannot verify.

Thanks,
John

On Mon, 05 Oct 2026 19:15:52 -0700, Jeff Johnson
<jeff.johnson@oss.qualcomm.com> wrote:
> On 10/5/2026 5:48 PM, John wrote:
> > An RX interrupt group may select multiple receive rings. The Wi-Fi 7
> > handler currently services only the highest set bit, even when the NAPI
> > budget has room for work from another selected ring. Walk all selected
> > bits and retain the shared budget and existing early-exit behavior.
> >
> > On a locally adapted GL-BE3600/QCN6432, group 5 selects bits 2 and 3. A
> > host regression built from the actual RX block completes 3 of 6 queued
> > packets before the fix and 6 of 6 after it. Single-ring, empty-mask and
> > two-poll budget cases pass. Descending priority is unchanged; this does
> > not establish fairness under sustained traffic.
>
> see:
> https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath12k/submittingpatches.html#tested-on-tag
>
> For a datapath change I'd need Tested-on: tags from both WCN and
> QCN chipsets since they have different requirements.
>
> >
> > Signed-off-by: John <dencity7@gmail.com>
>
> See:
> https://www.kernel.org/doc/html/latest/process/submitting-patches.html#sign-your-work-the-developer-s-certificate-of-origin
>
> >
> > ---
> > RFC validation and limits:
> >
> > Source applicability and the host regression were checked against
> > backports 7.2 plus the 230 wireless patches from perceival/openwrt-flint3
> > commit 2365932733ca8ec3b346621d9cec2eb3df3b2cf3. The new patch applies
> > with zero fuzz. The same source-block regression and exact patch
> > application also pass against official ath.git main at
> > 388d3c42e8aba1cfc3c6d2c52877a46d8cf740db (zero fuzz). No full module
> > build or hardware test was performed against either current revision.
> >
> > Historical tests on Linux 6.18.39 with local backports 7.2-rc4/QCN6432
> > changes passed DHCP, DNS, 32 UDP flows and about 181 seconds of traffic
> > after reboot. These are bounded observations, not throughput or long-term
> > stability qualification. The contribution was developed with AI assistance.
>
> see:
> https://docs.kernel.org/process/coding-assistants.html#attribution
>
> >
> > --- a/drivers/net/wireless/ath/ath12k/wifi7/dp.c
> > +++ b/drivers/net/wireless/ath/ath12k/wifi7/dp.c
> > @@ -52,8 +52,10 @@
> >  			goto done;
> >  	}
> >
> > -	if (dp->hw_params->ring_mask->rx[grp_id]) {
> > -		i = fls(dp->hw_params->ring_mask->rx[grp_id]) - 1;
> > +	ring_mask = dp->hw_params->ring_mask->rx[grp_id];
> > +	while (ring_mask) {
> > +		i = fls(ring_mask) - 1;
> > +		ring_mask &= ~BIT(i);
> >  		work_done = ath12k_wifi7_dp_rx_process(dp, i, napi, budget);
> >  		budget -= work_done;
> >  		tot_work_done += work_done;
