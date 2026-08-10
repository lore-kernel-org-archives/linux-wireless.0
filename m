Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5053B14AF
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 09:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786355453; cv=pass; b=ZIqZM9NFU9cyX8KHqXzRMaGvVSG9YYGiXgU5bt/5Xqf48kv7JYf/zJCpIfefiVvHmMBUVTyRPw3NvCBcIUY+K7ehI7TMiPPioc81xBdLwaHRth1pyJ3mKa1QBos8R47vcGES0pSzA+767I8AYaCUSd5UQp8IvO9hecWuaXX6DQw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786355453; c=relaxed/simple;
	bh=CuSQuhAi+mqWr7Aa6Bae3WKZXhvJ/H1Z3Ts1+D9P5z8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IMiifZ/Jt3o4X1PZBgujkjxjcKC7QMX3wL5F+9ZHzJ8P5ewyBiufkbw/oAIqv8xvpSq6ToPmMA9p2kfSwVDDntDvgrSzLEWcKYPMFnjjX8+7E6A3uYyVFH12Vr63h1eYfK6hLSjfgNkz3OgDtLJPSnygvpl2bR9fGRZt0cAOUGk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=PdvUmtXq; arc=pass smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="PdvUmtXq"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2caced6038eso16575875ad.0
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 02:50:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786355451; cv=none;
        d=google.com; s=arc-20260327;
        b=qLMEcQ4hBRDtn4aKaZ+mv8AgAs9+IoHvenuEAKYXrx3UU1sQ+eS1L852nM3a4ETQ/9
         7lWux0utrPHkjAecFhUmNK8LHqEHdv3Z5UrFPyfc8LFyl1etiGdrVEJ1Y4VOKvuMN7I4
         MnFMwclZFx5/GzyQtTXTt5OZFMUfJvUuuJ07/qMQOi5Qfl/5BLSDc6Z0Ow2yXiAkIdfs
         5iGAwrtxu/ZYFDH6TyLOvAsF3CeFO1qXJYYCFT0uL+VtrQTOQN0cCKPhtPJGFJGmkUY0
         Nmdh2RsxUrcb0HPXXzJdRQJGQEbOssoXsAIADj3D9YShsGqtpmewSiN9ZahQqmYjllc8
         kubQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=CuSQuhAi+mqWr7Aa6Bae3WKZXhvJ/H1Z3Ts1+D9P5z8=;
        fh=zFCB9yj6tbPtiNOgT9n/qK9LnQKfgtX1AWhCxXtoerY=;
        b=KkraD8ysDjd2uJz6qA0kddtHCq1iyZFG8btBWkZe9mWP25UYs7ELyFNxNY56MXTPQ2
         1CXjOuj0CgjUGSO7q64GDMTp4NyXv8QDDjL0pZ0lHbK6+7E5iqRt4W35LMdxSUovzl/O
         qWuLeGrE1rCBNuC5ZzljSn/G1GuHDLJv7oqMk2M//RbmjTnPkl1L7U+7/8Z1M5MpVGKB
         7V7ozv9vVJI2i5aw+ZKx8dK5IH2jM4vxUg+La9KhOkxjmhjqJEG8ucMrBchNCX18cIOQ
         5YMAB3hZ08bXJfcN5TQ9H2g7Idhte9MIFCc05kPRbLgelC3cccuwEu6XydPYdi5WkLyj
         llpw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1786355451; x=1786960251; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CuSQuhAi+mqWr7Aa6Bae3WKZXhvJ/H1Z3Ts1+D9P5z8=;
        b=PdvUmtXqRIEXtq6/HEG7iTZtizZdXO5ltsd9K1JO/jhHte/HJyjboI1FfuIoGye0U7
         S1e2phfoa3xNmcBo3FUBNagGdjQL9Y0ZgdWdRRMo02va5lNZMle1sRiUsxvqf9qH4cyU
         Frl1/b1Aw/u5A+NZ8yFzMy+8jpsphQk6/TELSaRe9dYV+j3kMkG5WLs+cpG7CT7Bm0NU
         Umy7NKHKM7z/ncPY+9LHjy/WaVIJcfQxFt1XD5vxhXLJrFo520oIlkmNEeoBhw0ElRTY
         Hd+WVFrsA2fzOHV8sk5+cguzr5N7CqUiDG3C9x8R5NN1Ue2wwnq5FWNo0AYC3ffWmfng
         7VXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786355451; x=1786960251;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=CuSQuhAi+mqWr7Aa6Bae3WKZXhvJ/H1Z3Ts1+D9P5z8=;
        b=SPXU+mMgvgqVuY+7GbNxGEEPtXcVZOvAcMoxy3fSqInSitHI8zIqZWEVDu1NKfiGZ4
         thubPGck8FNK7+SjwVhTZXolcnzMnis3WhqYOH+vOj/HmqwKAD3AQLd4rR7gjXoRTM3u
         JfWI09NeLghBPjSmV/cfkTZFrdcHBMASQ04pxZgX/Ar6jMRuwlaBPVi4EIa+zTvqmY1C
         wcZ5au6Ti6gCIgwYuJPT5tXjopliSOJpOxw8KhJQyWxr6pwG7mWscLGsRT7DMnHotNk4
         d23KatBjjttLR7C4CKZtN9kN3MeaWZF/7XO4BM2r+wgf64gldQQoxAgo1sRBYzyOaLz/
         EBHQ==
