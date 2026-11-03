Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714399;
	b=KvSlT0LWXoicaS9+hhJHNM91PxxgXCClbkw+seR+IjfJfCK/oeoUilbhnymea9aW/qDr
	 oABkrFryzUfWjEw2SJKsWh1uoUOqujp6NeN7ALWFfiJDYoqVUX7WhsnFWZm4irldkRvS7
	 0OH2DaXZ1toD65SNO94+4pPdB6zvfpfcYGzlBzHrkLSGpFSVxX53rYFNaQ45XxoVIF6hJ
	 S7eNRv6H67F7wufCth8ZoxBCk/dcSjk0+8U1V3lrYIBWOEUUlYRnOV0eO+VzdGxdNBiLc
	 H9jYHbFQcTujKU59gidv725bTyRqY9ISAYbvJxkRI4R4SL/l8Cr4xteTnHJXXdZcLNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714399;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=xnAMlverv3/IjELyJ32hRjwWOMBKoAty6kX1tfLCe1g=;
	b=aSa9CO0YIY2PiLHYRU0QuI+U14tN7ykPTp281+Pcl31Fa90YaS13clMg6scuhH6ywJh0
	 ebytunEz4+6ZOyGYXE/bhLiOXM19sUlyg+4AtvSdhLaGs4tOeAKIYGc1KP5tuceGlPmiE
	 pOvFuyryDxPECg1TuiwzkQ+VAhBEjfLaUZ8ClUq6Zz9Dz+3lzlr04IU2vbOkwaEeYy9+O
	 YXApnIyRHMhga0HRfkRjX/5bkBbkvGpBP17PxEVGrpJJJU6lm2tE8NZUDHYqdZjCkF5Bu
	 mdf+V6qmilJymAaUQa4a6PNFWaS3Te4vEAEC0MJNwra9a96unzR/kjassz+mB2NRWMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=LG3GQdL8;
	arc=none smtp.remote-ip=209.85.216.99
Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9C36085088
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 13:59:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F9C36085088
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=LG3GQdL8
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-3ae6b4c669fso480915a91.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 05:59:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793714399; x=1794319199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xnAMlverv3/IjELyJ32hRjwWOMBKoAty6kX1tfLCe1g=;
        b=PoKJ5ZqlG9wV8oRL0laxkLflOAZtfBKCBbKHDgWLk8ANYzc4O4UoqkvxB6GWuyDuUQ
         yTVSE0UulKCLpZEdmKf4hI5HB1ucdXlsyBFd7bByUJxmZ7i7QgOx+VzPlD/sMPcZ9TWs
         fyeybc92tiDF69wHQRiZdb00FEIXfpjWILZCVc+XLi96mzgbKvZAC4CYlmIhA/5qWqS0
         fWJplpNvI90Up6pVQcFAGf4LxHLRpT2iowFXq32J2IO4AvK4MyOr45BVBjyGIghOk13L
         Ap58E3MPWS1zAKMZJoaZQCVbtQbNopg+Dm9kBHFIE8a8rxKqpN8D/XREMSKg1aTkH/qt
         nLCA==
X-Forwarded-Encrypted: i=1; AKwUvBzcAEtvjR3wY4/EBTJVv0KJ+qAG0gGhMyg4hc+TWBgM4/8NmMarUqFecExDWd4CdA/UX2eFk9bk5Ec7XX+7EA==@vger.kernel.org
X-Gm-Message-State: APuU4Z+z26/mJxIME1+AdhOJJSaWlA0BnbuJmWT2FgVQuOkWn9FzJZRx
	LZWS13kwLgVstLrXr2+2NNo+uJcbWYSrd3pspEizYDdZKfVFLUjCazmhBFJk84HKu2IyhQQjZUg
	PyBYesX1Zx6hJHLIcE/NCBHDDCgNzX4vEM1tDu4DvWcofRCq32+fUyN2907l+14yDCtel7HrVEq
	7uqhN01iKk2LLVNUl8vVSj6ae5ou4lIWyIuWlXWTuHrc5IO/Cio8G5ITlEfxWJsBBHRf3Co5hNo
	YrHwByCg2IYPA+Yhb70+oLXOWaT
