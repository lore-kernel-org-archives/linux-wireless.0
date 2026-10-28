Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793221025;
	b=EY4ytTmtO7RnNID7OrqBmo7/L8m3orMG/BQ/Ip35RK+P3fIzPcjHi/Othr6y5t1shNfp
	 HUuzFo2q8HGbKtO6pWVz0fcPLqQpi9gRYM8+yz6hgVLQ25pRVSpfZ+QiiR3gmIM7U2NtV
	 pOv5atFOlrDPgCTpikJZC2P6Cbsk1gykIp2m0GN6cHWzJE6q0EtLRxQEbUMknKS6QFk7u
	 5/nF0+RsQXOL20EJ43UQ6FbswwQldMCAMst2JQK0pqQQmHRhMzxJUmVu32Nrh+xSxLHh2
	 11CYeiOCSO7Pk84KdtRka8pcTVhC3o0+CZ1lNTH/+PcA/BQV8btl/QZO0EsgD7LEXHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793221025;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Message-Id:
	 Cc:Subject:From:To:X-Mailer:References:In-Reply-To;
	bh=YJGCZGrXuYKSbtbthGQ4UJ9HIhPS+IvzoBo7ywSwUhA=;
	b=dkVAOUj3mFGL5FMSb0Mg6/O7V6X/22u4HxG42MTFS0d7htVrrJ8o/0undxPei/+bwS7v
	 xD32xlxynwcA3Gaojst8f/Td+m1gZxMc8jDmU15X/YwojhRg2YnVsxNH8kauTYeYgtKdx
	 /v+zM33d3kn3HUKaFZMoYV7rRzXyhQUguc8fakKNfdswsf/R+ouIrstI8rZHUEcdYKrAw
	 xwFnpSZUlBAh4N9NYmPRckuhG3z3QLvtL/XKn6+58MTFxvNw39P7MAe8yta9VBrJMHfhV
	 U0ypRgArp6KNuP58CohvhmfzfnH97gehrSa07ynUZQFH+XulU17Cr3kxlMbRMvJl5qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Gieqk1IT;
	arc=none smtp.remote-ip=74.125.82.174
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D52606A31E
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 20:57:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13D52606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Gieqk1IT
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-3645f0f3fcdso2547199eec.0
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 13:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793221024; x=1793825824; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=YJGCZGrXuYKSbtbthGQ4UJ9HIhPS+IvzoBo7ywSwUhA=;
        b=Gieqk1ITl0mmOTKbPJsS8Km5XhNPy/4pHSxLDepnbhSdn+pcQzY8FMVEkbRmsgn7CL
         rKYt9j0IxxhX0NgRwz1sDznqYEKlHd+3a8qxKlggP+IzWKfF2FbtSVsmtz+bdqMLZdo2
         2ERIRWuaj0YYiiYcT7LAbqOK88JgCK6ST7p0dEzfnP/KH5gT8Ec59HBGBvXbQlOAcU5h
         JQQ8BeqPv7PrbkieFXoQKZafND9MVGtjpgqW1rLMbkDGkSIHjA558gIX1dQwhgWbOOCj
         kEJAeD4daHuqaIZ4TYUyFLLoWD/M4/fp1YIcTcPJ/2Lxg1Lj7m58YHjoErZa5n/LyyiN
         tK5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793221024; x=1793825824;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YJGCZGrXuYKSbtbthGQ4UJ9HIhPS+IvzoBo7ywSwUhA=;
        b=aQKaFgH/sj5SmASO9sVcCcxvj9sIzDW+7VxS1ARsJbSZ3DorcXz7ihdiexYBJrbMJd
         F3/pzUCPNrca3nSHRlzFfUjPQngOueIbo+hbyLEOv5hka8AmNU0FfaTVpKDCriRn6Zc5
         d6EOzyMqm6UxNPfSmtRTnTPskRaiMugQXriUp1pDsOm8hsUri20gVohlJvMPe8NmP+md
         05vx1xldwN0PuPTCJfW1dcvc8sbgJjLuMhUud68FKZfHQARpKRYTj6NVn/eoPXNfZfzG
         K9ruAXQs9dXmKGil1cxk8pRJ5VDbEzE21nS+UVGDoMmLlL1aiMHaomCvg3HDuV+QVEfG
         48TQ==
