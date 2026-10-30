Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793359839;
	b=eYxSJbnX4bfd1Vqgbc5IveThYOyIXI+3Xv9wVN4lbbkPtqysZxJD09GoimdOlNPG343L
	 INmPOckdBhkHu3BsLKVwN8eqjaAljnOCeuT59g706BhjnULY2DXKuM3I+njhwD4Jov8qT
	 s86pKpY/LBc3axv+4VFGbDla3o+Yonlcg8u2WxjG7m4XP3OWahJ1c5ShI3cN54R4HqUt4
	 NFg0oATh4PluEVkW8U9QF1S64ekUahCjuLCmpPBWeE+Y0gOOGDAmOpArtnKzCnorhZ0ZK
	 dWqRXc90o6O2aSslzQutGA2dxQblPmSk/tSFn7MCQ2pCfwg1aWjBv89UpUoH+URmKMw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793359839;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=vNxcAmXBfsihDGwv4z0w8JGa3hWfk3AxBc1Ev4e0snA=;
	b=1xGWUyyI//5bnr4TfgV5jwCK2x6AweLHTVJ+EzkpALvU9wwH7NKAELheLwuPe73crJ6G
	 NYVvsCWQ0YfAmhdrBBtI9neWarn3QY71eAFQ4wV32kMPst5kAyDEXDp3tTiA5AQcHCx9O
	 HGmaPXwfOMVRShyWsP4U2CiLJSD9/CFO309eid+1Yrxd0KEgyODf+pufmsXLtUoBqV6vV
	 Q7rQaAWmZY5dbyCKf6GdFrs/gmWtS2KOItw7ZjLBg2FtWjD+WeBEpaaJhsphR7ZzkJZZ6
	 as3o+4cNy72L73gSCW+gxNPh4YB8JGH8LTZRm921bU92ZKw9444r6yhQ7BOTRWMIqKg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cBxDI8Dy;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.48
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097CC606A31C
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 11:30:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 097CC606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cBxDI8Dy
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-6dde81a6820so417924eaf.2
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 04:30:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793359838; cv=none;
        d=google.com; s=arc-20260327;
        b=a0J0ocodeHUf0PEQMLnAvfarMeoV4Xc2waG9jCp8KVWGQHCtqxsXx+aqIV6WVqFqGG
         fPL8sUQtcJF0BiJK1BHyhx61ty2OQJLVXiWP3Pk288umVuGX5Sxucdw8GG4F0YQiGPAj
         fy2mRWa5rZsLD+3SmCAZuH5zETVhTqNF2/EUMQu7PceQsWC6Ze4DSovb0BZ/QMHEf4jV
         vYAhSjaESQbQx1o0Tv0BpUpxHqD5opK1Fdl5uZoT7sVpRSqrj2DDCu7UKvzUmfVNAQ+X
         a+fu1l5EFmPRjf+cwOZSjxpmoSTjwfJGxl2EuRmfFOGBa2Lux8iwjC4EIO/uGMK4ChCu
         Y5Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=vNxcAmXBfsihDGwv4z0w8JGa3hWfk3AxBc1Ev4e0snA=;
        fh=Gb8RSDLQoV+qgJjwh3JErt+C3hloosFkdHxORzYl2ZY=;
        b=B8/GtfWdAE8i1eHMaEwV3viWfHdLPTSgd5mhWqkQkhjdAQmYGbUE7ImObn73W+n7ri
         jxlTDPQKWN5pbIaFnUu8tKuvJNipo/99l1j+ferQvv1ALPsn37yddBwqRO1X5YaIH4hf
         rMb/6/eb8+c9tWtuAQQin94JHKgT0h6n1Y8IhHggqa7kztsr/HPI5Wdh+X0xQclZqmbY
         9a935+Y23EaV/wAgPrlV9ZL2Gv3s6aPvDCgNtSpW3ceyFkQfVUiF4dJSfNIAp3wIsXs7
         HGpc5PN6czUWqu0yTBK40H8952OqpsD2hUJQl4MUjvw7drC9jY1bgqCVZNIwQI4icUXR
         SJbw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793359838; x=1793964638; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vNxcAmXBfsihDGwv4z0w8JGa3hWfk3AxBc1Ev4e0snA=;
        b=cBxDI8DyLDTaYGOQcITLNK7QxpgTOCvbFOuDJ8SuRzoxik61bUkTp4NRwXAxkuxJQW
         AK4qMBJoQCrmSzlopRYSVEQSdr60m4KZAWb9k242vlsjJh0BDdfZa5V6Wl28bHb/gTNE
         z782v11yzPsfxmaM3WRGGR9aGt2gPzDgbXRGZr/ya47YRGOpKQrTsWR5jK51v5a6C70z
         QOHRtHgxyM/ZAV+wbwJep5AILWQ5moOU5SeiJDV6QFOW/YWOkF4sCosSS2aDWTqD5A+d
         TUgeXF3fkDXZhvvEJzhPJ/TmWK0Vzd/UHsxUPEiIqXkhKGINhrJoWaY7P0L4ChVZH6IH
         etsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793359838; x=1793964638;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=vNxcAmXBfsihDGwv4z0w8JGa3hWfk3AxBc1Ev4e0snA=;
        b=ySi9zeHRUm+lMiSeax/U7X0JP9gPP89Szco6HkG8I3tbUHXjG9b+umEuiqR+snU3Eq
         mbgFunFeFcfiDLMUwHPJfHne/fkTyCJpC24ncQ3TOYI5854jahPIInqqJIxyeBbT52l9
         7UOMKdLM6PBKVA9KG29olCzK6wpfiYSEyieL7uoioZ3Jwm8aC1olTARR9UlfBbO6biM4
         OTqvFoz49/+7Pk5PUEvrjlvI9u7t0w5MnBqgAOP2RVe3vt0vfyWLkerRE80naoOBb/Pn
         BaSpE47BJtNBizVm/gI66r0vuyUpK2ySb5UunLZx5/ckiuBlr2xnMufWbWY1LL5YttiU
         BBVg==
