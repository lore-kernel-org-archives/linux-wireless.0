Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41211 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab3LPMv6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 07:51:58 -0500
Message-ID: <1387198314.4665.27.camel@jlt4.sipsolutions.net> (sfid-20131216_135202_406645_921B0088)
Subject: Re: [PATCH v4] mac80211_hwsim: claim CSA support for AP
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Mon, 16 Dec 2013 13:51:54 +0100
In-Reply-To: <20131205172627.GA3593@magnum.frso.rivierawaves.com> (sfid-20131205_182708_985437_520E9348)
References: <1385224698-12294-1-git-send-email-karl.beldan@gmail.com>
	 <1386075333.4393.13.camel@jlt4.sipsolutions.net>
	 <20131205172627.GA3593@magnum.frso.rivierawaves.com>
	 (sfid-20131205_182708_985437_520E9348)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-12-05 at 18:26 +0100, Karl Beldan wrote:

> > Overall it seems ok, but all the purpose of csa_finished is not very
> > clear..
> > It looks that this patch tries to avoid extra beaconing on the previous
> > channel/hitting the warning..
> Yes, it avoids extra beacons.
> 
> > But the problem is much bigger here, it means that we didn't switch in
> > time (before the next beacon) so it's ok to hit the warning here and
> > transmit extra beacon with count==1.

> Precisely what I discussed in the previous emails.
> However, I'd expect WARN*s to trigger on unexpected conditions .. though
> I haven't seen any warning, the codepath nearly seems to beg for it.
> 
> > So if we see a lot of such warnings, maybe we need to fix
> > ieee80211_csa_finish instead (not using work for example)

> The replies I got from the race I detailed felt like ppl wanted to
> prevent this in-driver, now we agree this race prone work is a flaw.
> Maybe I'll send a v5 for hwsim relying on future in-stack improvement to
> avoid extra beacon instead of doing this in-driver, with some
> appropriate comments.

Generally, I think I'd prefer simpler code in the driver(s) over simpler
code in the stack, since the former tends to get duplicated a lot.

johannes

