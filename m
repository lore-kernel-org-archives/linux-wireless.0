Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793540503;
	b=TpqOJSFY7yk3NvZUGXYhpvusZX19i9qYZTGPNHwhUNeezOdlSUPMv5t5jjDdwfe4XK46
	 KQC7mNkE/RM0kM7xeE/nFI7hrJLnGZ75NpiXB1/86Mx4ei+jTE4NVgnKIoltiDtfBb17a
	 imen5VR/UmuLHGc0VF0cClRXjAciL6C+NqzJnKnpj7bPorMkDBD0gAtBHkoZnSQlXB1T+
	 JsyeiUfoFHyezu1R+4wxQ9LQoVsfR2sK+n7c/dIKxIt/vjjjzZHGt5uRR4enjgR3N0ZRD
	 /1lBdpbTbWWxOOdhONe4VrQsSiMwODGgabJh/1W8vI3oQRmYNGoNmxdYDwWwiL3fWew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793540503;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D9SuAAhicfGEowYvG8qAtgOKnV2KMOsPr8uS/Jwlz2M=;
	b=A6V8+6ekJQNZQo/WPL1oX8sWBAJK5Q7Dj5yu7KrUf89ID0HZDcHYkpmXFaEdreYLmEYZ
	 yPHmeCNWwliiPXRYx2xcSArtolob5QZVWHxeCgRynE3CwaMQ4K6r0KSOzdu8IQ+ctXxkY
	 8fs4thbUcKKEFmf5hxCFTcjQ9TdMN2iCXXyuqVVLF2Hmu+TqqOjlk0lRuKQqaZ/SApCBx
	 P1agW+SyMLt3dH/pigihyQtyapULXUN2O8vpiOvbL0MpfLBIzqirNfMFQg+nHxXOG+Kb/
	 P2cFHSO31rpiGzaGv8caSl1FaDJ4KIXbF1076b2FBjvcXqXC8//FCNOsL5VxqnyeiqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TnBwHmkB;
	arc=none smtp.remote-ip=209.85.214.180
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2B1606A324
	for <linux-wireless@vger.kernel.org>; Sun,  1 Nov 2026 13:41:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C2B1606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TnBwHmkB
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2e98798cbddso9659115ad.0
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 05:41:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793540502; x=1794145302; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D9SuAAhicfGEowYvG8qAtgOKnV2KMOsPr8uS/Jwlz2M=;
        b=TnBwHmkBJcfx2omypk51rDF8gsLIEFeSM7osdJ6QXAjKOddxtvEBYLseofQY5eATis
         yg2y3pAPEQ8hQp/4LLvFJKAqvwAnTCI5LzPZwvejPMGUaMGdSfTIriwzWvnoDRtezCR8
         +J9WV987bbhGwE6BSqE3Vv8mZfLl2ntWStNv83mYE2PpeulC3ptKKEd2JUdO5ed31qYL
         TbFwlf6foIj5OCRjFpXLG9CTimh+UnKqttveSHFYqvO2XZ1nkxddXXj0wemtWVdYT7S3
         1m8DI0lZd0ZjILlbOvxxa6QrLTzmfiaZrCNtK+F3YSGCncmbw4kkGjQ8Cb3atT3dwCO+
         w0UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793540502; x=1794145302;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=D9SuAAhicfGEowYvG8qAtgOKnV2KMOsPr8uS/Jwlz2M=;
        b=tqJGFo5D1rxRhMc62XANnn7WUDKOz6DFi8nj2BqriNHVmVsKw0kEusme+sl+19c+Mm
         D4sGRILwJuudx8MVjSfosOtjkoraNw8edbidSDCNEid6Gkd6R3W+QhHsy/5uelKJ3xTP
         x9hZWfONk//cL8NrzliF6mNIWSL0OAnOScCet0X8lTZc3cyud1Nr/NM9N1s0QGxKrDW3
         RHDjk08f3Qx6/2NXlDYH3r3oggIkJDc4sOS8tqquv2UTlakBKynBeqV6HQMk93aYbiQh
         bpdHizBYgWsrPiXkXYOAhkjwcm9ri75tinkxxL0FHUkfQhN4qZaSlor4S5FUbIM+XsXM
         iXPg==
X-Forwarded-Encrypted: i=1; AKwUvBwf+w/KI0EvLhm9med9n15u8MS21Unj4QmgZLXFRo4Dt6BwUgOYslvynxdMQ+JpeEZ6NCtRfKGXtdd3YDlNvQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z+WbGsfVktoekbedXPdDgeisAfZmSirjTM+juSvEzBwdqM+PgjB
	ZlWfEfzbokXJ1EjTfpYQbaNeQs+BRnMbHjvJKWVL4BwGfc+T+qMA4mzv
