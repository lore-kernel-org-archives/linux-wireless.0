Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793590243;
	b=agLU4p8njRAHbhd4l15omQ+Eh4TU0eqtjbtHnhdqyPy06dAK+JV/ILyK89Qas8WWgCgi
	 gpOSbPDSvCN7RzZofKyxAsLUw0I6IRCYelV+CqmU0k+9zSvrJrICZVuQlic3XE5+KWmVo
	 w+rTdkeDKHMRC1XzW7AtadvKxXEt5t6tob/FzFk0IpTODGdPgqado9rPmNkX+M+YtyXxj
	 vny6xheNxVDw2hUqnjRKw/4BKdta5OYTaKQq4zjq2rfBjpvw3IpyzOo4eZFjuHKp9FVcK
	 vhiAfDyEUmgC16fx53nTL6Yrc4vk94GHhpo4hn/K+HaAv+VU7aKAOOLRF3bhQ0Rct3g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793590243;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=eMG3qzj/K1IfjUVt6rPED4KGZ+DREF1ZZtQ65RcHUus=;
	b=mveu8a4bsmzPpH8OoVaxjtfyZNWogTXWHMmDGrdiF73QC+kABvDoGZQ9QUfphymbn/wt
	 D/jr7THEcUvTz+dJ8VMubvddinSy0kUHZIyjyzcVZKR6iB3rGqxm+jHYS8OuYlRnyzXTS
	 2WlwlV9+O772CndM4meCuF8nR9H/OgNzcXsRZ8JPgaNZXyfqTola2XY7KSanZb2o3BoAN
	 cNytWEy27Jdnvac7DYfg8nifTrnQWuhfBixtgFzBueoJ1i/vAtQOiH9ZGNmI2JFJBRMT2
	 eG43Q0Gv6/LSBEbPhze7x4oGccePNM3xLgJ7GjG+TYtl24wYtPOPWHdtMxuckoLTXOA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qmlaK9vb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.54
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BBA606A326
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 03:30:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68BBA606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qmlaK9vb
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-475920b9ca2so581955fac.1
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 19:30:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793590242; cv=none;
        d=google.com; s=arc-20260327;
        b=FV2KaEqIvP2oV1P/82RNi/D4UUBzcZs7sbEok7v+e7plXaihXXK9she3rqRGj7H+7E
         WzyLM8aTttaUq1NxXwLEC2zMsGJ5nVXbCmptuXpm+HbT5cVpe8Ka4d3RKp47mqumbHXR
         R8f9Jv/3yaeWsaicnauiY2pUMKS/w6wIS+tR1KGXwBxev/qMkIn99TtItCfacVkibOIe
         YBG1mLDH9tW93udLF3qy5vr2jQzMiA9ZunzVKQr0ypCRYirt3TofasGcNEvR3PKH9lJP
         UI/PCl2odK6Hkjxr2VtJF7CKu5Ao2JJKzyh94eS4TtxQKyeM3SBSFaF4VONoZVMbEWcW
         xgOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=eMG3qzj/K1IfjUVt6rPED4KGZ+DREF1ZZtQ65RcHUus=;
        fh=dhkAR/4gOrYl5w4je/lt9cymy6UBUNMw1xPz1LpQXVo=;
        b=ga0sh14GLKYEEZLK6tz21oZYXuFStMO0EnRj0EoTUQs2l3xBY6btTxwhr0avUir1rX
         x+r1zqq8JAZCGEpsBPHpxi6Q1/kMemAJ4peaBU9NMjooym7MolgdSs42g9Cywj8gsxTd
         DxMA36HzQ7s3jXgE43wRiMt+CXbaI3d9ipbtbyYwbDg9bQIgaSEwIhuYboy/UUpbNIa+
         eIcaQYqx+zXh6UdMjW+8iTqlKAkqDh6Ntmn1KEIg+5hPu9utJsixU4m7xQIitLBNj88v
         eb2Vv0wknknZ2+bivqthF091gJa///shkT0NIJcxuypI1m1if1cvXgYfze3g+UEEhQrj
         Y74A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793590242; x=1794195042; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eMG3qzj/K1IfjUVt6rPED4KGZ+DREF1ZZtQ65RcHUus=;
        b=qmlaK9vbjM2P4NYVJt0RHj55P3y4S+mGZwDeTnQV+XkPuXx+/zuxVCr/MudVzy8qwY
         1geRWP2CKMdgYrdDvadEBrdD/pYmAg177C2xXxBr0aN+P5pJJ1WRrI1dnT00t3j8CYZK
         WOzymLofZ2kIh6QZQRbYjq2rW/21BIXTgg6O0js5djEd5me44LtsTRDVZfbvoHS+QerS
         ZsuX0UIKrp/xWR84IgLg30agIbGoZavQU1zaBCqDjBPcdoPDGck6ABM/CFsYGX8ru7gN
         /NOq5REmOCUqrw+8M3hs80huMOrvKL+pSVthktEONjAtyIoEqEwbQPb7wF1S9qZRGy8+
         XXww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793590242; x=1794195042;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=eMG3qzj/K1IfjUVt6rPED4KGZ+DREF1ZZtQ65RcHUus=;
        b=CtqX1BiE4ULE+6Nmgbl9YkulqDMx+M0PXKvPghRiWP8AuxPR3D0g8ocQ1bFWExBReu
         ty7uMQ92ibli7x2TITNgOGbx3uja0MwCTnpK6sV/drBolcBUeoLx3k1AHqLiB7uuWK7K
         t8Tj2tyALZGvEfHnrrABQPEAdJKMSxS1JztG5EOElf3zc/VU6NsPxNF/veRlRnT2+fmt
         lUEKH2XIMtzgnwuo6520+N8FITcOuhX04wx0NclhCW3IHtFLXZxBO2T/P7xNidLLkiKM
         ytK3oUSwTCQkADdnPcN9yZkL1dijZdSN//N+ca1Z6hZlck9PgpiRUyvL/rcsbixFCpwn
         doqw==