X-Gm-Message-State: AFq9FYJLrGTQxgffNTC6l4hamwJvUtoH4NYYMqKfQ1FE1IHxuYEvKK5P
	UWCHtbEqtVuvOeAF8v0sBl4cAycpy4PwcgVoMDGJjLIJkkCeYx4ozFCHMnkM1p+gQuPX9QWT2JW
	o9995xqKiXmkGro13M6YjiG1O9XNASZc=
X-Gm-Gg: AYBFou0VUNKi80Aevwpo6Wxqw7P8xvA4/Mp39gkatBoG/XuL1ZxBysNOZr4pT+j5Phy
	fkghT7lDDCfBaPQoxgIB+UR7uJBS7F8ZDOGbbaAI/wIfFYjW8Le4nP/vjiTTkjdtQ3zGnOx4HZ7
	q0vhljdyky9IvXWy27kkQ19g+sVWsAsj1Qjidza4RfrxBWKGpVD2FTUQT0jVUcIFIPidwpuH7KJ
	1jSke4xX+gO7Sh7K5M/PxIVhExvHUaOZKx8pUjJFdjGboTIq5vIty0IHagJfucufNvObW7X1efk
	uWV9ql11UEw2gyZ3g5Ridh6eBAZVTcqw/IrYJXEhiCW6A7240mLlnHGEAznNMI5xrYG/hP4njiF
	Nv3Jf44uYuDE4Z0ydpgpd4KkliJfpnUZJIC4K8mCxhLhbTWXRAD1AwW1cq6ydFIQG4yukHo4=
X-Received: by 2002:a05:6820:16a8:b0:6d8:2fe:efb4 with SMTP id
 006d021491bc7-714f1fd6863mr1213105eaf.8.1793359837825; Fri, 30 Oct 2026
 04:30:37 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261029134752.1299130-1-hjf3108@gmail.com> <20261030091020.GA27096@wp.pl>
