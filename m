Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.172
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792777242;
	b=jnfoOOzf8l+d43ef5tDPylnh3f7NIxKKZpWCrq5PRAFz0kifQBK1FqikrLAvPVG5p5jo
	 aGEDI1SngfomIhX4C6idfOpUAVWxnAx2Fyd93rRdFRt9f/2wTn2MQ8laV7+x2R4DL3rji
	 XE9SnhyU/hie8+Zjr6+4zsOXywytxbN6OHwNNc2mltto0t26TdnwHYzNPiTQk3lDL2WZX
	 Ibl7I8lO8rks0FFF3uoflRuYKyDjdsybtuBz0b0gVdzhMZvs3yeJbC8Xg5r6Q+h1qeUp/
	 k3vH+N2lxE98r11UTr0iHolSQajeXUXVBMjXAaof4jqFkVfPUFgF55knq0do6oEa1gA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792777242;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=FLYRLZKufzwkxxql5ZnFYPULE40YlPDTbaeTn0JxKhA=;
	b=MH9PLTyIjynMFvpO3irZT4L+rliLacEEEZzCMRLYE32FTXcONzZpTOWC2Mirl2yUPQGX
	 0ejwgwJr69UJZanbU6B6r/da/k3G7pVU/8jOmK461oYukPb0h0WYxRkKvqF+wV/8E7Uvr
	 08s8KFodIBv387XJGER3VSthRvL1dAxVZ7TWOSpRrHj7MQHhgYGxFVmxOQSNxCB9BXpgF
	 KYH/ZkEkA6r5RxY5YHlXa/Ns2DXKiposAuGRB1B14jNW/MapdOmfPHNg6xs1eZZm3P9ye
	 2zcrZff+9ZmNaIWZxzoslJTySemCd2bJxW5ablM8DAXz3mU8FOo1+RVPddkr/y3QVig==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=rhRyLWF0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.172
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79A9606A322
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 17:40:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E79A9606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=rhRyLWF0
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-3ab46699a09so9921171fa.0
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 10:40:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792777240; cv=none;
        d=google.com; s=arc-20260327;
        b=jz77FMAboGAwTeli59xcXumn7pOI1eiLCkZa3neDjsaVg6eSEbwXMWL/uRpYlXX9Ok
         TQpT4R6R2PkibYibv+ijG2NpHTozG6EAGE4B5MVf/+8l2HQK5Y4p+JycZzmCovXnSBwn
         vceNulVjdRJrjuBuQsT+VYpjXT86xZ6ZfF3AjyBejDEUbwmk/8gADBVKnL43umaLF35c
         UteK2978ncGpPSm9JwXY63KE3Pz65a52dOzL6Xkurf/eBkOrYv+6lVXAtEaNXnMCG/I7
         XGzoY2cXQPW5l1s3h/ncFgscAbsOdnCsoP0q67toXGIvG1pjxI1aU5EBtcJkULYYv428
         v/7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FLYRLZKufzwkxxql5ZnFYPULE40YlPDTbaeTn0JxKhA=;
        fh=ouokPDVlXylyA8Us/83JTDZqhZn9rh3wIj6eu0TEmmo=;
        b=e496GzCaE4TfIznKVZjvdBAQHW4Vam4Zg9D16LonR/cuuw5j/Hv6/0Zk32kSl02ClI
         S/zWGUDpjq3KVHgv26Cq+Ot8kHTuIfbXAGRjV76lEOjxIRD5OsCL4x/lXo9EMTgK4cOC
         vu62h0BGAjULIhjp8K37KDipN7orm6TxbpWy4v0fsKIUZ0CHwuetixxqTZXo22k5rmpM
         VumLKVytwFYzdYdNhbJg1z5HHXctcXKTgTJQ4yGa1WhbNFNdiUuCm/Qu34Dy2aiv2cxQ
         y1ZOU37fXe1UuM9YzPNWzcuZzdfmUGe0yEiu9AYOq4xz6FcJyN7/0Bpv9muHMWpgWWNI
         562g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792777240; x=1793382040; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FLYRLZKufzwkxxql5ZnFYPULE40YlPDTbaeTn0JxKhA=;
        b=rhRyLWF0S/Gi07UjqExh9ZmVInGhJV9xALJxsMa1EY4tGdhuu7hvxN7F/dnr5+To4F
         tgHd8bbEoyM67I55U8I11pQj9BQMYZy2aihW6boY/CJD/5b3tR5Kx5Tsn0xqHvQVkRPV
         o5Sq1EAEJ0ss3C5NM8F1U/yHOGpY3p2i1rQEMdYbRI5FhqAOUJ+ZD3dm2TFwH5lIsUE+
         RSBO4zxIYEbyq9Tm0eljoX9QWvFxXOmoDFbgY8zGn9jzupqJ64zfftc0PkPhmI+iz43A
         uu0iS7FksQApNsctKyBU+uwrI2uX73x1lOEGhYH9jGGtfRBzuu5/IWt/18v5GA8KYzDy
         A3jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792777240; x=1793382040;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FLYRLZKufzwkxxql5ZnFYPULE40YlPDTbaeTn0JxKhA=;
        b=0FplSeNG2f9dKzRgsLe5fGRTDZ66SLm3KisvPV8qQ4TE1SlN2Ab8bmm/K6vNXmbdCQ
         nc3QkQnIs5NHadLrti4YlVkdJiXRnGG6ogOaWsohrL+emEUPTxmxGRJNBuPQhlDkEd4o
         4J8T/9OYSjXV7bhc6n98Uv4rGMBgLsx4DZRXwGlYD7PvxVH9CM3rLm8ZseNIy35WS2ek
         fLbkWZTqXwiuhMrqpMqlk6Xzyt8bEkKNOeIhtKrZQ+TNASVuT0uMskwi1StusoLwimnN
         6ocNlm4BcR+4+EHDxobVJ+LeqH/Pa9kTPoEb7lfZaEETGGwDD3uYS4UAlhH2Q/3mbDR7
         sHIg==
