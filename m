Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792661689;
	b=ybUL1qq+bxq1tbaU49iCvz8c86nOEJQvznTfsyAOiO1ngKJ4q7/QUU9lIPOoo0a/dcjL
	 U9NlLBuKV5m8jOmiCKG5eXlxBGnI9hSAKWYBET6ih0l62fTgBqlD2oSH7bAx2UXNPXSSq
	 FQdNL1Yj1brSvSbp3cWjiLRLjL64w7HkYizOtzIQ4/xdwqhtHa0A6IO6r3TNltkLHroyd
	 stjBOmAZDd/FVOrmjGzgE/zQfeIVanAVE0Jouplb7mB55Hf6Ncd+kmmuk8mcUxgLV6K4Y
	 HjC1YfoJyqkIfMmyZ2/pztGywsO+WnBq3xDqytTAjsBqajS6kTxt57p1db4F7hTW81g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792661689;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=pVN1mqrOhYalxYFr7VReSIpfsAYguArpSUX3xTADh9w=;
	b=mi+Eao15g3pr8yPLDr7to5qZdkj9++Y+ofVUa+XN5+mo/pGOM+JbC2AOzlcWs0yiHQJy
	 JjuJNpKWbZyzfVeD59GsufRBAbUEBzHnOOR7Wj7hiVO8ot9R+9v0Gcg5gupYFUDidclY1
	 vZX0SIj1pQd0PNAuizSDo+OHoOMdZGlWXNIY63/WifCvCxxYsZSvdjq+/Wa9bT155ljYz
	 2xwH78RnyKiK5ef40TmKXUgVKyBG/EAGDUAXAbUZzPYheQSSurReWSXnPAXh8nm8KDNWh
	 ZT2MpQg/H5z0oyHQ97w2IjS1by7snuYN4FQpcL/VLWGIyKkntClG2f0T/Bg3mreCbUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=QOuNwM+u;
	arc=none smtp.remote-ip=209.85.221.53
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6928B606A319
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 09:34:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6928B606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=QOuNwM+u
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48b042c0759so1173112f8f.2
        for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 02:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792661688; x=1793266488; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pVN1mqrOhYalxYFr7VReSIpfsAYguArpSUX3xTADh9w=;
        b=QOuNwM+ut/XXfjXB039CTGSCzy8xsloaZdU5WvFi47yBZN9UVjzOndqXFgzO7mDjp5
         mkutKz5IeyUOk3yIX3FqigGFlDAW6BuAque+RcAG0Fyrqhu2KjuybfY0iLX2peTAqiPZ
         4rPEkh0A78fmZ1DkUT9wSb6gklNxpI6WiCIByQVRI7Gp9UG443Inw24cO7jHgVlQbFe7
         NRjqhAXVpHoIjq0U+UpLmUlk0LLBDAdzkrfo1m96BT0jXmhH1fj7+hwmlKcgFVQunGnE
         woL0qJRQibe9q87rMmdOiUojPzGBKF1qZy8PZl5WDQoZNzsbOk4/QZEQO7b1a+Aoxgb0
         hxXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792661688; x=1793266488;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pVN1mqrOhYalxYFr7VReSIpfsAYguArpSUX3xTADh9w=;
        b=RnNzT2G6pVsSHU9lPnOZ0xlzo7RIK963t2OkIcfxpt8x2xWI/2mTSxjZBEHYa10us4
         bYiLqtq1haGhFMlBRL5h2t4KNdvGxyb3M7flF+/v2NB/6yl0B6ur2rWNzDyWq3V8YfcB
         +9k2zfyVGrFnr7MnCq8kYxn2hWh1BD846wrj8W3KjbxGsN3wrWr1d+5COIL3gkHZu5IS
         YeUDVgNPBoArYGKHZGh3R78Qhq/16Xzm2rakw75twyUgPs5wHNN9DZLbZb6PZIDyDQcC
         wIuEf9naJ+ydQ7KyZwuwKWb8MNDexnHoFHWozafmnpQrbwmrV+oER1m/pwEr+RVIwutZ
         j1ag==
X-Forwarded-Encrypted: i=1; AKwUvBzhV7/RAXJWWzH3HZzNmv7T0RgbaphPWCF0DArxaQMsAmfTcqjC5FK3geVfkf1CEiH1hC5J7cRLj1OiL662Fw==@vger.kernel.org
X-Gm-Message-State: AFq9FYLiziBSVmxwLwsB9BFHjNNI2BEKL6CyKmZFS3jGkgdeqwt3+/yb
	STSJvUlSbX9gg49n2wXoenx5giU1VqWtLn0Sd0bZjNGZoeALja0KDS//
