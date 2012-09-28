Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52235 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab2I1Gjt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2012 02:39:49 -0400
Message-ID: <1348814421.9978.4.camel@jlt4.sipsolutions.net> (sfid-20120928_083952_542963_4B0F88AF)
Subject: Re: [RFC v3] cfg80211: VHT regulatory
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Mahesh Palivela <maheshp@posedge.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Date: Fri, 28 Sep 2012 08:40:21 +0200
In-Reply-To: <CAB=NE6URYEr4d6ti0W7Go37x1fRM_9XD09cQXx4EJ6afhpPuXA@mail.gmail.com> (sfid-20120925_210657_912005_3BE19F7C)
References: <504DBBAC.7040300@posedge.com>
	 <CAB=NE6UfQdM6HrVGw3Dn-NBxQupwA3kJD27kv3c9DjLY8DVm1Q@mail.gmail.com>
	 <5052E852.8030804@posedge.com>
	 <1347896071.4975.14.camel@jlt4.sipsolutions.net>
	 <CAB=NE6VMOvftuxi1zu3=4q-BJgM9rJHY86W-6+MAHmtY=V=6xA@mail.gmail.com>
	 <1348483695.10257.8.camel@jlt4.sipsolutions.net>
	 <CAB=NE6Wemx5NCTz-Q-vY4ogTUxbF+RjWdzeTt=qVrgGVhm_y+w@mail.gmail.com>
	 <1348557403.10041.10.camel@jlt4.sipsolutions.net>
	 <CAB=NE6URYEr4d6ti0W7Go37x1fRM_9XD09cQXx4EJ6afhpPuXA@mail.gmail.com>
	 (sfid-20120925_210657_912005_3BE19F7C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-09-25 at 12:06 -0700, Luis R. Rodriguez wrote:

> > You've got to be kidding? Runtime cost of this is negligible, we only
> > execute the test when we switch channels which happens very
> > infrequently.
> 
> Well considering P2P technologies slowly blooming I would disagree
> that channel changes are going to be infrequent. Then we also have
> scanning which can happen any time you move away from your AP and at a
> specific interval. Are we going to remove the capability to use each
> channel as cached value and always ask cfg80211 it we can move on?

They're still going to be infrequent, you're not going to switch
channels (in mac80211) for every other packet :-) Even if you were to do
channel switching every couple of seconds, which is really unlikely and
will kill all performance, the calculation overhead wouldn't matter.

johannes

