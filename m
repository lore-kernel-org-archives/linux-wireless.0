Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919C83F44EF
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 09:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787218465; cv=pass; b=m6bPqpim8LVTGSGLhbf75H9kfxcu9Xlz2Rchr95SLBY703gfIk0s4JbRvAk+F/RbhIYgWd6jBZGKbIVG66yDn/JWpfTx7tj6ju6B3/7oNVXG+MjdbDNRvdBCVniwfAcX5ds4jJ1l2PVhuLDASZ/eOUJnYZZY9zuAY2fWa8UbwAk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787218465; c=relaxed/simple;
	bh=nYYBXc76RfdtU54i/yfZoijMWBxoO6zClIQBh+szfn0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ya6OUANj39OimAtApLIWihl7T0Fso1MskogrlXCizEn7jLAs6Dm91u6pSmEdG7SXVvbVttJn0/A1nhFuWz6K0jhbQdDboLCOAQz7KvdgIpkpYs15on4O0wnaU7ut1Ipoxi603Zu8OFGsQPLXcV+saCp0Y6umbHBrmjOzkGxLD7E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S3kOmxpj; arc=pass smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S3kOmxpj"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-3a1585728b5so17439451fa.0
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 02:34:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787218450; cv=none;
        d=google.com; s=arc-20260327;
        b=L2XABcMmG/tET31DHCwD8qgudhz25UmyJcBZSJrhkNx4XQCL+lw1nIVi622rF2pa1N
         6xUzhTmMLEq27t/VDi/3Xih7rnCtl2AQra/utYgsGnYnXfmXEtD4zVKIRhMtF6qU7cxX
         WlT7vsYGfVaEBHtpooJCFi7a2xbkAPnaGNfCfPTiSVLsrx41KGkKGdolvkGF5f96BGq5
         pifTW6OVbvTL8BoYeCUS8nR7vD5wQQQYsZVmbJ0g3qTKEgAo0SzlsUvhOp0U5JCm49U6
         0VJAkDd+sJllTeRddBd0UvuS5wtdKmzHOCh9rzSQeUZC4lP60TCYjE+QMgaOiqzEckCG
         L5+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=nYYBXc76RfdtU54i/yfZoijMWBxoO6zClIQBh+szfn0=;
        fh=M357ojun8X6iPphMguibG9VBW65VZ9GaT3YjM4aEiNw=;
        b=DeN4Aw04nGvsuiZwcYtBr5ThMjhavb72dTkKJ5Cka87cPKCQpJ5eStmhyzRsujWRMR
         mjv1pOHU0OO2zF+/HgetZUx32HmKOKpyfTXzdcO5eWLE+sF7IwBRS94QpeE5xFMlVVsA
         9C5ZLt9HoDnZfkteP5tkRUOS5CZ9bzkgDk8EBmh62pzVAkkxpEid/xV/9SEA7zWl+Pq3
         2+O3EHEVk3Q8Ffej8MBUvXNjUqhcyHU14Fx0Io0FoGxPxcEJlOdEjE0z7nERldR+Tkhb
         h/uwlyC9E55RPvIKD5HKXr63N855F2glocTIbBMfklwaT3PCI+t+6RdeUy/w47ap38Bu
         6xqw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787218450; x=1787823250; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nYYBXc76RfdtU54i/yfZoijMWBxoO6zClIQBh+szfn0=;
        b=S3kOmxpjr8hALgLJmQEIN0nbQQ1PFcSjlZ2Rjp4qBk6XLRaTayQE2LWy9+usQDn++e
         qJrw1kOUZe7DE2bwFxzn4IcKlib2GXJyoL8CCS+Gt/8T7SoUQH3Zx0/9fcm5/ENWwB4V
         stbQrWbSUKCgXiG9mMLyGC7hLJrxG6uH+XZoW7W6XEIpB6KGFVJl3eVhIInzR07pqleo
         u/0eHDN4tOqdEG/ZXqS78bRvLNDxaK6BoS0xlKxxJNQe8C4yN7BpJMqubz25ea/5VdKr
         EYFOapSmNxoahpNxkKUkonR0fXpmsvR+Uvb/kANOuLUZYR/7vVAKJd7EsnjTUgIvdaRL
         RRTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787218450; x=1787823250;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=nYYBXc76RfdtU54i/yfZoijMWBxoO6zClIQBh+szfn0=;
        b=dsKW5sXstODWaAZzguOpebSqbPnkqTvmZ7Xv5wNKN8yHGqN7Ad+ayXv52yY59H+/aM
         WBJO0yJQgAzzi5I9C9Y43JXzo8GuQzf/jK95HtAa+NHdY8QN5lsf1HA05BIucRwCPdea
         Zq/Gk6bfwSQD7+8NtazRymvHEPe3J0XzrF0WEPU+rw4MWUFqMgxywmKF/86eY2kd9gM/
         +ihFDYXKF+5VA5bbarbtcCKir6VK5OxChR/T7WDU0/mA3U459CmV4ELsADzbmZs0vRY1
         pdGQJ+YYX+qGa6n8lV40KNFSwtQrduSNeumyJesNcW0r4y9w4neGscTTvdfR9J9sE6Cj
         SEuQ==
