Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.97
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714348;
	b=b8W2btj/RK9HkN52a/2T83KnAvVZ01CTFbyFLpnvdNDOuFX7F0UoCNLP8OKvvKcH6GSE
	 84depMI+ebwDEhGr+3NlGgwjkyiWuQzla9ilbgOafdh7MYys6w2L4dDIHBB+jICFvuWEa
	 ORnmvd0BR//CPf/oInrbIEaqHREQOWTTRkz+gbU1zRe7KE8/YaoNSf8kSHKHtx+2snpQ2
	 xTvXKpaz3lu8N0q/VSs7lCw/rlpaLokviVfcA0drW9C85Xk36OCiSvULkjh2ddjeOjsUH
	 vzcob5BSAw0Me7QAcSotSIrpEwgBM8YWUYiRkqWjgxm32aD4ggUVvU6hPRWxt7xRHeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714348;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=bmndstez1ROjl3SXVUcZnwGvUr5BBU/f9ozJwfuLHnI=;
	b=t4g54NVSsOOObaA77hP5H7yKe5RAzgzTBi9qxBEquujqwaFwKcxtVoIQ1LRVyoGf7yAw
	 BMc5GW2K/QBxweH4x7SPvQGAzdK+JGmbpRJCJkXlQkdAa8bX7Mysgs3eNZY3cHniMZdUY
	 K94NnQh+VaEdCJ2xqaCjWXC7jARHMVQ2A5ck0VwF6ZojJCo4+x1G5dJxbEgPPBYyfzidz
	 aqDtyOv2ZWefMuHCndyH+WWpfazXlVh4P2zyxVg37uBv9RZpHCtDIaBoORgqPHeDPYJhv
	 i8Y4sNDWvf8mpadyk5TXC6ONJPeRT2BunkArIFxMin8yzIAva4vZqgdMlSKENVMRDQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Qj5XYort;
	arc=none smtp.remote-ip=209.85.210.97
Received: from mail-ot1-f97.google.com (mail-ot1-f97.google.com [209.85.210.97])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0B6606A330
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 13:59:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC0B6606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Qj5XYort
Received: by mail-ot1-f97.google.com with SMTP id 46e09a7af769-833e671ee9fso4321599a34.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 05:59:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793714347; x=1794319147;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bmndstez1ROjl3SXVUcZnwGvUr5BBU/f9ozJwfuLHnI=;
        b=KpIx9w2UPTXG0GL9P4Juo7SI4vZ/sVcTHNrZ/YUI+PEBe3m/kTanVWP/fyFnf66nP6
         rRnwjtYg7DzyBQwca24bM4IT/f/eGQHbkLdG+g6qMs4VBIhYZjWL/iORhQKXIzLk6CSh
         enChF1JsLwa9yq1TiA+xrAh8ZwlpVF+TNBrt3Ksl9AOnJAoMgvqw2vMVDIRyCR+mphki
         RhD4lL0P5FttH33LMUsdVwggdCg26JTis0q8WX+f+fq6D05an1i8kuvxoe7zorPv6iar
         E29QBoMdAHUXxiMbN78tPlX+7lzTwZwSj57yXpo4Roan/Qwc79/4v0sSq/SYy73BZFpw
         FsiQ==
X-Forwarded-Encrypted: i=1; AKwUvBwGBpj0Bw7H1tfVGLUm65Nw6bu5NbeYI55qPQwG7ewQb3aUr/HyX7SKmqGjmtvVaWLAuJERFOrVoq/1KL/5Ew==@vger.kernel.org
X-Gm-Message-State: APuU4Z8RT6O1bAuSHvvnzLY6JYGw26mXN61BPMGUxacNolfWicK7cq5z
	9vDswK6/GFJBlYiPoVT4d19R0T4DfDjek29qSEvbzRU2GMhM9ZbxsEFaTc+rGL/jHH0pYJLSHFA
	gXN1OwWhwHW5L3QHmOPmfIQbq8d3pFBqP3ok2PAY3oWPf/7c4vFa+wYzgG5879BLsbHZhR8FHvf
	gOWf/U4+pKb4kZ6zzIi/nB6nAbHXsfin4OOBfsLuAaODO7unkTVwkFZtmsH8fdMwd+hM5W38bZ9
	gae6f/t1yxf5tPzduPGTRAUTV+J
