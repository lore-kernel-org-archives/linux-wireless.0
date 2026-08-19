Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D10945DF6E
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 11:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787139789; cv=pass; b=C926PvRdB+PMGcda2GYFgq6xfOJSPkUg2UxFx+4/WR9HtBAe9M/UBa8T20rGQ9wOt5o8TinDwOvSkh6NevOQjWBii8Yycf6nWQJikcVPvQ8SunUjXzpGxB1jpPpy9tT4nz0icyeIq715fqY28O4nAbpsacmNTQBrykSyQdv9AXI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787139789; c=relaxed/simple;
	bh=08kL7JbQEa8fJNQW+ej623AwIur83mUMehYAetGta8A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lqUrX2bgyBrnzCEkJJAqrxGWG9E1aZm+wmjKEy6CxZFXRSrr0x4Rqe9ndO6zwTOOhF3fp6fdVTpO4ui2piTpIifiK6IvM18RIE5ImYIY0AGSTlz/ijbaPNtwXASpixb8G1VSy1Z7srIQVAPNk5Y3dNRvhG/gYqOrnz0LnZu/xzU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kB1u61St; arc=pass smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kB1u61St"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-39c7ed5410bso6414341fa.0
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 04:43:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787139785; cv=none;
        d=google.com; s=arc-20260327;
        b=oqhWgDCjaVpdTA/2w/+Jp2T7pAip4Rr8E99/05qvIIZdQkez/WICrjgksj3MI+ymsV
         AgemESo9c1fzVfbX7ZZwJ/ysir3joPwAmhzv6pnoFyYychQbOoF8Bm/m2j3MfeoQMbKK
         8FljbYBYPnGFwbY2LytjUY2E4CIL6/ecdFK8CMgH/67fRr+yG52ndyj4G2wxealncyYs
         UuTc2y4rb6lZT1H+I9mBD15T8mgmymh6/Kn0dbCiZkqd1R/aXERRuLYpeWoesH8PgDtC
         RmAV00eMuLRnzJgslB178spCiTnmH9XSQBOVHYqPjym4CJTtPMkB8PVPZBbb0/ekaOAc
         H1Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rruUpDInQvQQuqMyUIBpR8nVOpeVCVZSdKEK5ZtInD4=;
        fh=JCP/S+tIkab+sRrVcSp6tnsF4kwa16DpFQib1evF64I=;
        b=a8rDRcHGkT0LKWtOyWMG/WF+jpypippfguq0NOO8PF8JXX/HNiD1aKDZxWuoWjebI6
         HzS2dKK7SM0rcSupt+ByV2iLlS1gXs2iU57xRhpSHNCfCs3GYjU1DiBpRmv2Chjbz7Z7
         wtDTLxWpYm7SYa+IJQFBtSWKNYChmZNIPQXpQGoGfECiUXad8aIm6zs7b08uflDoWONy
         bplJXoNMc/F2B+r46EE14G6GVuX0a/kLmMjXX9FMETLHOOCv/1Jtkk1BgbTldn8yNz8Q
         VmoKHI/s5Nb9Br8iLIIlRrL+yOwFVJqREqRwZt3rd2Lb0VX4V3cJSHyviFYioXSxh7e9
         Abjg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787139785; x=1787744585; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rruUpDInQvQQuqMyUIBpR8nVOpeVCVZSdKEK5ZtInD4=;
        b=kB1u61StMBPj4ZUwlTwHo+rDCRoAE5H5sTiEx11AuTUvin8iPliLRtBKxaC05+2QNC
         8UCoND2pA8Rs7/VjUmE+YAy4z3Oi0aG/5+k04EQ6DnLfCcCRXfidCVAjYP8KeBUvWKNr
         dwiTBGKay8aNf/Vx9ewIF3VmaBVFTUvNsmyNI/liOafSUBX3lYUv6FJ63UtIUxmU0yaI
         wMCB8dzreVt/D1PCrSLbKFDhB2Tz8h5jQkvO/xIAnI8A88l2mkPtcZQ5fypWyZ7qpsAY
         6D8+0wrUe83CmR/almLB207xYt1t4X4dyEWNyuEJBYpWo+QhAfYKOakQM7qajdrRaADn
         Lehw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787139785; x=1787744585;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rruUpDInQvQQuqMyUIBpR8nVOpeVCVZSdKEK5ZtInD4=;
        b=SL06T/L9ugC2pGUK2NubioS3F0L3B2dNl6cPYfrdyXxKg5LAaowE+GsOzrYJm0BoQd
         cyAJoEEHCy46FpNax1+7s9+9ifyUW4ZGs+DI/DmAp1eGZ597nL2zPlxYfuLstCPtcdqx
         6r3Sm7YWf/v8GPs1BA/yn+CSMNFxXyfyZixG7qlwJXDyMhr5fM1okeDMoiG6QsiOszqx
         0BwJzCNlOy98vmy4y3zIAc89bJwedUJTwXRyBlyVz+KLi/Ntl+A4IkyPuLpPAhtwtF1K
         JJjf4cGEzRSi1EvkMkr4DkdRxMRK0Rf5dlWbHnJMpgyK+TNOCd2ouMyNFEZChdY4Qurb
         9r1A==
X-Forwarded-Encrypted: i=1; AHgh+RrnG8e/bzpoPMJGB2IDJtk2aKaKJW1aQpUB1qhUit7AKNl4T3UtCi69bhyHxhUhaEBPMC6WaRyvgiAr2QoZtg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3vO4oCnvDQh2nDfZdt2AdwO7PqOgCn/q/7VF17e/0uhW9AiBB
	Hh5jhqlqPGUihkinKQxLaDh0pPoUagYsoPKHFvYQB8u0hozf2z/Lx656roB4LBrIG1f245J1E1i
	J4wMioDNG61aNVhernum0Iq547KDBuIk=