X-Forwarded-Encrypted: i=1; AHgh+Rotc4oMvzP3UuwTR/hvyagd4qmvIemU12DOVvQ2c6tgELDlz0Z1yn2IQzxeYzHOsU3eSb3g2G1ayJE+VFUgjA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzYNufRbr0SzIuo73QNwrOkBjZYQ6y97N9776qyzlQlSxiyTlOF
	xhT9Z6IX/Ufekmy2fPp3kvlKLZQ5n58pRzULEXUWOO6Zjkx74sIAB6GkbRomsJ3f1S91deOInJb
	T89oViGYppaOmTej42T0A+/yHgbBZBJo=
X-Gm-Gg: AR+sD11vijauqfP89oKALkXO5aJ23w04Zkqw+NXdtxnSBQFTRn8tJ2mA8HDJiEXHOZQ
	hXuJspDsRYZ+P8/IgdLzXtAag8orNIYeEh0KbHrb33HEgL45wKlODp2V1uduzT4uZj5smnYEV1J
	b8xQ1u1lXF1SHRF67DJelkHeJamepCHbLnuPVfL6DaOFleVMxXAVzQPXJl4n8BF7UZL5nKuxsUx
	LfKhjPrXelqLfTs7IZ9brxQ6r66qRkmUvFTbMJ2Etdm1RbTNooCRfMUW/XVGNoFM4trBWJr9ZiN
	zYHRgPZGNzsMfCCHlNGUV7sfisJrj0zV3QUva1+ivBAkjDbZ6cWIclo7jvsY7mDEHlzRMYOqqjP
	z/05NYavCNJwMskRYOcDD/voUZg==
X-Received: by 2002:a05:651c:2118:b0:39e:a64f:d7a9 with SMTP id
 38308e7fff4ca-3a189725893mr23369941fa.2.1787218449766; Thu, 20 Aug 2026
 02:34:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADOrJmbTyrGGkq+9OJDXCgTa2HvNo8BWxoE6yjafcrOq7WNamw@mail.gmail.com>
 <20260817215428.84740-1-gvalkov@gmail.com> <20260819-generous-nickel-dalmatian-b6bb08@quoll>
 <CADOrJmYfBe3ADun_kFjFSH6YOSTX7Vu3UsFsL57yuRdaQ=eJCA@mail.gmail.com>
 <e554c007-67e3-4fbf-b85e-5de02f649e83@kernel.org> <CAGXv+5H7AhZgZ06r9KO3HLZ9Cymkai+Cv9SgVTuSC1PjgGf8hg@mail.gmail.com>
 <d6c8f19e-f154-4b57-9101-cf3b73e9794f@kernel.org> <CADOrJmYxKTyDkKPaKCpH37RsyyZJZ+4uReE--+uvnHmEdNJVOw@mail.gmail.com>
 <c38cb98e-0746-4b28-b0c9-ce59e8338048@kernel.org>
In-Reply-To: <c38cb98e-0746-4b28-b0c9-ce59e8338048@kernel.org>
From: George Valkov <gvalkov@gmail.com>
Date: Thu, 20 Aug 2026 12:33:56 +0300
X-Gm-Features: AcwNN1UdyfRyP4qTovLiX62_oFOyy91L008QCKICpAGE3pTfgFyxj68IsFBTyvc
Message-ID: <CADOrJmb8CTkjRFp7OjynfQSFm3fHT87wemUM4X5yJjTtS=C7tA@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] dt-bindings: net: wireless: add flag marvell,ignore-regulatory-hint
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Chen-Yu Tsai <wenst@chromium.org>, briannorris@chromium.org, johannes@sipsolutions.net, 
	andrew@lunn.ch, krzk+dt@kernel.org, francesco@dolcini.it, 
	johannes.berg@intel.com, kees@kernel.org, miriam.rachel.korenblit@intel.com, 
	rafael.beims@toradex.com, avraham.stern@intel.com, error27@gmail.com, 
	s.kerkmann@pengutronix.de, gregory.clement@bootlin.com, 
	sebastian.hesselbarth@gmail.com, robh@kernel.org, conor+dt@kernel.org, 
	Frank.Li@nxp.com, chunfan.chen@gmail.com, 
	linux-arm-kernel@lists.infradead.org, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 20 Aug 2026 at 11:14, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On 20/08/2026 09:50, George Valkov wrote:
> >
> >
> > Krzysztof:
> >> regulatory-hint for me means usually regdb, but even with your meaning
> >> you tell SW what to do - ignore hardware regulatory information.
> >> Property should not tell what SW should do with hardware. Property
> >> should tell what is happening here in the hardware. In this case: what
> >> is the reason behind.
> >>
> >> IOW, why user of a board in country X, where regulatory data says X,
> >> should have the correct regulatory data ignored?
> >
> > Because users in X buy a board for X and the regulatory data says U.
> >
> > Indeed when the ROM regulatory hint is set to US and the driver
> > reports this to the OS, the wireless-regdb restrictions for US are
> > applied. This would normally be fine, however the third radio in
> > WRT3200ACM and WRT32x, reports US on all models including those sold
> > in the EU and other non US markets. This creates a conflict with
> > radios 0 and 1, which report FR and also with my correct setting: BG.
> > With the wireless-regdb restrictions for US, FR and BG applied, radio
> > 0 refuses to start.
>
> So if you move with your router to US, you would need to change DTB?
> IOW, the DTB is per user? This is obviously wrong... What if one device
> has correct regulatory data written and you ignore it? Why would you
> ignore it? If you decide to ignore correct regulatory data, then you can
> as well ignore it unconditionally and this property is not needed.

All radios on these devices operate according to their certified
region. The firmware for all radios is closed source, locked-down and
there is no API to change any regional settings or affect TX power. By
design, the regulatory information for this platform is configured
from the devinfo partition mtd3:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm/boot/dts/marvell/armada-385-linksys-rango.dts?h=v7.2#n106

cat /dev/mtd3
admin1_passphrase=[...]
admin2_passphrase=[...]
cert_region=EU
default_passphrase=[...]
default_ssid=Linksys07770
deviceType=urn:home-linksys-com:device:Router:1
devinfo_version=20160121.1
hw_mac_addr=[...]
hw_revision=1
hw_version=48SAM203.0GA
manufacturer=Linksys, LLC
manufacturerURL=http://www.linksys.com
manufacturer_date=2017/12/26
mfg_data_version=1
modelDescription=Simultaneous Dual-Band Wireless-AC Gigabit Router
modelNumber=WRT3200ACM-EU
serial_number=[...]
sw_version=v1.0.0
tc_passphrase=[...]
tc_ssid=[...]
uuid_key=[...]
wps_device_pin=[...]

The intent of these patch series is not to make the radios operate in
a region other than the one they are certified for, that's obviously
not possible. As described in the commit description, the goal is to
allow the platform to use the correct region, which is stored in the
devinfo partition. The hard-coded region in the ROM of radio 2
conflicts with the platform region and should be ignored, otherwise
radio 0 and 2 won't even start. And yes this applies to the case where
the user bought the device in Europe and has configured their correct
country.

With routes that allow the region to be changed, a user can move from
EU to US, set the region to US and use their device.
This is not the case with this model. The radios refuse region change
so the user should not use it in other regions.
For models sold on the US market, all 3 radios report US. The platform
also enforces the US region from the devinfo partition. Even if we
ignore the ROM hint from all radios, the platform will still use US. I
don't see any regression. My changes are carefully scoped to a
particular device which needs them and do not affect any other
devices.

> > Would you approve any of these or suggest a better name for the flag?
> > Should ROM be in upper or lower case?
> > I omitted 'in-ROM' to keep it short, because the driver check line is
> > already longer than 80 characters.
> > - marvell,ignore-regulatory-hint (current)
> > - marvell,ignore-regulatory-hint-in-ROM
> > - marvell,invalid-regulatory-hint-in-ROM
> > - marvell,invalid-regulatory-hint
> > - marvell,invalid-regulatory-ROM
> > - marvell,invalid-reg-hint-in-ROM
>
> The point is that the regulatory hint is NOT INVALID. One device was
> sold in US with US data, so how could it be invalid?

US devices have no issues, because all radios report US.
I would love to ask Linksys the same question.
My router was sold in Bulgaria and radio 3 reports US. Others bought
it from the UK, DE, etc - same thing. Please allow me some time to
install a clean firmware and I will post the output from
iw reg get
so you can see the incorrect regulatory hint and mix of three regions.
This will take some time, and I will be left without a working Wi-Fi
until I recover using UART.

Georgi Valkov