X-Gm-Message-State: APuU4Z+bv89g3YJgLpKYoWkHilKE/pDO0I3x6eQf1TUKtRKrL3Imz6bk
	hbDSnGuSPXTsPoEY3/uX+41HIEV5onCtf60YCwb00iqq/619eCEduiln4FbJbUGVROg61ksYLyB
	OLe+pYAFgSdX75YAESed7es5tCaXnnjE=
X-Gm-Gg: AYBFou1PxgcBDb5+m7d/i52X86HMQda3UFZcbFcjQ1VFUCYM0bbquA7r3MUKKv7F127
	+v+pwlsN21Yb36Nq0hYw0bJQUL5gW/35FPQ0vXMs2XF5zRVec0IhJ42j67KIpx4IhF+7/7DtzD7
	6FwiC8pVg0nhUvSmnqSvqqykaF/oVQ6uYXUTExHYqlqazjSqEw20osS1b07JolJybUExmUEO0Yx
	84I/QhsJlawcBcwP80XfmdbzVQaYzHJkoT7BvjBQzg4i53j2z/t5OZRWClXzQS7F9aNXJCYWOKP
	Q3l5r2PzQcyI2aiItX6qiJu7tUMXobWs3NJ1F4tONZp5v8RM4E4LZOlicFivBYBp/ccJV9SLUZQ
	SRXJVvvM3xJw3+9usYi/juHK2COrxizKehYWcIxGUN5R6Ev3i/kmeIzdTdAikvAJVmOdoN6KNBL
	Key6gLQ+/uVz4BQG9c+Q==
X-Received: by 2002:a05:6870:bacd:b0:49e:6fbc:cd5b with SMTP id
 586e51a60fabf-4a9077a2827mr5613306fac.55.1793590242334; Sun, 01 Nov 2026
 19:30:42 -0800 (PST)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261102032425.8249-1-hjf3108@gmail.com>
In-Reply-To: <20261102032425.8249-1-hjf3108@gmail.com>
From: Jie Feng <hjf3108@gmail.com>
Date: Mon, 2 Nov 2026 11:30:05 +0800
X-Gm-Features: AclHuK9UfW7MVkqaHjMNqDVksfpjO7v2dDScBxd8n0Y1R_iO0ssIBL334H5ZSS8
Message-ID: <CABOQOSWF25LgAw-ccQtMqhEyguGwGa5XS6JQAVLbo4BRiNjcXg@mail.gmail.com>
Subject: Re: [PATCH rtw-next v4] wifi: rtw88: usb: don't report the
 aggregation buffer as a frame
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>, 
	neo_jou <neo_jou@realtek.com>, Hans Ulli Kroll <linux@ulli-kroll.de>, Kalle Valo <kvalo@kernel.org>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

Please ignore this v4, I forgot to add the reviewed-by, will resend.
