Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.97
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714362;
	b=vO2OeRZuULbwKh+N9/L3v7AbDhf/8zFUjVT+Q/ghODdeH8LOgMQKnuNpnhrAgLSQ43cJ
	 Eay1z4aVvu3D6+ueCp3pdzaNXvWunsc4+m+vV3vY/nryhk/RmW7zo5m5XiCba9XP5qQGx
	 6JHAP1WDlkZJm/gDbmauQCo/bh4Grp9/QQtpGb5425lBHbBAV9yKDKHDcjVRJZ56y8qJn
	 CoHZ+4ainVy4ZAzAi/mZICmR4iq4qt/bZWrHQElADmV90F+FJtm745vYBn0T/Y50U0Dg/
	 Lh4zdJclo0hZPt7VXtAPu9xj8zT7APO5LPvwpS3O3TRyJBnQ0mibb4eai8wPS9YVhHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714362;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=ApeHudjpRw1j4fPKuyoZlTN6SSSk0BmJ7DVYBxcf3Y4=;
	b=XNNWBhRXJizJZqpJ8piYyPJWsdmzOSk0J8eJ5tYlcRNRWVu9dDX5LgjfXSbOOMlXZfdV
	 IlqxlCyCgYAi08hj3GDF+hd4wTEx0p3jflTBQgV64n8VkjD+lzcqKKWCjj8b6NdkGkZU/
	 bbTmjcUsSM5e2hRlt1hbkc2aGGtZ1i7iVCNv1nl65Wxis7FjjeNCTTYVlbDeHY97viUHu
	 DfWFI59p496iFq41D1OWYwOvLRSpx36kLr4WsYwTKFajFZtjoGFfHGWaXMjrRZM0qdz0V
	 bsk9W5aoZ1IC5LDaGrnJnkkKN/Z4qEaiRum/Z2PhPES05LqwJ8t0slwYX9nNWtvP13A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=RLtOpmE1;
	arc=none smtp.remote-ip=209.85.216.97
Received: from mail-pj1-f97.google.com (mail-pj1-f97.google.com [209.85.216.97])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BAF606D812
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 13:59:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42BAF606D812
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=RLtOpmE1
Received: by mail-pj1-f97.google.com with SMTP id 98e67ed59e1d1-3ad2b3b1c02so2300134a91.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 05:59:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793714361; x=1794319161;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ApeHudjpRw1j4fPKuyoZlTN6SSSk0BmJ7DVYBxcf3Y4=;
        b=h0JGja7vbQ6fnIoSIEQ9HwgLOPmZpC10upNUQYCj6P19zlAKQ953BLHgV16HkQlbNo
         MD9jZI/6F/D8vNC556sC8tf5yiME/S6b3mO8LSjCfPRQJA/veEghyIfRe6OS6Pw5inM+
         /XK8Bz5xxB55fTGdrj7hqR/Fr5yursK9jryJZaPi9+/hY4XrWRzNedKNSaYj6frVL7tP
         JlNZsGVMOyoAEmtEXtVS8JWxlMoIkLGA8dP7+/T+iUC1v32Khm4AQhbEHGaf/bqagot0
         UI7Kp5nzjp/hlXSue0zlAIy8ucOcju0ZpJ3HbDbVWvXFi2cJetjgBE5Djr10cGGAbu7/
         HF6g==
X-Forwarded-Encrypted: i=1; AKwUvBwpW717mArNAB7h94dDsgvVKGQcwU7qTif628ESE7HaR/nQSc02stXkyB3SnQ2OQG4OlWPnjubl72X6CrTUOA==@vger.kernel.org
X-Gm-Message-State: APuU4Z/pmjuA/hvYkFVXPUjv/27auG4XNxeXoe71rlAPSF5PJqbsmrbf
	40dvbIMF2OpckrOgIVV9dEb6MYuCSlZ+oaqEmcjITBGmA/KC8bPToqs4fSaUZccDV3IYW0YYM7+
	CIqAtZrOjNOienKrkJ7PbfDmSEact6OdSoDV8iy/4hzwtjg7clYA61eEJqkmdVv+1bmSSh282js
	QSIOTx4jCoovdxrJhJjavlNGJlyDNf5hrWXH7aM1tTHPdIGhAQheNmwY8yZSBGErArR8gA58FB9
	VYegqrYczd6Gx8qVIyV9S7D7pLC
