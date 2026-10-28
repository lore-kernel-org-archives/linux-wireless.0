Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793154151;
	b=WrA4fRxuiEQ0D7dVK14+kBbfRg51sMrQFFIjFuqZrp4sOBCSpuHgZ+20EtpmmPl1GPMX
	 aZiMQiLK2QrkZh7Si8MrOcAfJRQqP7xKT2c0/FDsPFkVydyvgg4333ypf7TVEV7bjsZud
	 2mA+MUMnr3wCTXASTpSj2fg1YwucVpmqgicsKMUpO+ZMD+gJBHW3arKVKM+673oIIZXCN
	 5uSJ/UWv82A3QeUFCLaDphjmc5xFw2fgcYnhFzMJ8UZQuWeuwWb9eqWMCo22SK5srF8lA
	 O9/6dgwsa0BdlTZuGvoIpJoKEflEhSehfhh9fL2ebOz9unQXh95zfFHI1ILtHmsG9+w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793154151;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:MIME-Version:Received:From:In-Reply-To:References:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type;
	bh=NYvMin0g8ymcP0uul+DR8fa2PSRDTRd2iZ1r234Kwqk=;
	b=FW/Wy3XDA/Vshxbip5enbDsrkdocQOfgMNpVr/ezR0HQzZIQ5JcPIMbusEtf8Ezxs5YX
	 U6NUZBLdbPaornScwM9yr0S6290sr2s7fnSZDTVYffeNgrCF5YQqKHOzy9/VOIaaZJ8y1
	 cpeQnJWjILIXzKy0U9ZhlmhzpaFcmuodJ82LiATXKKKXmTvb8bxT9KUuJgF4xJzx9LFrg
	 obFBrw1ZTKmdB7JBNCyFpae5lxOFCqHitlzXQ9pg9dCYvbxX10JI6fjYeET2RaGZNs46p
	 XwLJFpa4BNx1uvq/Gx6ocEutCgcK1/cuVCo6e/ReEmQwuSruw/q5yG2bNA8/uRJFw8w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qwNLcRt0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.43
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8965606A31F
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 02:22:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8965606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qwNLcRt0
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c414e5d282eso57919266b.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 19:22:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793154149; cv=none;
        d=google.com; s=arc-20260327;
        b=ia2QQ2zprF3Kx5WLuqohvAzzVknOlolMNca3y4UzkBuUCDWHWrRTLgNlZL3OiyyT5e
         yRqQBV0GJJ7FCG8cohICRIaQL7PPJqYajWZNSUjDi2Ppf3rmVSwu96xx7Ub04bn/TYqa
         Agcw160ItZG7BWPyycIbNjPfrgZzKWYjPeRPNkV2VT0A37AGHJ1MZeoDTM1Mqxa3Q6F6
         1KRgfiI/aEhxe1VWli/VLJT6GFL0WFKWJJ9LkfyNcR0zbDmJ1DCdfh/cHvvJXpiW/ZVa
         yahcAaipcO2ziOv6cgiRTqTI97kHjVaHC9AoB1GcPdvJOYwZ2E1elvD9uBpuAHdqP8QB
         sDpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:references:in-reply-to:from
         :mime-version:dkim-signature;
        bh=NYvMin0g8ymcP0uul+DR8fa2PSRDTRd2iZ1r234Kwqk=;
        fh=BR8WCkwwLT9HBTQjppfrWTgEdC5TiFXj0EqvJio29Uk=;
        b=KmVIje9aQyulIt7SP0C66Lwb1HzJOifbOLMV3pOd4Rre+8ZNAMez+2UXCXTA2fbIgR
         mRlBocTrn8ESPzOAbShURrBrAVh/6FZH/JReqo8g20jFeC6KaYCvG5D9ikVZTYKzRHdG
         8iuOl0YgupYz+Ug51rr28jET6c7RnlV/ao0F+pXGQ5uXacd7ABOOWyeAjwfxa1F6YID4
         AljrO+BXMkTpxxlN9LgdIDWkTUTJxwnxn9v/XWTs2cL/uvzc59SI5pW3sTQaJh6pb4yf
         3ZGJ3Fcf8cC+orn4h+JbvRrLopL0WIdcm26z4cLBnUmLV8JJIUr4wlVSR5lZ9yuaOUcA
         no0A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793154149; x=1793758949; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NYvMin0g8ymcP0uul+DR8fa2PSRDTRd2iZ1r234Kwqk=;
        b=qwNLcRt02XtpNSLeIqwxcaHhnnCrJUfUt4Kud9y43NP2UoWnG+ZzTmUbwiClH8Yz0Y
         tDJsckTwzlkYJ6BQieb5J6EsvuaYOFsErIU8U0bHjRj4XC+LWQ2sA9gciOtiS2pEsZBf
         8cIilm+p5tDxG513pmN1o8QxpTYCG3naVZx5n4Unog41ImfpFgZ7e27FVbfSRP5CGdrU
         l4ivr3u7Gch/t0EwrjvoQVZ3C1+X0G3ACpxt62AJ1+RS9IsyFUb1xZ7dXFgC3aDxiC7e
         PX4vByscdi00XuNvypiG1vU7XGlHKwAO2jjILFIXPy720KdSilyAeTUxFii+JDOCaK/h
         3WHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793154149; x=1793758949;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NYvMin0g8ymcP0uul+DR8fa2PSRDTRd2iZ1r234Kwqk=;
        b=jUJn0+Z9z8O9YoTg1aGjV4FRRNz57ikT4ZFh97oZLs/uBUARdWkUdiHedjiKV50KV7
         FaXSPiuivvUqQrkaVWzKUldCtISe9EfKNvc0+vByAiTLaCeku61IZxbqQ3lUX1myFWR7
         zzbJB0btp2kF576zX8Nz63XhjiVmxVPRxfnobp6ibzDKqie3mv77lZsedB53rcm6rWs6
         qdnxgUcN2MLNuJhW2nNTLC9UZsJIO01wXlOR0VVhk5OFfRl7nzWzFtFdPW61Z5qfTQhK
         pnFx5Lgw2qC2xJvKNFazjM/rS50fThd+00KW4cGH10Myjuaw3ggqb5vY13knUCze+jMo
         sW3A==
