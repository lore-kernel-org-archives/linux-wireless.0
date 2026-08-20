Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5110437472
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 11:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787225857; cv=pass; b=fltwLVEfgy9VvMtaklqGBSsfVnvxYRCD8iS2m04cxX4Mz8fIuOCw3S0N/0OFL7uJFg1EWiQGFezgIJyUZxeeGnNP837D2KfTeb0J26HZULUJ/lfKzDCQKokvb3kOCWxeiYem6Ek3xiZxh+XU/VLH9IfgatrKhi1bbEQzmSLa05c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787225857; c=relaxed/simple;
	bh=JpGKG8kAsf0ZoXPxIF4odTxusQDq7pH8qnGavadx7QI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tdv2o+DyFs3U/fznJ+UhOb95CFiy7WV1GAXS/Th5SeefP9iSUakAEDn62ARQ/7RVDXQcRuFMlyxApfHho7WwLj/h4/eQtw+UVtcyQujf/vVRFgvS2BHrJTaUzqaWI5C9OMxSgOpVtcrYHgfcnsr6dhXLsyfle7IuCsZ1Wdx08yw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=In1w2W8o; arc=pass smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="In1w2W8o"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-90898faf46dso11563576d6.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 04:37:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787225854; cv=none;
        d=google.com; s=arc-20260327;
        b=nxnFuqFPETD50ZVMW0/YUgKCqoIgM6nb+2bqnMygiLxgEVfVzKwdnpCAG6/drbQoK4
         IXRJ9yTSfnKPPJ6vi0Vplv13y9WJ/KgMsvS70UrydC5kEKOXVdxmTJfiENKzxiQUCZfy
         FImcWifMZjv2CTVckkbvdtMMlZZRdczXRw5oYD3WQ/nz3BLFNzSDjr516+0p7ssB94pa
         c3uxx3Te1nMndngC1GKKtAHvmtCULrakRlTWa13GwpUlIOGTP6RMSMkU+6FcXZoYyVJG
         Lz8adaxxpICCYwqU0rGsWO7z9K2tVje+9LPgjfFHft3QR0FVzHG/UtN/wXBrLcOxBLgl
         EEjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ixT0yjbO+0WwHHu7pE4LxTALBSNRTR/UqUshfMw2UX4=;
        fh=ad+rrHxu8+ebDG1NogQnFFOwTYoSQWwRF2PM/jNbvnM=;
        b=cRp9C1lQ8rXGOI7zlJZGKnXuOup3B56a7BsXtOg+LaPT/K3TEW87KMTr6G0VkFCIsO
         P23xH4IuhHmbR57mVrBvge8gFt9Ok2W8pkP+PTJa03rT1JyWEUzqBbM6IduxofnsJIHR
         se5tmPW7eM/N39UxDT6EKBKdDcJ4GLP95qNzLVa+0whtqTgIfsiAnthp4BpFVRLeOgXE
         i0S7cyknBLQXk2fg+GsEhOpE2n0plPBG9kUzlG8B1FURJ+rArFvpqwYeFNpPK3S6n901
         BRUHCtG3BM/BYtkGSbsLBq+MkyHlTQpXSO+2RzWdf4a2IZGTewxkXsaCvJ86ENyM2AZK
         2Phw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787225854; x=1787830654; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ixT0yjbO+0WwHHu7pE4LxTALBSNRTR/UqUshfMw2UX4=;
        b=In1w2W8op0DwNfQ9+hY9oxgPZtliGHiV8if5AA7THGKc+JjtDzA4JG0+UvN0e0aAPM
         4WHzt5ENWvOgLge+z91/H4B5l+MMXDs/M7fvoRLa9EXOzBhHinbADmdFGRKa4Eoh1IFd
         qpq2D95fvvvq89iKZU/AhT7q79rnm3zbv577Jbc3Q0YHn0VpmzpUbiFMDV4/1ap7La14
         NxfMj6j/WUZoN3qXVHs/X9iWlYBQOH9eWf5uP32fW3oDHRQVyhDGV7oj2g8cZZzQ9ZWB
         FG4z3/vqydUyE0EPSQ20OmfJsijcoIyt/2zqlxrNkZqjdo4TTtWvkV6CsQk3zOLKafLx
         A3Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787225854; x=1787830654;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ixT0yjbO+0WwHHu7pE4LxTALBSNRTR/UqUshfMw2UX4=;
        b=dD2r4SBUPdWCDFA0HPJJxjRfPpfgY+k3QtXDB1LLDO6o6tpf14jmlqtJd2QjztPjZ0
         iCQQXOT5THW/VohKMYZnvtQekW4UagXYvkHfxwHHPCAvqvhl2ccbW8gAQvGSvwOjovak
         1XnPaWdPXPmDh+gXfHkSZH6CGv75RtuwNqqmvCG+EcuEWpB8WZW5VSjzPsGCj6TA9WXz
         m8GFfJEZL7Ix7bBGBaHMKkrPGhKM6cgDUS/OAhlJDmWbLhGEeNgAJLEtCLl73daHXr2a
         OgWWjpYx8ZXDHB/h8dmDmNqXFwX3cYo50OM+RfBMMpZaq3p062O+tex3pDwLYz1ZRM2L
         ZjRg==
