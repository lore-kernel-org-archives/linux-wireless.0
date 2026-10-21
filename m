Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792599624;
	b=F2bRUH2WeqHoluq1WH0yjtZuQPx+JakaViBW2WKS590sUUJDDJaABRvv68Uw1KN8HDeJ
	 AgNW51XRGkSXBrx2YF9MZzZ2BiowdksSvGBCsn8lcavMB3Mw10KOE4CcyRdcLrmlllgdt
	 sJbChNUiFXl4pb4IJs+EZoZkTyT09uQd1Y1IXS5Bj8dma/eQszsBvEoUScEv2jFjOdG9M
	 iEWyjQOypAuyWN55wYoLXKufmEZrOYgeWEqORBqGz4nF9i+qSJBcQLONX4qnRLamBtVHb
	 n3gEBQjk7Yq7oLGueXvGq76zSPiLp5KxyouYpDBN4PM36zg7aLWcemlqjaP76IT8gJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792599624;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tanuq6pdo1p+/CXclZjkrZ4cpxXAXmw+CC7txW8gGPM=;
	b=HrEEVkod2OmMj6tj5kO8QNkPMJMlVTtMclHbSRr/f5gVk7pT1tf4LuFT4K1RnfMaD8VW
	 Gy4v3t4BxAjiKXiQgjnGD+BXC1IPq5l2ZvA/zP14l37LE3K+zhx4Ovc3fa9ahDaNbIH5w
	 by+60AOrBcqMpiD8q26KsYwepJINotVKE9Pc8Znld6wqj4t6Vl1CJxxRlegvdeErJ50iX
	 F0zYssc9AqanSUeqwQPV87AjFpurA8/yfILZZFWTyxqyEcvfIRLjSOx/ynmk3eGYL0MDn
	 08j9MzIPISG7+R0Fc36pfv8cJEXTFYo+KzY6OM7np2x24GnTCTsTnC7CbEQDymvfzVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=IufIiBVr;
	arc=none smtp.remote-ip=209.85.218.43
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DBE606A31E
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 16:20:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42DBE606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=IufIiBVr
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c315869241fso115606866b.0
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792599622; x=1793204422; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tanuq6pdo1p+/CXclZjkrZ4cpxXAXmw+CC7txW8gGPM=;
        b=IufIiBVrHxU9E82YvriVCaCkao5TdI8rYykhZwQrLX6M3zxHF8MDpf/kT3tuF+Pz5R
         3w1MunUA57C9pm3ptz4F2YCeZHJVw3BXCVBhVI/POagEnHiYqozuoMNPP/EN6geBqQ6Q
         YmScDrql3MQtJKxjzemzYW0EmYeAm3cclzwG7pxKFMkB8FvZcEeQK2g+ClEtACjjxy3K
         ogkcqfxUT70Cl3PUlss7L9Aa41BYZSVCCR0LM9snta4z2I4cDhEPrsi0dpJfmNqSfz3j
         BODuwASwjn2gQB0QUoqwwvj8rk9FbDCgU6Riam5cAhzEdCozhQo7/OmEBwflU3uc48RD
         q0wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792599622; x=1793204422;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tanuq6pdo1p+/CXclZjkrZ4cpxXAXmw+CC7txW8gGPM=;
        b=Tr6+BfpPwbk1yIM52bWy7+zzHfIxJKTDzGrj3jyegJK4X1B/TFBJq5HD0ubAZAdlx3
         rJ6OrJ7p908lr6bjm8ZsMdbGiNIZ6YECZDOMU8g/TatQz3kNh/fI9wgcxmqIAkFWVJbO
         zz5DVti9G0zTUrqrqel/JnQHgD/Yq31HFzb/FkHZDg+BuZ1akMMerD72BRoiprElfKGs
         8jiMW26FWAh0jb2MYiHSHDGU6fZI3tyzL9fqhYZvAaaWfJZYzKCLpvz7aLlEoPkLxHLR
         g0EgD6uz5LPKZg71FKZE6iotNstu/adGqZDLqowNYb/LFj1Mgnx7Sy/eoTQnbUXvKE6J
         EBMw==
X-Forwarded-Encrypted: i=1; AKwUvBzMero3f+aDHVWeWEFZRqx4Gh20+hXSjnMEUNzqO3t/qJqUDigJSPlPnRzHMNs6O6uypj/gUQxwYKTKCIkqPA==@vger.kernel.org
X-Gm-Message-State: AFq9FYIyeFmnjahkHkmsFYKmE1V2o17Mb/nsykGLyiPrOIDxNyvEAHSi
	hOj681Tx0rq0VaOPW7O+nqXZ0g507HzfMPJefTYnyzgDBTzM5JLCNDUqvvztADimOQ==
