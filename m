Received: from smtpcmd04132.aruba.it (smtpcmd04132.aruba.it [62.149.158.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8094525A8D
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 17:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.158.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791912589; cv=none; b=ArhxKEpLYPA3ZVIVc49PjDZhieoVkeOf8d6G/BxYz4MI7TcpIOIsXY/XSbOhFWTUXpcy6AHHB34PTjIQwV+/syMumpGOFkQx28CSz0/23JPRPpuO6cy7M2sdC7rXGOEZDbja0BhQh2ccR2rtE9D4b5bdiJtfCV/PPKDzUC7Bl+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791912589; c=relaxed/simple;
	bh=JXjuI24D+JN92IftggV2Z3vBtLO72/3deJBrbhK4KLI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HmOuKDDTSclISUGPRLEpHVs68uFlS+SgUi2DWHbsZxbf0u6mEL4CyX/EFEuGomtoCwv6b7U6AF0fgmPyPzTJXkyiHhgy8GyX6nE9d0V9XVzaUjUQ26zx/l5x5PPKKBLtuTLds+nKUWOc5P2jGjq1P9x+xkDL5xUjrdqYxUrt8us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=LGbvyeEv; arc=none smtp.client-ip=62.149.158.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="LGbvyeEv"
Received: from fedora ([94.34.125.0])
	by Aruba SMTP with ESMTPSA
	id GgGqxY4osk92eGgGqx6MKu; Tue, 13 Oct 2026 19:26:37 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1791912397; bh=JXjuI24D+JN92IftggV2Z3vBtLO72/3deJBrbhK4KLI=;
	h=Date:From:To:Subject:MIME-Version:Content-Type;
	b=LGbvyeEvh4iONzllWdZOA4PoXGGIQy5BwNCPTz+mPAEQoiVdMs8IhF/OjjER7jnFk
	 SlWqj45toc8UYkzDKBWNxxBAmO0DevsZ/Mdwn8TLT/icOJDli2RaWYdTmChdOOiusV
	 AAu00xasYwQ6amRscUF3hwUvS2Rwj9CM2UWgia7UZamVxGulpkC5vyeErdqURQ7l9O
	 ZUQSrMYzqWMB1Xc/e+kvKvDmF/fF6/d0Kwb04xa/BQ2Y4yEt3rJ9IdDssrkoiyWa1h
	 VQannN7EQOMTH3WBqRwegks+E1jgdBkCU8VpuIBRRS/KvnY9afnO7eegI86GOxuydO
	 a/KffNvJ4quGg==
Date: Tue, 13 Oct 2026 19:26:35 +0200
From: Alessio Ferri <alessio.ferri@mythread.it>
To: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, Rob Herring
 <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
 Philipp Zabel <p.zabel@pengutronix.de>, Broadcom internal kernel review
 list <bcm-kernel-feedback-list@broadcom.com>, Thomas Bogendoerfer
 <tsbogend@alpha.franken.de>, linux-wireless@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mips@vger.kernel.org
Subject: Re: [PATCH v2 0/5] bcma: support the BCM6362 integrated WLAN
 backplane
Message-ID: <20261013192635.5384335c@fedora>
In-Reply-To: <6ceddef2-09af-49ba-87c8-4c39e34d36ac@broadcom.com>
References: <20261012-bcm6362-wlan-v2-0-4752da7e0982@mythread.it>
	<b7e21fad06d27f88b3c18060b4f4a69149de52eb.camel@sipsolutions.net>
	<20261013145630.52fdec0d@DELL-MOBILE03.ad.smart.it>
	<20261013181600.58ad8dc3@DELL-MOBILE03.ad.smart.it>
	<6ceddef2-09af-49ba-87c8-4c39e34d36ac@broadcom.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-CMAE-Envelope: MS4xfJeKBQJQmnPe1Xg0Lp8Q0DrUYJ2ttd191ob+gky4vHAn4IbBZx4yvhQVWKuDNpp7Ni0oAOe60vfJmwH+5B5qVXQBkWtim5enuXFigv2zSjd5gevXtEr3
 rGLbVAh/a5aAL4dLUutT9B6+SX75kRH6M9sle6f1SpiAiPsjgwO8DH7Lq+UsAgSUN/BwZCo7ftolfJevkuBGgjxMhSDFAdwLEUln6obFYGw0yYJjyz2/HuAU
 6/mbyh1+LQOmUcgq3/Fhc955lVn7vgH3R1TQbZusFlioksvfQfpIBKzexJP6wK2G9AvFDnjk3P3lUCafnkjgFGUp4zCA51qHDrKkmFZvAyTCnrBK2dBp8OsY
 0ef03CwpgmLDNWXBK+gIuwbVd7wDafXJcFKlkVqTMmXySebTzPYw0rOawp8JvbKbLlNMeWQc8FYOPjyajv9+BVzg+Heu4zDTc+0JAwn7lobk6hTGbtZDAiV/
 BlZvPZFQTTX4OYNNFPxi09FYPPOoNxK4gIgzG1PEevjjInc8k+Mzl+YXevI4/11/HD4BxDyS+brl39H9Fi6TFL0sHO2R6kk9V6gVFOOawNvc0z1PK3Yn1K4H
 oZkI4QprqDo/eCCKlFZ8wcoVoAZTLTK+yrqQtfv1jPwULA==

Il giorno Tue, 13 Oct 2026 09:25:30 -0700
Florian Fainelli <florian.fainelli@broadcom.com> ha scritto:

> On 10/13/26 09:16, Alessio Ferri wrote:
> > On Tue, 13 Oct 2026 14:56:30 +0200
> > Alessio Ferri <alessio.ferri@mythread.it> wrote:
> >  =20
> >> On Tue, 13 Oct 2026 14:29:37 +0200
> >> Johannes Berg <johannes@sipsolutions.net> wrote:
> >> =20
> >>> On Mon, 2026-10-12 at 00:45 +0200, Alessio Ferri wrote: =20
> >>>>
> >>>> My router is running daily with it, using openwrt kernel 6.12. =20
> >>>
> >>> [...]
> >>>     =20
> >>>> This was drafted with the help of an LLM and cross built with gcc
> >>>> mips cross compiler and checked with the dev version of sparse.
> >>>> This time i also ran dt-check-style and it didn't flag anything.
> >>>>     =20
> >>>
> >>> So ... are you running it or not? I'm confused.
> >>>     =20
> >>
> >> I don't see your source of confusion: i am running it with kernel
> >> 6.12 and it works, but last i checked the current kernel is not
> >> version 6.12... so i had to rebuild it for the current kernel and
> >> i did it with help from an LLM. And also i ran the checks for the
> >> dt part, OpenWRT build system couldn't care less that i didn't
> >> even register the bindings, but i know bindings maintainer care
> >> about it.=20
> >>> Either way, I have no idea what to do with it - I guess Rafa=C5=82 if
> >>> you want this picked up then let folks know? But the last patch
> >>> should probably go through some MIPS trees anyway, so the others
> >>> might as well go there too, I don't care (and don't really _want_
> >>> to be responsible for this obscure corner just because some wifi
> >>> drivers use it).
> >>>
> >>> johannes =20
> >>
> >> The original code is Broadcom's. You can also ask Broadcom
> >> directly if this is correct/sane for them. =20
> >=20
> > I must say that i was pretty vague in the last statement:
> > By "code" i really meant "C headers", and by "ask Broadcom
> > directly" i meant "ping the Broadcom devs already included in the
> > cc if they do not respond by themselves in a few days". =20
>=20
> As you should know by now, the folks working on this never cared for=20
> upstream in any way shape or form, so using bcma and Device Tree, and=20
> combining both might be a tad too much to ask to review.
>=20
> That said, I think you approach makes sense, but Jonas Gorski who is
> not copied on this patch series, but is now aware of it, should
> really be reviewing this.

Thank you, bcma felt the simplest way to integrate it and it is
directly used by b43, which is primary user of the device.
Will wait for Jonas input then.
