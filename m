Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC2D2459FE
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2026 06:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782108624; cv=none; b=A9F6L7exS1MfLbT3REsTFLLnTsSHyDUWIfBZ3HT8OyVRqNoP2ktmCZptNZOa3VGG+OGJuFpNU6NjcucTIKgXnMqmxPIG/B1R/xcXVu0mhJmBII0ZkIWyrbVX07uYTIsUGU/FTVTFvHwJnaHSND2tl6mwp1F1NjNN9pcsJPzOy34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782108624; c=relaxed/simple;
	bh=cXPYZJ9/riZWh+lp8dsWSCNnS0yrdPqRxLUj9p6sSqQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XcnHWqV40H+cYguhtM58pYqgjxFaamh31Yq2t2KuWZpvGdftEDvApcMxE5HuikYrHN6srUOcyvA82DbO46RkkIG9LFtEPYyFTTh4tPsvUXDi8OH14Gn4OJjZKuBBlQy+k6FoP88qnjoLeDDAfHzdXLkIVFzgcC709EwrzqikyO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=p6NAiLSW; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="p6NAiLSW"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-84537777d45so3143027b3a.3
        for <linux-wireless@vger.kernel.org>; Sun, 21 Jun 2026 23:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1782108622; x=1782713422; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ha592al9vZ1mrUC7RTQJRzNKOisxo6kGTrWMTgXlll0=;
        b=p6NAiLSWN++bDzlp+fxXHp3Uz2cX1tfOTkGVBow9yC/rgnnmBQKD/H1AM48JDlnec1
         KXYB0OahjFkRr8OOnd9RB580wRgdaw0yyAGa1HcbSUtvPuZ4BuEwCMw509mVikWgXc6F
         910MIcNdzxESWQAvVCzK06KCceOtMNSqfd1wrMNKgjG+3yvOnWlWOzpdnpx5wvzcxCxj
         n/MJSTY7mkAhXhpCvp2WztQqg6A9IB4RVB+tdO0KAGznSb2S/0MY+zTRefD4465bECuS
         DAitiZ/T2+r/O2BjA6Ht9wPuzisEAO2U+DZeSgwIwOuua0jstm+yT2YVEmgc7tWpinEo
         4t9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782108622; x=1782713422;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ha592al9vZ1mrUC7RTQJRzNKOisxo6kGTrWMTgXlll0=;
        b=ToosOy2jkWZWYdtMtS0gMxKTe6vp3gwCsD7/wwFsjsCxrkHGJ7tCUdOf590t3750fK
         M32v1lvhdADg8WCrKmdHv1IXDcSlmGeH92ko/oQY15FdmPYaO/vo8TCPIrhZviL1CGvu
         xi2dF54Z7r0vixpXwMaHRFAMuXAGntm3O4VPEsodIui6U/O2E6Km4xFDxH5Ud/kVkDfZ
         yy8zDW/xy0BX+gktmiBKeuBhxPCVJgmtyIEmMWWsW16RKqbf06O8hPE22Fz2VH9EERgt
         1+n8hWpWpUkJ1wVnCw+xWjRuXMfbFQ9eB3WaEriAiGyonf+zL5WYEuJXRKWVyVuI8Zte
         KpKw==
X-Forwarded-Encrypted: i=1; AFNElJ8jOb0yd9zI7iKe38EAr8vy5T/RjqkAPuUyJ64CY3HIgzeugpcfE5KcrsQhQPs7rVg4VBAylRWYPHiYuSOvfA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwmnwpAZqCm8GYDj6uMps3srN8ytLEyLiauoaAtQ5ejYlm+LaZv
	5OmPvASI51tI2Bf8cc1zWNxh5Ln0aTJwKG1k25QqbmUCNP4AsLDQ83+W31sspPCL2xQ=
