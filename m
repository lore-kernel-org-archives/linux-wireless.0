Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793465740;
	b=pkSTUYADwTi38vSF7+2TwtGpC6qOsLpPA8kutXMx0v7vrfnxJ0pyDFEE8vF/OwecrCvp
	 i/aa5aajPS7c7GYWbSjf4hhXS1Od8LaAUS02BtBI0nzi7+dVpq84BzAbqjmF44iJRjiYA
	 eb9yDOebBb1BQmM3+J8mRStA9nzwRT1hgEYxs7DuY/3Yynp57U+xI+7YFfrnqAfEa8/Ny
	 xy8TFdNeIixvVDi97Av2AtRj2tEboUwdcwVmVFrSaRg4l+65g9Gx3+YXB035KMcDQYAqj
	 aOJrO6M0Lo7H51nVd7TUMIfKzO5+DDtWNzxcXjERsmoMk/+6bU4lIeDJykYgGg9dUVA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793465740;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Content-Type;
	bh=shOrZ3PlKolQX3Sbw2tCYn4l6UGKtUxNeWswLeQIJxY=;
	b=xJN9l6svZvgVb18KYMHXBd2CDdrNO7xk412q94meAeaZvnHaOjQkjfokSJkKXKZ3LfAK
	 8+OJVNFDqcBm+8BGjpfanK5PcR5NyITKgMjq3XxsLJHDW+ZaWdZodnP2wYjNQFSyfAPaw
	 SVG0r5y/3m8jOsWWcae8NpvG9BYgr9KVV8BFPIl8UwHlsNyvTtmLk2f4U5jxslaPA8fW1
	 sIjB4vWgymg7xH0+1AfpuTMyFPiX+MSkBnLr0IteDpk+eHhP6Xwk10VnQjf1R857rRb+L
	 NkHHikPEmuo4XHAvBrdNq2e4jqxEGUmXKYXMMMWsIMBNN7Si3YOjuUn/dGNeBUZvM5g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=R9Ad99QA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.47
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B80606A31A
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 16:55:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88B80606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=R9Ad99QA
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7f48c750afcso1147791a34.0
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 09:55:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793465739; cv=none;
        d=google.com; s=arc-20260327;
        b=l9BMnldG+v3NDlD42PTm4Yyb2kLc4FcZVinqWSEw7D0h5gwC7omADkJBUI2yfshEVG
         I76ie16B6/tiwNb57pkPGCsJMlnteQihIyNauIh3B6gWmUVLJjVX6gAI7445APmXnYnT
         K55IB6lCpjECbbPUFDXf4wAkL/q2Hzq2M6qLOfWHFr1blrgFLQPHjaTTlRI5lI3Rm5nD
         GvcVqFQVq1FMW5lesSNEC5pM7I7A1gAODbhXR3LBdsEW0R+15loj6AEFcKc7R70vJg/1
         0/sv5hQIqbckZ9WBSFwzqiVyeLCvW15PbyMyzGBDwnh+CxmcqRPCAdaujSnfk7dECRsm
         PSpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :dkim-signature;
        bh=shOrZ3PlKolQX3Sbw2tCYn4l6UGKtUxNeWswLeQIJxY=;
        fh=dFLIicc+bmLRC6hHgJ6xR3xC6T+UBAk76g/ZlmGKXd0=;
        b=kq0KafcukP7N56NmPipyCUS3cTvJljJtwZBh+tWRyEKhOTddRH+atd9jtah0buYwV4
         7UFMeOuunbbrbWY/O9IxAcPgw33qW68ATzKmoD7PN8LPpauRC2FrWr+Gv90IwaBaeXts
         xFxhefg0b6WwU58nx1fD06hULmOOlPCP6sw1ZmAPxcWbmGPzlqm03V8xg2f7zmzXLXIo
         HHXFmC+crS5DZFwsnDhgeWvpiKRC+jBEzqU7/m3dEXNJjiI2LdxwnKjXZMSyDNFfCL/c
         vgjBF44y7OFeYwuH+qN0IrV8tigxHnM6Wxf/6BT7ts5J5yyOtbjVl3EMioMzzAoGKP6F
         K3gg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793465739; x=1794070539; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=shOrZ3PlKolQX3Sbw2tCYn4l6UGKtUxNeWswLeQIJxY=;
        b=R9Ad99QAXfuzuY5/9D2ynDVyHWpq5pTiaioQ3+IO/a/qS8CIZ3tIE/EcDiQTDuwrNT
         fqftLnXrrlDyyZkBW7lGnRClYYN3x1KEiICXhtpBU0v2Whl/QIU8AzJrC8At8Xt3Tn9f
         dbSBNOioqW98pjaFDTcQg34msah7oHO7V40X9gzpEBuSjx41NsGsnPHOYablLFAme8H5
         wPLBZ7p3xhvvX99K2+aqiGWB/rKJIgKjDtL/0X142kRM63MzQixtghPpXzOoPfrYXgkn
         VvF+TXvLA1t3SFfB9a7s1tDxJJuD0XBlY7i8R+HJp55NLBCVM3HfV0ypx82uOHHLP/c6
         4XMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793465739; x=1794070539;
        h=content-type:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=shOrZ3PlKolQX3Sbw2tCYn4l6UGKtUxNeWswLeQIJxY=;
        b=wXYRYIfu0TAt4tis/4wdZethAviDjzzX5MP3KGMaKoAMVS2+F5z2P1BGN353UWmOCz
         AnyF+N0bBcXWnjfjEv1kyEBzSehKOfVFCiPc5DH8udKGsylSw7chVT9y+9AqXhSUoKhA
         LJiRG4AUoPP4ZiwvCOyKWeyT5FmL0SwGojUewt4/pSkLQwBluq/MkE+ntJ6zrlIsLx6I
         9amlcffQ13OXPnbIOVSLV3RM9xSpNmvAvv3YqvkZEwqDrA7nfU6KtadQFVUGNfkhqTH0
         nKiMZ4hmkVxKTOQQ3DWMnSSoA5W9vSpGCBNNRgg8JhK4IhDJiwUjhZVtCTUethDoqNx8
         hiLQ==
