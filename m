Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.196
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792484941;
	b=NO19bKedmb/o0SfS+uIbjA7F9jkh760F28Ci/h6EZYLbzPa6G01rbaUZrZbJu8irUjK1
	 9FpiQqjgpmQtm08SOcYGBhbZbV/Au39Wyg+mbxlTlCAfXhldT6yPj3yjMjwWP8t5a7rp5
	 hfwnQSnU8u3LWwc40CGA9qX0VyYoU2k+b+7MPEni1IuyhQGwtg3hCljtlM9eEm/bwJqxB
	 wblMSiovOqZBivRgVuWYZVD71Fi22lxMektXGU9+0M69hfreO1yz5lhhtkpF4SnQbkynr
	 zyZLHLaTIFheIx9wBBaiDm2ALXz2rje2aIfNMw8V66Bv9Re6q91IQuK/jYlERwSVC4g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792484941;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=NavY/ytNnLmh66Ul0qyAE6INpifpVSZOXQao+qNu7CA=;
	b=hiXmK42ln3bYmWpfV1ZHy40X6GWx+ffGmMyL2yOJ5HUy6JFdJGYy/PqrJhjVBGZvwEwD
	 Shmqn4VnoCQBQiPHxGboEQVg817r6++M41VSNwk+H3OqxrixVBK58MxN3Iu0Q92AGH7+8
	 RqpxXsqGwDg2jDebpZNdcYDXRcqKe8u6chUrMaiMgb9B8PtI6BldnP/MZEwnxAvt3Yi0y
	 umY+XFtkiswsNEvs3PAkL52EPJCBmHkT3E7Gk48lgUSbXiF9aNmFQE6z+DNt826iPWP2w
	 ol0ECJ6GORLfaXNAa2KqO5C6Y1ocIzEX6C1pFDHsJtxurtuhSyLCR51BjonO9gXPDJw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=VpvxBWjl;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.196
Received: from mail-oi1-f196.google.com (mail-oi1-f196.google.com [209.85.167.196])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4E7606A33F
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 08:29:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B4E7606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=VpvxBWjl
Received: by mail-oi1-f196.google.com with SMTP id 5614622812f47-53dbe9b8d6eso368688b6e.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 01:29:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792484940; cv=none;
        d=google.com; s=arc-20260327;
        b=MVzoWuN0RmmKRWM340lWH+T9KjpRAdBHGc8uNi9iCDlei6r2JFn+YX3taAE3QJFVvF
         IIjn6PCOJo5Klxl2xAWMjTmPMzhabltxi+dJko4VvPIuh8TWVepTp/fsGt9z8WrfhXhD
         KAb+8C3Ox+JZEl9ek3KKGiKZs3OZ1tnwjZjRaoCFcM9ol/bNNIap04Or0POz6jXrRAOB
         cp5RZ+bdcbIHNIwegZ9tv6j0mUuYMAoXckP44lWLqU7b/CGbp8/Oq4v0xMkhdl3i6oG/
         OSS412Yvi/ECfJX4f+tWU0KeoudLRGUvgDUNF5iljiCUeyS5Y//bPkshRw3VZKA3DySD
         sapg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=NavY/ytNnLmh66Ul0qyAE6INpifpVSZOXQao+qNu7CA=;
        fh=BXa7dFNRU7QvV/lhhDD4RZ0MBhP21q3Lb3RXRfucNok=;
        b=i9u8E9OhZyVoKjxiCm+jfsOKtDom7APIs5ngS5b0mTe9Szfo4UlnKuE9aMv/iPFG4i
         eHNxafj1WRkDelOmtdCikOYBEvG54/fpocW79GuutVXA2cteFBAQjf4SJ0PydQbJE8ZU
         YN+1QGsXbdhgwviLj9syZhe2PEdzJWn38Dt+VpBPH6MrHJL5GynrVrXuB/HNrLDsJIYe
         fe2jS+HrrC7aY5gTnLEjaoCY+Ded/zJ2pUGtcCERIkd0vQCkSbDVl+Lkd+39KscLT+sC
         3elFwIy/on9OTYGnLMJk3MuV7pe0ESem++p4vgB55/gmbRvwErF+gTLru+Y8KNpDkT3a
         zbKw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792484940; x=1793089740; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NavY/ytNnLmh66Ul0qyAE6INpifpVSZOXQao+qNu7CA=;
        b=VpvxBWjlgA+Bqt9L3rUE0lDmeWk7FGC2H7K6V0coJLcF/UaUitpHzPnIr7hKPrqjnw
         obGlwrDmQ5jVNRoz42j3jIT5r6AwPcOg2goyD5sDbn4gacl0tCefS4FH6p3yUdEO/qbJ
         oJMQ78LnplMUCNP2HkqyZYmEmHct8uZso2S+nsFFQIJ6lifAUybX77IOwpd4GSaFybLf
         g8u0s6OhIHGzgnyCsV3uStL4XjQhPRfY6ivGFApt1yAH0K8xW6qSZbjOG8XoyMqFh29B
         YKwNr6PW3T+dzwG2P46Ole+iDypawco0RgoKqe7+UY/jB0aLnupgcVwQBaECOJjP38zK
         0TFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792484940; x=1793089740;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=NavY/ytNnLmh66Ul0qyAE6INpifpVSZOXQao+qNu7CA=;
        b=benDWgqzCgrAO9kVE14Ovhd3QZYE7RHVBYB9vmlFlMnvwhbVM3nVee5ATU2TtNWR8n
         G3p8tosPgN0uIdhipxsUvFJ/XT1FirE91NUgtkuRCQVZqfIWE528c+wgpnk6SRShJrJE
         78melC5d4VQ/P6Otbk+DO3oyXKb8DGkpPTZWjDTeLXg0TSjceHvxwmFmqcTD+8A/5FHR
         PkN4Mbn1Bufyb8FemOSbq+CXl2Wyfd/lfwZOS5sJYxCyiBZPjkjD7hJ6g0Nn+6486k1x
         KDNvPmhBrvl65djqZqopT/dkMWky1ReUepII8QDwuRUgHumifhJnEglq9MA4drLAxnyQ
         Qwsw==
