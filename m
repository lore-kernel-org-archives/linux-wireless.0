Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236FB36308A
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 07:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786519431; cv=pass; b=TI5mk3kKR6k8Y1yr7FvxwbjW92COukUwDhHUBPe/plL2pEhcTNQadFyF6K+LpgATqPGujJ3OOoEHawspQXy5b0YJ1cJWg5NItQjiwFc9JaMWKLPnJj5q9X5HN2foCoETsMEUUJnznAeO5VNJru0xnkRlIs/S6SxyEVsekKCKsHo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786519431; c=relaxed/simple;
	bh=lPE2CLxAbZbntiAzIEzsCiAb8fZRvxGUGyest/89SrU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SKSDLG/YmDN52Mf+BWK3EySdiX8iw1OTmi5O5bj8e28fQVR1LZk1iKkddnuzOWmhUmCbh752bBI+2amn2i6YkMZVNmmWPnfhdAiRr73ZAS2mCHU14cGowRZW/dI+fgzrea4PkRds22mziRs5h84KhaevmBd8WNXtiPu0EVvWX2Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z3fOzic8; arc=pass smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z3fOzic8"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7e9ef94c0e2so386389a34.3
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 00:23:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786519429; cv=none;
        d=google.com; s=arc-20260327;
        b=rxvT0Th00h44UYA8yuT4rYMBZ4KBxdNG7Ip9GK/Eu3keQJjWFhf76jfp/ayM0DGvIn
         xaQGoikWOgiDBNNfCqzI/kYkzvNWv6t8MQ+T5O30QCm2BXJqpyA0nXfE/viJw4X3UksR
         FG/9Qqi29xEyQUbXdYtmZvCXebArWep+l7NzqA+uY7PrjKLlgEZT6/CprrmKMwP3d5mA
         BgB5QKyn2AvFS3XBWytLWdpqlvwNuY4Xsc+N6iWiQEGSl6kN3GpDtttjhCbl5SVy87IH
         ag1xLCCArbf1nWBrXB9L8UDwMgIRM8Afhzjpgj+/vSrPpohpJRKEvfB7z3NJwji9+fBW
         0OrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lPE2CLxAbZbntiAzIEzsCiAb8fZRvxGUGyest/89SrU=;
        fh=6mQmOShwDkHr7oo2lLjjC840VgeEf/JrS2uy0Ad7SgA=;
        b=BfBkF05hsQu8/hvtbwLYQM49ZoCgXBhYyR8OTPghbUhoPT1P7wOSbEH+m6bCC7eH45
         6hO5ylyY9EQ3VQw3UA/JyiSGY6xeTTFFXmExCVL3O8ZhcX8b2syIqgtPwhwEjGA6fmmK
         HnSW/AFQg0CNkhWJAGwQxPzPeFfHeMOM6pmLiH4AyEttDie7mj+A9AYuE4sphkoeTN8W
         vwjjHQ/87UZSwRIZhcn1v8mFYCritQcPL7HX1ahDRr/ekJ3LQXx1zn2tyzVz6S8xCtVb
         AhvVLKx+ynGRMXQRuEeJmt40aRyjiWlkAo/b6MU5g8NIw4ItKSCN7In/4RIyFL6/oZEP
         kGqA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786519429; x=1787124229; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lPE2CLxAbZbntiAzIEzsCiAb8fZRvxGUGyest/89SrU=;
        b=Z3fOzic8JixLXdJzs1HMK4OIySEDXhbKkW+3WC+fuvL3zKFGPiFDYu4tRjL0UEpgNt
         gZLGN50GQDzInUTbj7hOzsbofLiiT8Mw5Ac5xurlSivHVhPN4ULtyMPRgSDPb/Fcghup
         7nmNIvyp8ZFqelgXZi+dzqZSOuZWZLgc8Xk2IZIAgSIn1C6GuWIL6ldCtefTPQQk4TMH
         if1EhtIC7Hys1Ysw9inJLeJ9e68s9XjFi9QDOZWAX8gOsfq+2+77GIlpQ9eoCtL5iqok
         5bWBv/SQVdXIo4XmACz+DOT/2YjocTnyuHkwEoNLXUgGgnPFRuoI8OjinWeQPuWBJatr
         Ec9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786519429; x=1787124229;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lPE2CLxAbZbntiAzIEzsCiAb8fZRvxGUGyest/89SrU=;
        b=bY5hSHrttY5yrGGlCh4tS153ddsbLpyLQHoATbUnt91DFVoHfBHg21YBoa0gOFY1nL
         zlTF3ww7spMRFONPGUMRvVKGNeHsaFLwMCKXOkIw6pgqL9me5SqfVKKR8odzVUTMIUtq
         AC9ntiSJeJvLuc9IZvcUwC2fc1u738YtQETkuHHx0G6U3rKLb8rS3233ppbH2/qOwejC
         kyHHKioQme+ghL+fzU36mAeOwfjjCGfIogL/d3VE6aTiVxqA/OQGzdCox+ft4UDMXClj
         P9sFujvThyze6FEjSDJpVwDNi1jOLX5OQAA2JFImi8Y5zwRB0qj9N0zsJaNanppnQli2
         uMBQ==
