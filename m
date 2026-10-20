Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.231.197
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792530060;
	b=3R1yKIW1Teigjsw+yL4OWQxxtE2B9XXRDLolLEO6QrnnS8N6OR2TR5qtp2jvr5RNnodB
	 OZzEZbPQWPMo8pR6bC7KNMSb0QzKDZgFZreMkINngezzaYA4JGJqXX+axSrPG2TDSNcoF
	 NH1ThKTwxDWEHC0G5g8RU31cM3r1pcbE7yRtyh/a2TOK7abK1aPn9/PGH1P+tmNeQWjjL
	 SfWzj2L1qMgzKwuo+KyEzcf9U3jyK3oo3VtRvlwMFk/TTNPxM9+F5tBHVVKN9kcoAOqmT
	 JRVnCXp7/Ohk0XEj+dGhP+UxK7oX1990cCK36Xoe56xsMkLCBO/HvjXSGhShaIPRGvA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792530060;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=E3HO4v2ppYBHCxa7uFucK6ln/LBk9azH/BeZ/nONaC8=;
	b=0k1IgYIwxVjtr8+o4aYlAnM3A18TULjnQmV7GnzMmCRfKqJ1fdZFsNz0UShuAR303Itj
	 obiwUb7V033E57JFrxA1oRbEvE6eAkHbNE1zltYWbg8qFEMSby13XgdRX4jPQjMoVi8QH
	 0JzhQEvGj4KNM+zAluP3sNyu3CaeVvni+v5nw7HT9RAKADFPczwO6uV7Si3UosBHq9rBt
	 1s23qrRCrMzZuyEnBWzuwmfFALDHP/xNSSV4Hi3QWMKJEPHexuyPrF1u3TeGiWXBCyZJJ
	 7mc0U1DfyDpsGr6Fn56GfsKNL2KbX+xrQxMjDLpEI2NwCYNA4eaBGVKqtDBgVKLeZMA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Cnu1oGDL;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.231.197