X-Forwarded-Encrypted: i=1; AKwUvBxfWvliCqO4mnb5cy6nh4vutSHGtP5z86QBw05S0TH+hWazt3TJpM7TQpnn/hCxnOGGRyCJcRX+Cd6NoEV3Nw==@vger.kernel.org
X-Gm-Message-State: AFq9FYKGSRTxwQXYFkSK72Oa9hGH5bKkVp8T7eWzRKT6GVaVemW/gUd9
	asukSKl75MtdKDyFJzCFmdn6O5paob9IA0IF+t2EXFzU3JycolAx2IpEk/qh4m1+duH2jfePmwd
	COhYCZdG+cgnQD2BRU2r8oRzZzywCnK0=
X-Gm-Gg: AYBFou2OYf4yF/1kYfl/43J/2g93/EED5VbrUTmAFX29AkGceS/wdXONs6jS5GvfCoU
	N/LIgSaE/51b5ztz+CYf4ozFJTjb8NvJx0f6u9ihItciUZhYqvEuiDo7q0Psm1RaqHJLwLjC/zE
	f8BnKF1wM42CbcLop4LlmUCcUodqymqRKkint4sHxwmCCAeT9NIFwYS1TMgXsjIUjrjoRMVfSda
	qPEtArpdDuqjUZCpri4sar33kcbYhWxXDoIkHR9cH7eriW2Mujt1XpBRS3yrkp/Tz0Gof7qVzfy
	zcVv2RL0bWliRwkJVCdO6Oa8nwodxDuFIutH0vGqIw749yrgKVRoO+o5SbmL7YueM3ARDVxg4XC
	Dg0mWonnVZYVXfHC9yPK9n9b+tLFt2jqwJDA57cvh3Q6tWdDoBqBAzfs1+xT/Plirvb3BG2U=
X-Received: by 2002:a05:6808:d54:b0:4a4:989:bb1f with SMTP id
 5614622812f47-54d90fa2426mr776594b6e.9.1792484940372; Tue, 20 Oct 2026
 01:29:00 -0700 (PDT)
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
In-Reply-To: <4f48c50cab1145fd9dbd6df6d424c877@realtek.com>
From: Hungyu Lin <dennylin0707@gmail.com>
Date: Tue, 20 Oct 2026 01:28:49 -0700
X-Gm-Features: AclHuK9c9F__jzyrGsDM3XhJ0P84vKewaRrJS_W-Dm5zp-eUXPubOxCKHdiOFkk
Message-ID: <CAGEkeHevidTtTNj-qfy6kE_O0wRvqT=F=sG+Hy83BOkRjCUqeA@mail.gmail.com>
Subject: Re: [PATCH] wifi: rtw88: allow key removal when the CAM table is full
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>, 
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"reza1234khan1234@gmail.com" <reza1234khan1234@gmail.com>
Content-Type: text/plain; charset="UTF-8"

> I knew. I just want to know if people encountered the problem, or
> found and fixed this by reviewing.

Found by code inspection. I don't have rtw88 hardware.

Thanks,
Hungyu
