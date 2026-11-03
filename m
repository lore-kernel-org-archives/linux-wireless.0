Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714375;
	b=xOLEBrJzPcyY2LBGNnCxOChpUuiO+oqsrCYXQDl8h2OjUuXDfkTnqzfkrYRexS11rROv
	 s3ABSTh74NHWWq9xld0KWtjmZM4d7FTyrolp6aR0H7Y9kxHw1SOASaJ/l4FTMTeQYlUHy
	 cDF7wokAw7AgmkXRGRgGoPjCLVIkHpnpjGOwEpfBY6MiTnQytCcXr+KJbf5tkwMHS7XC4
	 yf+g8QZAiCJ5bbo9rHzQZdGMA7DG9GTLOd2Aeg+vaoVKSCOQ3ozECPGdtLJgLijOWCXI3
	 d72S+gBJ463ifvvvGxnO79U8jop0GEb98Hz9IEdEKgCOkRtBbqre8sed+HnrfSlgLuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714375;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=43xLL3WpmNZ/pYhKQm6M7yVVXTs8TfUEc4VM7Zt3f3A=;
	b=ShS9BZYNwAgosQE1byVmRM6xnOkQ0IVdFNwqV7Vpbrgop/pRnim9gPuTZJOCXQ/M0vyG
	 cXgAvhEMvuEDUhpqDzm7n4fQVi93kgMnk7X1sXMrGKaiWrfdrM/e0rxMt5sx8p1QhbfDz
	 v8MkxG/Hb/3F0Vt1rjxAHbIMds4e9IPTrt2bbkvUb0iWNVDRkTW7D3Z9WvMxlUVT/llKQ
	 eMkreBPPaYhykmgGaqaNTDy0oCuHHcs39vIQdHRzHt2DQP8Hyg1seczFy8sqTp/gp9/0R
	 ryxepebhr5k03lvZNSv922Zo85GXVns4Z0vEOMN8pO8QcvHOcco3nyOtJx8v8HrUvqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=ISDU6a6r;
	arc=none smtp.remote-ip=209.85.215.225
Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80633606A32C
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 13:59:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80633606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=ISDU6a6r
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-cc751eddf25so2483161a12.3
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 05:59:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793714375; x=1794319175;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=43xLL3WpmNZ/pYhKQm6M7yVVXTs8TfUEc4VM7Zt3f3A=;
        b=CJeuUP0JPQG7gf3UhSo1brbOrW3YCuMG8v6EfDZMmIRjtLdkEnobFvrJivziDYV2Pa
         PNmnPw6lTSGBghks/Rgt9jF7PMfhk0V9X7+9vxsTc88V+bb9kHkh26alI3zJVc6rUHpM
         LjSP2uM7fGQckfdJLTCLB5kFswZiCH6Kv0c6XQfQL1tsxqP94zhlUh/ZW4rvf/5fpHP0
         1YqnguQaN1ou3ZoW6gMf7s6YOp6lOrtuCVT9IkW570ptlwKhDYHQNGmSn3XbxmMmstjb
         j6whnE+CrZMOUSTcppHo3L7YLQruGA3MTM44Q7gwdEmblepADhbiPM6WFeEV89m16KVD
         OQcg==
X-Forwarded-Encrypted: i=1; AKwUvBz/Odrbg0l4EWgtko39AP5oV7Pm13enK9Hmi9JdKHnVgR4euXwheAr5i+koF2C749GDFCWy6rz0QZPLgEntbQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z+HhemHzTb8dYTlBfbZUcee27Qu/GUsg7vSUTPWauH+jj7sAJwo
	LHHlTXK88fIE+coBDYIBfqXahGjYJWBKVJz/8XVqoO3t38nRcvmjNqdZLc0XAvxKvHTyjFsw1wj
	zOUGIy1lPcf2y6Y4vBM0GncxytgJyDoT85bT3Z0oEN9CMElACX63jtp6nzf5Um4BQQyN9Shq0Fx
	uxYdglwQS08/r1gv/aXHbkaMgRZJBvaThJa+2biJjnkj061pnU4dwbSAGDwtPlwK+9QHQC9g9Nf
	fzkOIMZXvrnuk2ceR6H2tIZJGXJ
