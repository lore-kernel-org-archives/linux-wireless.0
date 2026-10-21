Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792567466;
	b=RJlNanj1STMHSQI+ZKY805GA2ng79r2pGk8+ctMKA/UkRWsrctz0POjxfSHHl8A+TSdW
	 uDcLpRUZprQO5xalNFiwG1nf0SDvOlPi4kvXnxH5awUcSUAvqqZQsfym5E7qC8B7fNSwG
	 E9a5i/JwutSUNLCN36GrMZIiiUlIV+ASQPV5spqpWIlHIcNxaQATEMrPo2F23hRcDImjj
	 RLnGcqN3Vh0FJVf5fZWEGidVKwdyltYgUpyi/ptenY0prDhIbtPYtIF3ihOJsVtIjeEJn
	 /XLejZLTV2luIjXO7lPdFuwHck8uUXAO+lWNa8SoyRrOEKRjSbSKIAwW+jSz9hmWmhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792567466;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DfpMKp5SVl95BmunPA3+9Zd5WUKrXPlkJ5zT+lTuasw=;
	b=krMDNE3dkzWkzLb6w49MlZkIvgyDDEKz05QUbocG1OQyfYUuojrqUG+7zS1T4oqHJLow
	 KCflI1QqvuK8oCWoAm433VojXXJE6wjls47e/OyhzXivcnvGROZ+L784z6VI5CPE2BdEk
	 PhEr5ez8bY0Ht84CawnwYmC/IUJK5KWOR9wwFYH0Z333iHps1X7MSU62zErO/co8uKnE+
	 UWd+IyyL5OZQF9k8RBwpCPaE2XjjpEucQtM1x+RnsiJZrOnL/7GqA9iIWhPQd64ru0fW0
	 l/NdGp1d11mbjLLChlBhNnrA/H5eWbBu8AvPXvGJkK6/3edv6ELMTjiYrt06ZQ/gjXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=N0EN+m+U;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE75606A31D
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 07:24:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0DE75606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=N0EN+m+U
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48bbb06e746so159588f8f.3
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 00:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792567464; x=1793172264; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DfpMKp5SVl95BmunPA3+9Zd5WUKrXPlkJ5zT+lTuasw=;
        b=N0EN+m+Ug4+56UzGDul5oSi9w3tJ3rrroIcexOwfn4C4foBx7DZkOLmXYt8zL48D40
         FERKbM4L8aY4l2IrIRpfhoUUdsLtYMVJo7b0XssQykAEIXjQoYPzPvVTFJ4lIc9N3x2m
         JY2tCRtXPXfgq5qRr/w7M/VqsLKrWoi7let/egIeed7wVWJgWdGVsGV3F/GWzScwSQzx
         31PN9RxZS8XW68zslWFbSRV1PpJ8nC/Osl9I7Kl05SROynybG47tYYw0/OYMuGr3OYFA
         tocXwMER93nadiUfbUjOvUol1rNpvJ53DcCN6wQKBtj8tfD3S6cCFgw2cx/pRDTZ0PkX
         4Trw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792567464; x=1793172264;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DfpMKp5SVl95BmunPA3+9Zd5WUKrXPlkJ5zT+lTuasw=;
        b=aoUV9jPYWKFPcYOMtrxb2aSWJ7enDVKNti8k5f1MvXCZZG+W8HwVWAdURF0qjid9Vd
         ah6rZx8Z0jRyrzgqQwX58FtBLi0Ccpf+i1aK/DqXKBk+evnm0nImlfDgmX8aqpzkKgsW
         G3m5FuREv9bHnB/fimfWTH1u+5Nq620/LIBLRy13X7r7ury5FYbsRP8DF++yrGD8mw4+
         /wvX9DyUNzm/oAWXMnqhzlioYKnbj9Vaf57GIWmfE1uFAcaRUuDwlzkkbbRJJd/q9Cq4
         n0bmETWlUy+a3BIfFBseqJ8jS2GTlPPZvrgV48QDmoz/THxFtnHqqJBlM3++QdZXjp4c
         Zimg==
