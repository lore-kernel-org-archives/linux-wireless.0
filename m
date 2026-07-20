Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1D642A80
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 21:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784583077; cv=pass; b=tdRgsLcwpWHXBNegliEUf339R1s5e1Anw63ih1gG5KfqjFc+c5AWUlubp3E1l67RRvrRDN+mLuPI8oEAWK+MW4L3YoCLLVOKRhSDmytoUzKWEdE01h/sTlf0mDdMybCSQGKVwYSVtfAOPwlfOXSwtzPW2ugOeE8zS8AbIWtYE2Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784583077; c=relaxed/simple;
	bh=LyVE2RfK4OPyFdZqMYkgAm8eoo2PwftW/lLocRBSoYk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U79OWld8OsXDnEadBumO1E9cMvBfmpfeRbD4wUtvAKC3fX4VA2Bvk5OMUPRDCFxIVDLVgFaN82IGoUVC49JVn/s7E2r0Xt4B7jd9RyDK3jtVE2Z+YOCEWF9BeZSRLs9UnrKNi1WVVSWRxMFL9o/PM7Vio8bIRvfc5MBE7DXxjfw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ah8JG4xs; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ah8JG4xs"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-698c1df9651so1550928a12.0
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 14:31:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784583075; cv=none;
        d=google.com; s=arc-20260327;
        b=mP8y08OGL/3TMqMwg5qMv1VNO+A3RyRVONdlIZbV6PeY8hhHVVBNpFdjxQQD3V0OXe
         Zi9m0bwRrPzp87rsgxIhu8vLq1oixKMP6BKgj0FlCneG3RWdkrYFqLjuPI3yGDZOldFO
         MS1F66HLuUShO4qMJiS7+MrvfSxnYQ+UgCeSYvsQnBEYcm6XWa7cbZiP1oO6YoR2FStC
         Qog/sDyxE5T3o05r/x2kB/ag7UoZAPzBTi8ZUTo1G03cufakiW492JLgnVoQzQbJNCa/
         UjXhm4PcZTv7YLLiTbix4w0G3wdilwV6VlZp5o2c6SwL5ukAwaU4+PlMFWeShX3xs78c
         KXlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nNwA6ao6NzwbPSAsYgBOx8qGkJlRMW3TZGLPQCknqik=;
        fh=aKOTxJi4jyrNN3r/Yy2VFHZ2mojm9enz4CpKF2bOF+Y=;
        b=UbKAo0kX/rMc9HHDZoYZlakbVWyi+oNvYULANpybFBIe45HwGUVqbafJybdOBJgEyt
         yZJrzq0NNiz6YADsAt5XW4fELJ8MrQK9GntW3Z2XmVn8ILlYqNg3LeBQPcwXmkn6sEBq
         PMCvvpt/nBxqCYDEapvcpbvzmnAsycZkafcvmbn+J7nUN7s0cV9jeNRm1+V3GM70k6Q3
         JZ52POJjYv209lwZ8TTsdGlU1G3n7vK83sLfv/9ZYz7ihVyWD75pa6T405jMKJMHXbTa
         6edTHO7wbjafVtwutfgWhPmLalc1BYBjHfDD1SkUcOqdtvKNAzdBE31D+z9Zc3eLPztk
         ZR6A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784583075; x=1785187875; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nNwA6ao6NzwbPSAsYgBOx8qGkJlRMW3TZGLPQCknqik=;
        b=ah8JG4xs9buFkJRFEy0iLeNfQkx8oIG0NuY7cZY0uFsIIYb8bBT7VLP3RwE7XCrGeb
         met95OCSOp48UCLCQ4OkJG3AINPwJqFaKSMDBAByGo/okaJaaebmrh1n0K2G9xsrpm2q
         C/9tyVWTFaXD2700C6PKeaB5YKbalgufOV1wscUkfnaSrBdTeGKdANHU36ACnwJfVo5M
         FW8pRUuxaeUIk0Wnx8HzNTVoBHiNTTbHB8Ce3O99p+W4ra/78wU/zG8vBqOkhPYLkcm7
         dXT21Fysx08wM/COB8HinGpJUkLnFlVtWXqmix7xKWezEHJWvLc4a1oFZ3wUI695OAws
         iTYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784583075; x=1785187875;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nNwA6ao6NzwbPSAsYgBOx8qGkJlRMW3TZGLPQCknqik=;
        b=ADkBMmUBkcRGGM/JEvR+2aCMy1My1PfCl07y1Gq1wgGKBKJs4Rc9qp5B9ELDkI6ijE
         /k8EeiuCQX04MdgaYL1KhEAx2XaHOrUxXipfzbHcAnOQEV/v3cDp9TsuR/IHYoe6YMOt
         k3v2kTtUJx+sScYkKnFUxa/GB63ydQl3V2KxAsUOooHfaHgz2QXA7LwXPeFFR+qc1mRo
         CZN5+e87YU5aizTzzE/9Zjwa6SmsWDWX3CZGYZKwAJSWmy/HUi9UeSKluwRMMg1KL3Qe
         e4aPkPyrhTpMbSVGnitxAe7UhkDx2lmjxPb9E15G9/2eJXOw453J/JtBQg0KO5zINZWk
         IYdw==