X-Gm-Gg: AYBFou26BS4eQFVrBp9ykMnXLxdHXUerMTLOcJqkbvBTF7vcbB8kyLk+vZlbNBhsb25
	RYFIsVo5h+DQctDJFqQ0CzwfyHhwIGWQfeW4hC9ZWpUg0oOw7KeX7sQ2pfGHxF8EG5mJqpkCp9Q
	D227v3Y+yNdcsij0sjgLRNYUS13Ra7Q4BlfCG3QvzRPnpTF3gs8G40IP9RrROvtuIR52+VDB/m0
	dXBcAvm3fSn8aGL3hnt9iket4FZ5F2XkEMB0mureoEXuR+4vQljYHESBl87hfT4aWcPA/jRz/7B
	4yB7pusMf2ZNMNvzORWjoiqLxjC/02NMz4+5uE4HU1z4bERh3WmDRiw52VkECbudGRpTzVRKGxQ
	w19ECSOnGdVRZmeO4hNmbaILuRZsS8SCy7FWOXUKGLG1TrVBWigsolgwuDNWxiQhw18tzJoG10X
	k98n3bYXO5oMC0xxd4VdEkz3YM46L+Y0Euz7QtEpU=
X-Received: by 2002:a17:90b:1cc5:b0:3ae:3d82:5d88 with SMTP id 98e67ed59e1d1-3ae8917bf84mr7764058a91.0.1793714398635;
        Tue, 03 Nov 2026 05:59:58 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3ae881b211dsm4185832a91.4.2026.11.03.05.59.58
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Nov 2026 05:59:58 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-3425098ae4bso1031545eec.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 05:59:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793714397; x=1794319197; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xnAMlverv3/IjELyJ32hRjwWOMBKoAty6kX1tfLCe1g=;
        b=LG3GQdL8JLA+f1gF3PhukAabS/i+7KSmdZY2Ckifi9iWeJZKBTMPjvgUVyir6qLfis
         9pSwkAly3zfmJDAhGoVNSJCHzwTU11wtH9i2xlWmaD/US1PujHyWad3jLjKo1DJIvebL
         z8NdWHIpde09qOmtJzxc27G+LD9KmeP/VOrdY=
X-Forwarded-Encrypted: i=1; AKwUvBw5skDHQ24IV9AA/gqQkB98ceIPKG9MycTxjHfw6ORU/20SHlLqK+NRRmeUImE7h8m17b2Hng3jeo3gFofKXQ==@vger.kernel.org
X-Received: by 2002:a05:701b:271b:b0:148:ece:8cc3 with SMTP id a92af1059eb24-1a94adc93b7mr20492418c88.24.1793714396646;
        Tue, 03 Nov 2026 05:59:56 -0800 (PST)
X-Received: by 2002:a05:701b:271b:b0:148:ece:8cc3 with SMTP id a92af1059eb24-1a94adc93b7mr20492387c88.24.1793714395934;
        Tue, 03 Nov 2026 05:59:55 -0800 (PST)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac18458e07sm41658755c88.8.2026.11.03.05.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:59:55 -0800 (PST)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Michael Reeves <michael.reeves077@gmail.com>
Cc: Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"Franky Lin (Zhenhui)" <frankyl@broadcom.com>,
	Mathy Vanhoef <vanhoefm@gmail.com>,
	Kalle Valo <kvalo@kernel.org>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	asahi@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Daniel Berlin <dberlin@dberlin.org>,
	Janne Grunau <j@jannau.net>,
	linux-kernel@vger.kernel.org,
	Hante Meuleman <meuleman@broadcom.com>,
	linux-hardening@vger.kernel.org,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 11/13] wifi: brcmfmac: Support versioned join requests
Date: Tue,  3 Nov 2026 14:58:55 +0100
Message-ID: <20261103135856.3676311-12-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260925-brcm4388-submit-v1-11-b5cbc2cde2fb@gmail.com>
References: <20260925-brcm4388-submit-v1-11-b5cbc2cde2fb@gmail.com>
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
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Fri, 25 Sep 2026 23:43:46 +1000, Michael Reeves <michael.reeves077@gmail.com> wrote:
> From: Hector Martin <marcan@marcan.st>
>
> Newer firmware uses version 1 join and association structures with
> explicit version headers.
>
> Query join_ver and build version 1 requests when required. Retain legacy
> layouts for older firmware and fall back to BRCMF_C_SET_SSID when the
> join iovar returns -EBADE. Use the selected association layout for IBSS
> joins too. Report unsupported join versions rather than guessing their
> request layout.
>

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Regards,
Arend

> Signed-off-by: Hector Martin <marcan@marcan.st>
> Signed-off-by: Daniel Berlin <dberlin@dberlin.org>
> Co-developed-by: Michael Reeves <michael.reeves077@gmail.com>
> Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>
> ---
>  .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 73 +++++++++++++++++++---
>  .../wireless/broadcom/brcm80211/brcmfmac/core.h    |  1 +
>  .../wireless/broadcom/brcm80211/brcmfmac/feature.c | 19 ++++++
>  .../broadcom/brcm80211/brcmfmac/fwil_types.h       | 29 +++++++++
>  4 files changed, 113 insertions(+), 9 deletions(-)