X-Gm-Gg: AYBFou3dGp/FD35W8a+tw5/95Li3YEi2ZUHgctV9t5whwL4roJpS/Xm2xb3ufB7GjBi
	7fcRJVeE/mw0SqVSel6bKr256j5LtlkeXCveGdTNBvqNVD7YptMkqXnWO7l6ouF93vOwQPgt0Ho
	MTyqYJ31dsWdBlhvFTor1IqpM+egb61J6NkjKuEtEfXl3mFPT2ojkotBbhrhSf2Nak8vnzk9w9Z
	62rwfeHbE3lpE2CNG2EmTwlITxuO5sQxPz+OCziWfBlYWByFvy6JsZ5WlRsYsAs3pfDPoRT9LKu
	4r2+mJSqQsvJvFT4mVy5g7PtZx7s33+dLdbUcUPbKuXAQhOJoKF3PN/yPXp0ZJP+y95llD0mYmk
	ntCyUtBxtJF+PT5m5Zv3UzKH/U2COZNWjTPe6l8qpmONNwpcjkfR/qs10GzA5i9mEvvPcxM3zsN
	Rf7KPZV4lGOv3h7y1WEeYI/HWafO3MPO+5Op4EcVo=
X-Received: by 2002:a05:6830:2406:b0:845:8d86:9f7f with SMTP id 46e09a7af769-85d364a9eb9mr10211762a34.8.1793714346700;
        Tue, 03 Nov 2026 05:59:06 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 46e09a7af769-85d35620e5bsm112793a34.8.2026.11.03.05.59.05
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Nov 2026 05:59:06 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-139b62317d0so9502385c88.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 05:59:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793714344; x=1794319144; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bmndstez1ROjl3SXVUcZnwGvUr5BBU/f9ozJwfuLHnI=;
        b=Qj5XYorta1jw+8PbfZqY71LtnJoR1VdZw+gTUwW6/ozIzSv0aM10Tyy7BI2/uYiYCA
         FFvVmgp8cNb/J02cehNMBCQNCabMVVX+SMB+ewHIIaQBee38RYLRWMlG4CbQBgoiVPtS
         H1SC9bf9/blmL5n2lOHDZfwrGjSvAf63thBc8=
X-Forwarded-Encrypted: i=1; AKwUvBzhK4sBpOY/E5FnKpQAeLH0W7B6warPs05PIEnajK8PeimFMMxnCO5l2hFCJNRiJ0EW+iwt3R5JkorUPpuj0g==@vger.kernel.org
X-Received: by 2002:a05:7022:ea55:20b0:1a2:a5b1:884f with SMTP id a92af1059eb24-1ac5da7726bmr20328261c88.31.1793714344056;
        Tue, 03 Nov 2026 05:59:04 -0800 (PST)
X-Received: by 2002:a05:7022:ea55:20b0:1a2:a5b1:884f with SMTP id a92af1059eb24-1ac5da7726bmr20328216c88.31.1793714343237;
        Tue, 03 Nov 2026 05:59:03 -0800 (PST)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac18458e07sm41658755c88.8.2026.11.03.05.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:59:02 -0800 (PST)
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
Subject: Re: [PATCH 04/13] wifi: brcmfmac: Support newer PCIe core startup and interrupts
Date: Tue,  3 Nov 2026 14:58:44 +0100
Message-ID: <20261103135856.3676311-1-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260925-brcm4388-submit-v1-4-b5cbc2cde2fb@gmail.com>
References: <20260925-brcm4388-submit-v1-4-b5cbc2cde2fb@gmail.com>
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

On Fri, 25 Sep 2026 23:43:39 +1000, Michael Reeves <michael.reeves077@gmail.com> wrote:
> From: Hector Martin <marcan@marcan.st>
>
> Newer Broadcom chips, such as BCM4388, require changes to PCIe register
> access, watchdog reset, and RAM size detection. PCIe core revision 64
> and higher uses a different BAR0 register window. ChipCommon revision 65
> and higher requires a different watchdog reset sequence.
>
> Update register access and reset for these revisions. Decode the SYSMEM
> bank counts according to the core revision and exclude ROM banks from
> RAM size calculation. Disable all detected D11 cores during CA7 setup
> and select H2D doorbells based on the firmware DAR flag.
>
> In MSI mode, firmware can clear the mailbox interrupt status before the
> host reads it. Requiring a nonzero status can therefore discard valid
> interrupts. Process ring events without that requirement when MSI is
> enabled. Use release/acquire ordering on irq_ready to publish the
> initialized rings before the interrupt thread accesses them.
>

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Regards,
Arend

> Signed-off-by: Hector Martin <marcan@marcan.st>
> Co-developed-by: Michael Reeves <michael.reeves077@gmail.com>
> Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>
> ---
>  .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |  35 +++-
>  .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 197 ++++++++++++++++-----
>  .../broadcom/brcm80211/include/chipcommon.h        |   5 +
>  3 files changed, 183 insertions(+), 54 deletions(-)
