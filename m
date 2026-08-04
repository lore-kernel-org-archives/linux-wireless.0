Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5997447A893
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 17:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785863593; cv=pass; b=ePsbIMXyCkZ5bOdYKRO+4vXDzsFrzSIhUfUgAqKdqMI/kP90xmSg3BKKZYne0xRMM4Nb98YaPaTjbKQ4I8n9J0TwWiN5Se38U8bCJ5bLx9bIkVOChoJjSJ/zWj3YkSMCssD9g2gKowUEjzGV6poOU0sT0TvUvaJtfeJPpYaFrc4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785863593; c=relaxed/simple;
	bh=zNOYD7AymG4CtiYaWtFQm5qBYQopllfjl49X5WI4DWg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KIr2dJzowmtOS3MlS5LiP3MDktBYRzdXEo7WpPYBJM3EmZN57OcZbkV5fblLqiI1/Bb651PGschbb47SubsV9La1h1gSCbpyL02U6Jx/QeXQxpp0gas5O47kUwreyA1o9vm/3gU5j4ZYuCllcwN/VKLvwpDwUy9Mv3dhb8ZIjo8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=NoOhlOrL; arc=pass smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="NoOhlOrL"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2d02b4c3601so1165395ad.3
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 10:13:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785863581; cv=none;
        d=google.com; s=arc-20260327;
        b=XZrhaH9Z0txPGyjp+3V2cZNKImCg6qZPsWmQsqSCzEdpSN4/IQWumWCb8zI+6sFCqr
         oSoPz1FKQH64kcXIb8ZUHrBz3zNsmdQEpMv/nQ0gPgKDFw6yrdqfWz57BgiS9J9f1c3Q
         H+MOR9S6knB3mzWTucc8nrA5p94MfdCZPFBZzVORQCj+e8UX87ovIOZb3sPGNjdasSH+
         FdjeeLX7cxzok8KkVT8pw6+zhaGJ38qaZS5dAsOdrk7Ddomn2O+INGcMyK9/CYrAzx+e
         Jn071rsuB0K7HFOZ00T44Q1Oi179NA2k++7Lzz5fd2kS5iXTnTGc6X4kk7fuKbUIkGW3
         ODoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=zNOYD7AymG4CtiYaWtFQm5qBYQopllfjl49X5WI4DWg=;
        fh=zFCB9yj6tbPtiNOgT9n/qK9LnQKfgtX1AWhCxXtoerY=;
        b=fgISYXZ5FuA73wfZC5S17wQ2ErEg5xU0KumbyS/5e/2gVKrTAJ29xAgw3V3WZIqPhz
         EXlJdD5fX2eQDMZZkBJ2SUtIx6eTtuNpdcuOoJbJ2uA7oT4W0lacD1AEbtrlHc22Z1c5
         nCv0dKiS5yhoPPdSqhfsK/voPnVOn9A/CSjAmWQtJlOZ9Zg4jLIDGFd8OsJ4iGvcTwpB
         yMc4iRTafK1kIriNsWxQE+AVN9dpcMWkIK0x03in9Kecd2xVEb5hpEeBxnQmeNMGE3uu
         +gVcg7EvxwVLK8jX7q5UMO6nZWZz6lOgrC6i/97LOW2Jp/ZpovzgWUMBj2vhmhWuLfmP
         Z2dg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1785863581; x=1786468381; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zNOYD7AymG4CtiYaWtFQm5qBYQopllfjl49X5WI4DWg=;
        b=NoOhlOrLcsCuFYlqUqSjuMSvFmx1awwWamb+zSIzVuw3cZbptsN7inyThedKNofEzo
         2lygaC5hO9EWz8s3SImxZf2DcQLJdGhOji7WKWjRE211BUrtcG0knGM9MHgtnNxfeo1T
         lYrwsk5jjymPDSbEd97zU+HeLMBZnG5Qu3vRPV2wr+k5gaATfAwQdk/cy4DkyNwB741F
         og0e4H2fSDiwJbD3SjYOcmYnw3CiKeKmMlYsMkd9aJurundNHGwugF9zKonG0Y76I+Ts
         jiRk7madlZ8M4YV8QGdOdAlSjVgJ2i+yjpGcB593/vCAoFWlCmW651mU+C5DAuWGs87m
         lsvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785863581; x=1786468381;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=zNOYD7AymG4CtiYaWtFQm5qBYQopllfjl49X5WI4DWg=;
        b=FVByNZ2i/2cb4VJ4e5w5eCWSrQJczGTX/oxTpOzlqkWXj75hWJ+frTy667yz5mXKud
         rJksoyI1LXsCEbz0b0fp8TZQEEiSiG6caOIRz3YhO2b+ZaMf1M7zhMcXGok9Fj1tvaCP
         PKzbCf6cOseGNGtBFzpf/Fscd6kVKzyxasC9MIEVsBVUorXVze+H19fCOi5sCIRM1+DT
         cagtBhhmiGKUGeKoyW6HuNr4IjbsMsdF+79B0mpoq822dr70XjRS3nPAae1P8s34nyEY
         fvAobt3YM7lPKHYYsyGIwpqo8axkkKZQJ1PGx8fAWETKdDNEXAvq0tjMIzmj7zKYPpsa
         msVw==