X-Gm-Gg: AfdE7clCaWNwCWwjO57hNeqYW2dIK7Y/34OaMFoQfAPGouLKrSMOipwIXOpITKuKiMB
	QF/mPFKwItgRobSX5fT04q9qw/dwpS3hPh1PLrIroPuKn4EcstRmwf6JU9D7/+RnFTzmsBaBlA4
	DETRvPQ5AcE9n6kfVte0wyp3RJbz+NyKwF0WmLcVJ7FG5f32IKpn3RD2g43GwTwLtmsQ+ZDZap1
	S5GwXhXCaJ9dLwk73iEwkYAbozx0Ncp4DFJPjxU5WaQPzp3UcyzGif5a7ktELY5HMBWH7zMtk7W
	nbybM7vnruXDJCWsQqYoN3Fc33np7z8V2WV06iYXvkIlSYgNZk8WRlos1MGzESgJqCizLyZ0cth
	8I7gulNbfpQ8/blD3ACt44ps8Mr8yw2OhxXlwsDVcf3swA9YYvrLnMZljESWrN3Eigxl1xp8/Tj
	K0gv5LhTRXJTlZ3G4ziO7kVbcn8LprPM7pMeZw4CGCqhDlt7K6w63DEPnXoqlLxtdC1t46SYtF0
	9GSQ3jGLKdY
X-Received: by 2002:a05:6a00:3d4c:b0:82f:6e9:d1c3 with SMTP id d2e1a72fcca58-8455087b229mr14542809b3a.29.1782108622164;
        Sun, 21 Jun 2026 23:10:22 -0700 (PDT)
Received: from localhost (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84564d6c2cesm7418159b3a.2.2026.06.21.23.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2026 23:10:21 -0700 (PDT)
Date: Mon, 22 Jun 2026 16:10:18 +1000
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Callaghan <dan.callaghan@morsemicro.com>, 
	Arien Judge <arien.judge@morsemicro.com>, ayman.grais@morsemicro.com, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless-next v2 06/31] wifi: mm81x: add core.h
Message-ID: <o5cnnv4t7je6l4d3re6cifwb6v5ox3znje7hqmy7ebkktt5iak@4vtrqqfxx3iq>
References: <20260430045615.334669-1-lachlan.hodges@morsemicro.com>
 <20260430045615.334669-7-lachlan.hodges@morsemicro.com>
 <f6dbd068437564e18695b1ef263ebba27ad7fab0.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6dbd068437564e18695b1ef263ebba27ad7fab0.camel@sipsolutions.net>

> > +static inline u32 mm81x_fle32_to_cpu(u32 v)
> > +{
> > +	return le32_to_cpu((__force __le32)v);
> > +}
> > +
> > +static inline u16 mm81x_fle16_to_cpu(u16 v)
> > +{
> > +	return le16_to_cpu((__force __le16)v);
> > +}
> 
> The whole __force thing here seems odd, why isn't the input 'v' just
> __le16?
> 
> This goes with all the FW loader thing - but that also has all __force.
> I'd argue it'd be better to just have separate FW-endian (little endian)
> and host-endian structures, even if that duplicates the structure
> definitions, but it'll have sparse actually checking the fields were all
> converted correctly rather than casting a little endian structure to
> host endian and then doing the conversions:
> 
>                 mm81x_elf_phdr *p = (mm81x_elf_phdr *)(fw->data + ehdr.e_phoff +
>                                                        i * ehdr.e_phentsize);
> 
>                 phdr.p_type = le32_to_cpu((__force __le32)p->p_type);

Having separate structs for the hw structs definitely seems better:

	struct mm81x_yaps_hw_status_registers status_regs;
	struct mm81x_yaps_hw_status_registers_le status_regs_le;

However, since we have to do some elf parsing, I assume due to
the size of all the S1G reg rules, it seems best to do something
similar but it means we have to define our own le elf structs:

#define mm81x_elf_ehdr Elf32_Ehdr
#define mm81x_elf_shdr Elf32_Shdr
#define mm81x_elf_phdr Elf32_Phdr

struct mm81x_elf32_ehdr_le {
	unsigned char e_ident[EI_NIDENT];
	__le16 e_type;
	__le16 e_machine;
	__le32 e_version;
	__le32 e_entry;
	__le32 e_phoff;
	__le32 e_shoff;
	__le32 e_flags;
	__le16 e_ehsize;
	__le16 e_phentsize;
	__le16 e_phnum;
	__le16 e_shentsize;
	__le16 e_shnum;
	__le16 e_shstrndx;
} __packed;

...

since the kernel (AFAICT) only has a single host endian structure.
However I am a bit cautious about redefining elf sections here since
I cannot find much precedent in the tree. it does mean we don't need
to use __force. Of course we could also do what you wrote above and
convert in-place using __force to the host endian struct. Do you have
any preferences here? Seems most wireless drivers have much simpler
TLV followed by blob firmware loaders.

lachlan
