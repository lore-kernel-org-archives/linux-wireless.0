Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.214.178
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793020926;
	b=sql5uMNUrvZslc6HDvFWjnZcTYgoLQTerQAE5xt2DsQIBV0GUrwbXTLYausCyIp498Dn
	 qUhwOr/jwSWseAxaukMp7I+s6s9H94Y8iwqcWdHJNaQV9UcXbeKcUAHXOAIrbOjs9Bf87
	 irR52eE1L8Lzyatu7RFv2mW75rJJRljgy/75h3O3zYeyuR8yU9ZAq890eATw618lJcTni
	 tLkjr2DCfCzM8470H6cfOOkdIKBvbxBf8VuLsdKOrM85dcZvcMtDYN+D26FGfIW2VarQh
	 +fiKRLBPAUgKZnLNZhhA+45iVRZ/ydGm8yhZ8MH6M6v6UeUxEN4TVa+sy9j94pL294g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793020926;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ygKVfMFF6pfWjNei1maHXSS98SoQihg9ncD5VKqI0fA=;
	b=K+6vYRNwmBPjxuhZr9pqm0RNIseMdCSh7Wh+JYBqJjAdOEsQTBnvltfAxDXo9V4ZARaR
	 9nGi/Ol+dLJV8+Jb0OQtdE1bwnJgY/5WLgIYKqJk/kBv6LQfrfKS4wTy40ddGG6vaoZXR
	 BaNh0EkLJfoGubGiluEvCPHOCJ5f3t8XSvoUhHlLV7JREKT68crMRcgSnwWVKXvI+1RyW
	 SqeofarrLeoM3wUld/fUSuj6iIAUy9abiPxUTHmWY2Z2/aRJzYGlQzjgjVD9Idqdx1KNC
	 0hajrbXIPZspfuOZccTaRnG7t16ZskOiIJ2nfSUU9IIPz+vUY8J/Ne4Jbg+fBU4OR9g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=fIs9BgLG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.214.178
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34AA606A31A
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 13:22:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B34AA606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=fIs9BgLG
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2e831e86ebfso18311955ad.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 06:22:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793020925; cv=none;
        d=google.com; s=arc-20260327;
        b=iuoqPDxBt998Vu3zawDeAWRj0ToBo+SJVX4kKpTXdjWzw6pm/zwSd0rd8q47gWa6JN
         bJxdcjV84DSqFAFoy0lxw+7h+PYliJ/QvqG/eM9U8Ip9ahJp2nV6YYBqf/w0Z59nX60e
         gXq+pfKW0/m8ajC7nWctJbaVZnR5UeezwnROskIjf4VNtvkFEwTfAoaVgnNiMkj3f74E
         qKyK7o5zIrEWywOegGJdDQJFyJ+CJxT1OzhfhCJWh+gKBslyi7TpYbR90y34m+DNlRsN
         8F4Cs8zS0mKCqPthwAHfLm6pInDPnJK8WmaAyJpEiw+tf2l/Qf6dPWv30SyETHMzXfpd
         JRrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ygKVfMFF6pfWjNei1maHXSS98SoQihg9ncD5VKqI0fA=;
        fh=xEaCV0GsHXCXr69EfmEOr7CUEqjbnflG/gV3njsa+EA=;
        b=BY8oBmK2Do4VqALh1k8IeD673ZB2ROnIbASrgQF+R+NDykIMVjUQTg0qQZ5/NDX0S/
         gDtqfa97sOsA2vseTG9+byLQfm/FdwoMfPNeQf1xcfnQ3pRG5HeEdilkjXEye1vpbJvV
         yD5WP0gD6viTlNyCIbuymvegeVxYz3QShfdldqVfH8+m+B8F9vAjqwCtjns5jt7k4Kra
         EdiOukvFs/ZaVBrFgSHQpTRv1EV2SiVFLRTLEnq/BiKguk5aJdurw82WqBXsdf8vthY3
         KNGGIGhoaPZnHYq2z9JarznAKhVYz47iqy8GjSoNcycX63bRH2Qd1VmkcCqHoUS8Z1WO
         3N7g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793020925; x=1793625725; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ygKVfMFF6pfWjNei1maHXSS98SoQihg9ncD5VKqI0fA=;
        b=fIs9BgLGnncca5CErJJ1CLztnWZ9eJaGXLAcPHNmeSAjQARebuf9Iirederfnjc3jV
         v006lzd/aPs02tnKfbeESxf5QC/bNzu7guUaDv2dl1hC2gIYU0hCA5+YNoC0Gy/fj/Zn
         oAvo6zBoQtIhGHJ1Db+229lEZK+3xCYQdQtYGY4gnDTD0zobLT7/vpEsDJ8Oh8DJLiqS
         SU0IYum4ulGzIH6Uk13SMm6nkzxEwINhbVXnGcrj8+Lk/Vv/MAh0WQN316jpnAx7mIKn
         SfYmcM2NsYaV3UtNc0NoUkTYyo3Z7otVOF/EwvLQaAu2FdUjS/VKk/IHc9JUqp/u7UM7
         Mn7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793020925; x=1793625725;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ygKVfMFF6pfWjNei1maHXSS98SoQihg9ncD5VKqI0fA=;
        b=FSJOFJS8pdlqgWetRRitCQs9EPohEmAlxOni0GfrOcU9WUQwuoMvmZBdIdVhlpv1OO
         mkPm0dNkexu29EaCWbEWA3bnXcBMl7lsMpYfgfnZJs3K6JqNQavc/Kylkax4o5dwRbGW
         bXhJEwLkI5lUTWu6Rw4X2hglxkFLCh+jzLcYIH3P1ybtjpfMEp/aA4lrMHzSl0wOzT9Z
         ZjcGBuYiWTEoVp3NQYYtfpicuUQuVaBR4GxEdMQGYKdfSe9ah0nXPBYjIE2FbDteVO5P
         LNqehssx+245zNy6bQ5/bPFyW32Ls6K6f86W1agzfvnsX4QA9j5M/sqtj6wbWfE64e57
         C+aw==