X-Gm-Gg: AYBFou2M+fkU6yJsp7nzGG9hYcPwVLpuzhWVV8v57ih+XVxg4n4hKZdUv3QnyiGIPva
	0WUP3aPkgYN7niTZExsx8h6B+u7OcDxs5AEcqSr7/P7H4AMveU6XfAfQi4MPKRHxem7ggUNLQtm
	o4ybke1WVqjBiM9bxX+Oehs2tlidCy6RD4BdwWoaLVDy+eRShTKDz5KqVpaKT+ahZ3ZcMs4m/MI
	f/BHXbS5dGSBXw1OTH9CPMgNGgifYkj5KpmEzzz8CP7IdOKvaIANUN9ETfY0EdUJHOPwZ9QDmgw
	JlBKPKFZvgLqMDasjr2ndBy3DZVx2wJuMdI+uzcXG9zHZt92xIXV3rqvOphaTOobcEsZtOnsvo6
	ljO5cQ8Ylgmfp9Zia28iYHJHHAKJRnfi1iu0w+i+WSm3g6p01ESRc5NVw9vFzq5oy5SU5dvlcx1
	ydyQ5mp2cDjT2znRjNSFXc09kcQgtJ2vOtlcx03nusAPzkbWvywHBkBXWvws7Ok0qcxa6qEiw6u
	FVRyELcC0oOF0bVdwb2PKyr1vvpmTLbSz+cOuDySV2cuDDdg/kzRdX5pl/6GisZTHLfJdO4sRMC
	t8UDLtWYpAV/hcgZT0d+2piGqeONzo13pEFC4I+bq2YXeToOS8UdP9U/1DYjgvrRqbA=
X-Received: by 2002:a17:903:1b05:b0:2db:733c:fd1f with SMTP id d9443c01a7336-2eb364005f0mr64610475ad.8.1793540501905;
        Sun, 01 Nov 2026 05:41:41 -0800 (PST)
Received: from KRHW1CJW23 ([139.177.225.243])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eb3927ff6bsm18769675ad.52.2026.11.01.05.41.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 01 Nov 2026 05:41:41 -0800 (PST)
From: Zhao Li <enderaoelyther@gmail.com>
To: Luka Gejak <luka.gejak@linux.dev>
Cc: Ping-Ke Shih <pkshih@realtek.com>,
	neo_jou <neo_jou@realtek.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Kalle Valo <kvalo@kernel.org>,
	Hans Ulli Kroll <linux@ulli-kroll.de>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] wifi: rtw88: usb: stop RX work before unregistering hardware
Date: Sun,  1 Nov 2026 21:41:17 +0800
Message-ID: <20261101134116.30404-2-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <4a555879477e2c5b8eb2f2cd430157adef580461@linux.dev>
References: <20261028141904.8707-1-enderaoelyther@gmail.com> <4a555879477e2c5b8eb2f2cd430157adef580461@linux.dev>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Luka,

On Fri, Oct 30, 2026 at 02:51:43PM +0000, Luka Gejak wrote:
> As far as I can see, rx_urb_work can't bring an URB back at this point.
> rtw88 doesn't set soft_unbind, so the USB core disables the endpoints
> before it calls the driver:
>
>         usb_unbind_interface()
>           usb_disable_interface()
>             usb_disable_endpoint()
>               ep->enabled = 0;
>           driver->disconnect()
>             rtw_usb_disconnect()
>
> After that usb_submit_urb() on the RX pipe fails for the rest of the RX
> teardown, and a failed submit only queues the work again on -ENOMEM. So I
> think cancel_work_sync() on rx_work alone already closes the race, and
> the same change would then work for the older stable trees too.
>
> Keeping disable_work_sync() doesn't hurt, but then the commit message
> shouldn't say the work can restart a killed URB. Or did I miss a path
> where we get here with the endpoints still enabled?

You didn't miss one. usb_unbind_interface() is the only caller of an
interface driver's ->disconnect(), and none of the rtw88 USB drivers
sets soft_unbind. Before rtw_usb_disconnect() returns, only its own
usb_reset_device() enables the endpoints again, and that runs after
rtw_usb_deinit_rx() has destroyed rxwq.

rx_urb_work can still run until then after an allocation failure, but
its submit fails on the disabled endpoint. The commit message was wrong
about that.

I'll send a v2 that only adds cancel_work_sync(&rtwusb->rx_work) after
rtw_usb_cancel_rx_bufs(), with a corrected message and without the
3e3aa566dd18 Fixes tag. It applies unchanged to 6.6.y and later.

Thanks,
Zhao