X-Forwarded-Encrypted: i=1; AHgh+RoygemD38tHVlUepo43zO3aw/K1Yuoh9lKcu3yKnoKaiXfWpXyeBiFCvMR7F2QSGDXbeQiYxRnmEbGSGocyTQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyeZ784mWTiZxEX9Q8HbY20WU+wFoiXbphTSpunJ/RWoUkpa4+p
	VKQudVuPpK3jEc3Y4aLBdoHMnEX0uxH9vrevqdDfKT3bPrgkkdK3HN9mqoJEXnQXXZFD+PeU1GB
	XA8q2EqmHprRoatWqeZY5vDq1+AngG34=
X-Gm-Gg: AR+sD11yon9z/Pf8XIQH5nZpDWcEeWYZLOQKjpYgsipDUuTCdqLkMzaNDWqWvxYuM8/
	zBgdItAPUVgqtdpi6FKN6PIvLOLkUYMsqhGrspADKOx/ctvg3KuOaIapEEj7hrp2gUpszJyqmQt
	W/xUhC1rbHt+Hgz99OU9fQIH0SIDXhWuVbi6oMFJHbQS3jfLNALP2zoiVTf5aR3ENNSe94t/mj1
	7FAXBBNW3EgOCskwk/IWZwDe2PUWzQi3i3qyLM2tiIP5Mf+dsekOBFi0HvHYVzOIbUSWxRgXcIT
	FeSe1ULN/S15jWXbbdTD9K4WVyzCo53Z9RnRKAjQftksvGGmmrA408o+QEdvkpqwAjN09U3cFTE
	8DgfHF/GG/mrPVbqVLa4pAFgIqkoYyMOFb44t7h8ME7Zj5miMB9vcf9g1lnRoR+Dg2T4dNu68p+
	smBg6IBFXgkYUEJ/XhdbaMUBdvdrZPovJ4vBsG9PE=
X-Received: by 2002:a05:622a:261b:b0:528:3d62:16c8 with SMTP id
 d75a77b69052e-52dd5ca8ee0mr115464781cf.31.1787225854456; Thu, 20 Aug 2026
 04:37:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260814105327.6687-1-luka.gejak@linux.dev> <6C350314-0529-445E-9324-FD5C21C5B495@linux.dev>