X-Gm-Message-State: AFq9FYJJZGBHl0QsOR2QG3GvUXuF7GGdLp9a9i8XjOAc7XHyQHruI29T
	bb4VNg3Rw86AKr+ORSCscu9ewSVNJdz8PVEUYgfOr/KPD3i535DXRMS1DetoS20zFo0aUUAyywD
	T1B24AUpio6oFliXJMKxTcXLh5BWoqXcfiuA6lt0=
X-Gm-Gg: AYBFou2kVEa1Y9u07xAJPYvVKgwwe3NrXdxvNbpvVqk4OiZeXRDVGcARmFaJuI+hnCH
	VpMcAOtkhUzMEL5rXbXVMWU742hgNQRDlL57P4OhHYQEtQvVfwAPkw55lzUosvMv8QyFeUz/Awt
	xq1XKSmGcyBu6VipZGEdse/K8YFkyW1SEzj9wDmIZSb/ia8yV/sujCO++2lz88lhEEuXx1mAtE1
	UccLyuk53sKKDmIM9TUSFLDhdO8yvR/HEiNGazsoGA4GWRMLm636M2ud2hjzXWn0LdetnFBRRGj
	XzObiudsvM1uT4AsLy8RsIf9YK1BlmswmpwiXrI0wfaTkWmszd336/KJx8MlFq+jaT13wNZCbi3
	hfQGgowOU0f1plbn2afolp/rI4qLom4hSKloEun00YI6X0IEM8Srd5wUT1Oih0uf3kZ6Uu4U=
