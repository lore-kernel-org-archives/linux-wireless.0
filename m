Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEE5337699
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 18:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791742381; cv=pass; b=JH8ZCm4TZA44mFJeEbgw94LqVzP56eiM69exZXMrfyJMJ5Ox6+E/+4RaOC+1NfuhFyHF2FrEansTa3MWfdl+Sj+5yp1Ub/yovzF4+NvVpYZmo9/qUz28IKpfNbnU4MazFZlcfJ6CH+S89pGoPK1S9SEI44KYh3emj6q8UWWJUSg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791742381; c=relaxed/simple;
	bh=gwRi8tJ5LauvJF15FnsWPOaMsiBcZj8ycmgZAY2TY4w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bGoDLT+HoPQjssL6G+xGQ9vcHl5CRS5v+177iyKyd3oDz+kghDaxUbGkLLWqveIdx3bnz9DgPEBqB0sLY+IKySnjUu4avpsqItNkbD9CATBDzX+jrIiDSoL9U0Y6QKmJ2M/I4lj7ITd0Xun/B5oMJiOtpeog0Pcvl2g3F/jFPUw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cg5b/B48; arc=pass smtp.client-ip=74.125.82.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cg5b/B48"
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-33c2520ad38so2756476eec.1
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 11:12:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791742379; cv=none;
        d=google.com; s=arc-20260327;
        b=EkC8HLHEl8eNvVHFp5f318mliiPGnL+ifYHnP6xBuW6auxcmAi9hX0XP7WGE/6VFw6
         mw3EGJD5s2av6aJkk553K/6IOjrm9m00upO4+mwdDOYKiK6L4QghrzIFzXVgEU26lwQN
         ScMoSR+JpKwV0K3D/TwWr7oHUX0aH9vR47vfuKqiDjgdvEkH73FQdz4nzeNNFprev7aY
         EzU9Ggc2UP0HBTk498hu3PJJKqxlx3UJ1eS3d8HrrprD0owtU/Iws8TgfZbLyAdKGy6S
         26VDQJfrIdnUvNkIHuZbG9xpm72Klnao0h3ysDd9O4mFyrOXafT7bFl2tKpxV2xWuPVd
         E9rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gwRi8tJ5LauvJF15FnsWPOaMsiBcZj8ycmgZAY2TY4w=;
        fh=scchgjic1mIZSMr2/JluakSsXdvBKLxLewywx0wjsAE=;
        b=DUbUXWSXogpT0XGFRWSPTsGCHaGnGkfF2/0CzFNdPT1f9d4/+H71yfmLZTOufT/wXD
         yyc4Dnat2EUPmnOmNGwANx4i9VL6Efa7s5dOAnM1VF8QmOBEOobbWSZMY9nXwhjkwBsI
         oBgG42tn6G6YRKlFEqrxpQ+HzWc/QOHVRnvVROaEfbGkvAUp4hF/YOjQTdk3ZLyHOHt4
         JUJgZU+mW3P+ogb8RQ0Orgo2I2qV59ycuitTDhQ10iWCjbrRgIPn7ceB/tQG0fQnq/2Y
         5yWwe2Pu6h4pmCw6Yof3XlAGLmu/+eDrcDepRErzaacQ6QT1H9h63y8QoyCPS+wRSypl
         YHRQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791742379; x=1792347179; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gwRi8tJ5LauvJF15FnsWPOaMsiBcZj8ycmgZAY2TY4w=;
        b=cg5b/B482OUEHIyUOiMGEfhIDYnFdmVLCPuk//Gb3hEnVfAtI5lW2XuvLOm3Vwhv5m
         d/MDzRmudHFTDKKYN9/yOE8XXbezepP8Qjh2IafESYzqBggmxnwe8frz+7904OG4/JiV
         p67s9nc+7t0kvH/hr+mPodwvuVpMuZcs8vYNmrVx/6XM1ASMjrvL0KgJsf5Hc3E8+adB
         r97eUPqeTOZWJ4V0sT7zMpLtS+iOozgMrjebqajOpmkUQN3xxgbmR0JxnMclTXpVTCo2
         HYYgSxjmrqyf0fMRpwhZL+0h+bIwdg9lzSZ2zwPArwo4D5nccqO5nXSm0Buzg8ZpsjVZ
         tRQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791742379; x=1792347179;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gwRi8tJ5LauvJF15FnsWPOaMsiBcZj8ycmgZAY2TY4w=;
        b=nMsppdNReg381DGn725VtskJwtB9jsSpXuhJk7eOTeZ93x1EzRgwzUiC8QO0q6iTEL
         DgCAwBQ7ReignEIwHpJJmPNnduwGmxe4v7lM6a3KIEFTVJkNhY8vr/KMQYyzHMp1OVBb
         vq9ri9+MfGl4Qhec1Ry58miZQMhkWd+y6GWK1o+CNjr2DY6NkytvdPdfjlOJLDWxnZ36
         8uuwkowTJ130FvQS7JPUZGO3wR6GD02Ju2PWxQ5adPkOTosh1SMC2HU69RyYk7iKzh31
         qahCK6Rw8ClcOZIwXnYjm1lA8ALGVt9BawTGEoVoZU8p/fyYhWdyod52EDjXHX1Vyt04
         nsyA==