In-Reply-To: <6C350314-0529-445E-9324-FD5C21C5B495@linux.dev>
From: Peter Robinson <pbrobinson@gmail.com>
Date: Thu, 20 Aug 2026 12:37:22 +0100
X-Gm-Features: AcwNN1W2pDAuqNXfr1cGUgQUcf8LtfOiyR3M3Pw9QbM2tqVPxJgHD_tyOpBG8ys
Message-ID: <CALeDE9NmBpsBdVHYuzahgrxKtvzxs-ML1netc7OMOEMQ8j5+vg@mail.gmail.com>
Subject: Re: [PATCH v5 0/6] wifi: rtw88: preparations for RTL8723B/RTL8723BS
To: Luka Gejak <luka.gejak@linux.dev>
Cc: Ping-Ke Shih <pkshih@realtek.com>, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Michael Straube <straube.linux@gmail.com>, 
	Bitterblue Smith <rtl8821cerfe2@gmail.com>, Hans de Goede <johannes.goede@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"

Hi Luka,

On Thu, 20 Aug 2026 at 10:02, Luka Gejak <luka.gejak@linux.dev> wrote:
>
> On August 14, 2026 12:53:20 PM GMT+02:00, luka.gejak@linux.dev wrote:
> >From: Luka Gejak <luka.gejak@linux.dev>
> >
> >This is the first of two series adding support for the Realtek RTL8723B
> >802.11n chipset and its RTL8723BS SDIO variant to rtw88. It contains
> >only the changes to the shared rtw88 core that the chip driver depends
> >on. The chip itself, the build glue and the MAINTAINERS entry are a
> >second series.
> >
>
> ...
>
> Hi Ping-Ke,
>
> Please do not apply patches 4 and 6 of v6. I found real bugs in both
> after posting and a v7 is on the way.
>
> Patch 6 touches the skb after handing it to the TX worker:
>
>         skb_queue_tail(&rtwsdio->tx_queue[queue], skb);
>
>         rtw_sdio_8723bs_stop_tx_queue(rtwdev, queue,
>                                       skb_get_queue_mapping(skb));
>
> The worker can dequeue, transmit and free that skb before the second
> statement runs, so reading it there is a use after free. v7 reads the
> queue index into a local before the enqueue.
>
> Patch 4 concerns you more than me. It passed the padded size to
> rtw_sdio_get_tx_addr(), where upstream passes skb->len. That value is
> encoded into the CMD53 address as the transfer length, so on every other
> SDIO chip the encoded length changed whenever sdio_align_size() padded.
> For the RTL8723BS both expressions are the same value, so the change
> bought this chip nothing and only affected the other parts. The padding
> itself also ran on the generic path, giving those chips an allocation
> and an -ENOMEM path they did not have. v7 restores skb->len and gates
> the padding on the chip.
>
> The other v7 changes, all in patches 4 and 6:
>
>   - the free page check, the output queue wait and the accounting are
>     serialised. The TX worker and the H2C path both reach
>     rtw_sdio_write_port(), and two writers could each pass the checks
>     and claim the same pages and output queue entry, after which the
>     chip discards one transfer silently. The vendor driver has one
>     transmit thread and never needed this.
>   - the padding called skb_put_zero() after checking only tailroom, so a
>     cloned skb had its shared buffer written. It uses __skb_pad() now.
>   - the back-pressure stop could race the drain: the worker could empty
>     the queue while the stop was still in progress, see the flag clear,
>     and never wake it, leaving an access category stopped with nothing
>     left to wake it.
>
> Patches 1, 2, 3 and 5 are unchanged and keep your acks; patch 5 shifts
> only by hunk offsets because patch 4 grew above it. I dropped your ack
> from patch 4, since the rework is too substantive to carry it.
>
> Most of these came from Sashiko's automated review of v6. I checked each
> against the code before acting on it, and one of its eight findings did
> not hold up.
>
> v7 follows shortly. It is hardware tested: 60 idle pings at 0% loss with
> power save on, bidirectional load with no stall, 19.6 Mbit/s up and 36.8
> down, UDP at 0% loss, three scans, three reconnects and a clean log.

I had done some basic testing with v5, and had left a v6 to build
overnight. I'll grab this shortly and do a build with v7 and do some
testing.It was generally looking stable on the Pine64+ board I was
using for testing.

I think I may also have a device(s) with a 8723cs and/or a 8723ds I
can possibly test with, I'll see if I can remember/find it over the
weekend and get it running for some testing of that too.

Peter
