Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39739 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756331Ab2IRInb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2012 04:43:31 -0400
Message-ID: <1347957847.6503.6.camel@jlt4.sipsolutions.net> (sfid-20120918_104337_198974_0F170017)
Subject: Re: regression: tethering fails in 3.5 with iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: artem.bityutskiy@linux.intel.com
Cc: Eric Dumazet <edumazet@google.com>, linux-wireless@vger.kernel.org
Date: Tue, 18 Sep 2012 10:44:07 +0200
In-Reply-To: <1347957651.7112.38.camel@sauron.fi.intel.com>
References: <1347361823.26457.3.camel@sauron.fi.intel.com>
	 <1DC40B07CD6EC041A66726C271A73AE6195AE9C8@IRSMSX102.ger.corp.intel.com>
	 <1347631355.5263.19.camel@sauron.fi.intel.com>
	 <1347640763.5263.24.camel@sauron.fi.intel.com>
	 <1347892887.7112.9.camel@sauron.fi.intel.com>
	 (sfid-20120917_163617_677167_0B529F43) <1347952199.6503.3.camel@jlt4.sipsolutions.net>
	 <1347957651.7112.38.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-09-18 at 11:40 +0300, Artem Bityutskiy wrote:
> On Tue, 2012-09-18 at 09:09 +0200, Johannes Berg wrote:
> > Hm. This is curious. *How* does AP mode fail? You said earlier stations
> > failed to connect, but can they actually get associated? I'm curious
> > because while I could see the carrier state thing causing issues (on old
> > hostapd versions that we didn't test), I'm not sure I see how the skb
> > payload makes a difference since mac80211 will linearize management
> > frames (so association should work) and data frames don't matter (so
> > authorization should work) ... unless there's a bug somewhere in
> > mac80211 where it forgets to pskb_may_pull(), but I don't see any such
> > place right now.
> 
> I am not sure what happens. In the failure case the high-level symptom
> (in NetwokManager or in Windows) is that "failed to set IP address".
> I've captured 2 tcpdumps - for the working (those 2 patches reverted)
> and non-working cases (vanilla 3.5.4). I'll send them to you privately. 

Thanks. I just got that far as well, but I hadn't set up a DHCP
server ... I'll debug further, I just confirmed that association still
works.

johannes

