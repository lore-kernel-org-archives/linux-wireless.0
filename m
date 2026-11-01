Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793550538;
	b=xjWnql4LtQE22x7eRfenrWYPCNgRyGGSJRfnGi6DNfGuao1C+6I7/CKt++XagxX3jT1k
	 7fjme/hGac+4sdj3gu10OTpi9bBWxlzA95eA3JbCMrWYkrJWfQIHKgU6BXU49bG2FUx4O
	 ii9TTlzila0GCWm76TgXgstlOa1vSz1Y4BBHVH30Xk0Bs5hBSNmK+MH4i2ULVVORoCiny
	 XDeNr88GIJ+Qmd5ymuVX2+gBAMksh35XtdtBeyQ3iv+dKVEUodrkaOhOTl0sw7M9Dnhb9
	 ZzCT8fSl88a+Asvz/VdoAkS4OvDAZv9VdM1DvCIv+ltwr/f7GLRZ2on0mmbthfvxwzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793550538;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=2JLpxCeKgZysAKba9RBz4wH5E04iZ2pCGsqB3gTXKkE=;
	b=Y7Qgf7MBiGFa4GJLCvrWT+yPj5t1wWTpmV/4W3UXloIc7pl6/VjOMmWc3gUVcwTOSIi7
	 odvRb6WiWzESxUGomL86HWHB/j7MQlxAg83PGKNJHiiLUXqw6gRRBeyYavpaCkmN9EL4z
	 HtEGJ415EMMo5H5mSL9bXSJne2gH8u8erSNAuOhu2wqWGrprTOiDUoQJL64OlPcCLGob9
	 F1UCpaep2z5ZtCyF3BpN42bkWiX+ehgOutC4CGg7lp4/OuDwY539sOGuo6y0XDGAh4uZi
	 HhvzYBEc/H/Sg+pc6oYWRydPutEC/PzlC8CT8IlEA2TAe/KZp/pTvpd4FxXtUvWvSOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sLfzxqhE;
	arc=none smtp.remote-ip=209.85.217.43
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20FB606A325
	for <linux-wireless@vger.kernel.org>; Sun,  1 Nov 2026 16:28:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B20FB606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sLfzxqhE
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-7bec5112765so1609431137.1
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 08:28:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793550536; x=1794155336; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2JLpxCeKgZysAKba9RBz4wH5E04iZ2pCGsqB3gTXKkE=;
        b=sLfzxqhEzv38MlKSy4bUp5GWSKAwzwrXaXfry3rGjJ/csL6Bfgf2NTDoh0wOddGBB/
         5IA12BGJA2Bxz8W/bzHR70bSGyICtFX2nGC4bNg+Va9cdOuO5f4eunCVfi6QwAorWCCU
         t1rDw7Vj/MWoGPUtxTYW7KU3O5TdRB7eDIdSVZshnIDyHEpAvZTe4Vr60N9SGNllDgGA
         IUT9fvSXI2arg/YpIoSCXIL86dm40Epr6WhwZlnbHp6fhDK6AGRmbXRZDD9MxKCe9q7g
         WvTb8zvsybIO8s1zz7DL2I/ZemEJZCkbiKYt738nKjJNPsGe8aGOfwY8NYBD9yvsEKOQ
         v0xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793550536; x=1794155336;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2JLpxCeKgZysAKba9RBz4wH5E04iZ2pCGsqB3gTXKkE=;
        b=CvhGEVf6+lEdlMzFtBTUNYv/3HIYV5Kj8MhtEql08kkatGKcrkzE2hxRUfCVoNisDi
         yaunzUCavBy88Y6aYugRcdzWKRkzRQvtiWxW7jC/B+fBX3vGikYWz+RIY7NSOdHgqm0P
         r1RN8UZZC8kRsZdV0MwxVYtP/0kIrzwtSLBmtHjsaCVaFDmWI3cMz7MsuVlhJ8vp0RaM
         qgmndlHhK5HW7aetKhtdlbBe4ISKBNxwaV8IN/3zEz5VVmRAbvWxz5ukWTdvicVeKLBZ
         RqSAYhlSDkfzHsvy9OB+0cawuEkt73kL4x/UcQH2VWyxr6Gj05PRQpt/+qK5LGkw7x2m
         KZ8g==
