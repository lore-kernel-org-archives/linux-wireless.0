Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F70B495031
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 17:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787851661; cv=pass; b=k2Iz9C0zN+GJHu7m5dDlU5pGFmbBdRP5Kphren7GoX2nV8vNL0Y2DnOVc7vFsBowJyi35fKtvmIhjORFdoassXmj8CiYU3hGjlsH5XLpLBjT3718THfMcmDKY4WOsLnfSCU/STX0xhvnnuhuLkja39Ifcf7GahV6o4IZa9C0Sxs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787851661; c=relaxed/simple;
	bh=HvwT6T6j+NkHVCIiwJZYKviDkprWnij+Zd4dVGP5+4c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H7KV1PQ0Mysc72QxNUCv63OI1tmdYrAjgMS1UtPE+DhaWxXArQgGdag1oQ6uKh1WUy8xxnjx4ng7oBFovQDpZvIB84t8aWMoRtqEE7K/iS7Sl83Fmt4fYoEX2nJj/1Y+eEx28sWUfYDfh1lPB8p4Y+4d4aKeke/KhQ0cCsPbAWM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eqebu9kI; arc=pass smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eqebu9kI"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-3a20258987aso796351fa.3
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 10:27:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787851655; cv=none;
        d=google.com; s=arc-20260327;
        b=bV9uHPTQ5h2aN67nrLi6kJwQ13bpZABSApqj4RkmrkuVajVaAJTytq7fL5mu0F+hfl
         csynd5ufPLzjkJyXLXw1A6Wk55OhauZtKPgLPA0rMVAQXhkq5g29e8xhD19dGZwcZ2m/
         btQxksWOr8c4XJmclYexH8P1kZ7Px5fvcipuXZ8o5m2x+gjMB/8bTttrSfvE9XZtExr6
         jmH5rrne9gWsXQ/ZhjytSZw1fhucrGpjQwL3KHPmi70ay8DQYSrqFVm71BBhpfmG5F/a
         2GG3oVvM/iER4+pUB6yN9LT54ejJ7qdglhYpZOh8GhczBkOsnKcxN5du/KEMh68Q8awc
         QwMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=HvwT6T6j+NkHVCIiwJZYKviDkprWnij+Zd4dVGP5+4c=;
        fh=ASzTWdVNs8e9YI9n0drmrB1Ylgv4cOGe3fd34vBz8yU=;
        b=OcpWmgAkACVxRVC1omFndjD9eSHF0we4je4QHRo0MyHT8eM5SUrxsJXy8LmovPXjoE
         MI37vNQbF79TdILPMrmqd7Fqtl7asuxp2JxmOUHouk/48aTd5a/CNsXcLd1/fA6uakoF
         XHa2cjV7MliyVszHbhtGmBK7klJHX0OS2lSZs5GZJLxaY2DR8+TcnWVYCfhdC7keHJ79
         8fk47JyhUzc9gm2TYvGIg26rfxZ5nWzGYPpzBkLeQXDRNxfQUK9E09rwuXD7sPgKYR/S
         4vFZj56i4Y8uhGIg6YrQkjBxZU4YgMnJsoaunjqGPjuOzqNscYZehbIixLMyziEPtJDq
         u+mQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787851655; x=1788456455; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HvwT6T6j+NkHVCIiwJZYKviDkprWnij+Zd4dVGP5+4c=;
        b=eqebu9kIn1KdNwwDWR9qsI1okv8GRHyA7WCPkRLt5s/V/9miIz5qmq+h/pfFg6HLDy
         ytpDDnnx1hk3HNruDfyT+413QN6AIG1j33eWVnnrgFVjNON0909xUr3zM74oLpd7i7Ck
         WDvWTsI84NMonhzQ8+Mb1OMfbZc5Ag4NF/3f9/OW59+DAXycr2VGA/uNy0o2lZ8zRmdL
         7zX4jTy14T6kiLLh9uD/Z1cPZDgJGKeoX6PU1lia+8er9D79yDfpFP1M7OThfSXi75JW
         ojx89OwyRy03HG3pIKrca6F3NN9XURrJjM3EGZ2UafMV6vUuzr2Ny0YuWXdKIQJeD7aq
         e3DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787851655; x=1788456455;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=HvwT6T6j+NkHVCIiwJZYKviDkprWnij+Zd4dVGP5+4c=;
        b=GaJQz8Gr3uYZCMBNQeYj87EL5eLmiLgnPjUSmS+TRH0pwj7aff7WtEWqAy+jRQKjIi
         ffB0Z1sGQ+K9t+TO3ucVH59tSGdLvxbRIe7r/rx1A3d3c8zpw9cYCu5H1Vb1DNjA0LSa
         bwqd2ajEcWno/mhQIW43zXkyYle3Xz6LgKQ5WYe4dQIhN1ZIx6NbOsAsIAzd2GaU2Juo
         QP80CGa/KZ3z0fM8zoAMTwLj9HsQUlbxqqiCPnqQ2pC/cnW5KsvudZ/C7fdexVZOVIV3
         1uY1xDqZuy3J3+5SBWEiQSaC4ke7EXM9Y3QwuF0r4hemeUTXVKIEWHFdvyZVvq8qn5i6
         L7dg==
