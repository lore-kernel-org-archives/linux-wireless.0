Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAE63B19D1
	for <linux-wireless@vger.kernel.org>; Tue,  9 Jun 2026 07:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780989780; cv=pass; b=EJjGVLK2R3fKbbI9ztxg5u1MHbnzk1f3N0kVtgCBABW4t/N72S47hUbm0cOwWLAuM+Cc17BEZ6Li7HN3nah4YRJ9GQ+4MUe8wI7EEwb0Gt2Q/rX21epEXesBCRXXONCmDx5y2L5jnPIBPaJC/E1JN9/gE+x8RBlyIzyBGxg6X6U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780989780; c=relaxed/simple;
	bh=PmdY2NZaUOzBDSUH7dOmsNy2jhGnIK7fWI6FkwjDu0E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CyQCW9ZFC7mH9JxGOjIaARCivmV3De9YbgrBO7r8H+NhypvWNN7YI5tVj7UgtCuq4mJxDmHg3k81Zz3hUyOx8GYEfgny7nZKHeWDvPn+E6AmeLIAKouMKsVgPInEOQ1lL2BYak0w1pfOs7axy5bvJ4TLKWyh7p5KXkS0PCW6/Ro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dBuTZzuq; arc=pass smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dBuTZzuq"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-396aacc5bcfso50525471fa.3
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jun 2026 00:22:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780989777; cv=none;
        d=google.com; s=arc-20240605;
        b=VJTX+Hxy8cYOFUVSdNoHrJGxJll1fdDZ/kSWbR5B2TXSGJI6WxOewGaAwo6UneOF5I
         xW5xbgdurS06eER1UTLPVEd8JuJuAHlmelxMvk+gL8h6oPJdLJMaxXHd4hYftajOhH99
         YxZKm2fmpjmcpruOU549VrPBNaqTlVWIOzaHHQ6ckO666hpYDZrlMPSGSgZxlrz1NU6O
         FVMgwHAsjsbLEMEY5q8PGDrPlfDJOCOps9xU66DEwC75vQx9GM1lfsecG7vvG9fO/0xY
         SEk6DpGvgq61AId2YbMiHSmdTWU2mdxo8XNdcpm0YXEwatutw8F4ZTqlV7D5CeZHtUgP
         uo+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:dkim-signature;
        bh=PmdY2NZaUOzBDSUH7dOmsNy2jhGnIK7fWI6FkwjDu0E=;
        fh=8Mi0kWdkEVEDL/3lMqnYZSAErVaWoab7DRuJ523aXRA=;
        b=XiqkTL0UCvoTCJfRiG7tyZCnkeZq4+g0Gil/WbHUEMOzMEuHmLCbLL1sLULoAoQ5yf
         0aJfRJn2PbdM1Ypm/3wMQ7p8B6PUQuznlauuPB2ARVgNCRDneNhHGcqcLCr5z087Tvn8
         eP2XPg1Tr0JCqIj+lJ5JN3/YOvYHjUwI73qH/fg2C6mT1vzg/YQwUP7HAeyQZOi0N8KQ
         5myEKWAgTrVx7fWv7oDpbuiYpLp9O+QwuWGzXjVKvqOSt51JI4GPzalP3glusBdfaEKW
         5Cv5y5M9OEljfORuGtCWyoKgZndcHhlZJEJD5haY6ZujPiqsUQ/2M+8TZOMd4I2fIcGW
         VvrQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780989777; x=1781594577; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PmdY2NZaUOzBDSUH7dOmsNy2jhGnIK7fWI6FkwjDu0E=;
        b=dBuTZzuqjEJrxQenrL9MivaSZcY21Svbjz0eXNbvUEadZxJTTL0OCU4qzXfTu4CFA7
         OQ0fcaTgyp0h+hq3Fuaa8OaxEebZZOvsaGjdjx7KYPfDz2zOMpV/SCK7jbbADbdOl+tP
         UnCZhhuhqp/PGdRKiXUcCNhYdAYx45fv3wRYqUSuUnQJuhe3NweIBzJ68Gn427SG3cOS
         lV2OmNe2bvbSE0A+dD9lbfp4U9fkMdvGqmZD0RId1aQZUgvIfLM3ywYpRB8tIos1Cjjx
         kpyu6i0bImGEO/XkUisunwY5HSZewK+9GHeYxjD05+bO9xgPm6v3wIOmBC49g5YQtcII
         2Acw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780989777; x=1781594577;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PmdY2NZaUOzBDSUH7dOmsNy2jhGnIK7fWI6FkwjDu0E=;
        b=CFAHMdW65Ok5loXdYD0oyY/OUDb7/ooTZY8jTBzBGe2r3h+jcs8mGHFI6kQ24tQJIV
         tR0+IUmcl62ia/bZ3HXrYjWk+/U/cT4B5P1ORAmRKtd+PBL5KJpRaxM3uGZfb/vp6XU5
         IZIPNwHr2kZ5JPkfUOA6hiZ1ldyq8vX1tClte4PFhYFGMssfuultmNTTl1dSjrmMdYt7
         wrQXFxPGu/9zsGq9bo9JMUd0nqG0XcLXQVylpCnM/7mwNCOncUz1tN49nCoBT6bvbbY/
         vZqDbGlAPaou+DS0G/F2+FrN1O9MIUe6wjbVAiJgILuw6VI9He1IvnXsIx+l8Tqzcqnk
         ZpxQ==