X-Gm-Message-State: AOJu0YxE+Yk9M1zuI7VcT2bjqfaVuDmOrTZ6QRz8Rd96VW/vxsqVqiLf
	F96LWPmMzd4tKqpeNqnLSmJDV05WRbtvXoZXMq9Qpt56vEC7V0jwv4i0+M/eEZdMnufSjA15FMn
	rJKrqVaLW5OoRrdKV+VVCcPP76cG4d9b4MtyA
X-Gm-Gg: AR+sD121xlW/gz2u6G+NKmKZYKN+Oh7WIseagdy0PFY4FVxYTD4nIXTbvhj1WPoezvX
	qlJN5P1zD5L5slvZty/Zq7BI7gh4Rh6X1V1XKFknt8FVYp9x4oLQu1l1pZhCnPt3hEaJZD+Uf4l
	v5C4FgB3HWlYlFFOkqS0/kM2PdS4zpMcDj0wDhWeTMBAj1MUAmR1AwfJnMBqa42frm+cavTawsz
	bk+ovrumT5lzhojHeKVISC1nENTnQwsHZFYNKX2itCKUN4gWONBbroj7NW9uLdb9uOv3Zq7WlAO
	Zue16KWpC7o0FBxuyXR0UrectCxkctDE2CIJVXUYumsXs6IuloaIYPSaY5UiZa+ueazCy4NHvDR
	GR00S4CUZQSH6qnwTw/X9xL0lKO9HAeLn
X-Received: by 2002:a17:903:1c8:b0:2cf:7ea3:7cf1 with SMTP id
 d9443c01a7336-2d2b2db7e96mr175168425ad.5.1786355450923; Mon, 10 Aug 2026
 02:50:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOQMLZVB3_wedJ89yNoCKTXOsuXWNq+T785bVQBSr3Yh-TPqeA@mail.gmail.com>
 <ea2f5ee46c064fb9b3a45e9d705e2f59@realtek.com> <1f8a2a023b064bca87a8f1e6712bca3d@realtek.com>
 <CAOQMLZWhvwxTk9PNa0E=73pBOoah8X-2C+xN5-VY_gCSVtBkVg@mail.gmail.com>
 <CAOQMLZWpPDbm5yiBg89GjzXnCwuQn+t5V=AP617MoH6q8Zu2zw@mail.gmail.com>
 <fe2f2e2a52ed4565b5c2927d872d82cc@realtek.com> <CAOQMLZU31dc6ZvNi_veM6uU1fSXYNBdnWLkOwH5xXR45uOFx1w@mail.gmail.com>
 <CAOQMLZWPMq=CCFpdg5wwsJ_QnrUKx_0YouTxdaSePO_0YPqcLA@mail.gmail.com>
 <CAOQMLZUn30NJwU4pR0hL=nz38Mbp=73wgqd+CoQE2qSO3cf4_w@mail.gmail.com>
 <013f7d3cf223417c94df41a2a45fa540@realtek.com> <CAOQMLZXiOBsjn=UEO6UryngzkfCzKdo+Xa1RmE_vTtZoFKN0Ew@mail.gmail.com>
 <CAOQMLZVMALBLeCZUB3Jdvk75znt0D7HxrXyPMhGPvcKLx3j-Yg@mail.gmail.com> <0912165f66394229b4f2b4114ae28a50@realtek.com>
In-Reply-To: <0912165f66394229b4f2b4114ae28a50@realtek.com>
From: Adrodoc <adrodoc55@googlemail.com>
Date: Mon, 10 Aug 2026 11:50:39 +0200
X-Gm-Features: AUfX_myGatWDRYLCMVCj8Pi0R-1_BG8zlo2mj5DRninazg05b4LEKJCTS7wvsFs
Message-ID: <CAOQMLZUbZhNhOQyxGXW7YSOU-z6w-4jWqfqVkaeMhdx2kLDrmg@mail.gmail.com>
Subject: Re: Error in rtw89 using Kernel 7.1.4
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

> SER L1 ("SER catches error: 0x1000") means firmware detect and fix an error already, and notify driver it does (driver no need to do anything). Therefore, I'd suggest to ignore this message if it doesn't bother your daily use.

Ok, that's good to know.

> By the way, the first log you shared shows that disconnection happened after SER L1 about 50 seconds. SER L1 seems not a related event.

I am pretty sure SER L1 (or maybe "firmware failed to ack for leaving
ps mode") is a relevant event, because the connection was not
functioning properly during these 50 seconds.

> More, the disconnection might depend on AP you are connecting, so keep the experiments in the same environments if possible.

I only have one access point and all experiments so far were on the
same computer using the same router.

> Yes, it is worth to try by setting
> iw dev wlan0 set power_save off

1. I'll try disabling power save on the newest kernel now.
2. If that doesn't help I'll try disabling ASPM-related features.
3. If that also doesn't work I'll go back to bisecting the kernel and
will ignore SER L1 from now on.

> The second way is to debug on the latest kernel and apply debug patch to dump more detail needed by internal experts. But it seems like this is still uncertain because of hardware flaw they mentioned.

Is that still an option? I think it might yield results faster. Since
I have to keep a kernel running for about a day to make sure it
doesn't have the disconnect issue, bisecting will take quite some
time.
