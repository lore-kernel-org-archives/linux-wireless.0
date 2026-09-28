Received: from mail-24424.protonmail.ch (mail-24424.protonmail.ch [109.224.244.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147D048CD50
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 21:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790632181; cv=none; b=n2fYLS0d61DZblysFtrqGrdO++UvRyjDimLJDXQm0R+umT0qRYv6ZNtCFBBe+DX2p7O2EBw0gmjPqRbIK0U4CbWfrSIFHGZ1d8TeheiDLI8XkhrzB4eITfncC55LTiPDFjCswpDzWVC3/Etyxd2epkIKPTN1JT759YpS+tS23tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790632181; c=relaxed/simple;
	bh=PNs/xjd+CmpCK8QDGuLrwOcskb3fP6eQToWpewAfVvI=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ChNZcS96i4OoYxz0PU5x0qwMkVOfGpwtyiBtUCmQgVA93cStaTLUu6z6mpR2Zy6+LqfdglgsiBxf7RB66KAecZHO8daOshdtPEFrBOlfq88Ue4PQEyP7KBmZ81hX8PVCqNVRVWxtrk4CsgSeJ49WuJIVQ3g78nsIK/4K1ClwjVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=OykkXDzh; arc=none smtp.client-ip=109.224.244.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="OykkXDzh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail2; t=1790632167; x=1790891367;
	bh=PNs/xjd+CmpCK8QDGuLrwOcskb3fP6eQToWpewAfVvI=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=OykkXDzhez/BXrBMx5ymjDAgqVfIrQgReIcP47Ch+UaklYm8/CLuA1jJJANPk1lBy
	 +00qwQMSuQM06Y6kNSJYhRd+Kr0G0nqAFVhzdS+jzEo6y0Lgtgioz2WCSLOWR9WDIQ
	 QY2A40Pzh7aJfY39qlGT46Z3vvJ5ZkOdBNkgQLLsBFpNHzq1C5JMatdND8HODB726G
	 L44KXkhBQO3o9yGBrRXmh9+J8dXtBQ7aZnzt+cKd65IBEo+hUj0vHH+rwE5DSE6fhx
	 w4X3ubx5ZLP/WcU0GACye0ZPQ3lSRP9BHDZPGkducg7h4Q+9l7gMf4icakIOsxostf
	 2L4m2qr2oE2vg==
Date: Mon, 28 Sep 2026 21:49:23 +0000
To: =?utf-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
From: "andreas.wendleder" <andreas.wendleder@proton.me>
Cc: "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>, "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: =?utf-8?Q?AW:_Re:_BCM4360_AC-PHY_support_for_b43_=E2=80=94_reverse-engineered,_seeking_guidance_on_a_clean_path_upstream?=
Message-ID: <DL5AS1oidqGRAmMHt0Jcp3X4T3ob_Fa-lfhTmMMak3ATUnfcyETDn65CQf3iLvVeg4ExYoc_0GW7QMoaB1jEW4nzKAKFDv8bD0hqBEtkUKg=@proton.me>
In-Reply-To: <20260928200309.01a36f5e@barney>
References: <rOzY3WnW4q5L1osv7iagU81dLGldzZEsu3EqHxmH4d7Z4vxubBYvRNT0vsrbr8n-CUSEYyXxGFE3h9PHLHgePjm3_rMK_B_0m5loTpyxX-M=@proton.me> <ih-lXs5OlHxMhydtcZFtKNhGg3cGlR137CEMZ07_zFQcfCYAImW6MRWPDjkdwy-xK9bIwpDK9ImgerqHmQMsAxX3ckEjsiN8QoCSlpvIsSM=@proton.me> <20260928200309.01a36f5e@barney>
Feedback-ID: 189422222:user:proton
X-Pm-Message-ID: ba3b4ed9e1459082c2a0fc85a9bf61f856bed3a3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Michael,

> So I think if you use one of these approaches, you are fine.

Definitely not. :o Apart from register dumps Ghidra was used to decompile a=
nd analyze the original driver and all steps were heavily AI assisted. Also=
, the driver is still kind of rough.

> I think there
> must be a human involved to review the specification for copyrighted mate=
rial.
> But also for quality control.

I can have a look at every piece I give out.

> So, yeah. Feel free to post both your specification and your implementati=
on if you like.
> Please also fully disclose how the intermediate steps were developed and
> what role AI assistance played.
> Then we can decide how to continue.

I'm keeping the repo private for now, I'm happy to review the spec or give =
it out piecewise, just to be safe, if someone is interested in implementing=
 it.

> I hope that not too many changes to the existing common parts and other P=
HYs are
> needed, to keep the regression risk low.

It's about 11.000 lines but I think the common parts weren't changed too mu=
ch.

I`m looking forward to hearing your opinion.

Best regards,
Andreas

