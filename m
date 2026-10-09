Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CDE3E49F9
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 21:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791581057; cv=pass; b=I4YJCoMRBEDSAHxm+vnVpu67ZoYg8SDkQA/SJD2EXJBEqBORs6gZUjxosWFD/kLO18WWzFZRgNy8avQziX1u4hgyZ4I5jw8LEU4LgTlWNtTlFTcQQhmYPsWAWbB6U6OempbuIaPiT2qPMfPN/AlPsRSPqc7t9GuzauAhQ38LsKs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791581057; c=relaxed/simple;
	bh=mozIcxnttMuBerZr7muY1MA9s+09XZ0iafUEVW2FWdQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=doM3pc8Yap7ern4U0AQH9Q/NKONoKRNOYGV7zlZ3ZuMNBqBqtT2ISOJp6XPrZk99NqZwHL2EwOoKRscO7Am1RgIPTvCEeneB79CEje2hV76FuEmnTrebH1v2AoOB0/5N27IrSf2De07riP8un3zSn6s0OUANOxZXlx+xgMfmqw8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=guo741cU; arc=pass smtp.client-ip=74.125.82.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="guo741cU"
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-15354aa70e8so548433c88.1
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 14:24:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791581055; cv=none;
        d=google.com; s=arc-20260327;
        b=S3oM0X1+PqvsF3+aKlme9XHNmFfXmYSLaubpOhbduy7lW51wxQxHcyikmmZwDTvrXG
         af+6GSbm9DPQp468i0AEiuw43R4fLSBEPIDH24rI+vOWdQyED8cH3ofdZnAsLDYIKUbE
         /u2Mq/5b9KihtDlaUKER8Cesoj0RBdRGje4RToH304aFYrPcuP1KP27r+8wsOMt8XTDk
         uRK0ErQz9bWCNtztwh8HVFQLvREpnsLzaVQ+LQOm28vZhSHlLX0g98q+1EFecanqJ9LG
         UnBdBhwgWfHTMw6nH1j62qrmTgIPhsxqyXatl91oVCnbk+VX3apckDalwlYyurdg7mpT
         qHsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zqL268J7XZEssG22JT3sRv0E3q65DzbxPLXlXrFzGX4=;
        fh=89z+jhSL2Q2Ko+vzwKhykaOdUwS1qgnaC+zk0+4njio=;
        b=d7GIhQ9vFY0Dr4h37jYLxG0aRp2P9eYfmOxF6Sq9KOYD7A/mIudtrMCf2F5hQ2XYTl
         0T0Rzl6nasolWrikunzibgU6SkIk+EjxF+/+LnGInimo+arYbEXvZHLpqcmFlDoSaoQr
         CjfUFtVB0LVkzJPf7adxBMMS8Nl1ReXy42YSVp86UgqPTcRVjAgbJyhjdrz9biP2y48n
         K5RDfsjD0GQQ8nuRpzrLlArePmrCil2boBgCvOuffeu5eIk40fjxcpbFNofW59S29zpI
         pUkxrd7zJ4vIH3qY7mqf5Np5zWYKDokRLIUHjWDRleYPd8UO446AOIxqjiYT/CalZmwm
         hbIA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791581055; x=1792185855; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zqL268J7XZEssG22JT3sRv0E3q65DzbxPLXlXrFzGX4=;
        b=guo741cUqQvzbVgpUaAGa6y61P1FT8B38AwlcjJww9ihAeTRfPZ8AuaK4Xn7smcFB2
         dge4548X3h2yTmB4+l4Pm/WR3x7cI+qk2K7He7bOJ4IalNHGcXHZQV9xPqhJdIBonMTe
         Wz6bZJ3DIXIaIGP5dUgWKrdvyF8B4BcqAzDTCHGg9A5l4fJpF8I+qbL6Uii3c+t/4prh
         +pM3eDc/QvFJ7s/J22dm7eVpZ+8bAxgIcVv3Z89FEfsPrJ6EVLls2/s5A3PIfdopzbTh
         wax0Jctz0EoA6UrMObLCoMTsqu+7fAVTCOT4nOHkpgKoGrrZsoSmljihkjo29acC21q6
         dAAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791581055; x=1792185855;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zqL268J7XZEssG22JT3sRv0E3q65DzbxPLXlXrFzGX4=;
        b=mucGwg0BdMcREpcyBC0HCo7+E1KyvY7a+mFdS6A8nPSjOyo1KRHj0cJcsSKNjCeips
         m+FhGJy59D1XqKuOmclLxDmyTlj/VRD8ATlLSrDwXybloul0jYKj9M7Z6+RVikmdt1KY
         tGpBPBsiFlQwL9yjazZ5obGJJ1YNhTbZBWqReeZVJC58Kd+xA8XKZ2tjEU/r3Czm3fXf
         8JrZZk1ydbBrM9HPe/Ytvfev/R8qxfy7iyDXJuI2hqfPvIAn84G5WwVBxfP0gasOt/cR
         +Y5Zk7zTzYRkrtNBgBtX8koakjCnI9ad0I315Fcn83mWfDGktY1kTtE4wgdNnY15EkVu
         Tumg==