X-Gm-Gg: AR+sD13f+dpfpB+J6BHmw3HsDfrXe7Hw8GDE8oyiQQUQ7Z6Tt+AkaymcAbSqmhSVdKW
	ZJD+fnCDx+ye5P4TbzMhAluHO/5/SvKMlEdGJqfCqXWbGn7ZKOoq8aUEGL/cCMW7Dm9bxC7ZEQY
	2cqW+5wSe/jwnRD1twi0SzcH1sm1jao2qQnsgk3Akbn4Br5xm6AcnJcrKQgsxnAQrqKyh+L2KMM
	twRop1FFByCqtYQdgqcKEkzipBttB0yZB8EprtSec+JGlrl1jnqH3+UEmzgABRBr40EDdbbTN52
	pU/QY3PNMxQAm/5aXcUHKYj8SYgf52j6RsobIcBW1txxz9k52cAoZ3WlFyfI6dES6CUGYalSrec
	Ub1QQFbrxaE9kNL3Kiwx6/1Jj+Q==
X-Received: by 2002:a2e:bea5:0:b0:3a1:85a0:c5c1 with SMTP id
 38308e7fff4ca-3a1899c16f4mr8655901fa.11.1787139784486; Wed, 19 Aug 2026
 04:43:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADOrJmbTyrGGkq+9OJDXCgTa2HvNo8BWxoE6yjafcrOq7WNamw@mail.gmail.com>
 <20260817215428.84740-1-gvalkov@gmail.com> <20260819-generous-nickel-dalmatian-b6bb08@quoll>
In-Reply-To: <20260819-generous-nickel-dalmatian-b6bb08@quoll>
From: George Valkov <gvalkov@gmail.com>
Date: Wed, 19 Aug 2026 14:42:52 +0300
X-Gm-Features: AcwNN1X_uzL9E44yhbWS_M41oClBHdMfV11eL6pc59WJx0lXGGLZ-ZZh_4cYzLM
Message-ID: <CADOrJmYfBe3ADun_kFjFSH6YOSTX7Vu3UsFsL57yuRdaQ=eJCA@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] dt-bindings: net: wireless: add flag marvell,ignore-regulatory-hint
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: briannorris@chromium.org, johannes@sipsolutions.net, andrew@lunn.ch, 
	krzk+dt@kernel.org, francesco@dolcini.it, johannes.berg@intel.com, 
	kees@kernel.org, miriam.rachel.korenblit@intel.com, wenst@chromium.org, 
	rafael.beims@toradex.com, avraham.stern@intel.com, error27@gmail.com, 
	s.kerkmann@pengutronix.de, gregory.clement@bootlin.com, 
	sebastian.hesselbarth@gmail.com, robh@kernel.org, conor+dt@kernel.org, 
	Frank.Li@nxp.com, chunfan.chen@gmail.com, 
	linux-arm-kernel@lists.infradead.org, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 19 Aug 2026 at 12:42, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On Tue, Aug 18, 2026 at 12:54:26AM +0300, Georgi Valkov wrote:
> >
> > diff --git a/Documentation/devicetree/bindings/net/wireless/marvell,sd8=
787.yaml b/Documentation/devicetree/bindings/net/wireless/marvell,sd8787.ya=
ml
> > index 930b700b73d0..5f235cb9f3e5 100644
> > --- a/Documentation/devicetree/bindings/net/wireless/marvell,sd8787.yam=
l
> > +++ b/Documentation/devicetree/bindings/net/wireless/marvell,sd8787.yam=
l
> > @@ -59,6 +59,12 @@ properties:
> >      description: Calibration data for sub-band 3 in the 5GHz band.
> >      maxItems: 502
> >
> > +  marvell,ignore-regulatory-hint:
> > +    $ref: /schemas/types.yaml#/definitions/flag
> > +    description:
> > +      Ignore an incorrect regulatory hint from ROM,
> > +      so userspace can set the correct regulatory domain.
> > +
>
> Same comments, so you just ignored entire feedback?

Do you mean this feedback? I already replied to it:
> > Anyway, property looks like SW choice. You must describe hardware
> > instead.
>
> I am sorry, I do not understand what you want me to do?
> Can you please send a diff or a clear description suitable for people
> who have way less experience than you?


> Again: you need to describe the hardware, in commit msg, in property
> name and in description. You cannot tell SW what to do, that's not the
> purpose of bindings.

I still don't understand what I should do?
Can you please show me an example of the changes you want?
Else I'm likely to make a wrong guess and implement it. That obviously
won't help.

The commit message already describes the issue with WRT3200ACM and WRT32x.

About the description, do you want me to do something like this?
    description:
      Ignore an incorrect regulatory hint from ROM,
      so userspace can set the correct regulatory domain.
+    WRT3200ACM and WRT32x are known to need this.

About the property name or flag, do you want me to add a separate flag
for each affected hardware device?
- wrt3200acm,ignore-regulatory-hint
- wrt3200x,ignore-regulatory-hint
- the list may grow if someone decides to add other devices
- and the driver will need to support all of them
- that doesn't make sense, because it isn't scalable

> How did you fix the threading problem I mentioned in v3?

How can I fix a threading problem?
I don't really know what the correct thing to do is, once I forgot to add
a version tag in v4. So I just added v5 in my next submission.
I'm new to sending mails using git. So far I've learned that I can do this:
git send-email --thread --in-reply-to=3D<Message-ID> =E2=80=A6
and I use the last Message-ID.

Krzysztof,
I am thankful when I receive criticism from you or anyone else, because
this helps improve my PR and it helps me learn. A clear communication
along with examples and links to documentation can make this process
easier and more productive. Thank you!

Georgi Valkov
