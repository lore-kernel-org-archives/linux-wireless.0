Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC9935AC09
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 04:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787546394; cv=none; b=Ry1eGhIbjR4jc2vaa+YYA3TC6nUwzz3DqHi+X2Z8TDgTKmK36w/FD/GN6nlwgy7nVKVp3IAkTzWBE65NZ8ObujxqK1fMWBJO8jRydUiOzpizxOupnBhsrVpoSTJuIOdLoJBpv1hys8gjBAtq3bLQsV2uFVXbBA/7+XmftMwcFA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787546394; c=relaxed/simple;
	bh=bamvOZ5tUCgdaqL7D0Y/4JjSmYGsOedivVLNrTZcQ6U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lG+Jd44W+BjZ8yMaR9+l+9dfEikD7u7ieLQKP3vBqXOTimhz++sssjPMTn7+5kHduf7nQynt+c27MqgjLcpAd6EXAVj+wjjfiE2KdLcDjOverxDNSmAq6cAJGmmZWPOB9t5HaR4RDKLyyOGRNM+PilVK/mODRGgalrGGHB2Up/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G9TpU+IK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G9TpU+IK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DF51F00A3D
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 04:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787546393;
	bh=bamvOZ5tUCgdaqL7D0Y/4JjSmYGsOedivVLNrTZcQ6U=;
	h=References:In-Reply-To:Reply-To:From:Date:Subject:To:Cc;
	b=G9TpU+IK2J5ouDaTwB5Qa7BPgw9uKp10IUHnobQ5bD2NgR9dhDvp+P6L3PtjpyQ3k
	 4ozB1mtBei7uPrdOuy+vBPo4Rfe3wPLyWs1fkrCvbpONhKVNoDfuFTuQxksBgGblub
	 A99k8RMQsppIgemXcJkfKqvccv96Ky9w0VoeNHPmiC6XQIRTdukeq2+clcw+ZjFq8W
	 ce2Yi2zzZ2r2zXgjT1eUjP/Imx8nPNVzxcEyYfOIwmnqOmlAfdCWcSOMhdh4xFFcA4
	 f6HzAC/kslCr7/CtJ+WP2gB2rVcawEm5D9ovXQceOTyyteUBHfNa37PtpGmuEbNFCo
	 ucRdkE+8IcZyg==
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-39f75e1e9d9so20397351fa.1
        for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2026 21:39:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rr6DLMV6/yh47OBZRYky5rc3108Mk2nIt54l3a50V6DSgndIMW9KQgrnl8XBcbgvi4duBcQFBri1Uz0bD+pxw==@vger.kernel.org
X-Gm-Message-State: AFuF++kmkhFy4kXvQ474rhalQf3nKu1z9ZQXvqHjvWLF3pgrNi8a4L8e
	5y7kVsXtMudk5aDnYF/XNCogCaS3srydhmNlqyUr1Sn4A0/GQaBY97FpuQO1BIKrLLQyt6fX6Nl
	+zG67SQMPNUjaAPjgqa2SJtbIcglGVsE=
X-Received: by 2002:a2e:bea6:0:b0:394:3b62:b6aa with SMTP id
 38308e7fff4ca-3a1aec678fbmr51224111fa.12.1787546391501; Sun, 23 Aug 2026
 21:39:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CACeKqZC+RCVtvGMaWmNYLnyA0OKsKM3YmaMxNk_KZqr3Ekji3Q@mail.gmail.com>
In-Reply-To: <CACeKqZC+RCVtvGMaWmNYLnyA0OKsKM3YmaMxNk_KZqr3Ekji3Q@mail.gmail.com>
Reply-To: wens@kernel.org
From: Chen-Yu Tsai <wens@kernel.org>
Date: Mon, 24 Aug 2026 12:39:39 +0800
X-Gmail-Original-Message-ID: <CAGb2v64zk4y4PBE6q6vendj_Rfnh8tZfk_sqoJJWghZEj5gOow@mail.gmail.com>
X-Gm-Features: AcwNN1XH3otKghPwxmWqDEXTHV3SQNRzM0wewEl9BEaMb8A9id6-g_EuCy3q6gc
Message-ID: <CAGb2v64zk4y4PBE6q6vendj_Rfnh8tZfk_sqoJJWghZEj5gOow@mail.gmail.com>
Subject: Re: [PATCH] wireless-regdb: Update regulatory rules for Bangladesh
 (BD) for 6GHz
To: Tahsinul Mohsin 2524687642 <tahsinul.mohsin.252@northsouth.edu>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Aug 24, 2026 at 4:19=E2=80=AFAM Tahsinul Mohsin 2524687642
<tahsinul.mohsin.252@northsouth.edu> wrote:
>
> Dear concern,
>
> The Bangladesh Telecommunication Regulatory Commission (BTRC) has officia=
lly approved the 5925=E2=80=936425 MHz frequency band for shared use in Wi-=
Fi, IoT, and WLAN devices.
>
> Here is the official BTRC circular (published
> September 15, 2024):
>
> https://btrc.gov.bd/pages/notices/6922ee00dbfbab28ce0c438d
>
>
> Could we please get the db.txt file updated for country BD to allow the 5=
925-6425 MHz range?

A reference with the band and power limits, as well as any other
restrictions like DFS or TPC (andif TPC is required, what is the limit
if TPC is not implemented) needs to be provided. We cannot put random
numbers into the database without justification.

The BRTC circular only says that the band is allowed. It does not provide
power limits.


Thanks
ChenYu

> Thank you.
>
>
> Regards
>
>
> Tahsinul Mohsin
> Undergraduate student
> Department of Electronic and Computer Engineering,
> North South University
> Plot - 15, Block B,
> Bashundhara Residential Area, Dhaka 1229
> Bangladesh
>
