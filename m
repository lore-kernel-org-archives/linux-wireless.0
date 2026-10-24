Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792823123;
	b=Iz4WLwVNySq9e2XJaGgNIltP8CvBsP6Q2Dtk1lKELGY5WDMEuUf7fDFhGIUDXKm96sl1
	 oEvlt65gVJQawvL0YEHTw3CnUEylrnNAbWDn0N/gASD33mma806bg+/lhwO/D+CsfR1o5
	 lVtho618OwZl/kELh+EKK2Ic0CsV5vZkKeK5sfYs502wSgZoUHZy5Ocj0fgTlQC0nZ4hG
	 4b+3RDWAiHBxLtPRpMzL55l/cEcBMU/LtgvlI46uEynzMNhQYF+sobeAQw4t5nix7E1vH
	 NQDwQVoI1YXY0AopOcYJSMXssgNJ/JKkuDYcTYXqE6LncBXpRkFr7xk6L49xAd2GVQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792823123;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:MIME-Version:X-Received:Reply-To:Message-ID:Date:
	 Subject:From:To:Content-Type;
	bh=OmybxwBAR46wDDl63pyAXESI98xxRK/BPussCp8D0eQ=;
	b=jmcjSzOm+OSD5Rv90f6s1D3GrcRXxUVWDaavLdTKzxI74kUI5zoUZRp5sXqTyAkyBx8S
	 bUxpOEWTL4qftFiHGGSyTvoFdpiPofjIAWy3q/7GtLkaVx7sSuaMS7wmrFHZZfxO9P6Hi
	 084etM53uzMpU/mhNPeNxRITEsNOuI0v1bgeEsAGeTjsMqnWXino8raQYnqePbFT07tXK
	 XmzeKFH5y5TGN7HzE4oDk5tU94b/JYFxYJuiVarbp1K36jguezwv1R8DT+Kc6zHd0ci5y
	 d/45KWoUSA7XqVC4k+vZHQFjNnv0dbOH4HOTVuw/ig7IruXg1rIb1uynvg2p2SWGCAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=jmJJtwnr;
	arc=none smtp.remote-ip=74.125.224.72
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com [74.125.224.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108EC606A31A
	for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 06:25:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 108EC606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=jmJJtwnr
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-679f81d5d7bso2732391d50.2
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 23:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792823122; x=1793427922; darn=vger.kernel.org;
        h=content-type:to:from:subject:date:message-id:reply-to:mime-version
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OmybxwBAR46wDDl63pyAXESI98xxRK/BPussCp8D0eQ=;
        b=jmJJtwnraLkiT1tiESs4IAQvWE4pquaCPz+FBUwLaA0wI6Aiz0fzXv/GGNyT+palyl
         WHiramcY+gBIHuAuf7JZHYscI3R7dph0UkQRVQST/URi64hu6Q66/vjZ3ukTKEV8YxP9
         lf/gsFtpRxuyX2tUz7Le2xGNp3QzgVA1vaidiGiWpn4WwE9IGgFEwwFno8zWKyNBMdHe
         wDVHzbtw9o67DVotrvabMZKdpx4qtAUANLKE0/utK7tus3BWqZcB4jMr2OCaBSnOS1UZ
         bT5NZaTHd8SDpO37xwkfMHXJqTPnhkGYbo04q2SnLX/PQlAR8qUsjJ96M4oisB42l/Z/
         LMWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792823122; x=1793427922;
        h=content-type:to:from:subject:date:message-id:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OmybxwBAR46wDDl63pyAXESI98xxRK/BPussCp8D0eQ=;
        b=p7ryAoRZ/L2jakQtF3IGmgev9kLov/LPEq24bGdR8B5aGdpkXLe1N2J0d1Ck9E7spr
         Xcn6wZT5EPL+pJivhk9jalXtTEAzB+B/xt1wjPe2sHwi9o/xgQK8+oAGd2ytu7YvGNEt
         akmMqCuJuN1/fPFtzQZWuWJKJasUi/voFcXIyCWJ9a4G/qXFMLK4YfqvXxnkhYQStbmn
         dcOcIza+GRAQzap/oohCMKVnDXnOrTfj+ewITocDEoGc11qGWZxVZYx4wef6swABuAWM
         t+CfSHguBsLf7gV2EDdih7cePca6URxKmZM4XysARnMG0dMAh3CPQQKnPhc+SrzwAdt/
         QSxw==
X-Gm-Message-State: AFq9FYKE9NzhAW3gyWgkyGqSwCzDWcYL93YC/D5e/+BYrvZQwgDXl8K5
	q9ZvOF2phccG6sWb/QuY629swwSfV1v14pBjFnHS9XyaKTiCw3+X/FXTq5hHPtjzhuMJXv87iNT
	ksOY=
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:690e:1444:b0:679:8831:9f47 with SMTP id
 956f58d0204a3-67a4525b7c2mr829706d50.9.1792823122111; Fri, 23 Oct 2026
 23:25:22 -0700 (PDT)
Reply-To: editorgkxjournal@gmail.com
Message-ID: <autogen-java-b5729a0e-8ab3-4d3c-afbf-e3f707dfae4c@google.com>
Date: Sat, 24 Oct 2026 06:25:22 +0000
Subject: Submission portal open: Engineering papers
From: mounishabuddhi89@gmail.com
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Dear Linux Wireless,

Consider publishing your next research article or review paper with our  
open-access platform.

We provide constructive editorial feedback and clear author guidelines.

Submit Here:

https://kexuexuebao.org/

Best regards,

Editorial Office
