Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714368;
	b=wbDsWi6D86x1RFE76c4caJAPeJlmwxI2Y7qAsy3hhJSPz3lSUf3fv+Ih8ayiELp5VBes
	 Wu3vDEl+zOkLzna911K+/e9g7t1hCMnPHZjH3lGjbUiP8kaAsHaaP7WJN/dGqaJc67eXQ
	 XkqSqEIfsbujnSTEzZzcI0bfWdEjM3OecS/+7qnN9gNfhvKMc8xgjWlIYcNawd8j3Iwrl
	 4q+X22b/f7YTV1TdS3sT4DM3T0S6/UFY1Q0cmLCbXChOximD1FBBDMVLJmT4tAV1+LzcL
	 fbaXRVnREoZj887BWISK8ElOxVXGc0dEgKgywLlfwEZFN1L8XnaROZFkvFrEVkn2c3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714368;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=ObP2EjY6D+HzwangbrGAF+EH007820Bo/Jvo+O4ZYyA=;
	b=OiVq7zyiR6xYOSCcypQnrwPP+AWVK2Lhj+jjW/HF38R+CIZU2gOPBzxDhay8CO9hgqgo
	 P285Yj1N+Qz2O5uNTx5gPJTHo+Qcr84SQ5m0isaZYRrbVyvKprXrmvyHrgiugZHHw4j7y
	 MIRtwPP1ENjLwVI6nQAL8Q1lzHvxCFeafHEB1jEIQ1PLsQjGAPKb0wqF2webWChTKtMt3
	 k8Q9/ekOd3kbSJwpqr0K2mFFkG5ZaVa2NMFbU96qtG8vsiXaUmKB1AHKyY/zGz7GoePKp
	 DGzPL/k8Zh53vHKtLoTkCXWVmY7t9zUpGl9U/HmopMQN1bQBoXgdGj7imT670D8qOyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=InjbKNaF;
	arc=none smtp.remote-ip=209.85.222.226
Received: from mail-qk1-f226.google.com (mail-qk1-f226.google.com [209.85.222.226])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA83D606D811
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 13:59:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BA83D606D811
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=InjbKNaF
Received: by mail-qk1-f226.google.com with SMTP id af79cd13be357-9441591aa5cso87093685a.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 05:59:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793714367; x=1794319167;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ObP2EjY6D+HzwangbrGAF+EH007820Bo/Jvo+O4ZYyA=;
        b=srFTQK1NkRLig8SjxFgweXlIdBRkmzsF2BeXDb5Vx/eDFMy+GhUGstVYfs6V2jNeks
         Zu+8lgNgwe6gpBI3eiJ4BjoCQRynMEfmS4acEMTtJxKCThuSQkrm3uvMxedy1ZUvRKoq
         zbxpkdIJTom4oSP0zh4tjyeP0rphKXgj3r2MkdJB0JSup6mETLN2wPchUhsT6OEXqgaW
         18KRsUxr0QdBUcXr5expE3qkibR2n+Ck5C8x2FnvrnD7D1EWzidFoiDeXhDAcOmz9ERc
         CCG+7xgiXKzR+nctDIDxZbeyr9dDGHbF2f0VNF8ZsfC9uQuDEGPpofhgHgHi7Zz9mm5B
         L9pQ==
X-Forwarded-Encrypted: i=1; AKwUvBzmvXiKjlaXsNSBgdS4RpJQMzDfKbPviV95m4+6mrWEyaquFYboFUuUqypAj+qQNX6/vQNP9DXLHwtC2D0JlA==@vger.kernel.org
X-Gm-Message-State: APuU4Z+lcRBfwi9BAAvPqzt5c763VJZzTPKMY1ECThzcA5G6dofdVyNH
	kfBzZGmHQP475ahBdREYAEwKc2q9HCHnrYwjuszuVJthz/v5zUB+kQK8lIfjmVPj++21fnSjNLR
	LDKkN+ZThb1YhIORCk2jaPUk1MRpmVYQ30/c0IKjZ25mT4lihk339xTiVbkgj7+abHt0bHfIv7E
	dNd2YT4ePoXvGxOTYrfa47lXOR0FIanGLlEJsxPQHm38Wf4b2jzxP09r1jg4fNrQ1ENcE3EjLSc
	RLDvNxgwM+4IKmNM3zTGDdvRwG9
