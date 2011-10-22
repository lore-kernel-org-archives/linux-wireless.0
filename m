Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45836 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429Ab1JVNaH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Oct 2011 09:30:07 -0400
Subject: Re: Setting negative value in dBm for power output (txpower)
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: Patryk =?UTF-8?Q?=C5=BB=C3=B3=C5=82towski?=
	<patryk.zoltowski@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <CA+XFjiq6EJNczcotbk3R5YQXa-iY_2FY8KK4UN69XxSTm8LtoQ@mail.gmail.com> (sfid-20111022_000241_407613_8304DCDA)
References: <CAJ5hJZSm4P5Vpzmi6yfF3vy2XAMKH9kE-Kv=FfDLVX9DwQC4Aw@mail.gmail.com>
	 <CA+XFjiq6EJNczcotbk3R5YQXa-iY_2FY8KK4UN69XxSTm8LtoQ@mail.gmail.com>
	 (sfid-20111022_000241_407613_8304DCDA)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 22 Oct 2011 15:30:04 +0200
Message-ID: <1319290204.3956.0.camel@jlt3.sipsolutions.net> (sfid-20111022_153011_517590_5B552601)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-10-22 at 00:02 +0200, Gábor Stefanik wrote:
> 2011/10/21 Patryk Żółtowski <patryk.zoltowski@gmail.com>:
> > I'm doing a research and I'm wondering if it's possible to hack
> > wireless drivers to allow setting  txpower to smaller value than 1mW
> > (e.g. 0.1mW = -10dBM, or even 0.01mW). I've checked source code and in
> > net/mac80211/cfg.c there is the following check:
> >
> >  if (mbm < 0 || (mbm % 100))
> >                     return -EOPNOTSUPP;
> 
> The "mbm % 100" part is even weirder; why do we even use millibels if
> we only allow whole-decibel values?

This is really just historic -- nobody has so far cared about TX power
enough to clean up the APIs for it etc. The distinction between
"automatic", "fixed" and "limited" (auto <= some value) is also not
really done very well here.

johannes

