Received: from mail-oo2-f32.google.com (mail-oo2-f32.google.com [74.125.231.160])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B4A58E2A1
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 17:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.160
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789061914; cv=pass; b=SbqZ+FMpfsL9uoSJb3X8keP6iulQ+1lC6OAg7zN5pEFlcVk/KYa0dYsiOrny4IfpYA9x67yTyolnAuKpf1NSUkn/cEOk2jZSIkGvhZTugG6GQYAw+ldPtPeVpnuTsjaAqYviACgXvi+tZQyVBY/4HQR1iw6Oorta8Xjo4GV25fI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789061914; c=relaxed/simple;
	bh=XGzv8jeCrqkzgPMYFYsG8kVONBLGr6gJeBygDyTbHMA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=n1O8f9QEwoyLygXiIRg48AKiTHMOngPtsgZs0Nt1fAHulRQ+ZqF9J5IrQ/gvV44pkvDM3ss0bbvUv7K2F638HFB3xkYV4vqh5v4HYwHmPFKY4hRalavZXCh5sIb0lh1/sZkhhc5U+JhltTAg++0fbh15QdPGTfDWXjCB418i7o0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=80211networks.com; spf=pass smtp.mailfrom=80211networks.com; dkim=pass (2048-bit key) header.d=80211networks.com header.i=@80211networks.com header.b=BqCOvMQc; arc=pass smtp.client-ip=74.125.231.160
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=80211networks.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=80211networks.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=80211networks.com header.i=@80211networks.com header.b="BqCOvMQc"
Received: by mail-oo2-f32.google.com with SMTP id 006d021491bc7-6bcdf97aa5eso10140eaf.0
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 10:38:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789061893; cv=none;
        d=google.com; s=arc-20260327;
        b=Eums5uwTyZRtjRGFFYQL5s941mMisFgUosGoNUdauc/ng2utiKKvIRkdDtNm8AKPsv
         EQfNYcmHZIxPMxzKbw9nl2bK5RRv0bXnzuiB8u4bSN1HNVpnjd2dbmdIsHAeKnk3F7i1
         B7+cvMaC3DyVZbjyuvODOCQVIMz+z1MOyuAOT22SzX1vlQpZ9phkzPJ4tqaoKyjftUt9
         pNK0roKX/UPRPb76mNBCkmRLACoqkonux5VjTPuTuxZmrd80wjPs6SjzLEwZA04YL8Xw
         Fd7F3/SXBI8WLOawJxG85sejaC9jVMwGk2cm99VP4GERM3EY+zeV4Dh9+YJnW9sTM8ez
         IfQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=kqdEW/NNqFtqi6NoYYLQ2JpoLKEb30OYDLJZTZQ7EiY=;
        fh=LFOtbSvqJezF9V2sSJOWB/BFcQ2vFY+c8NPJSCbOLfo=;
        b=sdpxiiAEyKEPDfp9r4k5dUPLUx90poaWjSeCmLOlU7RxIBo0UMrR1Iu9SVlgdMPzGu
         0RfZleC/qzwiCh0YbWs+yUpSD9qdrOJWMpDvMBV/YfLe40RZLm+IdTHL/AnNd72F/3fz
         e62cimFB+vtFkoTxXjZO5Au2RZc/fBZLWsI87vMaVHRG+cUqLSha4Lq0/x05keaP94tN
         r+VDZ10krWPrqwSnbxE6rMG/rzFn2oe76aIfJzwToNSvAMSjIy0pe3pRJ/9M4v5f4awu
         YsejWiJPblSaaaEQoTSPDzBPUysoLzHPwCZ+QF1OOfqRGj1q/b8mUYxS5/pLHcFSYrZC
         slOA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=80211networks.com; s=google; t=1789061893; x=1789666693; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kqdEW/NNqFtqi6NoYYLQ2JpoLKEb30OYDLJZTZQ7EiY=;
        b=BqCOvMQckbXfBv/Iwmb9aj948Aq3MRx8lckGtDgRl9dpQNF0fTLFcB8FZrxfHcGjWL
         aQjZqNLxGWyiJyGMHEntGVHUDglO5PDWVw6hxVVhiawEH5GpukL6acuA0WojiP4RJr84
         xVDhAFAlD/LndgClRLEhBcmAFdiWfxtFp3QHyFS0OlI9988EL+AbjMDkqihcYTzSOWqj
         g88427wo/3yKm0plKqW3+swGddHQBrmp1wZOBcc4bCw1nCh6aPgDUKQInctx0esIG4DV
         0tkTjKLYr3jnNQTbX6SriG1SCld4hlID7FQBPGdiv5C6YeNFxK4RpAkL1xnXduwzWLE9
         p28g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789061893; x=1789666693;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=kqdEW/NNqFtqi6NoYYLQ2JpoLKEb30OYDLJZTZQ7EiY=;
        b=Cn0RFKTu+YXtJ62jgQnfmQ6zLOysV4IwG1W2xl/mQzKMv22ONdIzfl8wa2CPxOFR/4
         /BPpz2fMo8Sr7x/idEEKWALJangVJj90HysGI1++jfxyzc29iRaGpsEytT5H9oCNCGlm
         LnZuQANLn58OfGLfu31O+IOCNAKguKg+HnebJrwmNfaRfI1eDIt8aQnHBFht4bC5vLrd
         qN68c1Pyhxg2UKoTBV5XMS7Sm9euHj6agZ8EFUE8Ix1hZ5WA+qEF6Rgksj3kSmLKq5ZU
         Y6O7SXaj2q2Ys1qP5szPi0F5CfU9lAmQKEusZmzr5tBcvC2AtRcZcmmkKK+F2lJGEnBn
         Z3Bw==