Received: from mail-oi2-f5.google.com (mail-oi2-f5.google.com [74.125.231.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC660606A321
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 21:00:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC660606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Cnu1oGDL
Received: by mail-oi2-f5.google.com with SMTP id 5614622812f47-5413fa881a9so27800b6e.0
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 14:00:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792530059; cv=none;
        d=google.com; s=arc-20260327;
        b=JMn/Wjiune+FbBiS4frOksYEiDmVcM033DZg9a4fhmyHO3sh7+rbtd8vmBLPtX1GeM
         EdMUIlgsRnWbjsBQdqqt2JvGmcRdSsjqWcdD+rDqmhi79XftftGCmkI3RclhNZpDJFkE
         Dzf2QAG4OeY5lcIQdzPUelyMkT8KhWoVg2RwaWrIM1F5ruAXAGYKN0k3IezZT1OMAffu
         iAEZerD+dS8TkBHbJBV6vUAiakUYHCMW0dxYSnAnaWbUDqwbQfBVnZHsgXwgNNSYT33K
         DDzhdpVCIx5bXOEAEuBjr1hrYmAWw1nWHZLqmhcPpo67UXyHT4wTld1e4lVpJHiFPho0
         BboQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=E3HO4v2ppYBHCxa7uFucK6ln/LBk9azH/BeZ/nONaC8=;
        fh=cC1xgzxzsfKnjB96Gt1vsF8xZQa5bOFjmf4b9VugmVo=;
        b=PTmvPKox3z7BkGQBxyF5y15+bPLjadc1nmAAz2f/PnDsab835zrdhiFWyndEyI/Bm/
         CZAL3WUFTCr4S0CurCVUyqMefGVuxtMz3nruqPLjLtGNN4UQhSftpOkYg5maEN9ziaB7
         hvUjEh2LRbo3e2EuDOkdar+OM9QWbJ1dz5YywpoHo4h959YEYREb6Wd6Vzl2KR5LSu4d
         9aZ6IZhWholHILynBkptTA4NbV2kg5P0crdSF833gSLEm4ihrcRtRECHPo2rmrAH2F6f
         ZssYZzk9rrXqC+I0AJ7kb52ByowYPbnyaQeYdvX/siMDz0IjK/Wn9/mka+3J0wW+TQSB
         HOww==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792530059; x=1793134859; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E3HO4v2ppYBHCxa7uFucK6ln/LBk9azH/BeZ/nONaC8=;
        b=Cnu1oGDLo7LAUHnjnLp+M9CEh6hDRYzv2QGVj3pIytf1lXkACHjzPeoHCw8JKNGI6T
         P2b8MIv/5o61z2vodC6IhJHZQ8VjJqjP/5C8/H7uY5TLV8CY3INHsWo0Dd6PxcBssU5a
         NGPnwQNpiesd4lTubKFfxh80+nJj0QK8RuGR8gW7llYlQmXwzhpLcjbkWVUK/W5mxo9G
         de8Fr0srtEs3Jy2Gn2fb65FDgxi2c4a5zR5Jn8sm4wxTYbNG+yzdeeTm9z/1/uu+eIx7
         B29eqO1L44ryeh7YFGJ6ygqjC5P/bDYlcU8V9Ctjs03Yk2XRDP6L6FD7fwtntdvmf5dc
         VXYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792530059; x=1793134859;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=E3HO4v2ppYBHCxa7uFucK6ln/LBk9azH/BeZ/nONaC8=;
        b=kcxIeOSSt9jxFJmMgd4XQ3QvUG0c2qWLyf89y6ux+3s0TWD1Nxs/UXeB2A3KopsOH0
         PppigaR/AovGyeU50JSESnFqUcMm39GdZ5eA+Dp8MABatY5jopYpCYruocUOxcajqwor
         JonsB0kfbbGkfCTm+t+GiACBEc1kYM1SWgI8772iZExhrTkIAi0VhGVAHJgtLNJJHb+Z
         KzkCK6BV3I2rVrH4cwyRTE71Gpii0SIRVLtS0s+7GjuZD1qLCsMcwdFQTC1F6cQLMot+
         ih1TJP2huZLyvLe+R1TKM3j3kkHRXVFfGYkzitfTGH6F4GKfSl3pPU/RReal3LjVctBv
         xxmw==
X-Forwarded-Encrypted: i=1; AKwUvByoI8hVveiJSJvMUIY5daI2Q/DPKqtr1ASIwZAXeQqAQapOQYq4QMjr6NDDAnXqnrv620+PWB8+NPyDSIT/uA==@vger.kernel.org
X-Gm-Message-State: AFq9FYLe79IytfdoLmTv5gggLklxexk3z1nU8VW0milSGHUs5cuPSDLH
	ddtDnYyaDEsKKnIxwdaxKd1O+NSPqSIxxssyv34tCnc0cIvBlRFtAq79tbK/3lysdNJVfcog9HA
	S0EoKT/PDCisluYM0frcrfL19GWo8hCQ=
X-Gm-Gg: AYBFou2R25LA6RgVIvKH4Eda/c4aupDhKuBco8HZ6jwZhsLhH75+12r2AEfPyUwiEsF
	qJ4J7D2i9vFy7XizkMErU6RipNvED6FH0eOl/AWepMhuI8Spi32rLvKkmXoiyzq1J15o5wy3Wkd
	VtzltPlfOExi693JtgatthGx7L8OJCy8ZrFUk5tFYc/EYd6XZZpW3TPWdi39IvxH2+aO11DRb3u
	nsMR2ARMZUmDYZD1plBiBel4U3qnsxnt9GXA9nEsRfl7tpZujDNMsRzo7PcM8QxyI6N1mkr5tTP
	mYbXz6OsGTBgqSY61g0O2TwL001FKhccLmDaGQobCv12vf60nhDZVADbswqKW9tpQBk0qz02WMz
	Eiju4MjouC55+e7GLtKJKzuSD
X-Received: by 2002:a05:6808:1b0a:b0:4b2:8ee8:8a38 with SMTP id
 5614622812f47-553400a0bb3mr51174b6e.0.1792530058614; Tue, 20 Oct 2026
 14:00:58 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261019165103.5990-1-dennylin0707@gmail.com> <9bde49a2e7794e4fb6bc3ae104eef87e@realtek.com>
 <334c6e785a5d242c6f168d57d042d63b777a242a@linux.dev> <4f48c50cab1145fd9dbd6df6d424c877@realtek.com>
 <CAGEkeHevidTtTNj-qfy6kE_O0wRvqT=F=sG+Hy83BOkRjCUqeA@mail.gmail.com> <CANQ=N_C3+gpQ3O=SXYpRCGTh_MC1y4TEfnxF90SWgUVF_wYPUA@mail.gmail.com>
In-Reply-To: <CANQ=N_C3+gpQ3O=SXYpRCGTh_MC1y4TEfnxF90SWgUVF_wYPUA@mail.gmail.com>
From: Hungyu Lin <dennylin0707@gmail.com>
Date: Tue, 20 Oct 2026 14:00:47 -0700
X-Gm-Features: AclHuK9nvE03u4OiDejZFQMMS-WdqhkSgofSrM6bnKNHfObbE9P6OAasARHTMnE
Message-ID: <CAGEkeHdT1-WwJnF1wTkrrRQRzrEYESOoDeAYE+fiV0gROG+6sw@mail.gmail.com>
Subject: Re: [PATCH] wifi: rtw88: allow key removal when the CAM table is full
To: Shagor Khan <reza1234khan1234@gmail.com>
Cc: Ping-Ke Shih <pkshih@realtek.com>, Luka Gejak <luka.gejak@linux.dev>, 
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> I can help in testing if you want. Since i do have rtw88 hardware available with me.

Thanks, that would help.

Best regards,
Hungyu
