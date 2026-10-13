Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9172328635
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 00:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791853128; cv=pass; b=E7TSD05D3+poBHg0oXPW8fducjeaRIIoQk73PYWBwd87NDRKEaiQPDJR8ZXuYbfFI7exW8lAlNiRM77Pd619mXxqpcYW5JjU7jJ3wmiMfmMFV2SPYWF2qEEQ4ozBh4B3XIkG4yQ7F4VqztmbhbIRDnGWX4ZXjpaLTu5mF8JW45I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791853128; c=relaxed/simple;
	bh=k4uBOr3fUC9C9V/2LEU8KbJ93ho9bjIXmyZyw7xe/xQ=;
	h=MIME-Version:From:In-Reply-To:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nw92op9Ke8hn2lpNOuJQP9I7CYpNfat43Rm1j+EBXgnJeBlzLmRZgV7CPJd537F0mWVDNXLrhag4Xy1gARsOn6MhNmNkngArwFlpb6oDwZ3FZEnWtHAxbesFHS/Zt+3X3z+/KdY+hr50K4Bq+dh2IABT/wAi1W7kQnM4gYnbQKk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr; spf=pass smtp.mailfrom=khu.ac.kr; dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b=BMtkzgR9; arc=pass smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b="BMtkzgR9"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5ba7ed32ccdso2819071e87.0
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 17:58:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791853123; cv=none;
        d=google.com; s=arc-20260327;
        b=D8tJAe6du61MKWbs8AF+9C+XSPG7VxnSyq/ng+cHN29RpgVEbN6y8H23iAV3peNvFq
         9wa7j5SyZxzYZq6puJkge93o76KXxp2h63BIsa3s7y/zDBkN8svtawomStvJNYfGD1Bu
         lpI00vgFXsrIHg0FyVjEMPjNLas4SbGeS/A4iETL9kepFwj5BMb5qGD7nv85WBsF928A
         xAkZoxmQiVrvuhrMOvmT6xHX0KpNkZgqZ1t0GqXewRdUiWyKTdBeykQDfysrV0hSPOLD
         G6DCB8AxedNlcKuebBzqTXKv8XtkZHfvEfpxvoC/YFMY52AcU1Pdy/RfqoriXVfN6mEL
         ONNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:references:in-reply-to:from
         :mime-version:dkim-signature;
        bh=0wOhigAERgw/ecq9Zfp4x327PQ7aRIqMRodPt/se31w=;
        fh=OpHnJR1Rz6bLlpQ5IGiauuARtZ3rnK4eQzjxu0UPuq8=;
        b=nViKxzTW0Mt6keCYFOREwBxMAoLmsgLlFhEqU+5sSVXf4Wm9TjzpVKnLli/aIEVkla
         7SvSdqceoUkVsOGRS+8XLXFBznJ6flKauUSOvHsn8SJofEA5V4f/2+53g/YOAqJ5pNsi
         Dp6TBwQ5bMTjGIWjEgZbzhiTsS2IBgX6YX1Ed1VozRKF+wQ/+zFdP9I1q5JCwIGWA2te
         r1n7V9pBAxjLhK8leSddWpmaT3lkswSGfdUudjFBE8MU9Qy0Oncjb7VWwC4c1ILwisJA
         SWsYzzz0E4F20I1ZRT8OILoRMDZmThxtJwRTFyqpYBg3y819zYn8Jit/YCQ9yz3z/jGk
         8/hg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=khu.ac.kr; s=google; t=1791853123; x=1792457923; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0wOhigAERgw/ecq9Zfp4x327PQ7aRIqMRodPt/se31w=;
        b=BMtkzgR9AyZ2IkE6qpDGPnMWdFbq/no756w7o58F1IxN0ulDLrxzXRlpH+bgKG1kXn
         ZkoFrAhqXXnKT9U/iFKiN5nbvcl1MZT5XUXnt/pNuaMantJfrlaUAyISTCm8ejPyh78G
         gRa/YfGRIn6GmIwKJz7tJcSswfp+Tis5FQBcU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791853123; x=1792457923;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0wOhigAERgw/ecq9Zfp4x327PQ7aRIqMRodPt/se31w=;
        b=FigDq1tWRCIYAEDm7Mblbc2qT7+XR/WYePdfQJUw8bXa34Cum2GqEJFboePu4NlJ/H
         hZquL8q9fY1fw5bT6Gcyn8v5DUjywhIMlxrZsUWE91T50774OEhJiHQEiP4pvAjXhxO5
         WIek5NCVrXU/EnhYukbWQexLsN7J0iAq5SZmX7r15MqX8RpNOqGBU8VJCANLRUy4eUhZ
         coKcDj55J6826eeEoLkpTwd65nbWcXkKBzaURlxGoVws0yJqZsP3qqka9ryX85SGZBtd
         vLtiqJUWkjXixDXisaIdQIzGba5QjoJDRTUQc6j8jpIsJ275G3KOE9pzQFznNtZl+d8r
         jpOQ==
