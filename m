Received: from smtpcmd03116.aruba.it (smtpcmd03116.aruba.it [62.149.158.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0010A3AFB01
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 08:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.158.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790672352; cv=none; b=c1hRxJwUcaMFIHXTcII/V8SzW/T5dfU+D5nISOy6qgVSPHTk9ovvogmJJ5pYyEW7ZzqZYnwEA2Hbgt3+v8qsIpFyw1CSPHuvyb+6R80z865jjiYZDcEIj/exetmMT+9sGYZR+0RSpVxd2ZUNdLBf/BsSaGZWB9LVd9JSF46WJpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790672352; c=relaxed/simple;
	bh=F770U/ZW9dr6tmV9XMmJ7Hip1w4hincRL7oGr6NNsZc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A1X94IRWXDC458IDVvABax1x9695Mkm9Y/7jgg8CefOq4X3yYAgGYjtAZ8xcgSq/UluI5U9u38kE4EUlqnRuuISurxjueNdMMoobFlUoX86+fc0JJCgpn5laJYYlei86pmLJYPgx0/W6X5cbiiMZF66X+7RnBtBM3RQfwrqlywQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=nU12D5xP; arc=none smtp.client-ip=62.149.158.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="nU12D5xP"
Received: from DELL-MOBILE03.ad.smart.it ([77.89.54.34])
	by Aruba SMTP with ESMTPSA
	id BTfwxW6R0dVTCBTfxx07qk; Tue, 29 Sep 2026 10:59:01 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1790672341; bh=F770U/ZW9dr6tmV9XMmJ7Hip1w4hincRL7oGr6NNsZc=;
	h=Date:From:To:Subject:MIME-Version:Content-Type;
	b=nU12D5xPKlCl5dTOJfCmY+GmQnImlqBaWDn0RquvwlekMflXGrhHD4hezfbtIQaRT
	 B9BslVv79tHs65RJhtYrT8sZoi7IMBZEad1Mrq3u/Af262aWIb2IckHN92q9VcI70y
	 R9hQtGyUX8jMX8mDHqhLJTEWW008qPuV3m1fwmRI1gQqjRY7FWMUcWC4i4GeT4nw2n
	 fw02iF17f0MEIeTV5hQnOUDSuslhRQyfds/3OR36SoYO/gLe1z7Yz7LgynEVBpNLsj
	 Wi7py1Z6IhtLt2OzEVJ0KXJpY8KD6b1mhxknT/sZD4TMtBcdsDMYq4pNxeUa4pnNd2
	 IGiXg17wPf0jg==
Date: Tue, 29 Sep 2026 10:58:59 +0200
From: Alessio Ferri <alessio.ferri@mythread.it>
To: "andreas.wendleder" <andreas.wendleder@proton.me>
Cc: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>, "b43-dev@lists.infradead.org"
 <b43-dev@lists.infradead.org>, "linux-wireless@vger.kernel.org"
 <linux-wireless@vger.kernel.org>
Subject: Re: BCM4360 AC-PHY support for b43 =?UTF-8?B?4oCU?=
 reverse-engineered, seeking guidance on a clean path upstream
Message-ID: <20260929105859.364ea71b@DELL-MOBILE03.ad.smart.it>
In-Reply-To: <d6tVX7HBAW4Qnebx5Enj79edWG_LVmnRT0bjhcfv9bb1h0cewrTEDHK-VVoSy0NZcMzv3FB8OVEyTFNgA7rs_zaplEfiLXdwcCqhYDeonMo=@proton.me>
References: <rOzY3WnW4q5L1osv7iagU81dLGldzZEsu3EqHxmH4d7Z4vxubBYvRNT0vsrbr8n-CUSEYyXxGFE3h9PHLHgePjm3_rMK_B_0m5loTpyxX-M=@proton.me>
	<ih-lXs5OlHxMhydtcZFtKNhGg3cGlR137CEMZ07_zFQcfCYAImW6MRWPDjkdwy-xK9bIwpDK9ImgerqHmQMsAxX3ckEjsiN8QoCSlpvIsSM=@proton.me>
	<20260928200309.01a36f5e@barney>
	<DL5AS1oidqGRAmMHt0Jcp3X4T3ob_Fa-lfhTmMMak3ATUnfcyETDn65CQf3iLvVeg4ExYoc_0GW7QMoaB1jEW4nzKAKFDv8bD0hqBEtkUKg=@proton.me>
	<20260929081403.6076a6da@barney>
	<20260929093405.79d9f4ec@DELL-MOBILE03.ad.smart.it>
	<hCBGuqVmDlV3Y7f2t6L8DtnoyBNbC8KghHXm0fZCHLDLrtfaoYw9e0UcCCsQHHK1X4TBz0DuvSL4zmAx_dVS3q54BZ0JZXtjXXNnuSAFtyo=@proton.me>
	<20260929100544.343ce6d2@DELL-MOBILE03.ad.smart.it>
	<d6tVX7HBAW4Qnebx5Enj79edWG_LVmnRT0bjhcfv9bb1h0cewrTEDHK-VVoSy0NZcMzv3FB8OVEyTFNgA7rs_zaplEfiLXdwcCqhYDeonMo=@proton.me>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfEjpnqeaAJaKmk86tSb054r59JtrAzJIjBaPxFrSPI24Hc5WRIc6kUncSgii1yRrXvK4+CH+6A9xKyc7qu0OXXIzyZqwbvf5XfL/sJgOKY/MQMUvWkuC
 U7bLpsoWwuCByfZDZkZpgzEgF5ZzQUKGbYkW9eBhKEaIwaFMEhMXjEY5hJI1yxUCeHKb13V2vdK2v+T8TcT+5cTZ4i0vidYsEl31U+d6Y8sBgFpY3UL0BlGE
 r4jkXr4DZOqsU6ty4CewdOCuCcBNBopImYM9nT8PNmBcfRsVIp+h3KjEZPrsNl3cBa/L99Fmx1t0szmifX2qUw==

On Tue, 29 Sep 2026 08:27:53 +0000
"andreas.wendleder" <andreas.wendleder@proton.me> wrote:

> > Least, but not last, the wl order of macro operation and b43 order
> > are different in multiple places, how did you reconcile the two?  
> 
> Good sign: we're core_rev 42 too, so our disassembly and yours should
> be directly comparable.
> 

I didn't mass disassemble, i just hooked the io accessors, both because
it is faster to learn what the driver is doing and less problematic if
someone ask. Also the trace can be shared, the disassembly does not.

> femctrl/srom: not touched, no handling anywhere in our port. One fixed
> test board, so we've never hit a different value. No data point to
> offer - if you find out what it gates, let me know.

So you harcoded your srom?

> 
> wl order vs b43 order: we captured wl's real register-access sequence
> live (bpftrace kprobes on its own osl_readl/writel/delay, wl left
> loaded and bound throughout - never touch its binding while probes
> attach) and diffed it against our call order, case by case. 
> 
> Sharpest example:
> b43's generic switch_channel calls the per-channel tune, then
> unconditionally re-applies a captured POR snapshot afterward -
> captured during wl's first association, on channel 1. So channel 6
> got tuned correctly, then immediately overwritten back to channel 1's
> values. wl's real order runs the POR replay once at attach, not after
> every switch. Cost us a real mistune bug before the trace diff caught
> it. Smaller example, same category: our TX-cal port was missing one
> PHY register write wl issues between the gain-table override and
> starting the test tone - doesn't crash, just makes the measurement
> never differentiate.
>

But which driver version did you look at? The 6.30 hybrid?
