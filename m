Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792594760;
	b=WTYzIJWf4nFlwdtniVwPnzV4VqrqKXd5yXXyFYFYcjjtb/i/Osj+wgOmy0foGtYXYXXZ
	 zjj9SpIIgOLfITHdnQwlNvIqsDbyIwcjHNnpi4ictPRS2dp6Yg8jJFa3ecrk3/4YKqIbt
	 L2FE3Kntp9rX70q46SnHsIVuEe/SIq7RWyFjZRyCUL5gluzge2ZxFut5ioBC715ooAVFY
	 TuKvSj6ZeDE/zeXMeAC6uwWneYuRKHzd16925YfPp6WK8mMimkPbIUywclO89wY120FOa
	 5y3wnRBWLXx9chSSLSmUQOScpUxj77T7wzf1iCXqjycMocvrtVMKYvqRWUDYUhq+MSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792594760;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=hObvmucUS6t1rWR1L9u3AvYVQ+Nq1snLbT3mu1kE8f8=;
	b=CcJ/Al6U4grStWGmTWrl85Itw08Z3b5k2V9WNpZq/hAP9Zm0S/BuzaBv3YSZVKpwhSSy
	 uCMNzslnHvbE5YO+Gz9pHY1t4wzowosa9osZt2qOQk/lEiJjs0a7PY0hHVbaXK7jQZRCJ
	 EnIC3WqxBBPAC297Vm5787gT9ZEejn8PlpUw3O6hWJqUmEuIPyo1w8PCtEqfNHeVejAwy
	 8aIZXN/o/fxt5oTLFKZbFnR6R46rqW7vdMZDAzHJbzmXwpKZCkpnRK68NZpcAp6EuhWU9
	 R7T9+QmNonAvTDoZQ2FcowbAaKzaffD/y+IN6XuG+erq1Oot6qFm8Jh0QO/IgNxtlOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=WO9+EzJK;
	arc=none smtp.remote-ip=209.85.208.176
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253BD606A31D
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 14:59:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 253BD606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=WO9+EzJK
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-3a9e87ba7f2so7376781fa.1
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 07:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792594758; x=1793199558; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hObvmucUS6t1rWR1L9u3AvYVQ+Nq1snLbT3mu1kE8f8=;
        b=WO9+EzJKvDZCAa4i5HUJlbg7DqPjyFHR5FavlN/kFq2BTKdu4v3gy6HlWq9kDt/vnd
         z4Zq7rZBRF75tNqrVEnK+W+VsEjahiudmwOkz6xukmkjENYYIF3q5UJkG2TBsIeg4Ppj
         qHrsk102jqTowe8j/4IwuJraQEFLzymsvR7k5v3xdgkk0wr99EreFczLMgXXFwE2PvX/
         RtEnsVVhev7EUxg+dOyvq54UZ9qIEJmP+nPM9zr63JQ9oSgxFXDMormbGbSdwHhwHwoc
         NaebjomKS4GyMem9+GbsBBTGVE5CSDtf/w/M3BSBPxhCPMnhO8s6arY959PR/M8oVxMa
         YSWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792594758; x=1793199558;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hObvmucUS6t1rWR1L9u3AvYVQ+Nq1snLbT3mu1kE8f8=;
        b=03dTz+v9e2XGxyWmnJ4S0FgWDozFo8pf2418vtI4F4jZ5zo+J9G+eIt7nToPMFz6+n
         /4Ero/hg+mnQBuaUUtVN8xG3UqtW2PoX/Di2jtVP9sbL/XjHWanxUx4EV7ZflLpeRYDm
         v570WakmSBezbXs+NlOUgkQi7xqU59iQO9MYr11tmgGh1p1l6+OLYBNb3LDFoRmgNpth
         vKiIuhaA6JLD6F4GGNk7hgTS+JL1ToqxdmhiH62mBUv4nCcm/XjCSS+HZzG8UG7ASJJR
         TStQpYoOG7+ru7MK4xL1Svka3xMWl2kI1g0BKNagqZ1IaxDcna2fExHdFs8B36hxCtzn
         bg2Q==
X-Forwarded-Encrypted: i=1; AKwUvBzzF0le3SKZrogXdT9yndgmTnhbmr3eyoKfYe5smXYaINAftYwP7YPWkhfiQZO1dnfzwuMMQNRh6vqVIm6qhw==@vger.kernel.org
X-Gm-Message-State: AFq9FYIvh6DrjlBq2pUxLdxgvfaOkY+ir2lpCzAd9tcSCPDSMuXCs+Uq
	Ewzq4p21VSIVESO9Kts2+/nWYbkheSDeSoUO6y+gjYWb8kuxYhNlmTAJ