X-Gm-Gg: AYBFou0ivx6hbfu+33TMMtI80s6XoFo8O5AD/Ee9OVGlKsfYIQFK7rRuL5q+Viur7O0
	vB61b6pkU39pw+4ogwYR1UBxxvJSxWXESks5mivrQoruCmuiBk6C/ttW0Xc5xnXIQ49mcHwxEdG
	hHm2zvgHjhrIwY+ZFWi0wjFuWtGIKMF1fr003RYB6PAP3C3+cqSn0L5FpeXt1nIZIwftt+NA9yd
	WqLyDYE69i+pUWccbHNaEm/c8xD9b3qu1/hiHqmqmvuYhUhRJ+kdq58V/j2j1c8K4cOjWr9e5dJ
	tgbOD0KGcgy6DPfNj3Nzgq/kU3/RLDSsHVAsT4YnuRMXMk7aUvExOKcK09gOO11ewIk5q+0UnG1
	PvG3OHMbAtBDycuaVEw29fgSx0DjuWz3KN0xCq+msMRM3cqOpFksuZeFai4GzlLoBxdzvZHa8bH
	sz/E2NELZuA9RUV2S9t4VuJ8WxWucFLeh1yibLIcc=
X-Received: by 2002:a17:90b:4d05:b0:3ad:c482:ae93 with SMTP id 98e67ed59e1d1-3ae897f55f1mr11128115a91.27.1793714361308;
        Tue, 03 Nov 2026 05:59:21 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b07c9d77b9sm1901557a91.4.2026.11.03.05.59.20
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Nov 2026 05:59:21 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-1383723dfddso1110025c88.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 05:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793714359; x=1794319159; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ApeHudjpRw1j4fPKuyoZlTN6SSSk0BmJ7DVYBxcf3Y4=;
        b=RLtOpmE1mIOTbJbge1Tfnyerwmo6zO/iYqBQbf9QWS2xcTOjK0obPShjEMtTt7R7rz
         NQeZ3JrxK7CujzRlbWCtxOO1hHpt9EP+WAqNgsPq6ZaJ2oqio3DzBqqmFTnPcYmoyvy9
         ysRhg1SkNNOfUBU/0ccWKnXhh5FLB+5FNWhWs=
X-Forwarded-Encrypted: i=1; AKwUvBxuoQfKdSoCQVkUlDbsI+ZGVAdfeN4KchbKiYMrgQD4Nk8DYmFwtly8dCGLLW95MQZi/xv8Yx4R3CmUbqeRpA==@vger.kernel.org
X-Received: by 2002:a05:701b:4211:10b0:1a7:99b9:2eb9 with SMTP id a92af1059eb24-1ac5de4e8a1mr19735552c88.27.1793714359388;
        Tue, 03 Nov 2026 05:59:19 -0800 (PST)
X-Received: by 2002:a05:701b:4211:10b0:1a7:99b9:2eb9 with SMTP id a92af1059eb24-1ac5de4e8a1mr19735501c88.27.1793714358682;
        Tue, 03 Nov 2026 05:59:18 -0800 (PST)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac18458e07sm41658755c88.8.2026.11.03.05.59.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:59:17 -0800 (PST)
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
Subject: Re: [PATCH 03/13] wifi: brcmfmac: Fall back to RSSI-only default join preferences
Date: Tue,  3 Nov 2026 14:58:47 +0100
Message-ID: <20261103135856.3676311-4-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260925-brcm4388-submit-v1-3-b5cbc2cde2fb@gmail.com>
References: <20260925-brcm4388-submit-v1-3-b5cbc2cde2fb@gmail.com>
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

On Fri, 25 Sep 2026 23:43:38 +1000, Michael Reeves <michael.reeves077@gmail.com> wrote:
> From: Michael Reeves <michael.reeves077@gmail.com>
>
> BCM4388 firmware rejects the default join preference containing a 5 GHz
> RSSI boost with -EBADE, but accepts an RSSI-only preference.
>
> Retry with RSSI-only selection only after -EBADE. Log other errors
> without retrying.
>

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Regards,
Arend

> Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 4 ++++
>  1 file changed, 4 insertions(+)