X-Forwarded-Encrypted: i=1; AKwUvBxcNgiElu0QHvNu/+RriH5ZCQK2mGndUlb7PYnQ+exaJYZGSLxppWUEGEDUSK+jTyta16u1salQ4y8cMBiZOA==@vger.kernel.org
X-Gm-Message-State: AFq9FYJ5TUg8Cz2RfgdqZAyA1JJkWhtCt5KnRrZQ3rflNCr7HMUge2H1
	B1cSZs4Hui5NF30DUAuv2u827f/HvWC7wdI5027IhPtmWz+aUbRWbTO3vuk5eh1SMcNzIJjk37W
	4PIwwwT6U4UVqi7ucLVzPGlkOFLPM8W6STQE4
X-Gm-Gg: AYBFou0qDYnWdJ31gOoKTjkYei0T+tj8vpQnpd6CnOT0YTHF4fCjxZKQ81YWe0xaDLb
	7zi9uCjqrXQmSXdmR3uvnnY4cxB6wqRAmlHSSvaAeXMt85cXlYaoUoeJtKUi0hPYwKGJsBg0V35
	JRG+jyPlVCghZ+iZcETptOJj4siWm1zWdXDZABn2O3W03WeSJQDIJcralbbOUUrasgm4bmJlFIo
	DUzloMtg4Xz9Ux9o/LmTt8i9sgqJLCnC9jGAOfJL5rTI3cUMOqaymiNvPKWUcv+V0A/LcjrMiP/
	PLLwl0AYJVit3F0maY6IxYCobx4nG066lT874jAvgHiyXwHQYQSxncb5F4ixecydsFADrauwV1i
	yfZaulMOmtTWv/6YBU3NZDfzSxbLppBVVOBCw03NwV7v6wvH1APWu8YHD
