Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C573C3F8EB7
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 16:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791995046; cv=pass; b=UgpYzyaYVPgVtasX7buZ7RMmU3oZp8MLH9CpzE+hpLgEL+NjX2O+dsGKLultTT0KyishwBatbp1mV+LgIpkTLU0M1SnDYPkZ38j12jjilCefNfLzkzwTsVgLsz8ICej8ov9Yfgi6hbaRpSA8NytEhVjh/2IX5IgHa2DhKMfkOiE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791995046; c=relaxed/simple;
	bh=5+fRqqSG1cq8nqQQKGIiQ2SL34s8o1fvNH8jqcj0ows=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nl2AmskN8aiXuue/jfIyJ86hVKUf/rU+Oy7C0B840j+kiisvdbzE2lo5joAxunK7eb/jA8m9YP3b2YpKRKdhQFj3JOTziTlKxu8FNgQ9NTokn+sWulKvobROP7efca0E9YR09QRIennaZY25aGlw9LhL6tRYAPTKedzySuy0pYk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T7QMIca1; arc=pass smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T7QMIca1"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-6dde81a6820so889171eaf.2
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 09:24:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791995044; cv=none;
        d=google.com; s=arc-20260327;
        b=Mr5oCCXgvJkzNo805J7lC8pbNpxzdA/tRcvtAiLgHWwG8B7aDh9rToxLQS5margha6
         2NLH9YFmowky6tEF5uLAMu5AJBi67ff9zVr28wQEWg6Bh92lYQWWz4/Nqq0J+advIIHd
         lzAyuz0UIzcY8MICecEhiSDzhuVEtkceAPcdNf20kMFX06LyHavTr/MwlwuuNkzsd2sz
         0TdM6d2wCZaaH8rBk2tEIERPC18x+/R4dqv411Xqt2HKEnBzqLb4hBwnECzSHWmfZgX2
         jhm0XKrTOBzKXKAEhsFEY9ZHvag2JVkRdSY7wrzvJW9zGylh5EsR+lwzyRP3/jna8Upq
         raOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=5+fRqqSG1cq8nqQQKGIiQ2SL34s8o1fvNH8jqcj0ows=;
        fh=f9hFQUVjbQq8USMzmbA7B+6DLDxgXYGTKGlXxISsNwQ=;
        b=O0TJfywTklIRaz9oYVrOzjZ0XOUo13NwLD73sw79bY2dL7cwTQUtjqI2T7o8muWjJl
         lfqv7c0xZNmeCKKNTF41m7/k+BZiYuxeoCt7v1K1n0WoXWAOUxs4rksU2bOedDb5+wHx
         f/x6Q9y7no91cQyrQi46U6ZaNISMMeN/xHaIhaDcgObgBAghaDK7l4gAZsxVsnFYGVZP
         ZfaaUaKZrGxc30b+W9IJIb3whGkNOXw3VeOH+fLUb5RiaEiLlEoBSz8j2S/evv7pncnM
         sw952TP34YFL/dIDNlgK6D0Vs8/+lBurtim/ZTFqP8PKm7mxConmodf4AGYga59zAx95
         oG5A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791995044; x=1792599844; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5+fRqqSG1cq8nqQQKGIiQ2SL34s8o1fvNH8jqcj0ows=;
        b=T7QMIca1G7PY9cjd5FtkmIte3yqvB0+mW3dWTAoeY7bUaN9I6NQ+d5zQuKbIXwLgut
         sVNHo4Jqg/2S8lUTUrUwYcrQYVpWOakQTVt1YL6o4drzYDz5PVfNZXGwiCJcO4xy/p1i
         ZcAv7Qc6cjC1KzuNTMHvUBfnx3DAf+P3Em22YEYlXfgKHfji9yOtgW9zGdn2++Tgd1bI
         7+w51mSyY0PCS5Yy1p4M4Le8ppoA2XAK6VrADjo6YDOUp0CT8qYYFwQyGWOrgZo8F2cN
         3Oi1dZl1m3NuAzaLXe4udJvvYyxlMHCMdWbieMiiEX77LtrZq2xR+MrMHKIS34Talm7a
         NCwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791995044; x=1792599844;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5+fRqqSG1cq8nqQQKGIiQ2SL34s8o1fvNH8jqcj0ows=;
        b=bwgqUpoaxao8Ki7LKtxHzCMGNhzntMTBuiTAJDMgMeBPrVHqq3XLwabXk9AkuSxEKj
         6m4ed2cquml20YGfM6Up1UxTaj77RewNPF4fFX9UJGYRpGcFwejHYd9QwUpUvR3SFLJL
         J1Nm2xHe8i5y+YPwg7D19bFNMnrzEz/XSJmB5xVDTmCXlb1ybctrQcbHIAXWs4ygK4Zb
         bSlVRMt84Ht8OmXSQysraqc1tYZqCL1vZ9kwffOZurOo4PHrX92csVvtNRwJSfgcTsDz
         zBB9Fisc10FQ6VIfj0Iys0LZu7/jb5EXoJ5LKCCLpZYw9A+4J3FoBpslUfQYm56xY4OQ
         80/g==