X-Gm-Gg: AYBFou2sA0e5Df8ard4/8r5E0sIAqP6NxvwF8eBBrmOLbi4nuUW2vf5XmVNdkUJpTJ9
	V4wWkYxZdNOPNpt4jFurofhyYmO5A7qeL3wk03afksPkp724DGl2hHgQQ2afpnWBVUNua+UXSJH
	CMuojFmPHkcg3UXDpjnS5iJUYfC+xkrR4ipmtzmYczHWXn5v1GDBO3yMA3wneKHqGib/aj/g8KW
	J/0iaDGx05b0FObOKSsEDytR52hyclX+Ats2S+XIIID4MDfpAhHLdDmTXEHKU5vnu3VRDpdDu3N
	aJjCiaTGa6zJenZI9269/d6zbfK/63Kjo+qXqGwuoWMVtoC3EEAeohXMqLqw8YGZZqTYmafelMB
	xS8FkQuFQlcEDiJ8SL+tIhMAm5IZWZgZOjzEBZuGawYQ8Ks9fxnSsoN2yowa6/eEWtoOnd0O2Zn
	A0Cb80+7NY3gBOHNT4BZMhcDwpsmSQXlm3cRUsyoo=
X-Received: by 2002:a05:620a:4722:b0:93f:4a02:ed99 with SMTP id af79cd13be357-94413386199mr2605980585a.20.1793714366695;
        Tue, 03 Nov 2026 05:59:26 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id af79cd13be357-944252ea9cesm118947185a.1.2026.11.03.05.59.25
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Nov 2026 05:59:26 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3425098ae4bso1030827eec.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 05:59:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793714365; x=1794319165; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ObP2EjY6D+HzwangbrGAF+EH007820Bo/Jvo+O4ZYyA=;
        b=InjbKNaFmAH1s1J+/9edCils9XbTtwp8vdUhjyl1yTZEUXsnq2jEf75kNwAdrXmIbq
         QMAQ2F2lU5Sn2lErudD/4Nr+d2bRTop2uM/5bkHdf1j76I7ZczkbNGlDrKLRUoYSSuWB
         fK1MaOOrNBK2YsqU70TfpQwEdwy7oIfeq8CI8=
X-Forwarded-Encrypted: i=1; AKwUvBwFzv3OrDBrZb51fI5GLSzo3HwuC9wnW+CBptmigNhTxP9tKHzd1pz3huS3rnNwWUBDsDG1t5k/OzS6XytZSw==@vger.kernel.org
X-Received: by 2002:a05:7022:f90d:b0:151:7831:e403 with SMTP id a92af1059eb24-1ac5b027fbfmr16236304c88.13.1793714364464;
        Tue, 03 Nov 2026 05:59:24 -0800 (PST)
X-Received: by 2002:a05:7022:f90d:b0:151:7831:e403 with SMTP id a92af1059eb24-1ac5b027fbfmr16236255c88.13.1793714363382;
        Tue, 03 Nov 2026 05:59:23 -0800 (PST)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac18458e07sm41658755c88.8.2026.11.03.05.59.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:59:22 -0800 (PST)
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
Subject: Re: [PATCH 08/13] wifi: brcmfmac: Handle larger firmware band lists
Date: Tue,  3 Nov 2026 14:58:48 +0100
Message-ID: <20261103135856.3676311-5-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260925-brcm4388-submit-v1-8-b5cbc2cde2fb@gmail.com>
References: <20260925-brcm4388-submit-v1-8-b5cbc2cde2fb@gmail.com>
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

On Fri, 25 Sep 2026 23:43:43 +1000, Michael Reeves <michael.reeves077@gmail.com> wrote:
> From: Michael Reeves <michael.reeves077@gmail.com>
>
> Some firmware returns more than two entries from BRCMF_C_GET_BANDLIST.
> The fixed two-band response buffer cannot accommodate these lists.
>
> Use a larger bounded buffer and register only the 2.4 GHz and 5 GHz
> bands handled by this driver path. Ignore duplicate or unknown entries
> so they do not prevent wiphy setup. Skip unsupported bands in chanspec
> lists and scan results before decoding channels.
>

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Regards,
Arend

> Co-developed-by: Hector Martin <marcan@marcan.st>
> Signed-off-by: Hector Martin <marcan@marcan.st>
> Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>
> ---
>  .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 48 +++++++++++++++++++---
>  1 file changed, 43 insertions(+), 5 deletions(-)