X-Gm-Gg: AYBFou2KKDYypjMyeoKoWWTIp7DbFOpGMr2hTYXvVPxUCTULdBxqZjRN6y/rXwqRxSX
	U8BX8NyoYoKRF9YdiXttJIxKqCgOa5Fglh3Xm3gpQgH1REnRxM0Lwn5WMX584t89hfosbfH7awC
	7HIAWFEqc5TNmsj8hTnm7u5tMbZwlLYEh/yjfBTG2THewPpyZkhE+rFyk6GLk7sFJUC0gQLpA7r
	JSHvrI4qQlpP3N6BzvgwfaKEgX/iq0GIpiSvG0Rd7XtrjSfDEU/MfJMjGUsii74J4EHZ7qdrd1h
	JsIiGQkdfptQk/J5K6LanYP/gPPRbIAcN5Ac4cCD528M/JRKVKXc6XOHX8/mKCvafVINyYr3J8F
	g6tYCNzcOppc/j2fK0V/enLfVVXDk97PDeXfZyevwPAxh2PNQ1+1/BTfZYtYvTLg4kjDQCSWt1C
	Yb1sFHWDqJQoGSEM3N1Dua7olOvdTi5d/PAr1DjqZjWLNTG6Lf2mxeV4OVPi2anKLUfqkMLuHcj
	GWb4XY9R4JjU0JeTnOagEqJjEwT/J/NOLWMT8leFCiVkRs6K23xx2sss2ZE5OMNTZ4+mJO1KmK6
	2bd67YkWioq9l3ZTrmUxvej+w3BKiMFee7TQsdkj20Il8kM5Shbylh4wXxCYJQRc7cufdx0g3BJ
	GJrF/t0vKkdOFmd1Ng3zjxnCKez+TWWKEFq87hyATDOyiPLyhurIkFTXZHt7gks3EMke80DFcbi
	Kk80Fy+bx9fCHHB7MRzn7TKjhoqW6F6WFfb1EtUqaLqqg/A8Xpqqc/7UIwF50iy71TIBDo/qthr
	e68mQ4=
X-Received: by 2002:a17:907:86a5:b0:c40:f89f:d91d with SMTP id a640c23a62f3a-c467977fc0fmr243410366b.28.1792599622338;
        Wed, 21 Oct 2026 09:20:22 -0700 (PDT)
Received: from Desktop (pd9513e2d.dip0.t-ipconnect.de. [217.81.62.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c468a59d641sm18138266b.60.2026.10.21.09.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 09:20:21 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: rameshkumar.sundaram@oss.qualcomm.com
Cc: jjohnson@kernel.org,
	ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wifi: ath11k: apply the 160 MHz NSS ratio to the radio
Date: Wed, 21 Oct 2026 18:20:20 +0200
Message-ID: <20261021162020.280802-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <b5fc72a1-71c9-418c-95b1-897a62f0c6c0@oss.qualcomm.com>
References: <b5fc72a1-71c9-418c-95b1-897a62f0c6c0@oss.qualcomm.com>
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

Hi Ramesh,

thanks for taking a look at this.

On 10/21/2026 4:21 PM, Rameshkumar Sundaram wrote:
> On 10/11/2026 6:06 PM, Julius Bairaktaris wrote:
>> Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1
>>
>
> Fixes: ??

v2 adds:

Fixes: f552d6fd2f27 ("ath11k: add support for 80P80 and 160 MHz bandwidth")

>> Assisted-by: Claude:claude-opus-5-5
>
> The model-specific "Claude:claude-opus-5-5" attribution may no longer be
> required according to the newer guidance -
> https://www.kernel.org/doc/html/latest/process/coding-assistants.html#attribution

Agreed. v2 uses "Assisted-by: LLM".

>> -		tx_nss = ath11k_get_nss_160mhz(ar, max_nss);
>> +		tx_nss = ath11k_get_nss_160mhz(ar, ar->num_tx_chains);
>
> seems ath12k has same issue for VHT care to fix it ?

v2 will have a fix for ath12k as well. I only have one ath11k router,
a Xiaomi AX3600, and no ath12k capable device, so I can't test it; the
ath12k patch is compile tested only.

Julius