X-Gm-Message-State: AOJu0YyamFaDHH0o5wQy68IlOmfyRb9fMXugbaVKiMhWtSzMbBYZmahN
	C08GiVPy5mhXuYXJ/IXtoWlUuqf4joP060jOK5KHJCXsCzMTW46sD4JZPDz9QxHatHRTyafkZu4
	AkfEZgWsXRwdZmq77l6kVnsOClVgmsgRZOrFF
X-Gm-Gg: AR+sD12T5ai4HBUPW0CjV9DM8qdXuIWrCn7/mZEe9IDQOm7vCF6Hod+quyO5k3fna7+
	6i01IARaiCuu40jXYJv+S1YZ6i0Sd+w8s6FndY1RhWH6W+Ev/MvPMDZaJCgCMTM8sdgYiLlyg7b
	CWwTFFoDLep4DZhp0cM449NV+RB0VP0+CaY6zRaFKEfO0NPAzghlFtUlB9cEPi/1Qk5KbCCBvNg
	cjOlenQv3yaT5+jmURjj6PuA5og3IZ3ItNcnI1IsGVS96QDdnOkortG/wRlMh64+2/RgwljviPU
	rw9wluxg/28D8un/OtV8EZntufRCwyw81ewvlhnqtO5E1w2rMw+JFi+LDEm/4SDm0WVHQbzNCBH
	kM1ccmFJZvjb/qTUqHWmpL+R41tRj5RxSzVHkgea/8P8=
X-Received: by 2002:a17:903:2288:b0:2c6:8d95:fd6d with SMTP id
 d9443c01a7336-2d0ca98f8a1mr2621615ad.21.1785863581391; Tue, 04 Aug 2026
 10:13:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOQMLZVB3_wedJ89yNoCKTXOsuXWNq+T785bVQBSr3Yh-TPqeA@mail.gmail.com>
 <ea2f5ee46c064fb9b3a45e9d705e2f59@realtek.com> <1f8a2a023b064bca87a8f1e6712bca3d@realtek.com>
 <CAOQMLZWhvwxTk9PNa0E=73pBOoah8X-2C+xN5-VY_gCSVtBkVg@mail.gmail.com>
 <CAOQMLZWpPDbm5yiBg89GjzXnCwuQn+t5V=AP617MoH6q8Zu2zw@mail.gmail.com>
 <fe2f2e2a52ed4565b5c2927d872d82cc@realtek.com> <CAOQMLZU31dc6ZvNi_veM6uU1fSXYNBdnWLkOwH5xXR45uOFx1w@mail.gmail.com>
 <CAOQMLZWPMq=CCFpdg5wwsJ_QnrUKx_0YouTxdaSePO_0YPqcLA@mail.gmail.com>
In-Reply-To: <CAOQMLZWPMq=CCFpdg5wwsJ_QnrUKx_0YouTxdaSePO_0YPqcLA@mail.gmail.com>
From: Adrodoc <adrodoc55@googlemail.com>
Date: Tue, 4 Aug 2026 19:12:49 +0200
X-Gm-Features: AUfX_myBoEjl4VikNdVx_SwnPYtP8NwhggF8mF5Lze0PFQhlB4KErucD8QTm4bk
Message-ID: <CAOQMLZUn30NJwU4pR0hL=nz38Mbp=73wgqd+CoQE2qSO3cf4_w@mail.gmail.com>
Subject: Re: Error in rtw89 using Kernel 7.1.4
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

A little update: I managed to downgrade my linux kernel, but I can't
install versions older than 6.6.9-arch1-1, because when trying to
install them I get an error: invalid or corrupted package (PGP
signature).

So I ran 6.6.9-arch1-1 for 6 and a half hours today without
encountering the issue. Yesterday I was running 7.1.5-1-cachyos and
had the issue 3 times while using my PC for just over 7 hours. So the
issue is likely not present in 6.6.9-arch1.1.

I'll try 6.12.10.arch1-1 tomorrow.
