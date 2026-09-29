Received: from mail-106102.protonmail.ch (mail-106102.protonmail.ch [79.135.106.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189F03AFB18
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 08:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790670489; cv=none; b=mH4NpAkGmcYEj//qwe3oY7O8ueCSig0eGNxy/i4+hQoWKIf8ZctqiF6k8bjhNkb8enfd3sqybMbI04sHO77ENxzgX3q4Zh9WNi4amrRlEZRLihWVOjEyPxBhLqgv5OKbOTpfIPEdmWiivPNzO+U+IplaFWg3vXE8KyKZ+c3v2iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790670489; c=relaxed/simple;
	bh=yEwew7jBaK5kRRGaa2h0ZUzhCuD7vGgBcI47NzGlCZo=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zbiwb1o/sRN9CSTQ7D1KLX+jEzUdH1YqCpywrRaFHwruq3XC6Vxex68YCv71EJmCOs5d+bex0f66Gb0YqEKnA7c1rJsxk94j5mLw5RoJbfh/fUbpCrFtJZrcfqp+PuaEOg1K1Cg1ceEsOqGkdlA+mALhN9UJb2XJpjhLvYBlxvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=xLB1XhM0; arc=none smtp.client-ip=79.135.106.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="xLB1XhM0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail2; t=1790670477; x=1790929677;
	bh=yEwew7jBaK5kRRGaa2h0ZUzhCuD7vGgBcI47NzGlCZo=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=xLB1XhM0dEG/N9RI58GswV/uJ19jn5I+e3zTMTRbdjlTqzCNSoy+kIMBhVqi92dTX
	 O4rNo2IYQ9N/M+ONyQoBRtDMots5VMDTr4mqrpDQ7Lqd88Mhj2sFwpLSmrdOPgjKZY
	 cpP1LedlwhxfHTRHEwStApfkqe37qgl1YUgrzXZ13B1K264JVn9VGiRzh3SYn5joo5
	 jgyru16pWxgj5n/sSTPEzERfOZc8LW9rmyzBhNglKdgz+kaV/reay3nPM4apH3boS0
	 4tVmmr6vKrIyTnYPU8yTkzpLw67TvdgtTJx1xJ9OGiw2q6an4piyLqX1ZGjeFyLhSB
	 z5ruXRelQeYSQ==
Date: Tue, 29 Sep 2026 08:27:53 +0000
To: Alessio Ferri <alessio.ferri@mythread.it>
From: "andreas.wendleder" <andreas.wendleder@proton.me>
Cc: =?utf-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>, "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>, "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: =?utf-8?Q?AW:_Re:_BCM4360_AC-PHY_support_for_b43_=E2=80=94_reverse-engineered,_seeking_guidance_on_a_clean_path_upstream?=
Message-ID: <d6tVX7HBAW4Qnebx5Enj79edWG_LVmnRT0bjhcfv9bb1h0cewrTEDHK-VVoSy0NZcMzv3FB8OVEyTFNgA7rs_zaplEfiLXdwcCqhYDeonMo=@proton.me>
In-Reply-To: <20260929100544.343ce6d2@DELL-MOBILE03.ad.smart.it>
References: <rOzY3WnW4q5L1osv7iagU81dLGldzZEsu3EqHxmH4d7Z4vxubBYvRNT0vsrbr8n-CUSEYyXxGFE3h9PHLHgePjm3_rMK_B_0m5loTpyxX-M=@proton.me> <ih-lXs5OlHxMhydtcZFtKNhGg3cGlR137CEMZ07_zFQcfCYAImW6MRWPDjkdwy-xK9bIwpDK9ImgerqHmQMsAxX3ckEjsiN8QoCSlpvIsSM=@proton.me> <20260928200309.01a36f5e@barney> <DL5AS1oidqGRAmMHt0Jcp3X4T3ob_Fa-lfhTmMMak3ATUnfcyETDn65CQf3iLvVeg4ExYoc_0GW7QMoaB1jEW4nzKAKFDv8bD0hqBEtkUKg=@proton.me> <20260929081403.6076a6da@barney> <20260929093405.79d9f4ec@DELL-MOBILE03.ad.smart.it> <hCBGuqVmDlV3Y7f2t6L8DtnoyBNbC8KghHXm0fZCHLDLrtfaoYw9e0UcCCsQHHK1X4TBz0DuvSL4zmAx_dVS3q54BZ0JZXtjXXNnuSAFtyo=@proton.me> <20260929100544.343ce6d2@DELL-MOBILE03.ad.smart.it>
Feedback-ID: 189422222:user:proton
X-Pm-Message-ID: 7e10b522f9f14ce1a37a129c44c67ea8e667b6ff
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> Least, but not last, the wl order of macro operation and b43 order are di=
fferent in multiple places, how did you reconcile the two?

Good sign: we're core_rev 42 too, so our disassembly and yours should be
directly comparable.

femctrl/srom: not touched, no handling anywhere in our port. One fixed
test board, so we've never hit a different value. No data point to
offer - if you find out what it gates, let me know.

wl order vs b43 order: we captured wl's real register-access sequence live =
(bpftrace kprobes on its own osl_readl/writel/delay, wl left loaded and bou=
nd throughout - never touch its binding while probes attach) and diffed it =
against our call order, case by case.=20

Sharpest example:
b43's generic switch_channel calls the per-channel tune, then
unconditionally re-applies a captured POR snapshot afterward - captured dur=
ing wl's first association, on channel 1. So channel 6 got tuned correctly,=
 then immediately overwritten back to channel 1's values.
wl's real order runs the POR replay once at attach, not after every
switch. Cost us a real mistune bug before the trace diff caught it.
Smaller example, same category: our TX-cal port was missing one PHY
register write wl issues between the gain-table override and starting the t=
est tone - doesn't crash, just makes the measurement never differentiate.