X-Forwarded-Encrypted: i=1; AKwUvBxXHPcVqp6L4bs2+sc8zeviS5XSo/NwTm32hPdS844LZLx0Uw8b/y7BvwPWk7ILprYRlBVqHr2GQHzwNLcCwQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYL7zaTU2p3TRcehgBzggAHjugC8sPDlBHBbAXYpNhtpsI/i0mMP
	j0bNE4J4cN9+mUtr5Q42kyAsPpOCx2S/HOCY3h70r0Kx+Rz/3Y52CMNk
X-Gm-Gg: AYBFou2xgjNWVTqfRyYaOjpFEnlY+VkRWwaaJovkb/Dh1+fbmzCq6BoBxi59E4+rrUS
	7WpnZyn0eu7XvC+jNQfU95FQiQiK0iOzbnWSSzSpCTXVDaWYee1Hcf96qa01eIHYWThCLxfGeof
	Ul+rQOHIAeiryJN2lLFBzXsv9CI0PEyOkB4h+cM5G4ZXK4rMbdCsJq2a9f5LXCYrEqtCSYkx9b5
	p+0w5gRkOclTkGISKzzz8BtLP0socQRXKm+4+J/qiq7ihKUTFjviPGCQ7ZiEqzxrvyHB/ZAyj8y
	ofNtD5Ion3FIeeOcXa+FJape+8zfmvjwHkxxjoGHhRnBTTIgHL0ThCf1Hn0VAkXmctpSfZ7yIfP
	QNsAJ2XY6Y+u1Css3YHau3hxHFUoIwIaNkaGqUf2zKSp9wvHEeUwqcU5/N6mKt9hpZOQXXfvdle
	OzMebccAaKzrwOl+nfI1dGY8aVXqMBjM56xbqAd+C+Kl+9buwko/ZjJ5xI4RPJpE/sMnOeEtYtf
	980GGdKA8s1fHt2ebJZMhlELX3gTlRPmIdKSQG1nX4UdR7+J7DlxNUj5jdfZG1IvUduTwbpHxXM
	iG+vXAOqZW+AmGldRFI2qRXV85dEZ5U17NXCkE+DCxCljhmIjyHiEvY4QY2eTjrbAzDs9s9zsBk
	7LAjc9iCiqWOh7CvPsTNe6fQ+RyGMkcI=
X-Received: by 2002:a05:6102:290c:b0:7a8:10eb:96ce with SMTP id ada2fe7eead31-7d07277c1d1mr3201168137.4.1793550536617;
        Sun, 01 Nov 2026 08:28:56 -0800 (PST)
Received: from lore-tested-by-FINAL.eml ([2800:355:4:6e7:ef84:d89e:9472:15a1])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-992ee1d2d98sm9762970241.2.2026.11.01.08.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 08:28:56 -0800 (PST)
From: Angel Lindo <angellindo@gmail.com>
To: Sergey Armodin <dolph-in@yandex.ru>
Cc: arend.vanspriel@broadcom.com, brcm80211-dev-list.pdl@broadcom.com,
 brcm80211@lists.linux.dev, linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless-next v2] wifi: brcmfmac: pcie: restore FEM control pin mode on Apple BCM43602
In-Reply-To: <20261023143003.1307752-1-dolph-in@yandex.ru>
References: <20261023143003.1307752-1-dolph-in@yandex.ru>
Date: Sun, 01 Nov 2026 11:28:54 -0500
Message-ID: <179355041987.15175.6295443283645120622@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, Oct 23, 2026, Sergey Armodin wrote:
> restore FEM control pin mode on Apple BCM43602

I see the same failure on a MacBookPro14,3 (BCM43602 14e4:43ba,
subsystem 106b:0173, firmware 7.35.177.61), kernel 7.2.8 (Omarchy).

Without the patch, chipcontrol (ChipCommon+0x28) reads 0x01400010
after boot and 0x01000000 after S3: bit 4 is cleared, 5 GHz
association fails with status 16, and 2.4 GHz still works.

I applied v2 to brcmfmac and built it as an out-of-tree DKMS module.
That tree also carries two local patches of ours (one keeps the card
in D0 across suspend on this subsystem ID; one is in cfg80211.c), so
it is not a clean upstream build.

With the patch, 5 S3 (deep) cycles, from 3 min to ~2 h 41 min, on
battery and on AC: 5 GHz reassociated in 2-5 s with no status 16.
Bit 4 stayed set after every resume (chipcontrol 0x01000010).
After a cold boot with the patched module the register read
0x01400010 and 5 GHz associated normally.

Tested-by: Angel Lindo <angellindo@gmail.com>
