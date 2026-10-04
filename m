Received: from mail-pg1-f226.google.com (mail-pg1-f226.google.com [209.85.215.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC0F3B3894
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 09:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791107140; cv=none; b=fq0+6j0vFdh46Il67DcXRq/NNSQgc+CG7Q+73WbMxgzBpLlxqZsWO6hPZg3gLAAt4Fmup4OrcN1s+tBIfxUb2RtgniNWA920L88dXWkgREw2RYEnCDWuhCHFBoGKVuUZafVvUZ3j8Y3J0vy5YrwgsYi18ikmC7u1sZuF2Cc+ifU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791107140; c=relaxed/simple;
	bh=uSpJlr9pWB8cp8BrFmQO5ngregHs2jVsmD4SjTxJsbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qeNMaliFkzvRHKnozuPestWJxD0xygYK1Lb2OvZeu/kD2QZh1sHoRmIdCq8ZXsYI+hwMVuiM5wxvnvzj5t7UZQSKHfM1xSca6P7hh6uCfjh9fzLTGVVe3saLCEanqf32J/++2U2DWAUAhFNGUVfS/7m6Q0xX1RgTq162yAYmCOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=HEsp9s+G; arc=none smtp.client-ip=209.85.215.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="HEsp9s+G"
Received: by mail-pg1-f226.google.com with SMTP id 41be03b00d2f7-cc4dbcf2b85so301717a12.3
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2026 02:45:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791107136; x=1791711936;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KxK826MAOAYwXMvz4tvmAzJFT8E/SsdJVdTSWQcGqO8=;
        b=2mKvJwlaVEgrGMephWssqrtXKoOtmZo1OiSqLOBTTYUKGsOaUlrxxp1aXef/K+uujn
         GgGdWu4ylqKNpbARHhsiVU5VJ0pRMvH5sN7aJPp5RirYxBmAteKOs87niRzoSQz+8NDW
         hzY+jyP58oDqXxizaT3vuACCfOQ4rgX0K8hRvziDjVR4P/KIqRE25qR+1O/H+vwmVScI
         TRft0yVJ4MVuyGpCj4cthXXDxOw6ty14hWZO7FCZalqDl8SXG03lXj1O5/qRRYdIJ04d
         cJp+MCaDA+P5phzyDnZe/4u0sLu08RQZVL1UYDznPVlgPR07s/mmHeupkqsaoHwv9VmE
         qY9Q==
X-Forwarded-Encrypted: i=1; AKwUvBw2Imc+iMK6+ri6TqIk7/MHnbrJARFMz3cPZ8tbOpAhajxwOhoWuWxlpWDXdx1aR+v0fxn61oYo3e+aYr/XLw==@vger.kernel.org
X-Gm-Message-State: AFuF++nQUzu5uOxUT3kjzSOyiUaz8DVtYDKZTWPwxq/fTI3/sk+v263T
	27rqfAHDAO94BOaMZ62OLqCeQXevTriR4ReECEJG8J53+R7fj9CDwejrgY4dE/NjIJzB/cZo+m5
	crFAftvm5eDrYTS8hM/0GUqS+vaLC3e8eJHgJScKxooVH5YPRzsSVEbxac8hthPz/uOtm1LovQ2
	+EXzUDQ65yGiqd6aFMkLdUWxO7RuQrxabGWkBUKBMR+bM5teccyGXfgZT54TBkev+9ZMuMtPfOh
	oazmt7s8IS5SGMJeFYbn7oWOkFn
X-Gm-Gg: AYBFou1F8wxUtHs+ih/LUO6ifZU+y2Y3D4qb9o/R0/OOZNQRvuLgDNU8cYyTr3vkKUW
	FYb3jgZf972jwUHeVFPSPxsNyybp4YeP0GJBGyDmP2dKZhDUr8spR7jkhLdOeCK8p0v6qTGiibm
	Y7VdhSySB4HyfMFQTwkypr4rI1+mwXX2KkdBPr83a+L9l8+gmsPj9Qf3AgjKsZDaY5fPQLW64Oq
	xURdyYzfPeNc5opT/3e6/FKZNBdkrL54ITXUG+d95KdDZMErTH9fl+j/ahgN7gzlUIq5IWLk2yY
	jKuLenkMUrVJ6deF/tGmFY/wVycfyNoCSDcPmB+ZkrqyiIRXRXM8vLc211cYNCtuj0zxTJAXAyc
	x1VBo90Lyd+7ED30dyGfCr1OUMEY7DMGF9UbZqbQu7cOYVK/a92+hFgqAK/PcoQ69TfSUXt9csD
	xo2uYKc+ZNqapqbKeMxSBx2Y14JXmNKxjZEYCkmeKnjg==
X-Received: by 2002:a05:6a21:62c3:b0:3e0:b67f:eed4 with SMTP id adf61e73a8af0-3e0d6ed94e2mr4111257637.73.1791107135637;
        Sun, 04 Oct 2026 02:45:35 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-120.dlp.protect.broadcom.com. [144.49.247.120])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-ccb73cd14c3sm898005a12.4.2026.10.04.02.45.35
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Oct 2026 02:45:35 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3510d0baf63so1796069eec.1
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2026 02:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1791107134; x=1791711934; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KxK826MAOAYwXMvz4tvmAzJFT8E/SsdJVdTSWQcGqO8=;
        b=HEsp9s+GXwoBW3iYzUzslBstyzxFW/F1yZb+tVyN99i57PETeOk+yU7gkB5DpukJfz
         PZCnVoAECJu7L/aOx3sdLWUDm9RgL2kNLxHUmawtpXxp1JJmaZso07Al/7zQ2BY6Oq/r
         XJ5tdImn22Fw5+9lt8lUBRyyS2R7MroTN1OeE=
X-Forwarded-Encrypted: i=1; AKwUvBzBCgNwfq1zg268/xN7R1F8nA2HNYe0xz38rQBsG2QaFLNjfcWRM45XtxMYdlUokNG6xnOdPyl6xPzAR6aqaQ==@vger.kernel.org
X-Received: by 2002:a05:7300:d509:b0:351:23ce:992d with SMTP id 5a478bee46e88-35123cea7f7mr2847626eec.27.1791107133673;
        Sun, 04 Oct 2026 02:45:33 -0700 (PDT)
X-Received: by 2002:a05:7300:d509:b0:351:23ce:992d with SMTP id 5a478bee46e88-35123cea7f7mr2847594eec.27.1791107133106;
        Sun, 04 Oct 2026 02:45:33 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-351272f27dcsm3508030eec.30.2026.10.04.02.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 02:45:32 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Janne Grunau <j@jannau.net>
Cc: Hante Meuleman <meuleman@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	Jason Huang <jason.huang2@infineon.com>,
	linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	asahi@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH v2] wifi: brcmfmac: cfg80211: Report port_authorized for 4-way HS offload
Date: Sun,  4 Oct 2026 02:45:27 -0700
Message-ID: <20261004094527.1324037-1-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260915-brcmfmac-4way-handshake-offload-authenticated-event-v2-1-fbb9cc7ac177@jannau.net>
References: <20260915-brcmfmac-4way-handshake-offload-authenticated-event-v2-1-fbb9cc7ac177@jannau.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Tue, 15 Sep 2026 21:17:38 +0200, Janne Grunau wrote:
> Since commit 416386060 ("Mark authorization completed on driver
> indication during 4-way HS offload") [0] wpa_supplicant expects
> NL80211_CMD_PORT_AUTHORIZED to complete the authentication when the
> driver supports 4-way handshake offload.

[...]

> Cc: stable@vger.kernel.org
> Fixes: b8a64f0e96c2 ("brcmfmac: support 4-way handshake offloading for WPA/WPA2-PSK")

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

> Signed-off-by: Janne Grunau <j@jannau.net>
> Reviewed-by: Neal Gompa <neal@gompa.dev>
> ---
>  .../wireless/broadcom/brcm80211/brcmfmac/cfg80211.c  | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
