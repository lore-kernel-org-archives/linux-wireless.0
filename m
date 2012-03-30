Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33898 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933785Ab2C3La2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2012 07:30:28 -0400
Message-ID: <1333107022.3908.16.camel@jlt3.sipsolutions.net> (sfid-20120330_133031_637544_6861318E)
Subject: Re: [PATCH 0/2] compat: fix extreme build slowdowns
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 30 Mar 2012 13:30:22 +0200
In-Reply-To: <20341.39041.645223.592030@gargle.gargle.HOWL>
References: <1333105815.3908.11.camel@jlt3.sipsolutions.net>
	 <20341.39041.645223.592030@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-30 at 16:56 +0530, Sujith Manoharan wrote:
> Johannes Berg wrote:
> > Somehow exporting too many variables completely confuses the kernel's
> > Makefiles into trying to calculate the size of every file in a very slow
> > shell script ... this is causing EXTREME build slowdowns for me.
> > 
> > These two patches fix it.
> 
> Nice.
> 
> Trying to build ath9k..
> 
> Before:
> 
> real    1m18.689s
> user    3m1.382s
> sys     0m6.833s
> 
> After:
> 
> real    0m42.091s
> user    1m30.024s
> sys     0m5.700s

Yeah, I also see about 50% build time now with everything in cache, if
the files it's sizing up aren't in cache then it can be much slower with
the old version.

johannes

