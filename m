Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52140 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146AbaAaNmS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jan 2014 08:42:18 -0500
Message-ID: <1391175734.4141.12.camel@jlt4.sipsolutions.net> (sfid-20140131_144221_963855_6BDFD53B)
Subject: Re: [PATCH v2 2/3] cfg80211: introduce regulatory wide bandwidth
 flag
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 31 Jan 2014 14:42:14 +0100
In-Reply-To: <CAB=NE6XysGH36Jep4xxqQZPmFM=AR6akcb-REWPW93H4y68=tQ@mail.gmail.com> (sfid-20140130_014204_336610_4613A623)
References: <1390394624-3927-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1390394624-3927-2-git-send-email-janusz.dziedzic@tieto.com>
	 <1390492620.4142.33.camel@jlt4.sipsolutions.net>
	 <20140125003255.GE28512@garbanzo.do-not-panic.com>
	 <1391001002.4143.14.camel@jlt4.sipsolutions.net>
	 <CAB=NE6XysGH36Jep4xxqQZPmFM=AR6akcb-REWPW93H4y68=tQ@mail.gmail.com>
	 (sfid-20140130_014204_336610_4613A623)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-29 at 16:41 -0800, Luis R. Rodriguez wrote:

> > The only thing I could think of an optimiser doing is combine ranges,
> > but then it would lose flags which can't be right.
> 
> One thing is in-kernel rules, another is wireless-regdb. If you are
> extending rules in wireless-regdb you may at times run into a
> situation where two rules are contiguous and you know you can combine
> them and want to, combination for example makes sense if your source
> for the db has a set of contiguous frequency rules with the same
> power, max eirp, and flags. That's what the optimizer available as a
> library does in reglib, part of CRDA.

My point mostly is that due to how the rules are interpreted (a single
channel must fit into a single frequency range), this isn't just an
optimisation, it actually has impact on the behaviour. So calling it an
'optimizer' is misleading, that implies that it's actually always
desired to do this, which isn't necessarily the case (it's quite likely
the case, and IMHO the old interpretation rules are stupid, but those
are what we're stuck with.)

johannes