X-Forwarded-Encrypted: i=1; AKwUvBz8A7l8q1tA63QpEkj0luOUFCF3TARIx1NolsZgYdlSAER5EQeOxFElHeynq4rAFhxVrobV9Pb8wawt3fGyoA==@vger.kernel.org
X-Gm-Message-State: AFq9FYJEBopX8pMYJ+1Otamcc9KpvlRX8luThuPV3j/mW/qRk/tM472Y
	5rIG/XdLVTGVz5pKfz33zTbyFvE5xpryRo4lCMyqe3JJjh6RmIVFnt1rZaJnszpmAF+bINMWzFV
	cBukxbCQi2J3IvN2A5DO31RGP2zih6hM=
X-Gm-Gg: AYBFou1IWYOEuPzfyEXT2hhAsjXMmMlmvV0yvGzH617VuiYF2YNvA0ixqEn3jSTg4bC
	sRPBn09PEVGuuX86IR2DoCeKJntH2VpANEB1xXDAdJCj8yOf2Tx+m+QeKBHqjksWZGfXrsmstkE
	mS9WZFja4rogKOKlltYSMZLF+W03HJ1hGsclmN/gAKI3jfdLHIJb5J4YiQgpQ75oK39iY3M23Rl
	uQcIx3zv4WIJatiJP1RhVyN4BYUU0BI48gTgOxFBUVEvAr/Lsz16LBdINgtzupXmxOlpbm30QIk
	Xu+1ebJiybXomn1A1q9375dakI5WSu3ySD7LgQ9BKkSh1W4IE2Wvnqxl5IYbjlULwCXQzfS3F9d
	kismvNCs8OQWiLbI1RzB6AYpoTqFmuPeosckpAg==
X-Received: by 2002:a17:902:d58a:b0:2e8:18ca:5f46 with SMTP id
 d9443c01a7336-2ea9c6c8307mr61563325ad.14.1793020925006; Mon, 26 Oct 2026
 06:22:05 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAHaeJsQLvC-KBEpy5qu8iYxSB51mbHohrPvN4PJushF_Tk3foA@mail.gmail.com>
 <20261023180554.7266-1-lucid_duck@justthetip.ca> <CAHaeJsSfoTxJhWVCrELCiLZr1zD42LGJUvrmf7oSzRQpwh6-jw@mail.gmail.com>
 <20261024173414.10559-1-lucid_duck@justthetip.ca> <CAHaeJsTHykkk8Cm+FUZW2RmzzmT47aJNxRR1kpymhDvknnhKuQ@mail.gmail.com>