X-Gm-Gg: AYBFou00tJ3STP63DTNI26njeh94WbOCIL6ORWqHHqzoYNcejpuHQLuIJM8oEvos7Zb
	Gf2Z1spDM8gmXc7y75CQ/ZMDD4U1qwfrdCqTUwZyLaceD6+ma+kHcbwRqDgVxMKm49uLA3lrI/L
	4zcId+erc1ABSpZUjxutlQ1mnNtQs8Vvm/0J9JIk1w6xrkwbgAKHGa4TvRQ3lksgsbOMdP1rOW9
	9ghSF0ez+H87ohKtuosnqs3CUc+OkHnyL8XPGqalqKnfLb+wpu4rHw78/OBIQjk0MbTuqMfEIK8
	VSEvNvquy+nOiatc/cCdoDpjo9yoR1n/HEbLRgGVT0zaRlPNAjEEMQLXsVRdAFwljKVfRcTjb04
	oNPNHb0Izt3GcwxmGXvp6Cdoe9NlOQIhg3ngKZIsFHLSx8yrRvoqX566aTbsqUzr2Gl4g4hMF9S
	FJArjrfpA9Vc2aywym/t5uaRZu1h73oYnqHukW/GsI6ksC3QJjkqqqeib8SaezUOXM9RdAXa7Gb
	x9vUf9+DFDLuoatmqibaAgyQC97/xdzgK7eLiBV17DaBZLZnx/4qCIyBo6g3lzdy3SsviJ1kB8s
	+t2Sf2OCIV3/Q+vF
X-Received: by 2002:a05:6512:65c9:10b0:5bf:a34f:b94d with SMTP id 2adb3069b0e04-5bfa34fb967mr478168e87.9.1792594758106;
        Wed, 21 Oct 2026 07:59:18 -0700 (PDT)
Received: from [127.0.1.1] ([85.249.168.112])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfa4b90999sm128327e87.68.2026.10.21.07.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 07:59:17 -0700 (PDT)
From: Fil Dunsky <filipp.dunsky@gmail.com>
To: nbd@nbd.name, lorenzo@kernel.org, ryder.lee@mediatek.com
Cc: shayne.chen@mediatek.com, sean.wang@mediatek.com, matthias.bgg@gmail.com,
 angelogioacchino.delregno@collabora.com, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org, Fil Dunsky <filipp.dunsky@gmail.com>,
 netdev@vger.kernel.org
Subject: Re: [PATCH] wifi: mt76: dma: run threaded NAPI kthreads with
 SCHED_FIFO low priority
In-Reply-To: <20261020-b4-mt76-napi-fifo-v1-1-ac8a24e2062a@gmail.com>
References: <20261020-b4-mt76-napi-fifo-v1-1-ac8a24e2062a@gmail.com>
Date: Wed, 21 Oct 2026 17:25:53 +0300
Message-ID: <179259275334.35963.15413466304986880275@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Adding netdev to Cc, as suggested on the GitHub mirror of this patch [1],
since it touches the scheduling policy of threaded NAPI kthreads.

For context on why this is done in the driver rather than left to the
admin (chrt / sysfs): mt76 already does exactly this for its other
rx/status and tx workers (sched_set_fifo_low() for the usb and sdio
workers and for the tx worker), so the dma napi kthreads were the only
mt76 rx path left at SCHED_OTHER. A userspace chrt also has to race
the creation of the napi threads at boot and module reload.

Numbers from the setup in the commit message (MT7621 + MT7612E as 5 GHz
client, 3 runs x 5 min each, ~200-280 Mbit/s rx with userspace load):

  stock:                  ~500 full-ring events / 5 min, watchdog
                          resets and MCU timeouts, occasional hard hang
  this patch:             0 resets in 3 runs, rx 276-288 Mbit/s
  stock + chrt -f 1:      0 resets in 3 runs, rx 249-273 Mbit/s
  napi_threaded=0:        0 resets
  rx ring 1024 (stock):   800-1300 full-ring events / run, more resets

A similar restart pattern is reported on single-core MT7620 at much
lower rates [2], which fits CPU contention rather than throughput as the
trigger.

[1] https://github.com/openwrt/mt76/pull/1164
[2] https://github.com/openwrt/mt76/issues/457

Thanks,
Fil