X-Gm-Message-State: AFuF++kFclFeWjdjU2qHsPxl2drBF5ZCki4G6Kjq2sylfA3FGGPrjh40
	2cXAnk/knNl1O0Wc1Onqq6Ab7TUeGY3nSlRJRihD/sSZ31DLfZ4vGDnuZFohXpQqc8pIg7PFTIB
	nGya6q98DnXnLZuHHBwDHSWvCQuzFQfJIASuXoycmPXB/Rzer7r5oLq6cUQ==
X-Gm-Gg: AYBFou2mMsQh5OFsOK2kSuJUeOJJLk8MksCK/WBqpuRBIx+WzZBV1eYXi15GROpONSo
	QIuxfcm+fwm5QWq028fpzcxUZiWUslZwosnHWl9PUw/dh3wS2gil8GfznqIsARxQMTtM7tYX6JR
	bBYTDJDoEupDdicSxPV7Lh9qTWcYsFZg6beoja4edqzItbr9+/FLHAhGVJ2PenCoTL9lkh1MQB2
	VMhiwzuZnCh9Q0mIGpju6783+D8FNK6dfKP3VZy3KK8xEtiL9tWw7wUuMapBJQmlrOsGCQMvGSX
	UrxO7toPwoRqiOQUjeXPf5XnsFEtpaoF49j2kgmcvXOyoB9k+JzTwosg
X-Received: by 2002:a05:6808:d4e:b0:4bd:c8be:1e07 with SMTP id
 5614622812f47-4c31953a9c1mr106630b6e.1.1789061892771; Thu, 10 Sep 2026
 10:38:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Firas Shaari <cto@80211networks.com>
Date: Thu, 10 Sep 2026 13:38:01 -0400
X-Gm-Features: AcwNN1UIDEPi8j6yQIOoGHvPthCGEXcasaSqfG8o52oZcQQJdGbhVLvxzOPC3AU
Message-ID: <CADO+z2hr0r5MsOGCYJPecbVq4GeV5rymErCHOrE5hTYufn-sUQ@mail.gmail.com>
Subject: What does the txpower value passed via nl80211 actually mean?
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"

Hi all,

My background is more on the RF/testing side than kernel development,
so this may already be well understood by people on this list.

When I run:

  iw dev wlan0 set txpower fixed 2000

on a 4-chain AP, what exactly is the 20 dBm intended to represent?

 a) Conducted power per TX chain, meaning 20 dBm per chain, with
    approximately +6 dB when combining four chains, plus antenna
    gain; or
 b) A total/EIRP value that the driver is expected to account for
    across the chains?

The nl80211.h documentation only says "Transmit power level in signed
mBm units", and I couldn't find anything that clearly defines which
interpretation is intended.

From what I could follow in ath11k, it appears to be (a), but I'd like
to understand whether that's the intended meaning across drivers or
simply how ath11k implements it.

The reason I'm asking is that on OpenWiFi APs, this value goes directly
from the controller down to `iw set txpower`, and at least one
controller has been labeling the value as "EIRP" in its UI. People
design their networks in Ekahau using EIRP, enter that same number into
the controller, and can end up with cells that have a much larger
footprint than planned.

I have a LitePoint tester and plan to measure the conducted power per
chain across a few chipsets, including ath11k, ath12k, and mt76, using
APs from Edgecore, Actiontec/CIG, and a few other white-box
manufacturers.

If (a) is indeed the intended interpretation, I'd be happy to send a
small documentation patch so the next person doesn't have to guess.

Thanks,
Firas Shaari
802.11 Networks Corp.