X-Gm-Gg: AYBFou39q+OsvSGZjWJy1I5iJw6eLj6bBV/T5J/NNadu+zB5FrNHr4UdwnumTjj/9A/
	86D69Tt14Y2j+//ngV6Krjjv21PSI/IHudS9l1a/8ZzJ1jhZf7D48SlKbkguuKE7KAFl+f3kATR
	caHwEKKPEwS6rwJ6xcHzswFJeYkbQfsDkvbfJyWSYt9erQd7riX3u3V/urwJa7stNVHip2rkCvB
	7Ut+cEQv4YApU6OEoVQhstGYyEjVp6/7hmfBBHTZtQOQR5QeNoQoLfiQr9/6UxXj2dkcGIk5jpI
	vrcdHiWf5EJ8sKLd6Wtj51GTFKMvzNlBf/18Yvh+3k6k6E+1QCiEi6bbQDCpw8x3kr0D64M1M4c
	nMEm8aOdnwJD01DHsvDq6/Hiilzc41aN7iac7LVELnGdGYhWHmuuunTKm+/xnqukvaqqIO9qWWR
	RSOFT/rbBuhqblA10Y5Inr0PyJsphtCaiwclyR02o=
X-Received: by 2002:a17:90b:2551:b0:3ac:a7ee:6770 with SMTP id 98e67ed59e1d1-3ae895a5bd3mr12113304a91.7.1793714374870;
        Tue, 03 Nov 2026 05:59:34 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b07c4d7c5fsm1933222a91.0.2026.11.03.05.59.34
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Nov 2026 05:59:34 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-1ac19c6bc71so3070298c88.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 05:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793714373; x=1794319173; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=43xLL3WpmNZ/pYhKQm6M7yVVXTs8TfUEc4VM7Zt3f3A=;
        b=ISDU6a6rW4p2f+cGo6Neyxj5GI/ethEwfEGXvxQQEBa7XK0VqV0LEZcmo9AN2czJCj
         Yx529j5gOxKgSEViEgGlkfdZ9SFDMH3Ip02HXgqRaVYrY7pV/cJzFAIEJRp3ZxA8KNVb
         /3N7MlbT9ntoy/GR/G0rn3HMtR1EsGBgWEREA=
X-Forwarded-Encrypted: i=1; AKwUvBy5tYMpg+KxXNpdRT/kJCgkDIYAWC/1dvqOLo/MLUSEIbrNsofpd3pp/DRnbZGbvQtTJ52zc5FEWD8FkPSWow==@vger.kernel.org
X-Received: by 2002:a05:701b:450f:20b0:17d:7b45:f905 with SMTP id a92af1059eb24-1ac5f36ca91mr19014232c88.31.1793714373150;
        Tue, 03 Nov 2026 05:59:33 -0800 (PST)
X-Received: by 2002:a05:701b:450f:20b0:17d:7b45:f905 with SMTP id a92af1059eb24-1ac5f36ca91mr19014203c88.31.1793714372513;
        Tue, 03 Nov 2026 05:59:32 -0800 (PST)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac18458e07sm41658755c88.8.2026.11.03.05.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:59:31 -0800 (PST)
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
Subject: Re: [PATCH 05/13] wifi: brcmfmac: Negotiate PCIe mailbox transport with firmware
Date: Tue,  3 Nov 2026 14:58:50 +0100
Message-ID: <20261103135856.3676311-7-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260925-brcm4388-submit-v1-5-b5cbc2cde2fb@gmail.com>
References: <20260925-brcm4388-submit-v1-5-b5cbc2cde2fb@gmail.com>
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

On Fri, 25 Sep 2026 23:43:40 +1000, Michael Reeves <michael.reeves077@gmail.com> wrote:
> From: Hector Martin <marcan@marcan.st>
>
> Shared protocol version 6 and later allows mailbox messages over the
> control ring as an alternative to the shared-memory mailbox.
>
> Advertise host capabilities using the negotiated shared protocol
> version. Select the control-ring transport when firmware does not set
> BRCMF_PCIE_SHARED_USE_MAILBOX, and dispatch received mailbox data
> through bus operations.
>

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Regards,
Arend

> Signed-off-by: Hector Martin <marcan@marcan.st>
> Co-developed-by: Michael Reeves <michael.reeves077@gmail.com>
> Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>
> ---
>  .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |  9 +++
>  .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  | 57 +++++++++++++++
>  .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.h  |  5 ++
>  .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 83 ++++++++++++++++++----
>  4 files changed, 139 insertions(+), 15 deletions(-)