X-Forwarded-Encrypted: i=1; AFNElJ/FI3nxjZZ7I49JfUqzhEDQHu3KaLlRofgo9JL3qmMCjOb5/um6ihLvAKGE2I7oz0JJpz0yfp6CEDc3rJGmmg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyGXm1r6+AOhohPqs0EpSxFZJCqDAapDelVSvXE8uRLTRkPMWXW
	ERXWHMpZ8Hd5qQgL/gTbcJ5p6ubQBqOA+zic6B66S06NStMcEkRBObX+JRdYzIAs6Olv0Y2nSlV
	T/ITwZaqHSWfX32KMgoCuSDyO46bSEvY=
X-Gm-Gg: Acq92OEz8N/aplmhqMp90dRBWU8zTJotdcU4tDrWpwaUbZGugO7bkl/v7HBUd5Nm9fp
	9ChFwzDzHCvO6JNj9eCRiaIyncJo5sCmy6irsMC9efc+qPT7s0Tz/vW2ybPbxiuMmrpM6IlmiFH
	dvpLmSYT3wdIuaS+W+v10K/2wh9kOSlnJYPlVjSqubuXhvhIBmRc1SGOztzMp4tGJRmt2NqYtZj
	pjFKVmvH86jgU0W/ZI7URazMIIxkOOKPyu1hGmRxZPnW/MhF5L5vjOkmNVhrjwDztEtm5N35tl4
	kOxGR8SrwigVxQ12n0F6SEKQw1vkfd9zG6dCbALYb1LVoARmxnzFw4Bb/mAKSg/w
X-Received: by 2002:a05:6512:ac4:b0:5aa:77e2:51b0 with SMTP id
 2adb3069b0e04-5aa87c537f2mr5638974e87.45.1780989776306; Tue, 09 Jun 2026
 00:22:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1779269054-14963-mlmmj-1e4bac1a@vger.kernel.org>
 <CA+icZUVmdgL1A6mpFxMEtMtikwbkH5qWWyuEn-JOeSU80Q-mvA@mail.gmail.com>
 <CA+icZUWx8_ULgXkiOyeVuJDA4PCTvfFttcdYQphCHausdueu3A@mail.gmail.com> <20260608-gigantic-vicugna-of-karma-d3d26e@lemur>
In-Reply-To: <20260608-gigantic-vicugna-of-karma-d3d26e@lemur>
Reply-To: sedat.dilek@gmail.com
From: Sedat Dilek <sedat.dilek@gmail.com>
Date: Tue, 9 Jun 2026 09:22:20 +0200
X-Gm-Features: AVVi8Ce7P2uqCKfZe9TlC0xFpMYZxPEKPZXzIGxWDzdpX4rlHYejVPbCNktz--I
Message-ID: <CA+icZUWGFUpZnJs+8YLuFkSKSP2RxmSpbmMVjpje_MOPXsjwQA@mail.gmail.com>
Subject: Re: Unable to unsubscribe from linux-wireless@vger.kernel.org
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: postmaster@kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 8, 2026 at 3:44=E2=80=AFPM Konstantin Ryabitsev
<konstantin@linuxfoundation.org> wrote:
>
> On Mon, Jun 08, 2026 at 10:22:04AM +0200, Sedat Dilek wrote:
> > Hi Konstantin et all,
> >
> > Can you please check or help me find the right person?
> >
> > I registered linux-wireless ML via <sedat.dilek@googlemail.com> email
> > (email confirmed in monthly bounce-email from ML).
> > In 2005 short xxx@gmail.com was not allowed these days for users from G=
ermany.
> > This restriction changed some years later.
> >
> > All my unsubscription emails are sent as <sedat.dilek@gmail.com> and fa=
il.
> > I still get emails from linux-wireless ML.
> >
> > So, how can I unsubscribe successfully?
> > Any hints/help much appreciated.
>
> I've unsubscribed you.
>
> -K

Thank you Konstantin.

-sed@-