X-Gm-Message-State: AFq9FYI0Rj+jIgJduqFjRv1I9b3pqOY80eS9yk1schL+xT4HuXaKHYkU
	OhAd+vDgsJ5xGWugTzzREupA2KXBeYsdp2uBpl9jex840vJo+nGcQvjKwoFzUiz9D9cFUDhN4PO
	zCVe0kTjUFdERy6EeOdNHYXRKwo7F+1/qu2wbzn8=
X-Gm-Gg: AYBFou3T40Q069WBJ9BBRIDBgXnfNZFiRaJuUTVDBxcasT8KwBVgJOJDJsSNPFSD640
	KFJHHks2dsNxoI/AiwRHoYJVaL4ql9rAZJnlepEyko0ft2hqGv1EmksSJ+aNe2cH9NePSTY0Q7O
	/J8VBCyp8LiILArddaYl+S5Tuc6H65zRoeSH69RFivlix7IZCKi+Fcs3hN/bVL/a6pHgnlebzPq
	N4HYYTeiuRSgVE58SwvPrIoxm8e4sIPKYs8Ad+gWEfbN+VUOPSsF82nLAFRYjOQNeECqsKjOkir
	pmLuMYBtoRU41y9m7WCpT7DFPA7iPOs3oRxjbQRDm+e7+zUunOodql5V0pcrGMQDNn6A9tJt8uu
	CqoX/Y5OdFDuAXrQueOB/wAzB
X-Received: by 2002:a05:6820:208d:b0:6ba:3635:7ffd with SMTP id
 006d021491bc7-6ef1210af6emr12357369eaf.64.1791995043687; Wed, 14 Oct 2026
 09:24:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261012133728.77780-1-hjf3108@gmail.com> <20261013102305.GA58849@wp.pl>
 <CABOQOSU8KHVUrSc+qkCrpGK9zDBc3dNRqaRWKQ7ka=S6uLLbQA@mail.gmail.com> <20261014083131.GA62404@wp.pl>
In-Reply-To: <20261014083131.GA62404@wp.pl>
From: Jie Feng <hjf3108@gmail.com>
Date: Thu, 15 Oct 2026 00:23:27 +0800
X-Gm-Features: AclHuK_XrchuzxF7lK_lujwgtTADAD9DglE-B4mjPzQOJpXnCJaeA3LspBR630A
Message-ID: <CABOQOSWNQCxEFo20FJefmk97z_zND4CDogh9xmLPTrU=-xaB0A@mail.gmail.com>
Subject: Re: [RFC PATCH] wifi: rt2x00: use VCO_IC 0x2 for RF3053 on 2.4 GHz
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 14 Oct 2026 at 16:31, Stanislaw Gruszka <stf_xl@wp.pl> wrote:
> > > > RFC for this since I am not sure if it is a generic fix, since the
> > > > vendor driver also doesn't use VCO_IC=0x2.
>
> I looked at vendor driver it does not set VCO_IC=0x2 when switch
> a channel. However it does it after wake up from suspend:
> https://github.com/ashaffer/rt3573sta/blob/09b80e6290769c53736dc09c5ae9025e15bfbe69/chips/rt3593.c#L194
>
> This function: RT3593ReverseRFSleepModeSetup seams to be partially
> the same what NICInitRT3593RFRegisters does.
>
> Also NICInitRT3593RFRegisters it's different from
> rt2800_init_rfcsr_3593() i.e. it set RF_R02 before GPIO_SWITCH.
>
> Could you check if modifying rt2800_init_rfcsr_3593()
> to be more the same with both NICInitRT3593RFRegistersr and
> RT3593ReverseRFSleepModeSetup (regarding RF_R06 change)
> solve the problem?
It didn't solve the problem.

> > The adapter doesn't work on the lower channels in 2.4GHz,
> > channels 8 and below. This looked like an issue with
> > the PLL or something after debugging.
> >
> > By tuning to channels 1-12 and using the debugfs to dump the
> > RFCSR registers, RFCSR4 is always 0x7f on the failing channels
> > consistently. Since there is code to switch RFCSR6 based on
> > channel, I tried the same as the 5GHz code to switch RFCSR6=0x2
> > for lower channels and it worked on all the channels surprisingly.
> >
> > Due to the behaviour of RFCSR4, I think it is a VCO calibration
> > result since it seems to change after enabling the calibration.
> >
> > I could not find any mention of this issue elsewhere, and suspect
> > either this hardware has very few Linux users or my hardware
> > is special in some way, so I can't guarantee that setting
> > it to 0x2 will work with another device even if it is the
> > same WNDA4100 model and chipset, so some testing would
> > be appreciated.
> I do not have RT3573/RT3593 device by myself and ordinary users
> do not read linux-wireless mailing list, so we have rather little
> chance to get more test coverage here.
>
> Anyways, if init change that would make rt2800_init_rfcsr_3593()
> more like vendor driver do not fix the problem, it's ok to modify
> rt2800_config_channel_rf3053().
>
> If we want to be more safe with the change, we can limit it with
> rt2x00_rt_rev() using 'rev' of your tested device.
My concern is that it is just my specific device being at fault here.
It also seems to have an issue where the TX looks to be much weaker
than normal.
