Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:32929 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab3KNOig (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 09:38:36 -0500
Received: by mail-pa0-f51.google.com with SMTP id fb1so2159690pad.24
        for <linux-wireless@vger.kernel.org>; Thu, 14 Nov 2013 06:38:36 -0800 (PST)
Date: Thu, 14 Nov 2013 06:49:16 -0800
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Jouni Malinen <j@w1.fi>, sunitb <sunitb@qca.qualcomm.com>,
	rsunki <rsunki@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 0/5] cfg80211: regulatory quiescing and exporting DFS
 regions
Message-ID: <20131114144914.GG19070@garbanzo.do-not-panic.com> (sfid-20131114_153857_070349_3BB006EF)
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
 <1384368487.14578.25.camel@jlt4.sipsolutions.net>
 <CAB=NE6VkL8L1uiJTrY3P7LUSepRHkS+paE3kmsTunUW_6n5Xvg@mail.gmail.com>
 <1384370024.28250.1.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1384370024.28250.1.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 13, 2013 at 08:13:44PM +0100, Johannes Berg wrote:
> On Wed, 2013-11-13 at 19:57 +0100, Luis R. Rodriguez wrote:
> > On Wed, Nov 13, 2013 at 7:48 PM, Johannes Berg
> > <johannes@sipsolutions.net> wrote:
> > > On Wed, 2013-11-13 at 19:12 +0100, Luis R. Rodriguez wrote:
> > >
> > >> Janusz, please test, and likely feel free to take on the last patch.
> > >> We may need help from Johannes on the rtnl lock question now required
> > >> for checks on enabling beacon operation.
> > >
> > > What's that rtnl thing about?
> > 
> > Whether or not callers of cfg80211_reg_can_beacon() have it properly
> > held already and if not best strategy to make this simple and concise.
> > The rtnl is required as we need to now query the cfg80211 regdom dfs
> > region for the case where a channel requires DFS.
> 
> Can't you just use RCU for that part?

If Janusz is right then we don't even need that patch at all :D
The rtnl then would only be used for sending the wiphy, we'd
just require hostapd to always check for the DFS region prior to
starting IR for the first time, if the netdev was brought down
(quisced), we'd have to have it check again the DFS region.

This however does assume we can quiesce properly upon regulatory
domain changes.

  Luis