In-Reply-To: <20261030091020.GA27096@wp.pl>
From: Jie Feng <hjf3108@gmail.com>
Date: Fri, 30 Oct 2026 19:30:01 +0800
X-Gm-Features: AclHuK_e4xA3QBSsmu56J8ci6pvvanR1WNpINzrPac5UY53-74VJNasqJtIcqV8
Message-ID: <CABOQOSUhMXLVCwO4YUrPD-zhge-EkMi5V9s3vUZJB7T9ddiyBA@mail.gmail.com>
Subject: Re: [PATCH wireless-next 0/8] wifi: rt2x00: improve the throughput of rt2800usb
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 30 Oct 2026 at 17:10, Stanislaw Gruszka <stf_xl@wp.pl> wrote:
>
> On Thu, Oct 29, 2026 at 09:47:41PM +0800, Ho Jie Feng wrote:
> > This series improves the throughput of rt2800usb.
> >
> > Implements
> > - Frequency offset calibration
> > - Better fallback rates
> > - Aggregation
> > - GRO
> >
> > Tested on WNDA4100 RT3593, 5 GHz with perf3
> >
> >   patch                          before        after
> >                                  TX    RX      TX    RX
> >   2 crystal calibration          27.7  31.6    28.5  69.7
> >   4 MCS16 to MCS8 TX status      27.0  70.0    29.4  70.0
> >   7 RX bulk aggregation          30.5  67.8    30.5  80.9
> >   8 threaded NAPI with GRO       30.5  80.9    30.5  161.7
>
> Nice work! On what host hardware did you take the measurements,
> PC laptop/desktop or some embedded board ?

I used a VM on a desktop, with the usb xHCI controller passed
through into the VM, so that kernel panics don't bring down the
entire host. The TX speed is limited by the latency of
control transfers to read the TX status, and through the
passthrough and a hub it can only read ~2000-3000statuses/s.

Desktop is a mini pc with Ryzen 7 7735HS.

I think it's not that bad though, the slowness of the VM
allows me to see the improvement more clearly than
testing it on bare-metal.

> Regards
> Stanislaw
>
> > RT3070 did not have any visible change for both TX and RX.
> >
> > Ho Jie Feng (8):
> >   wifi: rt2x00: start the link tuner when an interface is added
> >   wifi: rt2800: calibrate the crystal of RT3593 with the beacons
> >   wifi: rt2800: use the 3SS fallback table of RT3883 on RT3593
> >   wifi: rt2800: report the MCS16 to MCS8 fallback of RT3593 in TX status
> >   wifi: rt2800: don't report an A-MPDU length to minstrel_ht
> >   wifi: rt2800: set the mac80211 fast-xmit and aggregation flags
> >   wifi: rt2800usb: enable RX bulk aggregation
> >   wifi: rt2x00usb: use a threaded NAPI with GRO for RX
> >
> >  drivers/net/wireless/ralink/rt2x00/rt2800.h   |   1 +
> >  .../net/wireless/ralink/rt2x00/rt2800lib.c    | 115 +++++++++++++++++-
> >  .../net/wireless/ralink/rt2x00/rt2800lib.h    |   4 +
> >  .../net/wireless/ralink/rt2x00/rt2800usb.c    |  33 ++++-
> >  .../net/wireless/ralink/rt2x00/rt2800usb.h    |   6 +
> >  drivers/net/wireless/ralink/rt2x00/rt2x00.h   |  16 ++-
> >  .../net/wireless/ralink/rt2x00/rt2x00dev.c    | 105 ++++++++++++----
> >  .../net/wireless/ralink/rt2x00/rt2x00lib.h    |   2 +
> >  .../net/wireless/ralink/rt2x00/rt2x00link.c   |   9 ++
> >  .../net/wireless/ralink/rt2x00/rt2x00mac.c    |   6 +
> >  .../net/wireless/ralink/rt2x00/rt2x00mmio.c   |   2 +-
> >  .../net/wireless/ralink/rt2x00/rt2x00usb.c    |  52 ++++++--
> >  12 files changed, 307 insertions(+), 44 deletions(-)
> >
> >
> > base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
> > --
> > 2.53.0
> >
