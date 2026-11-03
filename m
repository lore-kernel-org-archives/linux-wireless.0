Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714395;
	b=ELhTgKemJFpHT30SyxXttEAb92/HOX3kb538FCuivPhTR4WR/mVHWk88E/bBselZ+UtY
	 7RziLUY+p4TaDClUltt7Y5jXG0CDvmYdYUXWXpvBRqZ2A6bL54QrPaSyWYUcnvfH9HYdp
	 OqF+kNdkQ7Bm0B2PBD+DHPzbbLzF4DuJswUS0BZZwfUxUsKKl+hEwHRG+hD6PcQCM7fMa
	 nsQgMKc49KOn3nw8VJoAC00qHHxQaziE40zrsun5IPp25nDM/5ET84ikOt4at78JqptnB
	 iD/NST4fjOnqm1CzfabUoxexkcmgYHGVmKXjwQaMW/E2A/bq9vw2lT+k5k2RGi06n2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714395;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=FwIVVnYhvvjMTysTggNf76en9r3AUtCzAUuv63rWer0=;
	b=qI4svlYWEJ9H/eTeTIHCziL10k+Sd1aejj5L02hAY9K4Yp0On3VPqBpIK1r1Gw7tFa9P
	 SqunRTkgYDnfH6VghU1q5Rm8fFrJZQtI4168Cx7B+m8fuq6Y/76zl5mhAUGTjVpPmN4ba
	 4cLCdB0ipZ24aDyONsT82p5b6hGwhyOZ5Ckk8y6Msvx1rMJAK7IAkDPnY+VBQtG1qNgbk
	 Apel8kXWEnIL7OME2HFtjZIdr8+uCm+vd4cAYyHEdgbyZLGLYRGf9nOhUjUU8w8VSlBvy
	 RwO4dA6In8rVAU2h3sinL3YkAllHQoJ5SG51yWGFm960xxBmI3oipFi55GDKl3DRgyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b="Ir+iDq/x";
	arc=none smtp.remote-ip=209.85.215.225
Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C96606D809
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 13:59:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1C96606D809
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Ir+iDq/x
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-cdab6ae1ee9so1745649a12.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 05:59:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793714394; x=1794319194;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FwIVVnYhvvjMTysTggNf76en9r3AUtCzAUuv63rWer0=;
        b=mTT9IcHN8Haanx5Qj3rVXw4xj0KV5OqJjcY05B7Ivxf0blv0PdV+LRl4eNS1vBMPve
         GbAUou8Bnw+vTrRgGyMkM8y4SvoaTWJu+snbAhbHh0L6bvqovigtxQuwl/zUAqqMNuNP
         n/q+aZpfeYRVn5YCbLKJlJlJ63jamroBNQAaOJqhFxV3moXjuiGhrgH4mGo+JhPQNId3
         H+c+nzmwo9OrSAJlqN0nNYIAiykg0nNj34YEXa4e3CDEc/8G12Ky9x3q96OfoEgg49GK
         Xiae4gXMrKuKpDAuk1ixE9nN0J5OicZNNewmkcwwCBcBDv7YApmi4HnXCrck/0BlIs6m
         QxWg==
X-Forwarded-Encrypted: i=1; AKwUvBzagOcttwf/Ohwy/bVxhTApR1nzJ0oqGlKoI5kNlt2GfZLRPRxIRvfxwpmoe/fMdeppEcQCegJbk/fr5GBmnA==@vger.kernel.org
X-Gm-Message-State: APuU4Z81tr0mTUN9KRBgJ23DPctBiw9eKZiqgdQQid5AYcnjiqjB+RBl
	mvTprjOl8ktt5Yz8QRso1qrAhywEcgCcOW19nX6UrnvvIyrcQVyfH9F3cuf5baFyniWCla4SkQ0
	+GLkSVv3vsEWY1cJhkdun6xY8G9lEANlC3NSqSQ6gUbpKrIllIz9Wq/tCpsWgXYp0vOegSlBbB0
	KcX2xm9ijmf+fEGTuCM4pLMKrDCeIwDcH4H4VkJslvsa6rTSgB1/+qPyLIXhFvXpqOvukAsDYAD
	dzFjiAXVNL3KGr9bUuMfTReJMEG
