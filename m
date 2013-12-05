Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53383 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756957Ab3LER1J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 12:27:09 -0500
Received: by mail-wg0-f44.google.com with SMTP id a1so15004514wgh.23
        for <linux-wireless@vger.kernel.org>; Thu, 05 Dec 2013 09:27:08 -0800 (PST)
Date: Thu, 5 Dec 2013 18:26:27 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Subject: Re: [PATCH v4] mac80211_hwsim: claim CSA support for AP
Message-ID: <20131205172627.GA3593@magnum.frso.rivierawaves.com> (sfid-20131205_182720_125647_68D5A322)
References: <1385224698-12294-1-git-send-email-karl.beldan@gmail.com>
 <1386075333.4393.13.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1386075333.4393.13.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 03, 2013 at 01:55:33PM +0100, Johannes Berg wrote:
> On Sat, 2013-11-23 at 17:38 +0100, Karl Beldan wrote:
> 
> > This adds a per vif bool csa_finished that is set after a call to
> > ieee80211_csa_finish() and used to skip beaconing while csa_active is
> > set in case a beacon is scheduled prior to csa_finalize_work completion.
> > This bool and the number of beacons transmitted during the CSA up to the
> > call to ieee80211_csa_finish() are reset in channel_switch_beacon op.
> 
> Andrei says:
> 
> Overall it seems ok, but all the purpose of csa_finished is not very
> clear..
> It looks that this patch tries to avoid extra beaconing on the previous
> channel/hitting the warning..
Yes, it avoids extra beacons.

> But the problem is much bigger here, it means that we didn't switch in
> time (before the next beacon) so it's ok to hit the warning here and
> transmit extra beacon with count==1.
Precisely what I discussed in the previous emails.
However, I'd expect WARN*s to trigger on unexpected conditions .. though
I haven't seen any warning, the codepath nearly seems to beg for it.

> So if we see a lot of such warnings, maybe we need to fix
> ieee80211_csa_finish instead (not using work for example)
> 
The replies I got from the race I detailed felt like ppl wanted to
prevent this in-driver, now we agree this race prone work is a flaw.
Maybe I'll send a v5 for hwsim relying on future in-stack improvement to
avoid extra beacon instead of doing this in-driver, with some
appropriate comments.
 
Karl
