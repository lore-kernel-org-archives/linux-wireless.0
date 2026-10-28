Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.231.128
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793166336;
	b=mE7q2D4dNxJTUh+4vw1ij6TNI3qsMRJg8TNr6Gp58j6A2G/n59u8R4WLALbRCyNMnYoI
	 +VjYCtC+/iQVIme6CV33UkuwG97Mub2uZz7RP1vTQMH5Fmo7WNjPiyIBdKIJWKJlYLhdG
	 LRxkR6t9k4jGExlVmAidEvhU0t+DHNgqA4bRVRksvc+dpQU9+pRsA+ElbD1R4W6xVxhf3
	 UW8dDXlQc17XvvE9mT5FVx2Ehu0kmbIJkRgLVF+Dq3OwdKC0X5OChRrnBsdstBocV6hM+
	 uM/5t76T5f1yoRpOIRE4zHSlaD/yEC+6cI69vib8dcEOWju8VFucb4UI186h0NQaA/g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793166336;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=PFsS6+I6tSnMVxI7cw6XHZ1p9l0CCeVWrHrbBHijNRU=;
	b=slY4oQh7nR4fjyx+t2y9Mzbla4EvNwPggTvt9yZ4qr7eEHU7BPxUmnM+WEBKuJzX2Bh0
	 b4uTHnQd1ecOjXfHbspS128FpgxDo+Y7f/Vr75H/7Io8h/V6OyrZHzb3qzEFjI+YXm82N
	 1w47BF8O7/wcqx/uKFtmXcnOoUn0e+0ivdHqpoSrPK7QkxW5uXl7yZoOPEPvEZdnQWXlo
	 823/zm9YXPyZMluc6cx6PwyVxLPa3rggLdIn/jBd0y9Itn3fSqsgCwQHCaGm80PrXzFaU
	 KeO+nbVnb6a2tI7i3jV87IEXirARAAMzV+VjV10nTrjgY01+sg9nYGe1Wm8/r/2rgNA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LRw0BAXQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.231.128
Received: from mail-oo2-f0.google.com (mail-oo2-f0.google.com [74.125.231.128])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89849606A31A
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 05:45:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89849606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LRw0BAXQ
Received: by mail-oo2-f0.google.com with SMTP id 46e09a7af769-84e8a9fae57so249673a34.0
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 22:45:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793166335; cv=none;
        d=google.com; s=arc-20260327;
        b=MEcHTdWysTxBGaEOKVEygeoUAX/i139IlJRqteK45vcHPHC0L3QInYnPlbSFF3E0lc
         6RqqUdY3v5/I2wQ+DxeFB04VVB57C49vSq9pCD7uC1c6uIv3drQM0MAZR7D0JRr1l0lt
         z504Y377JC8oX3OSTFBDJ59UUKH0ePWuJxrJQs2I82YsHdeF9lbA8VDsdOq3F23I6Ml5
         9fAldnCi9Wn8GKox8RrWgDfc9ZIgVsXAU88gHANXETguFjCPmp6JeatGsioix3wjEa0b
         NEZOB/LeWeWmjkilUnQtNoTfy18w987/+TXzRbk3DqZys6T5xhLOswaC64CDlJms+Yjx
         7m4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=PFsS6+I6tSnMVxI7cw6XHZ1p9l0CCeVWrHrbBHijNRU=;
        fh=vJb8nDeUwEbTtD6uaaDU1BBsx80XXowI512MHIxZlDk=;
        b=L08FsF5TNle70kaeR0qr+eps7JH3WBdwsZ78nMulg31Rzd/k9cBoF5l2xGdtV0NJ9i
         /ZctxegqrgJyLP6VF+h/JWc0ZADPWbhX4ZvxDIz5II1K4764HzDgMbgDhxI0rU4C50Pi
         To3m7e9DW+RrIaei5ZGshTAZyB4N1gd5R0LAbpRHEcFiZy2KRnA0C4Qwza82IFBLnnlR
         /1COcvr5pBXU+BWgMjOh0pnA4kGOO8eNgbJC/F2z4US4bzl5pQF/1Ehynjq+mL/amLEb
         Uvt1nF+lisTgdg0WFgD0rtwgBM9k6YMs/Te62ywg6W/C9zc8RmwLrmceCEvGQjBDAo+E
         Yr5A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793166335; x=1793771135; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PFsS6+I6tSnMVxI7cw6XHZ1p9l0CCeVWrHrbBHijNRU=;
        b=LRw0BAXQl58a/IHHmGsMU3etxXpb/3ZUQJHH31Ssgt0OdIf1KhsaceSFALVL91PEZM
         ltlrxsZZeMoT9MKENRwGP7iPVTEIHhfrjh4VSdvUxhvtsc/Dae9j7JuiXljdT/DYU0Jc
         ebKSVs9VVBiDal89zqam54wlRVbIAvW1ugqo3WLxdhVqxoNKEGnPi/jWW33e5qeDHkaZ
         Vwt/Z3Epjs29Gj5aOvjPp6KUDi807JyNTHzpJMDuL8G/rOkSc6JhR1IGaVmcs8EzOUua
         un5Y6QNJDdA22GlQeJcXv4I1GnqS/rfKrfl1Sq9ngBtNXvOj9HXBXneFUM5W1XxIrfeL
         eWMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793166335; x=1793771135;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=PFsS6+I6tSnMVxI7cw6XHZ1p9l0CCeVWrHrbBHijNRU=;
        b=BlNgEwxjFQ17yAnhxpMuVtGOxYGhjqaeenpSiILYIEoOtEVGaPAneYgYO+JuYcFgbz
         e2Yr4wK3rUeegVZzL+MQt1vrLdknkZKJzihVXZ7gCeoYoNQqxjfcp05TwqzO0lbA1d0i
         A0mv/eCO8rX8HP0fZcIEas8A0d2JXcwn2z//YeC1xUcpLCdgN1U3R+f+1rmi+pqTSgy9
         GeJX4j+ZbmwZ/D+rD9N7kDVz68DoM8I0r7Db8AEZmq0iuQd1ItHLyljsOClEP2M7tPk6
         zTk7VQWZMd06kCxn/mhhhcsyJizbx1q0AfdTcDFDvk4f+j769/sENqYFG4BuboLkPm7k
         C0xg==
