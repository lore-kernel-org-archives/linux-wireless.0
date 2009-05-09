Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:44332 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227AbZEIBSc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 21:18:32 -0400
Subject: Re: Warning when terminating wpa_supplicant (wext driver)
From: Marcel Holtmann <marcel@holtmann.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
In-Reply-To: <43e72e890905081813r58888509je62856008cc62d22@mail.gmail.com>
References: <1241677107.2918.4.camel@localhost.localdomain>
	 <1241696104.27208.2.camel@johannes.local>
	 <1241704437.4903.15.camel@localhost.localdomain>
	 <1241705979.27208.31.camel@johannes.local>
	 <1241827331.4903.75.camel@localhost.localdomain>
	 <43e72e890905081813r58888509je62856008cc62d22@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 08 May 2009 18:18:11 -0700
Message-Id: <1241831891.4903.80.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> >> > > Copying Wey-Yi, but I think she's aware of this? It's definitely a
> >> > > driver issue. I _suspect_, but am not sure, that the driver kills the
> >> > > aggregation session when we disassoc or something and we only tell it
> >> > > about the STA removal after that, when it already killed the STA. Thus
> >> > > it would be a consequence of iwlwifi not implementing a proper
> >> > > sta_notify() callback.
> >> >
> >> > I don't see it with nl80211 driver, but that might be pure luck.
> >>
> >> Hmm, ok, that points to something else maybe... Now I wish I had my
> >> ftrace-mac80211 patch ready. Well, the patch is almost ready but we
> >> can't use ftrace in modules yet...
> >>
> >> Maybe there's some timing issue. I still think it's iwlwifi getting
> >> confused about what mac80211 is telling it as described, but it seems
> >> it's a little more subtle than what I said.
> >
> > something similar now happened during normal operation:
> 
> Just curious, have you applied johill's latest idle fix patch? I've
> been running iperf overnight with it and my woes are gone. I tested RX
> though, I'm leaving TX running now but haven't yet seen any warn.

this is still running wireless-testing.git from yesterday with the debug
addBA patch from Johannes.

Regards

Marcel