X-Gm-Gg: AYBFou2Axqo0qtwLc6CaRaphXN5QPLYfZnuu5HEp3gZlcPRCrtLvOZeRGRGnhKfOMJM
	SWbJZ/h3Q4HrqceAdYpV2PzwsX/aQnJiNqEg3xLlJPakiGkdUq2VPXJ0N6YH02KyOvHAK70p4cM
	eunlysLq3UKJW8jLfVOikpeApB7UBnxBa2ZRQuzlXFjQ37v5NSBN2CG9GOpQ+2pAcJn2eHopxyU
	er4IM69OSHtHnBAP7c+W0OUJ3Iv5odjZhb9HobXvNhQSqrsYyXf3Mxljy4lIQRMrFuU7xHdgGs4
	1Whc5+eEH8S4t3qkDFph/AmhPhfdWxEubwZD9Tr3dbmRnoz+fD0DBUi9LDivkxjuikJY3i7vSuO
	Oq+BMtNHxXE4svF7oKSa+sqsuitW2SDvDTg4pVKudfzP6Z77Zf3Vtz5pHNJLCMYWz7zwGshROhW
	ZtuWIVX5SUZSPSnsTW9nF154QyHpMb5t5NWj58Ass=
X-Received: by 2002:a17:90b:4e8f:b0:3ac:4e18:238c with SMTP id 98e67ed59e1d1-3ae89806287mr10029008a91.49.1793714394078;
        Tue, 03 Nov 2026 05:59:54 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b087409c51sm975287a91.3.2026.11.03.05.59.53
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Nov 2026 05:59:54 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-33713e5e6daso4900863eec.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 05:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793714392; x=1794319192; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FwIVVnYhvvjMTysTggNf76en9r3AUtCzAUuv63rWer0=;
        b=Ir+iDq/xiO6xCn6mnXr/0NRhsA0/MegfrRxIQaWgLmnp6ae3A59/41UTHw8v4vcl+p
         DwQiYn2r6u9ZTyjIjMrv3/GLN5k0iwkzYTKfAzNxYxSnPKB940fLE38+kX5NJxPv4wE7
         KKHcG2DTbW/i84JFn1K3XMHBRYLtCZamQioZA=
X-Forwarded-Encrypted: i=1; AKwUvBxkiHWP1rJ/zY4a8w++0fi8fEYC9YRvu57mRvBm/zkLgKTKPg9P6zuPvU4eL8h/8nF4ja7MxR0xxAdqU0zOLA==@vger.kernel.org
X-Received: by 2002:a05:7023:a56:20b0:1b2:3742:828e with SMTP id a92af1059eb24-1b23742830emr5949723c88.3.1793714392079;
        Tue, 03 Nov 2026 05:59:52 -0800 (PST)
X-Received: by 2002:a05:7023:a56:20b0:1b2:3742:828e with SMTP id a92af1059eb24-1b23742830emr5949684c88.3.1793714391367;
        Tue, 03 Nov 2026 05:59:51 -0800 (PST)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac18458e07sm41658755c88.8.2026.11.03.05.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:59:50 -0800 (PST)
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
Subject: Re: [PATCH 13/13] wifi: brcmfmac: Add BCM4388 support
Date: Tue,  3 Nov 2026 14:58:54 +0100
Message-ID: <20261103135856.3676311-11-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260925-brcm4388-submit-v1-13-b5cbc2cde2fb@gmail.com>
References: <20260925-brcm4388-submit-v1-13-b5cbc2cde2fb@gmail.com>
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

On Fri, 25 Sep 2026 23:43:48 +1000, Michael Reeves <michael.reeves077@gmail.com> wrote:
> From: Hector Martin <marcan@marcan.st>
>
> Add BCM4388 firmware mappings, RAM base and OTP handling, and increase
> the RX posting and completion ring capacities to 2048 items.
>
> On BCM4388, DMA_FROM_DEVICE mappings for posted receive buffers cause
> DART read-permission faults followed by firmware DMA failure. Map these
> buffers with DMA_BIDIRECTIONAL to allow device reads as well as writes.
> Keep the existing mapping direction for other chips.
>

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Regards,
Arend

> Signed-off-by: Hector Martin <marcan@marcan.st>
> Co-developed-by: Michael Reeves <michael.reeves077@gmail.com>
> Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c      |  1 +
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c    |  8 +++++---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.h    |  4 ++--
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c      | 12 +++++++++++-
>  .../net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h    |  2 ++
>  5 files changed, 21 insertions(+), 6 deletions(-)