X-Gm-Gg: AYBFou3LqDV/ZmARVHJNuYgp4y4N66nDOg89MRnPCoJDR4I5d/yukDm8EgKn8+yiK9E
	pVngbz4ca30yNiXMGrcazG8i3IsHy+XYOy3EwF2CBlRLHPFDnsjEwHG6/ZowwCpAG9F4IZBOYXI
	G8ErkVBzS3FvuFyvSWjR07NNGnpAVyuCWC8AktJqI5F8iloMfLCSvioYPU26wY5FTwGCDe8d4pC
	VZIArCERp5N2/hNF/KF1NxcXlRZe6pKhsLRTUh/9tce1jyBNtw1jb86zg6y0y8ohKGqLBIYLj9y
	Hkgsy15t9jowsn+ffn0zP1v5nYvPklB14ufrGkq0rkejnh7zCb8JKjImq6q1vwGk45W4VyNXlmK
	k+Tvl1spL9dFaY6Qh0LmcGuqDrNhPY6wIMieMTJtKu2tClez7rzTPWZ054j9zj8iurrY2TPhpS3
	QSFYlEET3G/YwxaLWNcfLoW4K4sR2X1M0P9yRDDzupxtX706ObSZoeuYZA2SfIgO0qkSk3Ib/so
	KoDHdO7/v5Ez2qN7xb0Lj9Ij+bBgeWiUAD9424A5PMc3CuXaZmxOoUdn1vVM0CQ0ks5n7+J5BNq
	tU1lNUZuWo6ZlKzX
X-Received: by 2002:a05:6000:4806:b0:48b:451:4f19 with SMTP id ffacd0b85a97d-48e264e2f10mr9528690f8f.51.1792661687521;
        Thu, 22 Oct 2026 02:34:47 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e25828e72sm10420288f8f.26.2026.10.22.02.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 02:34:46 -0700 (PDT)
Date: Thu, 22 Oct 2026 10:34:45 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Fil Dunsky <filipp.dunsky@gmail.com>
Cc: nbd@nbd.name, lorenzo@kernel.org, ryder.lee@mediatek.com,
 shayne.chen@mediatek.com, sean.wang@mediatek.com, matthias.bgg@gmail.com,
 angelogioacchino.delregno@collabora.com, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH] wifi: mt76: dma: run threaded NAPI kthreads with
 SCHED_FIFO low priority
Message-ID: <20261022103445.34cede9d@pumpkin>
In-Reply-To: <179259275334.35963.15413466304986880275@gmail.com>
References: <20261020-b4-mt76-napi-fifo-v1-1-ac8a24e2062a@gmail.com>
	<179259275334.35963.15413466304986880275@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 21 Oct 2026 17:25:53 +0300
Fil Dunsky <filipp.dunsky@gmail.com> wrote:

> Adding netdev to Cc, as suggested on the GitHub mirror of this patch [1],
> since it touches the scheduling policy of threaded NAPI kthreads.

I had to fix the same thing for other NAPI threads when doing some
tests that were receiving 'silly numbers' of RTP (aka very short UDP)
packets.

There is a similar problem with the softint threads.
Softint callbacks drop form being the very highest priority items
to things that really won't be run in a timely manner.

David

> 
> For context on why this is done in the driver rather than left to the
> admin (chrt / sysfs): mt76 already does exactly this for its other
> rx/status and tx workers (sched_set_fifo_low() for the usb and sdio
> workers and for the tx worker), so the dma napi kthreads were the only
> mt76 rx path left at SCHED_OTHER. A userspace chrt also has to race
> the creation of the napi threads at boot and module reload.
> 
> Numbers from the setup in the commit message (MT7621 + MT7612E as 5 GHz
> client, 3 runs x 5 min each, ~200-280 Mbit/s rx with userspace load):
> 
>   stock:                  ~500 full-ring events / 5 min, watchdog
>                           resets and MCU timeouts, occasional hard hang
>   this patch:             0 resets in 3 runs, rx 276-288 Mbit/s
>   stock + chrt -f 1:      0 resets in 3 runs, rx 249-273 Mbit/s
>   napi_threaded=0:        0 resets
>   rx ring 1024 (stock):   800-1300 full-ring events / run, more resets
> 
> A similar restart pattern is reported on single-core MT7620 at much
> lower rates [2], which fits CPU contention rather than throughput as the
> trigger.
> 
> [1] https://github.com/openwrt/mt76/pull/1164
> [2] https://github.com/openwrt/mt76/issues/457
> 
> Thanks,
> Fil
> 
> 