X-Received: by 2002:a17:907:d92:b0:c41:26b8:c49c with SMTP id
 a640c23a62f3a-c49bdf0b4aemr67593066b.10.1793154148940; Tue, 27 Oct 2026
 19:22:28 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 28 Oct 2026 11:22:28 +0900
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 28 Oct 2026 11:18:17 +0900
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Received: from 77377267392	named unknown	by gmailapi.google.com	with HTTPREST;
 Wed, 28 Oct 2026 11:17:14 +0900
From: John Macias <dencity7@gmail.com>
In-Reply-To: <CABkEBKZtaWkvxbhnOPBUjbh_iLx-Tyok0PskhduQk4O8qq=NVg@mail.gmail.com>
References: <20261025181955.2089498-1-dencity7@gmail.com> <CABkEBKZtaWkvxbhnOPBUjbh_iLx-Tyok0PskhduQk4O8qq=NVg@mail.gmail.com>
Date: Wed, 28 Oct 2026 11:22:28 +0900
X-Gm-Features: AclHuK_wdqnes8SIaBY8bLjvfS6x7r9wSEy2FronOU5EXeAQCT9oMMUCLEmzc4I
Message-ID: <CA+KzPsoFGBe4PBJgjKQf-u+aeS9ckNALFjEkra_UoddRS1TPVg@mail.gmail.com>
Subject: Re: [RFC PATCH v2] wifi: ath12k: service all RX rings in an interrupt group
To: Tamizh Raja <tamizh.raja@oss.qualcomm.com>
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org, 
	Jeff Johnson <jjohnson@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Tamizh,

Thanks for reviewing this. You were right to question the grouping
itself. I am withdrawing this RFC.

The reproducer is downstream only. The submitted base and ath-next at
7b14c8f4a961 have at most one RX ring per interrupt group for QCN9274,
IPQ5332 and WCN7850, and there is no QCN6432 entry in that upstream
source. The downstream QCN6432 mask groups REO rings 2 and 3 together.

Its hybrid bus provides eight DP MSI vectors, with ext group i using
DP vector i % 8. The mask uses groups 0-5; empty groups request no IRQ,
leaving DP vectors 6 and 7 unused. The host programs each ring's MSI
data from its group's vector. Moving ring 3 to group 6 therefore gives
each RX ring its own active vector and NAPI instance while retaining
the original single-ring handler.

That configuration now works on the Slate 7 in a short hardware test.
The tested module was built from the 25 October single-handler source
with only the RX mask changed. All 16 four-second single-flow downloads
completed, at 890-1166 Mb/s; the old mask and original handler completed
9 of 16 in the earlier 25 October test. An eight-stream, twenty-second
download reached 1208 Mb/s, with the slowest stream at 72 Mb/s. All
four REO rings received traffic, and the new DP-group interrupt was
active. No warnings were recorded in the valid runs.

The driver reload also needed a Wi-Fi reload on the Flint peer to bring
the backhaul back, as it did for the installed module. These were short
tests in one session, not a soak or a measurement of CPU time or
locking cost.

Your other points hold for v2 as posted. With two busy rings and a
budget of 1, its fixed descending order serves only the higher ring;
the lower ring received no service over 100 polls in an offline model.
Each rx_process() call also takes srng->lock, and an empty grouped
ring can be visited twice. I have not measured that cost.

For the tested downstream configuration, separating the groups avoids
the need for this RX-handler change. I plan to address the mask there.
If QCN6432 support goes upstream, it should use a suitable per-ring
group configuration rather than inherit this grouped-mask problem.

Thanks,
John