In-Reply-To: <CAHaeJsTHykkk8Cm+FUZW2RmzzmT47aJNxRR1kpymhDvknnhKuQ@mail.gmail.com>
From: Chris <hoopyfrood42@gmail.com>
Date: Mon, 26 Oct 2026 09:21:52 -0400
X-Gm-Features: AclHuK9WB8vBfhKMX3Q1TrHTS-1eG0jMt6qxG97MzBlpwE7ruuhiuAsEwZx9bHs
Message-ID: <CAHaeJsRROtH4CLVR8mhWznWq6c5mLqLsn9j=6EXPgFUOW8t26w@mail.gmail.com>
Subject: Re: [RFC PATCH wireless] wifi: mt76: mt7925: get the survey airtime
 from the firmware
To: Devin Wittmayer <lucid_duck@justthetip.ca>
Cc: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, 
	Deren Wu <deren.wu@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, 
	Shayne Chen <shayne.chen@mediatek.com>, Javier Tia <floss@jetm.me>, linux-wireless@vger.kernel.org, 
	linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 24, 2026 at 6:29=E2=80=AFPM Chris <hoopyfrood42@gmail.com> wrot=
e:
>
> On Sat, Oct 24, 2026 at 1:34=E2=80=AFPM Devin Wittmayer
> <lucid_duck@justthetip.ca> wrote:
> >
> > Chris wrote:
> > > One thing on offset 20: in monitor mode it doesn't look like all of
> > > rx.
> >
> > You're right, it isn't all of rx. Your numbers made me curious, so I
> > tried it here with an A9000 as a 20 MHz monitor next to an Alfa. It
> > seems to come down to how strong the signal is. Share of the time:
> >
> >                                          offset 20   decoded frames
> >   one strong neighbour (-22 dBm)            2.3%          2.0%
> >   only weak neighbours (-73 dBm or less)    0.0%          3.6%
> >   my upload, monitor on a side channel     54.6%          7.5%
> >
> > Strong signals land in 20 even when the monitor can't decode them,
> > including spill from the next channel, and weak ones are left out.
> > That would fit what you saw on 5 GHz and on channels 2 to 4.
> >
> > As a station the A9000's own downlink does show up in 20, so I'd keep
> > it as the receive time.
> >
> > Thanks for the long run against the Wi-Spy, and for the Tested-by.
> >
> > Devin
>
>
> Devin Wittmayer wrote:
> > As a station the A9000's own downlink does show up in 20, so I'd keep
> > it as the receive time.
>
> Makes sense, thanks for running that down. Strong signals counting and
> weak ones not explains both of the oddities I saw. For my use, a monitor
> hopping channels, busy time is the figure that matters, and that one
> held up on every channel.
>
> Happy to test a v2 on the A9000 if one comes.
>
> Chris


Hi Devin,
One more from the long run, which you'll want before a v2: the busy
counter (offset 19) looks to be 32 bits wide, and it wraps.

Since fix 5 went in, about 2.5 days of channel hopping, my scanner's
sanity check threw out four survey readings where a channel's busy time
jumped by close to 2^64 us. Each one is a normal reading less exactly
2^32 us, e.g. 264 ms busy in 645 ms active, minus 2^32. So the firmware
counter wrapped (every ~71.6 minutes of busy time), and in

    state->cc_busy +=3D __res_u64(IDX_BUSY_TIME) - state_ts->cc_busy;

the new value is smaller than the old, the difference goes negative,
and cc_busy wraps. It happens once per wrap; the readings after it are
fine.

Taking the difference in 32 bits would cover it, e.g.

    state->cc_busy +=3D (u32)(__res_u64(IDX_BUSY_TIME) - state_ts->cc_busy)=
;

and the same for tx and rx, if those are 32-bit too. I only see busy
directly, so I can't confirm the other two.

Happy to run a v2 against the same setup.

Chris