X-Forwarded-Encrypted: i=1; AHgh+RqgJNuhSR0aZKyCp2/c5kMzLWxPJ+6Vsr4TE4OwXy+tE94eIr3VnIEekUSZjkPB9AX6QeXkXRf0LvNknnY2Rw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzSNmeBRAlvo3hf7c4DA33rxnnhcCuiB8FHRjYdcuiszlY3sEVD
	P5BtjlTdbUf9EAwMIVULAVl5UKrktk2vYAnSS2yEZUCwI1wldZquuaIxHhft8GWLwW0Ybjnudq+
	piQRNSw7AP0/zGV9cDJfvTWwlX79zB7w=
X-Gm-Gg: AR+sD11m7XULdVAkQhF3lc9x8OthT/WyChK/OKXmBK2cQg0uOgiTzx3sJ8rgFyorOS5
	SsXV9D5RerB7vkIah8/ISSimPorrfpFCSqGn0uoz+Z6RoeTgF7+81VgXNcJ7JTHE92YB3pBfLbR
	rLEjC5zxwvR9kuIhWxv8YlOXY1jZ8jq4wgMDYtu+35JXdEVUVLHmEFFZotxKjM05O7iRuZbECBN
	oP39+6vSwCgdZhbHCOoPzTF9p0euw/bqfl5hF7yZ9pI+OvCbYQV3WAJSbXgDQ1UlCuWDveLl1NP
	wP6RMDGn5N18LFoUu6y26priQz7a3okXI9agIseHzXrf529JwlTGQlEkxvUeTkXhDI2BzKRRXi0
	mn7+yU1BuMHQRX5L6hh+gvyfK3eM1hDiiXLks
X-Received: by 2002:a05:6830:6a99:b0:7e9:d4b5:8004 with SMTP id
 46e09a7af769-7f3b7703ea6mr3313972a34.5.1786519428838; Wed, 12 Aug 2026
 00:23:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260804120004.523934-1-mikhail.v.gavrilov@gmail.com>
 <18b018d0-7f7d-4975-b0b3-5e3c9f413698@leemhuis.info> <CABXGCsMhfR-fOwUgKuQrojM8jEpdco_m9aYA9ph_EOrCfaPxeA@mail.gmail.com>
 <b308aff2-422b-4ac1-84d8-f066aa17f5fe@green-communications.fr>
In-Reply-To: <b308aff2-422b-4ac1-84d8-f066aa17f5fe@green-communications.fr>
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Wed, 12 Aug 2026 12:23:37 +0500
X-Gm-Features: AUfX_mxZLwD3AKWIfDqBi4-P_dTiG6Fu-Md1DdgkQNdMk5RKTm8G9CoEhj7fBUk
Message-ID: <CABXGCsNYLoE8OSxEbbYJPV34H=8s1QzLjvc2pjQSwiK2VjHdfA@mail.gmail.com>
Subject: Re: [PATCH wireless] Revert "wifi: mt76: Disable napi when removing device"
To: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>, linux-wireless@vger.kernel.org, 
	Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, 
	Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, 
	Bert Karwatzki <spasswolf@web.de>, Devin Wittmayer <lucid_duck@justthetip.ca>, 
	Eric Biggers <ebiggers@kernel.org>, linux-kernel@vger.kernel.org, 
	Linux kernel regressions list <regressions@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 12, 2026 at 12:13=E2=80=AFPM Nicolas Cavallari
<nicolas.cavallari@green-communications.fr> wrote:
>
> Depending on the patchwork configuration, you might be able to change
> the status of your own patch if you register an account. I'm not sure if
> patchwork.kernel.org allows it, through.

Marked it Superseded, thanks - patchwork.kernel.org does let the
submitter change state on their own patches.

--=20
Thanks,
Mikhail Gavrilov.