X-Forwarded-Encrypted: i=1; AKwUvBweE4r9uXDKzW4w8adxxQvEmechH5lAj7w3kDDkU7Lnl8r6Qmpsq8saG6FUUJ3vM2i5x2Qayd4diZSZcNpN4Q==@vger.kernel.org
X-Gm-Message-State: AFq9FYLMO8+xPIBAncepYl4sGrj+Zh6Equ7swFc3O4eB7RfsgMciudAh
	Ss1Sjh9AdjxpYXCjfVXZNy7R8ybQX+mXzvVE62qE358gN03YWoELIzpLkLgyQNPywwUrv1ItN3x
	AMwZcIb4vI5ZoBZctUX/ktpLDgL2gucA=
X-Gm-Gg: AYBFou3IDNzFL6AGcxWOAGvOMClvH92AptOs6/D/BRObP/1MeoYKa6WhAIdwJpAEkvs
	dp+nMI8l3Zt/dD8Ev7dnT8FY4c8Pda9Lvt2LPcbxbFouj9Z2vXEt1ZvGztP06L9gmvAXcCCASVX
	cJ1/W9Dy0wKVDsv+Blw+m4XepJyw/JDOI2UfpuEttzWRRuglm+4IPB3Tmbs5JUuwgg0xYexq6CF
	U43/84iZEXKzqLocHD8ifgqlcHjEPZ8HPzqJsGhsuG+QNomsWaRdZPPYo5yHhhO9w5pHfFAQqdB
	0eLOTZpl6CwtaBTeAyX9t0929rNgP3LeTJZYq1pYVR0eGir+qr1DYB8nTTvFGpbSbFrPx6VqlvD
	Ne3f88TVlxK5q4i9Jw2fLeOAokW32O4JwUq+ZTmdlVPa5n5nGsulrxfVcb4rsi2uIUiFP1OI=
X-Received: by 2002:a05:6870:6784:b0:475:e2e9:4f54 with SMTP id
 586e51a60fabf-4a8bb623838mr1143705fac.34.1793166335471; Tue, 27 Oct 2026
 22:45:35 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261019165103.5990-1-dennylin0707@gmail.com> <9bde49a2e7794e4fb6bc3ae104eef87e@realtek.com>
 <334c6e785a5d242c6f168d57d042d63b777a242a@linux.dev> <4f48c50cab1145fd9dbd6df6d424c877@realtek.com>
 <CAGEkeHevidTtTNj-qfy6kE_O0wRvqT=F=sG+Hy83BOkRjCUqeA@mail.gmail.com>
 <CANQ=N_C3+gpQ3O=SXYpRCGTh_MC1y4TEfnxF90SWgUVF_wYPUA@mail.gmail.com> <CAGEkeHdT1-WwJnF1wTkrrRQRzrEYESOoDeAYE+fiV0gROG+6sw@mail.gmail.com>
In-Reply-To: <CAGEkeHdT1-WwJnF1wTkrrRQRzrEYESOoDeAYE+fiV0gROG+6sw@mail.gmail.com>
From: Hungyu Lin <dennylin0707@gmail.com>
Date: Tue, 27 Oct 2026 22:45:22 -0700
X-Gm-Features: AclHuK_56Etvh4NDXHmZo6v_Uy5gCnaEAwyYEkyYaUlQKWDKsf27nBbYFYKNEFs
Message-ID: <CAGEkeHf0CLjxhGySt2axf8gXMrCcn=cEHbe1aXRW4FgcbxjyZQ@mail.gmail.com>
Subject: Re: [PATCH] wifi: rtw88: allow key removal when the CAM table is full
To: Shagor Khan <reza1234khan1234@gmail.com>
Cc: Ping-Ke Shih <pkshih@realtek.com>, Luka Gejak <luka.gejak@linux.dev>, 
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Shagor,

> I can help in testing if you want. Since i do have rtw88 hardware
> available with me.

Have you had a chance to test this patch?

Thanks,
Hungyu