X-Gm-Message-State: AOJu0YytE7Kry+AO2KA6G/5MStAsm5nSGiNhcSS2G8lY1mrBEVWNAt/b
	apqyl3gz3S6RSFkI0E4GxQLa605xG27b1S6IqIMUMk/v71mK+xV/PP8s5fwvbXO8ewC0VYzns5u
	N9FUuP8lsyMwIwRX/PoB7drlM20emoRw=
X-Gm-Gg: AR+sD12jhQUQTryqaYoaDsHHgTQFPrJt8DRY17XjydseZxxcPpp8z0PqgD4HTcoGi48
	Pk5Rm9qPsz7qfc8UiBZi2ioRuBuiSKNvjY2AdsAVBs115sCxgLoXPdrPuwOVCeCLkn4yrpnVYgL
	9KBVsShP1wrOO32z9+B2Mchoplx47VtLJ4lX6oQv/gAxg5W4o2aSIq1ZhZgw4qouY0SwcqXjZU7
	qET5xF8H9wyg6Ittg82V4K1Fhz72nZCauAMuUDaDFMAaWy1Y1YSGAATIvpQAYx6+dZIDN0S9EXO
	NxCkjinm3n4epDEmz/IkrVqVZJRN1Pw1qicQCW9V/HWBWNw5gn4MR7cO0PvE4g==
X-Received: by 2002:a05:6402:360f:b0:69e:1246:a86a with SMTP id
 4fb4d7f45d1cf-69e65164544mr3489726a12.0.1784583074543; Mon, 20 Jul 2026
 14:31:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260714150423.53960-1-bogdan.nicolae@gmail.com> <20260720194900.2356442-2-arend.vanspriel@broadcom.com>
In-Reply-To: <20260720194900.2356442-2-arend.vanspriel@broadcom.com>
From: Bogdan Nicolae <bogdan.nicolae@gmail.com>
Date: Mon, 20 Jul 2026 16:30:45 -0500
X-Gm-Features: AUfX_mwDL3jRFZM-mHkbrMM7Nz61SmsjwFBr2eIOv9ZsHK2PbNfTWiOWo4cXzOE
Message-ID: <CA+ORkNQcUjZ7ufoR5ULN8UDTzxXccFcmD8=rYe=UWVV3-M15Ug@mail.gmail.com>
Subject: Re: [PATCH] wifi: brcmfmac: cyw: clean up PMKID and cookie code
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev, 
	brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Arend,

Sounds good. Do you prefer two patches in a single email or two separate em=
ails?

Best,
Bogdan

On Mon, Jul 20, 2026 at 2:49=E2=80=AFPM Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
>
> On Tue, 14 Jul 2026, bogdan.nicolae@gmail.com wrote:
>
> > [PATCH] wifi: brcmfmac: cyw: clean up PMKID and cookie code
>
> The code itself is correct, but there are process issues that need to be
> fixed before I can accept this:
>
> 1. This is a resubmission of the patch sent on 2026-07-09 [1]. A
>    resubmission must carry a version tag: the subject line should read
>    "[PATCH v2] wifi: brcmfmac: ..." not "[PATCH] wifi: brcmfmac: ...".
>
> 2. A v2 submission must include a "Changes in v2:" section below the ---
>    line documenting what changed from v1.
>
> 3. The From: address (bogdan.nicolae@gmail.com) does not match the
>    Signed-off-by address (bogdan.nicolae@acm.org). Please use a
>    consistent address or add a second Signed-off-by for the sending
>    address.
>
> 4. The patch addresses two independent issues: fixing the packet_id in
>    brcmf_cyw_mgmt_tx() (SAE auth frame TX) and fixing the zero-init and
>    PMKID copy in brcmf_cyw_external_auth() (auth completion). Please
>    split these into two separate patches.
>
> Please send a v2 addressing these points.
>
> [1] https://lore.kernel.org/linux-wireless/20260709122315.11400-1-bogdan.=
nicolae@gmail.com/
>
> Regards,
> Arend