X-Received: by 2002:a05:6830:b14:b0:844:4959:e840 with SMTP id
 46e09a7af769-85d36416e94mr4003116a34.21.1793465739454; Sat, 31 Oct 2026
 09:55:39 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261031165117.2868671-1-hjf3108@gmail.com>
In-Reply-To: <20261031165117.2868671-1-hjf3108@gmail.com>
From: Jie Feng <hjf3108@gmail.com>
Date: Sun, 1 Nov 2026 00:55:03 +0800
X-Gm-Features: AclHuK9YbeGQjI7MJSeAsdzo56uuC2_4AAaYKpA4OEWtkPT2DcrWzkrTxHsIQSk
Message-ID: <CABOQOSXH=Z53sKaxFO916yz2rYcV2Z7DPZ9AKw=Sw0JBhmHw-A@mail.gmail.com>
Subject: Re: [PATCH wireless-next v2 0/7] wifi: rt2x00: improve the throughput
 of rt2800usb
To: linux-wireless@vger.kernel.org, Stanislaw Gruszka <stf_xl@wp.pl>
Content-Type: text/plain; charset="UTF-8"

On Sun, 1 Nov 2026 at 00:51, Ho Jie Feng <hjf3108@gmail.com> wrote:
>
> This series improves the throughput of rt2800usb.
>
> Implements
> - Frequency offset calibration
> - Better fallback rates
> - Aggregation
> - GRO
>
> Tested on WNDA4100 RT3593, 5 GHz with iperf3
>
>   patch                          before        after
>                                  TX    RX      TX    RX
>   2 crystal calibration          27.7  31.6    28.5  69.7st
>   3 MCS16 to MCS8 TX status      27.0  70.0    29.4  70.0
>   6 RX bulk aggregation          30.5  67.8    30.5  80.9
>   7 threaded NAPI with GRO       30.5  80.9    30.5  161.7
>
> RT3070 did not have any visible change for both TX and RX.
Changes since v2:
- Correct the link tuner start and stop conditions
- Extend fallback and MCS retry calculation to all devices with 3 TX chains
- Remove TX AMSDU and fast-xmit

> Ho Jie Feng (7):
>   wifi: rt2x00: start the link tuner when an interface is added
>   wifi: rt2800: calibrate the crystal of RT3593 with the beacons
>   wifi: rt2800: make MCS 16 fall back to MCS 8 on devices with 3 TX
>     chains
>   wifi: rt2800: don't report an A-MPDU length to minstrel_ht
>   wifi: rt2800: support A-MSDU in A-MPDU
>   wifi: rt2800usb: enable RX bulk aggregation
>   wifi: rt2x00usb: use a threaded NAPI with GRO for RX
>
>  drivers/net/wireless/ralink/rt2x00/rt2800.h   |   1 +
>  .../net/wireless/ralink/rt2x00/rt2800lib.c    | 113 +++++++++++++++++-
>  .../net/wireless/ralink/rt2x00/rt2800lib.h    |   4 +
>  .../net/wireless/ralink/rt2x00/rt2800usb.c    |  33 ++++-
>  .../net/wireless/ralink/rt2x00/rt2800usb.h    |   6 +
>  drivers/net/wireless/ralink/rt2x00/rt2x00.h   |  21 +++-
>  .../net/wireless/ralink/rt2x00/rt2x00dev.c    | 106 +++++++++++-----
>  .../net/wireless/ralink/rt2x00/rt2x00lib.h    |   2 +
>  .../net/wireless/ralink/rt2x00/rt2x00link.c   |   9 ++
>  .../net/wireless/ralink/rt2x00/rt2x00mac.c    |  13 ++
>  .../net/wireless/ralink/rt2x00/rt2x00mmio.c   |   2 +-
>  .../net/wireless/ralink/rt2x00/rt2x00usb.c    |  52 ++++++--
>  12 files changed, 318 insertions(+), 44 deletions(-)
>
>
> base-commit: 2c50cd5d10e8723797f28c7978f1f61688e0c0d2
> --
> 2.53.0
>
