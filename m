Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45389 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756640Ab3KMTMb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 14:12:31 -0500
Message-ID: <1384369941.28250.0.camel@jlt4.sipsolutions.net> (sfid-20131113_201234_320322_DB361441)
Subject: Re: [RFC 0/5] cfg80211: regulatory quiescing and exporting DFS
 regions
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Jouni Malinen <j@w1.fi>, sunitb <sunitb@qca.qualcomm.com>,
	rsunki <rsunki@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 13 Nov 2013 20:12:21 +0100
In-Reply-To: <CAB=NE6VkL8L1uiJTrY3P7LUSepRHkS+paE3kmsTunUW_6n5Xvg@mail.gmail.com> (sfid-20131113_195723_598333_78AE4C15)
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
	 <1384368487.14578.25.camel@jlt4.sipsolutions.net>
	 <CAB=NE6VkL8L1uiJTrY3P7LUSepRHkS+paE3kmsTunUW_6n5Xvg@mail.gmail.com>
	 (sfid-20131113_195723_598333_78AE4C15)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-13 at 19:57 +0100, Luis R. Rodriguez wrote:
> On Wed, Nov 13, 2013 at 7:48 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2013-11-13 at 19:12 +0100, Luis R. Rodriguez wrote:
> >
> >> Janusz, please test, and likely feel free to take on the last patch.
> >> We may need help from Johannes on the rtnl lock question now required
> >> for checks on enabling beacon operation.
> >
> > What's that rtnl thing about?
> 
> Whether or not callers of cfg80211_reg_can_beacon() have it properly
> held already and if not best strategy to make this simple and concise.
> The rtnl is required as we need to now query the cfg80211 regdom dfs
> region for the case where a channel requires DFS.

Can't you just use RCU for that part?

johannes