X-Forwarded-Encrypted: i=1; AKwUvBy20EgJFHGgyb/4TipYmGzIytvvPEZevin6pAZx/okdUK2my5GVG3S/DvHH4oprRnKrkYvHyYuMkz6njFPe8Q==@vger.kernel.org
X-Gm-Message-State: AFq9FYK5IvNhhwi5yEQClBr+YjuVawb4uJY8B1SXrK0UAzhEyv09i8Bj
	j4VOogDyq3Hqfa1AY1Ese/lKVCmLtN+IBN3oMTEWnpVqAwaa2RI2V33Rzwa2NfeECEocFfO9LCM
	yVDiRAGIUYlRh38e7474HB29xtAjTg1vH5hrxUpg=
X-Gm-Gg: AYBFou0c5xX6rKKOha7aD3fdxJRssFCwBZgRCvVH/TiSWH3myLcHVJ4Fa3cWZhJ7xEm
	i3o38qmc3Jnf3F/EpUZ2b7Ru5o3cP23pYGop5oB6TJJ4IXVRYjpqzwOSS6PiEow21nufJvi5AQR
	o91WY7xxOIo+N0HpRYpAAgOUon8u9tWTEljKG6NOgOIwSO0UBCAndN4KwwSYhuG0uxua9B6qihy
	KhrDyMsSbUw5zhntPx9vQkwgs+yRAgwYMQFjQyYCHGAzU2NST3Tv30Y7oyEb9zxVmet+tXGO27p
	8ca21DGiCep2r+fmzfdau6+LMYQhlrwB6CZEnp2jH0aI/xhtyuc1tnS25YjUxBHnCJgdV7BcF21
	3eGhNtx7wALTdd0f23OdhaePCH9qpJuBcrIety1OhvV7XrucmVNE4FXm9fhAAwzkODUoH8b9D
X-Received: by 2002:a05:651c:a322:b0:3ab:4814:6129 with SMTP id
 38308e7fff4ca-3ac6fd1e249mr153411fa.18.1792777239960; Fri, 23 Oct 2026
 10:40:39 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAAzpgGfrHpQZQ8iaH5fqZHzk5tTx39+jGvGkVXxhYFkp-A_bQg@mail.gmail.com>
In-Reply-To: <CAAzpgGfrHpQZQ8iaH5fqZHzk5tTx39+jGvGkVXxhYFkp-A_bQg@mail.gmail.com>
From: =?UTF-8?B?TG/Dr2MgS0FTU0VM?= <loic.kassel@gmail.com>
Date: Fri, 23 Oct 2026 19:40:27 +0200
X-Gm-Features: AclHuK_FiLbhnIm98d_qlqiFw3snCFR2PzcRfrqgURbeufGtsH9VJyRHETTgFU4
Message-ID: <CAAzpgGeAaOjPdiVOmeY7xZqEymyh4BfhESwAvTzczvqj+YuNHw@mail.gmail.com>
Subject: Re: [REGRESSION] mac80211_hwsim: CCMP frames dropped on fast-xmit
 (WARNING in ccmp_encrypt_skb, net/mac80211/wpa.c:462)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sai Pratyusha Magam <sai.magam@oss.qualcomm.com>, Rohan Dutta <quic_drohan@quicinc.com>, 
	linux-wireless@vger.kernel.org, regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

A small update on this report: commit 6832075ed4ef ("wifi:
mac80211_hwsim: reserve headroom for software encryption") is now in
mainline. It touches the same check in ccmp_encrypt_skb(), so it might
fix this problem, at least partly. I'll test with 7.4-rc1 and report
back here.

Thanks,
Lo=C3=AFc Kassel