X-Forwarded-Encrypted: i=1; AKwUvBz15M1kWYj8pyBde3GtQ7uTCsORFITQFRxeFNJxl05O4bxv2tYNXyutBuOwl80fz8XILha9OaDTu5drOY/wPA==@vger.kernel.org
X-Gm-Message-State: AFq9FYIFv7ZYZF2WOJ87B8a1G7LzutZOdJ0Je3NyrRNwavdw1IqeKsM3
	sGSyq7VUqzOICA2pV0aeR++FXXuK6jn312/S/Tkxa2/I3jFzv3xDV79X
X-Gm-Gg: AYBFou1VebADa+2U40DqPv5G1hkFj+hrrEPoSSPiddD4l49G9U/SuLP0p2kN1hMgCUc
	jH361N3GGQmdu1ONS0aVXLFvdISAHygyAYe4wNWa5ZzsBETgGf7aI+BsKE5OVLlrluVmuOufQS/
	uWqO+m5UtWu7DFsmfPZnLXiznysdA0JVi9O9iiprL1a3Z5QQq8kMr3ZrSFNoheuUe+LzM0WujL9
	z7Ft7HCepi85V7rVrfYEYCXM5PCy4IR3QIq/jWJwbDXiRtajyILBRFTM/jJQnCwbYz3fBgWvIVn
	MZ01prYB+Fxh1mainPR+heeI8xRHN6/FiI+XosBIXAi2AQG3Gswgwh9Z/XAB1KsShyP4Jop2xo3
	GGjApaO6yUb2ou0jBmiPuVERB4P0Hk8C7kMx1lSNGk8MuGUCwgT9qUiubvupLlSA+pWkdHc154+
	S9R9jS0NHGeRKlX1HmuwZKhVgYtppDjPU5opcEfzr+RQdgyc8UbrYFvXVkVcMd3MNCPFDQLJAe/
	K2xT0ZYwHs7obfIS8w8dasoO/x/XSZmRM/UaE4Y7ElIMfShILJzRFQCgEX697z1DVJt1RnCK/9m
	AJGJ+vodCKa1hBJcVk+ALUyul4wdgdKJXIk=
X-Received: by 2002:a05:7300:d508:b0:369:7c:bfce with SMTP id 5a478bee46e88-36a2014adcfmr7152319eec.14.1793221024030;
        Wed, 28 Oct 2026 13:57:04 -0700 (PDT)
Received: from localhost ([103.89.26.201])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a23908542sm9812986eec.10.2026.10.28.13.57.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 13:57:03 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 29 Oct 2026 02:56:58 +0600
Message-Id: <DMGRSRF4BEVC.7QZ92MFDOJ82@gmail.com>
Cc: "Ping-Ke Shih" <pkshih@realtek.com>, "Luka Gejak"
 <luka.gejak@linux.dev>, <linux-wireless@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wifi: rtw88: allow key removal when the CAM table is
 full
From: "Imtiyaz Parvez" <reza1234khan1234@gmail.com>
To: "Hungyu Lin" <dennylin0707@gmail.com>, "Shagor Khan"
 <reza1234khan1234@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261019165103.5990-1-dennylin0707@gmail.com>
 <9bde49a2e7794e4fb6bc3ae104eef87e@realtek.com>
 <334c6e785a5d242c6f168d57d042d63b777a242a@linux.dev>
 <4f48c50cab1145fd9dbd6df6d424c877@realtek.com>
 <CAGEkeHevidTtTNj-qfy6kE_O0wRvqT=F=sG+Hy83BOkRjCUqeA@mail.gmail.com>
 <CANQ=N_C3+gpQ3O=SXYpRCGTh_MC1y4TEfnxF90SWgUVF_wYPUA@mail.gmail.com>
 <CAGEkeHdT1-WwJnF1wTkrrRQRzrEYESOoDeAYE+fiV0gROG+6sw@mail.gmail.com>
 <CAGEkeHf0CLjxhGySt2axf8gXMrCcn=cEHbe1aXRW4FgcbxjyZQ@mail.gmail.com>
In-Reply-To: <CAGEkeHf0CLjxhGySt2axf8gXMrCcn=cEHbe1aXRW4FgcbxjyZQ@mail.gmail.com>

Hi Hungyu,

> Have you had a chance to test this patch?

Yes, sorry for the delay. I tested it on my laptop.

Hardware: RTL8822CE 802.11ac | kernel version: 7.2.11-arch1-1

I built only the rtw88 modules from the v7.2.11 source
tree with this patch applied, and loaded them.

I used it for around 2 hours with normal browsing, suspend/resume and
reconnecting. No new warnings or errors in dmesg.

Tested-by: Imtiyaz Parvez <reza1234khan1234@gmail.com>

Thanks,
Imtiyaz

