Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792979815;
	b=yYiAe4hB231Tr086PxG34oqmsO4E3O9vCPlULHe6o1vh5dD0nMLopJVz7eAN3YcjORdY
	 D0qHxwwtJJDpC+MbPKFcdeTfVWp9/aXrQ9UYQKS1/W8WKAf309p0Xkv7L2FcpwHTRAyyH
	 d/aW4ERRNbbtYu4vAZEIryMhlHXNM0MSRlKW+R3PuAz8QKMqXNDXAbG0pguvbRJ4Wo5aE
	 obEyqqOui78RsZ5SrS1UTq04hl5OlVMFRzNbWq+XzPqDlIvyoSkt9UNHLnIzQFR3xDTag
	 iCTx7sX19gLZy30P7hDjskHHpd6BDrHIpEJCgjiuqMwZ0vYgLbKjSz7M76rwEI6Kqig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792979815;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:In-Reply-To:References:Message-ID:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=SDc9vfJEDvOZ9KutnQcEZVkooC4ZxQzWj68/tktcKGU=;
	b=XnGGZOFQbDEXw3nMiSBZOsW7sSLU18KJp9Usz+ToD8pZaRVvgVNB+XzFhLIQM9qWttXh
	 7gailJatgUZyG5Mu/tMYSRIL8rN3ZjR14Wgt5/XGmaaXrU/Du8zSYQEAPQ/xl+4Yh1ZbF
	 Zexw4PkG3ahijCCck/jorPYoMC5wTdwAsNHAHsCC47s1AKINWNEOoNDOtZV7Xs6u1uK0o
	 Ly1xyTmU3SbuG7OpXPDs+EpVnSFeydJf+0EOu3rABw02LnXDc2iuhx8ur5DtuPV7gBik8
	 OzrO/m1ntk1QNx7i0zesobpa0Ujl25167f0fV28hmR8D9nH+IJLGEa66Q7reOBrqwZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qrclkRgf;
	arc=none smtp.remote-ip=209.85.219.47
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED63606A31B
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 01:56:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6ED63606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qrclkRgf
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-917a6dccc60so30256706d6.0
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 18:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792979813; x=1793584613; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:message-id
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SDc9vfJEDvOZ9KutnQcEZVkooC4ZxQzWj68/tktcKGU=;
        b=qrclkRgfOsMEvFkIVMdRXfEd2lcoY8o9dNOvaxoMTrQFTPc5o7DDMlGN+yQbh6Th0j
         5PUw1WZX9P0G12ow8Peh3qmIdqdZ6WHkA1B2czj4ubaEKsuW5LE7K8kZDuyHvDvIhTJ5
         Q0tRp+lDWWCZeeh10rr+WNBY25J2kRJcr2re0yxD81ZKrM4NAgBkyz8V7RVb5GFkeYoW
         x/76pPUtf77yYlbLEnrFauoJumApj7y5cOcmmb3MbXb0moNZGnGXM0Jm/kmrsjR81kvY
         n1dtaSyy3IhPS91RdYmfMahfGxRYQ7ct3qBp9nRE4VXxK20+bd6I8MJ1H2Iqg3KwPGtb
         0M0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792979813; x=1793584613;
        h=mime-version:content-transfer-encoding:content-type:message-id
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SDc9vfJEDvOZ9KutnQcEZVkooC4ZxQzWj68/tktcKGU=;
        b=sBAO8uHs8xyxI4mMRriU35y7fc+h0TAjDQ4r+JrOa9a/P3+Ud62AGoDjwPI4LrTgju
         /ICNMbp16rSIfjz/unW2Imoj2IVxUnRpUVq+J5pPfEuqomrLONWLcNay7Rht00M6IgKo
         B52fpAc3sVwte41IU4JQMfGYAmjJZYAAud1gmrp//QVsGjjkbhLe8XEaX8BLFEhy6w7r
         6669wUv68FZMDdpD+zxSv25xNamsnT8sdpms+O3A9CaR/xjIVjdvBl9pXdibCbN06olj
         joyiJotdJN7cobUASn/XhmLYR7HHi/PN4dX31/wA3Q7hZXdGlrA96et8/E1RHD9B1GX6
         ME2A==
X-Gm-Message-State: AFq9FYLov4l93QhYOsqZaYFJkudoNqH0tetK5KEO8p2oJQENnsH5Jrzs
	neyTK/wRc21hwvYwzA0wnNln402NNFo5KwiqmWRqxxIQ1v0ZHTn7Hbm7
X-Gm-Gg: AYBFou22PgCPgZAsZtptnfbU7vrCQs7fBqKVCsynA5ekr1Ky1Tx3bNeH4fVvG8eMy7D
	n+Vg93D0xMzv5X0Pil4k8wKJj9Xq/KXKCEkWxAUAiqACJ25OSXMpmzkQ1Th7W/i0s8y/Wc/w/sP
	5teHSJPH9wOVgjo5SCQZVlcTXwDqEsriUqhTAxtDo4TwyKbBoDrYdW469D1cR0aN168hwV21pc4
	CPMkcYEnBqR7CjlEA9SYS+sBmBUMjph8Jx1GKuyC7IOoI8Ebmgd/rft3PmygGR5817iYTgS+sqg
	45iEJ8rDr/w2c+bqucWzT72IYSrDSdGa7QJDcgcKbkFw8cNogpZ5u/rCP/LYtTGkRTwBXk0OFRe
	/T/7nD4qKA6MIzHiy5g8scFXlgSIyCF/AVoQJg/66mdeSazH6SbFc8PddIc0X8BUm6qDI9gDcUU
	UDx4mT91+JLhclUXwT1lLAjlHEKZXV3uCMrXzJbJEO/yvPzFZzS3FE8v+B97WzAigTRQYb3+4a8
	RIEz3qUmSdCTg61xQpfaX5Xihr9gxCufKHZZ8U3mmRTNfMyj3+tAmF/RaETAbAvCZXkaOhfHyGp
	YdOPMW6PUYSDtNfmAL/2XKmcLn5nGM7oDVq6eOjRVXZ3ViE+lMzXaw==
X-Received: by 2002:a05:6214:3217:b0:914:4c57:5103 with SMTP id 6a1803df08f44-91c48ecc76cmr89332146d6.8.1792979813343;
        Sun, 25 Oct 2026 18:56:53 -0700 (PDT)
Received: from localhost.localdomain ([217.150.74.224])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c51eb8b4dsm42413926d6.21.2026.10.25.18.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 18:56:52 -0700 (PDT)
Date: Sun, 25 Oct 2026 18:56:52 -0700 (PDT)
From: Eduard Zateev <hackerowskiy@gmail.com>
To: toke@toke.dk
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject:
 Re: [PATCH] wifi: ath9k: make sure we stop the wmi tasklet on init fail
In-Reply-To: <20261021120237.481898-1-toke@toke.dk>
References: <20261021120237.481898-1-toke@toke.dk>
Message-ID: <179297981008.47871.8854747166395230996@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi Toke,

I tested this patch with the syzbot C reproducer and KASAN on a 7.3.0 kernel =
built from upstream commit 21a7f44fd.

On the baseline kernel, the reproducer hit the reported slab-use-after-free i=
n tasklet_action_common during ath9k_htc probe failure. With this patch, the =
same failure path completed without a KASAN report. Both kernels were run in =
QEMU with the syzbot config and ath9k firmware extracted from the syzbot root=
fs.

Tested-by: Eduard Zateev <hackerowskiy@gmail.com>
