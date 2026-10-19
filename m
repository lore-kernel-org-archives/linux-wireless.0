Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BFD489FC1
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 07:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792394214; cv=none; b=p1LxDMCH3Ic3U1QbT2w+i7g0dI3Z9Ve/Jsrvwm2ps8L6Ppc5gPuopE6xWNPi7RlSkxzHJe0UEUnaMLrLz0UNgD89g3FhTWq0Fg6B27JU/VO3sICKvAHO1Y7g86ljF/Hjw1MrnUw2uIp9lLqViNF0tUjquBQkxmRZ0b01uqF5fEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792394214; c=relaxed/simple;
	bh=UXTLGIkFsUnJxCW0Fh1u3R4JyQr9vdQ2x1X9N35YPYs=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=f3Sil0Q2w98hxvQtyuSGjNuFH8GSlg1RCHSMmHfsozPm2BQhThj5cC8WFcI05i4sL6zTdCz32Ay4ClwTi/dxKnVZd2bTmY5qEbz/PZ0iU2L2KmAYZZexEl6R1mICQUCPdxcOad+aThY8UxZBZV7Aia4rfgHIB00Wwe7DZVyKOkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MO1QW8Ug; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MO1QW8Ug"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a1b07c3c5fso19590475e9.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 00:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792394212; x=1792999012; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=fFviAY7RiS+Pu91f0DrvvXmCcQam18iVZl23zB2xTik=;
        b=MO1QW8Ug3gSINayoMk7y7LPjo1fxY8W3WCOzUvf0vuDJqwIdX6a66AuPF/UrLhLSU1
         nK1s31CHRB0QuKdZjmGwwPGC7lnXTfVJH/YOVzRjtYIy3r6/f6OowHpCC+mLCpE3ghsL
         Kljgr3arYeDoMiHkk9poql1yQpE3qt3bgXjjdgUKP+IHGWs4LsTkMVIDz8dLNeYkYaqS
         kXR/cVajpV0RNNtxj2r1lVbVuZUgAcvozwwlAzxL322zZxC+CKcD5MAW7uNbjqyHWdMf
         snY6clbKJ8apET/xyxQxU09fADasl/lRDzrGu0/1Gn5hFZKlkI5mS0LywyJjPGrGgMet
         ikFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792394212; x=1792999012;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fFviAY7RiS+Pu91f0DrvvXmCcQam18iVZl23zB2xTik=;
        b=xfCZsLMsbyc4K7sv+TZSEhhB7G1wFRBaN6gnTjEVXYh+rwBVf1GVkuJC8eY+yTsFxN
         b8YBK1UCWr7Lkm8vWTKcJD+AAcUis5Ggf4I/2pQQYCydYBMcUneoi/x1sczJe9SHQ5xA
         a/61VTNSaPq0qixNOfS+TWn0kll2USbiwyOTumRwjkSCWUrSvFWvyA3DhQjJ+fg6X3Lb
         aVhC5M12iK6K5RnWn9RsNgOQFzAjEsiZ2sXX1cuiXHEhHx/2k1xcUIR7FScs43HGyB44
         p8y29+K/q0yo4AQijECfENBu5oMzZhloE+ms1S20vzyEcvjHe+cp/LQh2yV/V61rFTIw
         z+RQ==
X-Gm-Message-State: AFq9FYInccAT1Ebosp8pZy8V9PkJtQ9cOQlfyc/x1/FILMWcTMueudkl
	aGrfgmU3NAiAh2jn2Q/RFT52fgKRcxMg3jMeKBP9GfUL1Lo+Wj3XRKiA
X-Gm-Gg: AYBFou2DMOrfzJxdJLAezbPJb7mNNYK0p3HPjkd3tWm1OhQyJARXgirhjdpTFy+qPa3
	Ms3Od/GLXirWRDC4vHhvWFiGudd/JdnY7tf9H54u0/gwZjxMfC+5ewy9vX9aF9KrcrARVM+Dhtp
	acp9rL/UGxE0H0CGFUG8fJSgmsJIwe0KGxr3ex8EttgaUHjZqdHi7G0Np8twWbB90+ugi/XgKXe
	iesp9uGNQTjQEsEl8rtI/m02/+xAonsVooIeAwrvBAjzSZmDGlGuI2xmWZR2lYcVwkUM6okXD5K
	LPiXsOHq3ySxgkXblxkpjL/FSOyxSdmvWoI833zLUvomsHiDeDYDsLW3ybjueQ9jDB7J0fCw45v
	0nJMZkZ7oc1LJRulvQWMecJXkETvEp4jEqJ2rwX5Tpe7iA0Cw+QiWZVyRNTZ6VIOGc1ZfXU6Od8
	1S+5acJQccVXfg04mq31R/N3RUXASfTe4RJaliC376WC1xAdArTsWVjCtzZg8aBtW84Zb90CHhN
	Dy+CVpW5HonLhTYnb5yuRA6l1KfKFkVu6rGEmFhO2eFXqyuXou9p/xoXcRN0DrNDPaHEk6rDNVg
	/DB8ScGkjW5EEmcI
X-Received: by 2002:a05:600c:3b13:b0:4a0:2150:55fb with SMTP id 5b1f17b1804b1-4a1d75ad08amr171537945e9.4.1792394211456;
        Mon, 19 Oct 2026 00:16:51 -0700 (PDT)
Received: from localhost (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1cf05009csm224628845e9.10.2026.10.19.00.16.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2026 00:16:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 19 Oct 2026 09:16:50 +0200
Message-Id: <DM8MPWZ7TFEE.11W2Q780HK4FT@gmail.com>
Cc: <linux-wireless@vger.kernel.org>, <ath11k@lists.infradead.org>
Subject: Re: [PATCH ath-next] wifi: ath11k: report TX retries in station
 statistics
From: "Nicolas Escande" <nico.escande@gmail.com>
To: "Julius Bairaktaris" <julius@bairaktaris.de>, <jjohnson@kernel.org>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261018171803.1545946-1-julius@bairaktaris.de>
In-Reply-To: <20261018171803.1545946-1-julius@bairaktaris.de>

On Sun Oct 18, 2026 at 7:18 PM CEST, Julius Bairaktaris wrote:
> ath11k does not fill NL80211_STA_INFO_TX_RETRIES, and mac80211's TX
> status accounting leaves it at zero because the driver reports no
> per-rate try counts. The HTT PPDU statistics carry the MPDUs tried and
> acknowledged per user. Report the unacknowledged MPDUs per station as TX
> retries and leave TX failures to mac80211. Over 6 runs of 30 s the
> station's TX retries track the firmware's pdev mpdu_requeued counter to
> within 57 MPDUs.
>
> Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1
>
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
> ---
>  drivers/net/wireless/ath/ath11k/core.h  | 1 +
>  drivers/net/wireless/ath/ath11k/dp_rx.c | 5 +++++
>  drivers/net/wireless/ath/ath11k/mac.c   | 3 +++
>  3 files changed, 9 insertions(+)
There seems to be a way to retrieve this info directly per tx completion:=
=20

https://git.codelinaro.org/clo/qsdk/oss/system/feeds/wlan-open/-/raw/win.wl=
an_host_opensource.4.0.r39/patches/ath11k/0149-ath11k-fix-tx-bitrate-retry-=
signal-in-station-dump.patch
and the try_cnt comes from
https://git.codelinaro.org/clo/qsdk/oss/system/feeds/wlan-open/-/raw/win.wl=
an_host_opensource.4.0.r39/patches/ath11k/0117-001-ath11k-optimize-tx-compl=
etions.patch