X-Forwarded-Encrypted: i=1; AHgh+RqbBXN0LTlNMFNAhw3xWuqTaZW3Ixxoam7I5zi+brieu1psX9wzLX0p+6Usa9yqmGNKZRg3LQm6OoSwGDdCAQ==@vger.kernel.org
X-Gm-Message-State: AFuF++mEDgu54Xv653VrsD+ZvpTRBQAiF6eVN728rPFbzlAMfVKLjHrg
	HBuqNKb68vV9jKY//FHt5ivjZvdcL8pLiyTUwfIOGwD7myI2Owlus1pB/BO/4Kl1hXqTp4LKHca
	MHVDsA/7PkEcAdguThzken+EHvL3/rxY=
X-Gm-Gg: AR+sD117/pwQFA5Zd9t7E6jEoV85lwx0KusOjzjdDsu2Hu8H6XowNaxNgoaz2fA9AtG
	13hLI2KSjvfZOcLoQk9wd72J8oIPy/IyhCL4/8Zqv8+Qva/zBGRN9qjug7UJkekBY5I7i+pcqvW
	z5d4DQqSSm3lMGvP2Xlho+EaJZpOtlcS3NGeWc0ZFMBOA5zFt/1SeWQ8/iAMxLiCYDh0TTwJLDv
	AONeVEfseuSp/kDTQL0jNWyP7rC3Fpk+tL+FDxa52KMM0zRr8IcgYnk9CDkRyPH/H6gTx5Q+cR/
	b/j0Y/e2aqpl0ka9/QRfSRVk/DctpJjYh57I0ustBKBdRGbsNKBQse7yFGs6MDMtjmEZONgM8YY
	bvTI5JQiI/fFVlMjGnmaZoFuuBA==
X-Received: by 2002:a05:651c:43c7:10b0:3a1:980f:5905 with SMTP id
 38308e7fff4ca-3a30187d5eemr119801fa.3.1787851655217; Thu, 27 Aug 2026
 10:27:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260827130335.6606-1-gvalkov@gmail.com> <20260827130335.6606-2-gvalkov@gmail.com>
 <fbde1932-5433-48e8-b352-bf27eb545149@kernel.org>
In-Reply-To: <fbde1932-5433-48e8-b352-bf27eb545149@kernel.org>
From: George Valkov <gvalkov@gmail.com>
Date: Thu, 27 Aug 2026 20:27:23 +0300
X-Gm-Features: AcwNN1XMmtv8Tl2z9UfKPdkvBE_-gNrpL34xpH-g_gnIEgIMH3CQYCP7LMwA5gY
Message-ID: <CADOrJmY5jZvn8zEu-jCntGChXSY9wRd3bsOy1GB0EWNTY9GK6Q@mail.gmail.com>
Subject: Re: [PATCH v7 2/3] wifi: mwifiex: add dt flag to avoid conflict with
 platform reg domain
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: briannorris@chromium.org, johannes@sipsolutions.net, andrew@lunn.ch, 
	krzk+dt@kernel.org, francesco@dolcini.it, johannes.berg@intel.com, 
	kees@kernel.org, miriam.rachel.korenblit@intel.com, rongqianfeng@vivo.com, 
	wenst@chromium.org, rafael.beims@toradex.com, avraham.stern@intel.com, 
	error27@gmail.com, s.kerkmann@pengutronix.de, gregory.clement@bootlin.com, 
	sebastian.hesselbarth@gmail.com, robh@kernel.org, conor+dt@kernel.org, 
	Frank.Li@nxp.com, chunfan.chen@gmail.com, arend.vanspriel@broadcom.com, 
	peddolla.reddy@oss.qualcomm.com, linux-arm-kernel@lists.infradead.org, 
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	devicetree@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 27 Aug 2026 at 18:33, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On 27/08/2026 15:03, Georgi Valkov wrote:
> > WRT3200ACM and WRT32x routers always report a fixed US regulatory domain
> > from the mwifiex ROM, which conflicts with the platform regulatory
> > configuration on units sold outside the US market. For example:
> > - phy0 mwlwifi 5 GHz, hard-coded region 98 EU mapped to FR
> > - phy1 mwlwifi 2.4 GHz, hard-coded region 98 EU mapped to FR
> > - phy2 mwifiex 2.4 and 5 GHz, hard-coded region US
> >
> > When the system boots, it detects a conflict between the user selected
> > region and the radios, e.g. BG FR US, and applies extreme restrictions,
> > preventing phy0 from starting on any DFS channel. phy2 works.
> >
> > Add a device-tree flag, which allows affected devices, where the radio
> > conflicts with the platform to ignore the incorrect regulatory hint in
> > the ROM of the radio, so the platform regulatory domain can be used.
> > This does not allow the user to change the regulatory configuration of
> > any radio. It only allows phy0 to start and operate according to its
> > certified configuration.
> >
> > The change affects only platforms which explicitly define this flag, and
> > helps overcome the incorrect behaviour of proprietary radio firmware.
> >
> > [1] https://github.com/kaloz/mwlwifi/issues/173#issuecomment-307879699
> > [2] https://github.com/openwrt/openwrt/issues/9956
> >
> > Tested-on: WRT3200ACM, OpenWrt
>
> OK, so this comment from v6 was not about binding, but this is still
> wrong - there is no such tag. Just make it a standard sentence.
>
> Do not introduce OpenWRT rules in to the upstream kernel.

Dropped the invalid tag. I hope this is suitable:
The change has been tested on OpenWrt and fixes the issue where
phy0 does not start on WRT3200ACM-EU when a DFS channel is used

I sent v8:
https://lore.kernel.org/linux-wireless/20260827171937.28878-1-gvalkov@gmail.com/T/#t

Greetings!
Georgi Valkov
