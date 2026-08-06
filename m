Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0063EE1E0
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 08:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786004467; cv=pass; b=kl6bwAeaJ6D8rblDxbfauM4oArWpGR40Py7jpAP+mWEoFae/4tdA7DXhKoUpjURchfv0hNru1c4+wHIkk+IYRv8BYCLcC3tPyunaytwGPNg4KRoGaexiaOJYb4ZtsW6SZFq/sPR/UQBm/LnJCX0+pv6Y/GW68jaRUwz0rRGzYbg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786004467; c=relaxed/simple;
	bh=DQm+7nJbWgzZOSgakIrQ2bxhOp+OLa+HAHWPLhyMNMY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uvfC75sSEWfsu1C57803s5xTz2YmUnhO5GaXssHJBCFRTAhY3SSKPI9vay+FuCsA9Ldhl7vbudOWps1L0FRvppX+20OyD+M7OtUTSg/ZSvjLeFG8wyH8MdZSYA0pc2GnJU+UvGP1R0qEH53mGSCw5gVG3Ow2uvsI0CQxcS/4xo0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eIe9v3xW; arc=pass smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eIe9v3xW"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7eb64085c45so1555949a34.2
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 01:21:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786004464; cv=none;
        d=google.com; s=arc-20260327;
        b=Z3DIeNDJNz8fmga1C+hyYL47eQ8PP2n6J3VvwF56rYeZ0aYLdg7A8kuufqsBu1kCYa
         sfusSL0uIFUk2keubJ6Y+6pWP0YUaCMRP9W7vtW5eeJJw6Ug6bBL+jhMj/7EUlEwxiJT
         KaXxn5tPWgJZESZN0gTDbYjXom4kSkSFjz8EiqtvGaLcKwfYN4HDT/6OvwMdoxUxOKe5
         gT3qkpVxr6fSXAItEq8LnqAy1J0pRjrdVbXP7vWU4rA8Dd2IZb6WDMA1RQwGQ5RI4+Km
         uKJ1AAy94V0dQuRIFn6bSfHNWj7FsKKAWC6Hp4+QnfDMRpGIHIN2jFgtMBn2u0KgC+9E
         fFtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DQm+7nJbWgzZOSgakIrQ2bxhOp+OLa+HAHWPLhyMNMY=;
        fh=3qpLCN94SLVu+Zgyd+eOCvFJrskqItcRta8zkObVCHc=;
        b=XOmV6cgnQTW4batlQLIbXjid8FqhM+TxOCp+fUM8M2I7UxwePUFa1xRNMF5vA1aB2K
         XyRHGsqvdg3sb0G3qHUVqDte+NzqeK4Ya364LXfOR2nKfC7tPbHvknT2EIi1Iwbf717F
         h+4aa8TjE8sNECSunhkBJkbSodpWoeVr+1qR6+Yi51lX0KxLr36tLAkzlaIPEUFttA4e
         IS/7c/SW0GsCKfBz6MLsrvv4CsfBwV7UtLGEXSHz6sUU1TVvBdNVWdYnTl/ujt+zjv5b
         exmqw9w9micCfwDkRvVenM1UrInVGpu4RsEUXgd0DFylkZGlxK8q0GzVjary8CS5cSy2
         jlNg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786004464; x=1786609264; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DQm+7nJbWgzZOSgakIrQ2bxhOp+OLa+HAHWPLhyMNMY=;
        b=eIe9v3xWx5YcItbIKaAi0RzMsptulz7DlmoN1bl4eNObm3OZ0vB88hnMzpe3TSyyGc
         iS2OA6QfP7XtUzGAC+s9UVpcg8ViwBVE0lrBH70AIIQt7GUYifUZyDc+qSq4QOXe4K2v
         RGuEF+M+ze5kyF6R8F0np/a2fMwCk1kEIVrph/g5BuqwB4Mfpe2HS74qzpti2VPwsuLV
         6KpZf8Yx5jQf9KKwJcPljOzIrYTsEvsZ4Cm4M5bgw85AXcwsV2BqfPYV5wpyiEB7f+9U
         7RCdeK1+D1xFb34i3WEIOGqZ55HJk1H4rZZPwjYYcVZpRnnsdsK7JoNvHGHmAOFGSG+n
         UtAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786004464; x=1786609264;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DQm+7nJbWgzZOSgakIrQ2bxhOp+OLa+HAHWPLhyMNMY=;
        b=XKwO2lBJ/4BwcKlE8nFz8riTt9+YtG92saCRRf+LDDfkMqH0tEeYnXvloIiyM7v8RH
         f1pxsawB3eJ1AT2odrClBmNHYRU91TtW1gjNdKQL/H1UnbSX6O3yubmyowjEiP/hdiag
         DFVcsCbkNKVJsF9yORAA/BKmUybSRXm/kxeT9he2fWzIJsBPk5zcMCI1hTqqlLbk4al5
         4RMtitkvNcxQbpTLQX6dbWD3JJarZ6bsIfR7u873OJvAu7gNrnRMmnIYflr4Yrhh+WNm
         f7h1Pr1fVrZZr5Vz/ltqTKk0Td6/SESidSCcz+cV96U3rMSQJC0mPctQ3HUY0xLwQVLl
         wcKA==