X-Forwarded-Encrypted: i=1; AKwUvBziiXDuBqFQvFNWxdlcBZ6x8/w1F83UGUKGYusI+Rwc++Me9hAZEHDZoMpTSctfPYMhOsuFfcDbW6WieRaWHQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYJbBJGK29esctigAcwX1kIFZOFR414FlqIBefPoE9aRvIeGLXYN
	uIAhxRrSMkLlJLZ3lXCrXb4YUvkkm+LLVh30HiIonWfNSggOa1EXTYqQQZBK0lJUOEC5/KgzhVu
	oui3E1dYCzxpnsY4OXndYNWueVOv0jZ5BcPng2Qdu
X-Gm-Gg: AYBFou0lNq+p1kfhBobIFRsFk7+/BolZkJWBSBvL+b1FLlEy6kzs9sCw8gB2NWC2Z7C
	Ygf530R4BNa8kkCIRUCdVUmXnvbCQIKGPvJCJ9KYSu4CYTu1Bsi7mEN4O/ZU5YbRMzt1OmiXcLy
	L19tkxpuQtXyV77q7LcDfOGHcDqEUhM76aiJS9vwxg7BuZfPcp2/h4i292zv+XyXKLGAJAMnWVz
	38yVGRFOfmmp60vGiEQ7bG/hnY9lJDL5c2SLC4xIYEDwdpFEujXI2Z2mNF5NVoZNFNDrfqJp5Zn
	Efu4KQ27gw6J59LIADSquzOTjvDuKo8N5VGoK4v0btRs8RMCM7JdP1o/q1/MzDk4rHOIh+gW2ZS
	lQy6mNEZ6ghdBMGJx2qnGMoSbkLdsMJEAaRoyaqvlqxrZQIacTmFcKnlsn7rJjyVlJR4zWdB5+v
	dpkcvi/rtcKiKnPtYhQaV9PIDFRQ==
X-Received: by 2002:a05:7022:b054:20b0:144:f47b:58b0 with SMTP id
 a92af1059eb24-16a62228bc3mr4188069c88.47.1791581054829; Fri, 09 Oct 2026
 14:24:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261007205827.467974-3-johannes@sipsolutions.net>
 <20261007163616.1088d364@kernel.org> <CAAVpQUATko2Oig53r1+VHe+4Y3fFeX1xOw5RAnXtUAGwvQoB5A@mail.gmail.com>
 <2688563455012eb80063ae014f78230b10a14710.camel@sipsolutions.net> <8575c0d3cf58e56300313482dd1d4d74cbdbf4f0.camel@sipsolutions.net>
In-Reply-To: <8575c0d3cf58e56300313482dd1d4d74cbdbf4f0.camel@sipsolutions.net>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Fri, 9 Oct 2026 14:24:02 -0700
X-Gm-Features: AclHuK9minOGg6iZRYnVefHf6o9f3hjqkBhKGphgC1AFdNnbrzna3x5tbjMc5wI
Message-ID: <CAAVpQUCUGdJUK0ucjwJpRkjMQ6DGgZyswBSadOXvg7_gYDSLwA@mail.gmail.com>
Subject: Re: [GIT PULL] wireless-next-2026-10-07
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 8, 2026 at 8:01=E2=80=AFAM Johannes Berg <johannes@sipsolutions=
.net> wrote:
>
> On Thu, 2026-10-08 at 09:44 +0200, Johannes Berg wrote:
> > > Also, I hope we could remove the long comment in __rtnl_unlock().
> >
> > Couldn't we remove that today, by just __rtnl_unlock() in that place in
> > cfg80211? But it's not exported, for good reason, presumably.
> >
> > But that's also irrelevant, because indeed after my patchset cfg80211
> > doesn't do that any more:
> > https://lore.kernel.org/linux-wireless/20261006100655.2687533-21-johann=
es@sipsolutions.net/
> >
>
> FWIW, I double-checked and didn't find any other code in wifi that would
> do the rtnl_lock(); lock(); rtnl_unlock() ... unlock(); thing, so that
> really is gone once I merge that series (which I'm planning to do after
> all the net-next pulls net etc. settling this week).

Thank you !  Great to hear that :)


> > OK so I (likely naively) thought the idea was that most things like
> > netdev registration/unregistration eventually move to rtnl_net_lock()?

Yes, and hopefully readers (lookup, etc.) will be converted to RCU.