X-Forwarded-Encrypted: i=1; AKwUvBxBUrU3tgmaF6ufZdKgFpokE2AZjZtpRzg5jwdHorf4Ht20Fv5hBpSGiyfq85qCaYTCJz+5RBE8jdKf8k+1iA==@vger.kernel.org
X-Gm-Message-State: AFq9FYJQdCmZKCbAbwm+XaQxis8tRpIPrW24GEfDgkUwUYx67/n8fTs7
	D8GDWsX5wm8okNb5trX92FsjFb02ol3+cjAA4J+LEg7GeGsQHN+gEmIB5ttMU22hxbWED4+uTH8
	VJUUqvupWq3WlnaQ9bB75Tybf7dozl7Xjnj8qpxgHAA==
X-Gm-Gg: AYBFou2HYT9NSYHuZbR0beiGMqqTx5pEsS+bnZ6tx0lEAVoUr566k8QaDyKX7vsrw32
	nS2ASy9Tudr8cIbtxSmd8QM9qgbpAs7IKFAKkmiGJcd17Pe9ukWdqRkSH0oW5MW/pbhPhdJuQTz
	8tQh1XQLU4WNPrDKISw4CAfU3sYst56L60SVqxqUOvMXqHm+mHcyMQvU/fslTTOQu6kxzaJBCKI
	41zl+zjEfm0DcfnVdgiQ/7NmYPPoGwE1D4JhldShMJt4B9kNXKdj1gxbGqsu+L61vMO2ibxJqco
	TqQ28MW/FDyP0aOQOxnzJ8NqXJwKeSMn7mLg1MNfybxSaxKGDcFeXnhLJsoh1CzDx0TCCtdx1bt
	sK/fmA3rccoReIsxZCfSI92g1ZC3lSpPHjLs=
X-Received: by 2002:a05:6512:696:b0:5ba:3339:6f6b with SMTP id
 2adb3069b0e04-5bcde6bcb06mr3984876e87.20.1791853123500; Mon, 12 Oct 2026
 17:58:43 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Mon, 12 Oct 2026 17:58:43 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Mon, 12 Oct 2026 17:58:20 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: from 77377267392	named unknown	by gmailapi.google.com	with HTTPREST;
 Tue, 13 Oct 2026 02:58:08 +0200
From: Kim Wooseok <5mghybrid@khu.ac.kr>
In-Reply-To: <04d26f79d5984920a9584d3f31ec3b58@realtek.com>
References: <20261010-rtl8xxxu-usb-dma-v1-0-e670d9c08fdf@khu.ac.kr>
 <20261010-rtl8xxxu-usb-dma-v1-1-e670d9c08fdf@khu.ac.kr> <1fc8c339df1944afa6186197337edda3@realtek.com>
 <CAH1Bc_yOhZ9oqreJOLKb5RDFEW=0Zid=h4xu9oTR51RDwj_bww@mail.gmail.com> <04d26f79d5984920a9584d3f31ec3b58@realtek.com>
Date: Mon, 12 Oct 2026 17:58:42 -0700
X-Gm-Features: AclHuK_Ifxw9QoHyehe9vofNrat2BMmKWVVJ1nmld41C-se66_6KTgRsHhz1IK0
Message-ID: <CAH1Bc_wUq2Nmhvd9q85JP+KyCYHB_xqStfmo6ZirOxOkXzAg9A@mail.gmail.com>
Subject: Re: [PATCH rtw-next] wifi: rtl8xxxu: isolate the USB register buffer
 from CPU state
To: Ping-Ke Shih <pkshih@realtek.com>, linux-wireless@vger.kernel.org
Cc: Jes Sorensen <Jes.Sorensen@gmail.com>, Kalle Valo <kvalo@kernel.org>, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Ping-Ke,

> Does it mean that data in a cache line can't be modified while a USB
> transfer? Even the data isn't a part of transferring data.
> How can it affect the transfer?

Yes, in this non-coherent DMA case, even modifying bytes outside the
transfer buffer can cause corruption if they share its cache line.

On the affected Pi, the 4-byte usb_buf shares a 64-byte cache line with
the mutex's waiter state.

The important detail is that a task waiting for the mutex still updates
its wait list before acquiring the lock. So the mutex serializes access
to usb_buf, but its own waiter state can change during the transfer.

For example, suppose the buffer initially contains 10:

1. Task A holds usb_buf_mutex and starts a USB register read.
2. Task B tries to acquire the same mutex and joins its wait list.
   This can bring the shared cache line into the CPU cache, including
   the old buffer value 10. Updating the list makes that line dirty.
3. The USB controller writes the new value 20 to RAM via DMA. Since
   this DMA is not cache-coherent, the cached copy still contains 10.
4. If the dirty cache line is then written back, the old buffer value
   10 can be written back along with the updated wait list, overwriting
   the value 20 from DMA.

Task B never directly touched usb_buf, but the writeback operates on
the shared cache line. A subsequent register read-modify-write can
then propagate that incorrect value into the hardware configuration.

I think one possible overlap during a rescan is between the
channel-change path in rtl8xxxu_config() and the periodic
rtl8xxxu_watchdog_callback(). The watchdog runs every two seconds
and may update frequency correction settings through
rtl8xxxu_track_cfo(). Both paths use the same register buffer and
usb_buf_mutex, so the watchdog could join the wait list while the
channel-change path is waiting for a USB read to finish.

Allocating usb_buf separately removes that sharing. The mutex still
serializes register accesses, while updates to its wait list no longer
affect the cache line containing the DMA buffer.

Wooseok
