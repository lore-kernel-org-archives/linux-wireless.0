Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-6.exch022.serverdata.net ([206.225.164.189]:21419
	"EHLO HUB022-nj-6.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751883Ab2KTM4q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 07:56:46 -0500
From: Mahesh Palivela <maheshp@posedge.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC v2 4/8] nl80211/cfg80211: support VHT channel configuration
Date: Tue, 20 Nov 2012 12:56:45 +0000
Message-ID: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FD18651@mbx022-e1-nj-10.exch022.domain.local> (sfid-20121120_135649_794014_EBE01CE0)
References: <1352492254-29399-1-git-send-email-johannes@sipsolutions.net>
	  <1352492254-29399-5-git-send-email-johannes@sipsolutions.net>
	  <50AB3EE1.8060101@posedge.com>
	  <1353400890.9399.3.camel@jlt4.sipsolutions.net>
	  (sfid-20121120_094103_819884_8535CF9F)
 <1353404398.9399.9.camel@jlt4.sipsolutions.net>
	 <50AB70B9.1010505@posedge.com>,<1353414102.9399.16.camel@jlt4.sipsolutions.net>
In-Reply-To: <1353414102.9399.16.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No objections from me Johannes. Please commit.

Thanks,
Mahesh

________________________________________
From: Johannes Berg [johannes@sipsolutions.net]
Sent: Tuesday, November 20, 2012 5:51 PM
To: Mahesh Palivela
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC v2 4/8] nl80211/cfg80211: support VHT channel configuration

On Tue, 2012-11-20 at 17:29 +0530, Mahesh Palivela wrote:

> >>> For loops in both functions seems to be similar. One return false, other
> >>> return -EINVAL. Can we remove duplication?
> >>
> >> True, but they check different flags. I suppose we could have a common
> >> function where the checked flags are passed in, I can try that.
> >
> > I'll add this to the patch:
> >
> > http://p.sipsolutions.net/24eb25fb98ef2d0b.txt
> >
>
> Looks good to me Johannes. Overall your VHT channel config
> implementation done so well.

Thanks for reviewing!

> Partial regulatory check in nl80211_parse_chandef() has to be modified
> to include BW check. I see your TODO comment there.

Yes, although I'm not completely sure the bandwidth check ever made
sense? We'll need to discuss that.

Regardless of that though, I'm tempted to put this into the tree now. As
we don't have any drivers (but hwsim) using it, we won't have any
regulatory issues without the bandwidth check for now, and then we can
base further work on this.

Any objections from you? If not I'll repost the whole thing as [PATCH].

johannes