X-Forwarded-Encrypted: i=1; AKwUvBwbtBvV6F6tqZFc3HKIGwHXQOQ6liyxzoVbIs1ouXX7v0cCkmXm9N0sPiqZ+gvTCcbIc6FQZ8VWXxyJZI8INg==@vger.kernel.org
X-Gm-Message-State: AFq9FYJlx48tnruoeN8luBbtmaWHIPHLwlBZ2J8/K/9NFfDnGokK/6jZ
	7xTUWWZmGh2Eatyj9AU9o2u4LQZpCbIeISFvxbZfBNleM0MWhKFEFvZDU+QuXQ925K16u4Z8vJJ
	rG9zPdF6rc70vtJycwxcFR+j6mMUxbac=
X-Gm-Gg: AYBFou19jgd7w4iqBfxO8yDlZycUNXCOmpnX/DPR4dlG0GKZFftgmxUa/EmirTO9iXX
	nY5Y7midip8r03TZKWzC2VmPstruQu8qk2uqTDjSOb/CiyeSa/uNav5Fe2hsdO6Oq+CTBIqGinE
	e5XNKxDc6M1uUJQZX/t+ICOhwYeDN/O/E8RsyPVG3i0nlLUFgtigx8Ss7gU4zAN/jg5VaTxt1bi
	YLfRl4W29w+M+2kfnUzx/x6Y0M3/UXLfiHtwPPSNo6RN0Wca5m+f6FTTw3HMjZFNkSLAE7shg3W
	iWTz9quRXitRJwVHuKIXkKUgdi6c+bL+0cGaS/DaV76XGUNakC7p/ItrFcNENb4hW4xlDSEPtfF
	9YCs2LDUsHgKs1Q==
X-Received: by 2002:a05:693c:62c5:b0:353:7d40:6636 with SMTP id
 5a478bee46e88-3537dedaae9mr9900985eec.1.1791742378990; Sun, 11 Oct 2026
 11:12:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <asmCc1VxVPLIMgY6@google.com>
In-Reply-To: <asmCc1VxVPLIMgY6@google.com>
From: Christian Lamparter <chunkeey@gmail.com>
Date: Sun, 11 Oct 2026 20:12:47 +0200
X-Gm-Features: AclHuK8acOi8aVEUTuLTHFRamALp4FOSGaLarP7QqSjuV8P0SghSz45EXW4MkW0
Message-ID: <CAAd0S9A6zNJU=BkUgpGtdHBgkcnQ0NyOWb46aDnBuGCf0TKvmA@mail.gmail.com>
Subject: Re: [PATCH] Input: reject parent overrides on managed input devices
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Benjamin Tissoires <bentiss@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
	linux-wireless <linux-wireless@vger.kernel.org>, Johannes Berg <johannes@sipsolutions.net>, 
	Jeff Johnson <jjohnson@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 10, 2026 at 5:54=E2=80=AFAM Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>
> When an input device is allocated with devm_input_allocate_device(), the
> owner struct device is set as dev->dev.parent and holds the
> devm_input_device_release resource. Later, input_register_device()
> attaches the devm_input_device_unregister resource to dev->dev.parent.

Ok, why would this be a problem? If something other than the devres
garbage collection
callback access the data after it was unregistered... what else is
supposed to happen
other than a crash.

for what's worth: this patch seems to be a "spite" response to this:
https://lore.kernel.org/linux-wireless/20261008-carl9170-reverts-v2-0-3ecb1=
2089797@gmail.com/

I think someone else is working on a separate fix:
https://lwn.net/Articles/1038523/: "Revocable references for transient devi=
ces"
With todays Patch-Series V14 on: https://lkml.org/lkml/2026/10/11/475

From what I can tell, this should have been what devres was trying to solve=
.

Cheers,
Christian