X-Forwarded-Encrypted: i=1; AHgh+RqO+CHd9yJzNf0i2SOFEdomjYTnaQ57PBhXvrmLvo6DeAO59i9XMpFUAFiLFVAFrfOTEAiGRTUkOiNfbmLhFA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8thGel4f6ZstEDExbHSLa8ubkJxzKTtstiScSfiJZ6eLvCEvB
	wdQcjhUQ+L9ebZetC2wni57loYdMQvq0ZYhcUHgWY/kRFdaPvMa/M0DP7rQbpYoN9voy8vKRLZ1
	+8Wci8OUAfwJpsHU1WJSaImgKw8HX4geWalYNuXj77S1iSOQRvADIy0kB0PU=
X-Gm-Gg: AR+sD11hN4tYucszL12xgOVPdZFpHfnwkv7exQ/AF582LVCORY6ANLXXyl6LItZ3szh
	RUxQ5boO6IEoMeN3c+TUO7JZ/Spfih9e3c2SkOu8SSnOwDmZa+ThQ7ET4NlEUFo0RiGEELlSyDG
	Zsui7je0gUWNodFSM2xSaZExN80kaOVvSM3i0+2ctNlRFdtQnKhdJ0wDz+t7ayfll7glMgtSGMr
	IZqgE224+a2jgIVW1KwvZJCWeWrYKzDFJAAveAP1UOhtpcoG0crOR4QCLHWIesh8dvYRZx+EOqI
	c1mUUtqqxImi1DRf9nCD3tmrCOdcniYKhwsm7HolyBvp5SejFoDi4X548DDC2a2vxO4Xw+arOLP
	ODuZ0xFokAWQGc/CyoPETTKFY6/tDKqXhDZYyQyXlR8xKKiNv1iw42jpD2q+673ajNGKF7QVIkm
	p8Z9lAutAVjmW5
X-Received: by 2002:a05:6830:83b9:b0:7e6:f7fb:968b with SMTP id
 46e09a7af769-7f1e5c1183fmr8101196a34.2.1786004463813; Thu, 06 Aug 2026
 01:21:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <068e46b5-0c88-4432-959a-b9400d9691ee@mail.kernel.org> <3b6c46b6d79f3a0e0ded2967db3cfd469314b05c.camel@sipsolutions.net>
In-Reply-To: <3b6c46b6d79f3a0e0ded2967db3cfd469314b05c.camel@sipsolutions.net>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 6 Aug 2026 10:20:52 +0200
X-Gm-Features: AUfX_mx2KzgUvmSWxAEaAcPFDO07eE9PP75CLUmi62JzPJbq4FdUeANFUdNkvtM
Message-ID: <CANp29Y6sHOe5QY6BgzeUtKFGqc2pDyP8WAUzQ6E1-3oYgZTY0g@mail.gmail.com>
Subject: Re: sysbot AI patches and wireless
To: Johannes Berg <johannes@sipsolutions.net>
Cc: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com, 
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot@lists.linux.dev, Slawomir Stepien <sst@poczta.fm>, 
	Krystian Kaniewski <krystianmkaniewski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Johannes,

Thanks for reaching out!

On Thu, Aug 6, 2026 at 9:57=E2=80=AFAM Johannes Berg <johannes@sipsolutions=
.net> wrote:
>
> Hi,
>
> > See https://goo.gle/syzbot-ai-patches for information about AI-generate=
d patches.
> > You can comment on the patch as usual, syzbot will try to address
> > the comments and send a new version of the patch if necessary.
>
> I'm going to state, for the record, that I'm going to make judicious use
> of ability to ignore patches, and apply it to pretty much all syzbot-AI-
> generated patches unless a 3-second review says "obviously right".
>
> In particular, I will absolutely *not* "comment on the patches as usual"
> and argue with an LLM that can bullshit out code faster than another
> computer can even deliver it to me by email.

Some clarifications to prevent misunderstanding:

1. Every AI-generated patch sent by syzbot has been pre-reviewed and
approved by a human engineer. The person who approved the patch is
listed in the From: and Signed-off-by: fields.
You can see this pre-review process on our moderation mailing list:
https://groups.google.com/g/syzkaller-upstream-moderation/search?q=3Dpatch%=
20wireless

2. For the patches already sent to LKML, the bot *does not* send
automatic replies and *does not* automatically submit newer versions.
Once the patch is on LKML, follow-ups, comments, and iterations are
handled entirely by the human developer who signed off on it, so you
have not been interacting with an LLM.

I apologize for the frustration this may have caused. We'll stop
sending AI-assisted patches to the wireless subsystem.

--=20
Aleksandr

>
> Whoever is currently pretending to be the human in the loop *absolutely*
> needs to think about the patches, and if that's happening it's probably
> no longer an AI-generated-sent-by-syzbot but you're going to rewrite it
> and send it properly.
>
> (IOW: get lost, syzbot)
>
> johannes
>
