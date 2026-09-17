Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com [74.125.229.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3516547142C
	for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 07:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.205
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789630094; cv=pass; b=uchEjYOk5T5lIOYWscqr0FcRoOShV5flgVR59qJQF8LbyynfkQg9pjSniB3g5xycLBKtHB++yWMIJUE0kznP37nIQvypSWq1bMpguqtZdZ9FLrOQUACZ+4tqcIamHNwr2l6OobrrCi8jGigwJyQFTEkMAOp0ehNcgGLNB4LD1nM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789630094; c=relaxed/simple;
	bh=05elrYjvDIKm9CUVYbNesPAN1KsoJq8Oh1BztpkYF+4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RF/suY/hq/+1wOtLR+eVXTFP8qINC5RMRBonoWYEKf2H+ZFoDD8+j1n+Rq4QSQ8I7IcGppWsXLumpSiJa369uRjtYheSugakx/ACXqWlKykP2jzQRogBufyqOW5wfGu/LE/i65t7NaYBCft4gXdTwgSQd7ahY78dkmko9Mzhdvk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr; spf=pass smtp.mailfrom=khu.ac.kr; dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b=hU45zv8+; arc=pass smtp.client-ip=74.125.229.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b="hU45zv8+"
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b74dbc7359so362529e87.0
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 00:28:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789630086; cv=none;
        d=google.com; s=arc-20260327;
        b=jYjOmT/Z/Z0bFAleM3YgV5gpZ42r+UNFMHRa1vWGyf0Mf+QrDXHJbvhwpmf1NeZcBl
         4EfiOEHR+r3i2ZQRCr3KxtUOmbIjAO1x0QfOLHsO1rDa4zh8TGjm8ZZImjUrCPRmIoXR
         elMvF9v2+7LxcfbEoxq/yLqNkz3dMqURzKeI2fatNJ7AiW7ePnwsdMPy6QLWDidYLEVG
         BNSZnNh/2H4B128Dl3/F1cGOegbFqVLewSro/thQvYYDIBqvGYqTsiOV61cU6stmXK8a
         hixsq/Xx6o1Cx63msRjJ1wiBwSYNSl65HeBTUsv5hd+sj9QN0w9JxwEDb2CX//AdkBdu
         7GRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=05elrYjvDIKm9CUVYbNesPAN1KsoJq8Oh1BztpkYF+4=;
        fh=MhtQkZecYlWmxg3DBRqEiMKK1vmKtO5bFPrMDotOrCs=;
        b=rD3RIQNB//W8ZGJYUnyw7s/4zXDgR+56n558e0SaLpFyLzrwy6ciT+w8U1SVPoHuze
         GNV7IZiTVfNglfieLhASAMbjM6AgdffhmJxsjYw+yppY0x3lk+SmvyTsH5lbm92o/9hA
         suX3rBwxCXqNAOmeKi6s410UnEPPnvLnQXoIW9ssYkvsNkDsd8aqMrYUOvztBAu4TcXK
         5mwJu4oJUFNQd9uFYAuTCbmkWoeQO77npow03MesLqXnS7gPq7sKjhITkUvlH5IBSjqK
         paM57U5jQAgAa8ZiUPZyKm1HCYt+cnNsev2fFSkOduXJ9WxmXs+kCNbw7/BrsFikb14Y
         UsNQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=khu.ac.kr; s=google; t=1789630086; x=1790234886; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=05elrYjvDIKm9CUVYbNesPAN1KsoJq8Oh1BztpkYF+4=;
        b=hU45zv8+HX9YIvOrWXix++fNDtlyT7D9kKeMFKGiRd4vYZjbbWplbQGjITGs6SjlnV
         s/nMD8ODpqMG+TrrN1Ob/D/2sMibF83ZrYJUf03JB+d2DR3NI7bs4guQxatdzxq5M8fe
         3rl6DJx7dNVNqHsw8dqm4EUwN/GY6kVYg/vHc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789630086; x=1790234886;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=05elrYjvDIKm9CUVYbNesPAN1KsoJq8Oh1BztpkYF+4=;
        b=cNbLyE7qdh5Ev3YZe0JbsbUYf9ndM9ZEUeU5g2UFN8zasIQGDQJD1yWQxulDlHPTiB
         JXJQhXAvGGayo5F5v5wW74II4Ume9ghzEX93a+zeO3lPvOtP4aS0okQtAUZMClous0mU
         Ex+9yTNpOgTDx3NH9F8clH22JDz3YFwESe24TucQZerbIh8myuaNwUQ3E5RJq/xiFgaJ
         9XXZtGFUmQUEjryFyATVfCIvKaBMUH3B6Atd0DfTH0f1YamuQh26pojBeBzImla2CRvI
         sSaHvht9mTmi2c68HIclUrr9zZUVgJspbxAnt/alVqLJdQMd5SMrihsrQdIy4Lgyx7U3
         k0bQ==
X-Gm-Message-State: AFuF++l+FjWbDmzwPVlQ6TLJunw0i06d9eEyoj9qblOOAjp1HoUyKqVJ
	F913NXSEqx78R0O0TKFSCak1PpEI6VZ23oeDc9f8/oOH0TzaGNpFVSDvaPQn6wqezd2aNZeJdP4
	hFxpzgVI5O4+kj26rx7vxKVDJ0t+hAds2ZpJPXDEyUg==
X-Gm-Gg: AYBFou3N4LPVHx+fF/Nmb1Zqfby0ESm2wgQw8wxMkYo3XVhav4kslYIIj9dvVuLSaQa
	iYaA6Rh9udAL9xhdSrSaBREvqBbObM0Du2oDceoA091mLkB38yGQLlst5mV4whr2wpurCUO04a0
	fti8cuyESXwnzLCIpkTnR2HvE6Z0wycgYKwO9yN0X6a+9qL+xTbhcvmo6EXGQuHrvq+i4cuRggc
	D97V/kmVlDtn6jeKdYu0lY+mF8t1WDivJ5OqTXr5XO5JP+sjuiw8fckypciE921NTzsxlDchrfq
	lV0PKr2ev2Vm/nM2pjjEP5z+9/VIY0lv1uk/xXJYRzwk7PNDX+0CxNA=
X-Received: by 2002:a05:6512:1189:b0:5b5:fae5:b221 with SMTP id
 2adb3069b0e04-5b8b6605e9cmr1614229e87.14.1789630085986; Thu, 17 Sep 2026
 00:28:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260913-codex-rtw-rx-v2-v2-0-f09c964e0b96@khu.ac.kr>
 <20260913-codex-rtw-rx-v2-v2-2-f09c964e0b96@khu.ac.kr> <b235d4ac6b8048c4916f484082654c48@realtek.com>
In-Reply-To: <b235d4ac6b8048c4916f484082654c48@realtek.com>
From: =?UTF-8?B?4oCN6rmA7Jqw7ISdW+2VmeyDnV0o7KCE7J6Q7KCV67O064yA7ZWZIOyghOyekOqzte2VmeqzvA==?=
	=?UTF-8?B?KQ==?= <5mghybrid@khu.ac.kr>
Date: Thu, 17 Sep 2026 16:27:51 +0900
X-Gm-Features: AcwNN1Wv6zk9_UT-AZSH9kMTavg-5odm45cqC5oVbIByww0dhWV62MKE_I7qvb0
Message-ID: <CAH1Bc_xVJXP-p5sDVSbD_9=vO=pZJ3bj3nCFbrMmMkM_H_GedQ@mail.gmail.com>
Subject: Re: [PATCH rtw-next v2 2/4] wifi: rtl8xxxu: unwind incomplete receive startup
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, Jes Sorensen <Jes.Sorensen@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Ping-Ke,

Thanks for the review.

I'll share the RX submission path between startup and the RX worker,
while preserving the different handling of fatal errors during startup.

I'll also remove the shutdown initialization added in probe. For v3,
I'll test the actual start() -> error_out -> stop() paths with targeted
fault injection, including failures at the different startup stages, to
make sure partially initialized resources are handled safely.

Regarding the Fixes tag, this patch addresses functional startup error
handling rather than only refactoring: an allocation failure can leave
already active RX requests behind, and a later allocation failure can
also return success with ret still zero. I'll make these failure cases
clearer in the commit message and include the validation results in v3.

Thanks,
Wooseok