X-Forwarded-Encrypted: i=1; AKwUvBwhrwvPwVyuXe/SeZhrXO4unuQ/y/Y4fqRIr/bOYxYYRbYXfZWMmYWQSHYZUtS1dK8cwXs3VBkA7dJjpOE8Hw==@vger.kernel.org
X-Gm-Message-State: AFq9FYIAlmrnsyh6TSsDXejDnmwXrMy4NUzomtxr2lfp3cYlMTuF2IMC
	AaKWmWwLesbQSkujlaGE2n/VrAqdlGGPGrpTpjAVH2JUg6dqZ0ysMVyA
X-Gm-Gg: AYBFou1ol2MtnLRK4CxxLlOWUHh/ls9OC4jPZha3QiIhIIEoCsnzm7gq5RHOn3e2nDc
	KMYYgJz2q0DfoL95W5HEuUM10q4IOZDt3MniLTrJHkZAMq5j+JtXGDddCmJMJYQsKVxcJp/jWSp
	pDn1oAwE7iUFS8fdwcGNvwBf8NpS8iSImrIBwyt2A5J/eX1NyXlG322uZCUl949LfGTCm1tT6UT
	Zt21r97vnMIpUbvPlJY4598KWCyIuvHo9eoncYFxMdSsq8yWakUt1pGR8mqV3VrW31Qxbuf3cEd
	CzlkOfXJJc1z4LrSnFVhWGiabkjbpbzUJ4p7bxp7tXSAcneQUIxa8KPLBxNLDKKDFndbep8WWTi
	N39vDIxqtqeK4ckhRIBW6k3/MhT9bgIrgRgRsoP/JzQg5XBW8RVOOOt1kXPMrJEmibwJVy2He3Z
	BMFQmhep4alovtjuuD4QYxvUiA5pL5rCkGOexZDc4TTxQpRGWkU1urSpyqPyBfrvVmcZznCyFN4
	vDjpslQu8IoCo953GS3Rgwz3X9ESqNZa4L1yIvrds34xSw0BAcPZ0DybjFj1do=
X-Received: by 2002:a5d:584e:0:b0:48e:f07:160e with SMTP id ffacd0b85a97d-48e264f32edmr1993337f8f.38.1792567464375;
        Wed, 21 Oct 2026 00:24:24 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e25827087sm3687052f8f.21.2026.10.21.00.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 00:24:23 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: Re: [PATCH rtw-next v7 3/3] wifi: rtw88: time the countdown downloads from the TBTT
Date: Wed, 21 Oct 2026 09:24:23 +0200
Message-ID: <20261021072423.4006833-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <f61cfbcd59cd441da59a16db52512897@realtek.com>
References: 
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

Hi Ping-Ke,

On 2026-10-21, Ping-Ke Shih wrote:
> +/* the beaconing interface is always on port 0 */
>
> Move into function? Or just mention this in commit message.

The commit message says it already, so v8 drops the comment.

> How about setting a retry limit? Consider if hardware goes wrong
> suddenly returning random number, I'm afraid it becomes infinite
> loop. As my thought, at most it needs one time retry.

Agreed. v8 reads the high word once more and, if it changed, the low
word again; no loop.

> an empty line

Will do, all three.

> The csa_tbtt is just read from register and adjusted to what you want,
> but in rtw_fw_csa_queue() it reads again and adjust. Can you reduce it?
> How about adding an argument to tell rtw_fw_csa_queue() that this is first
> time to initialize csa_tbtt (like the restart case)?

Yes. In v8 rtw_fw_csa_queue() takes a start argument and reads the TSF
once: on start it takes the next TBTT, or the one just passed within
the margin, and the countdown work adds an interval as before.

Regards,
Mehmet
