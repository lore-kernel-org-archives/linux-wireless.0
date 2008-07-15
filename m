Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384AbYGOQvE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 12:51:04 -0400
Subject: Re: background scanning and fast handovers
From: Dan Williams <dcbw@redhat.com>
To: devel@e-doo.de
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <28167927.118721216023197288.JavaMail.servlet@kundenserver>
References: <28167927.118721216023197288.JavaMail.servlet@kundenserver>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 12:48:58 -0400
Message-Id: <1216140538.6039.95.camel@localhost.localdomain> (sfid-20080715_185109_999687_79922202)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-07-14 at 10:13 +0200, devel@e-doo.de wrote:
> Hi Everybody,
> I'm new on linux-wireless mailing list.
> 
> In the recent past I completed my diploma thesis, which included some software implementations with the Madwifi driver. In future the compact-wireless driver (with ath5k) will be used for Atheros Chipsets.
> So - I'm very interessted to keep an eye on the development of the compact-wireless driver.

I think you mean "compat-wireless", right?  In any case, we'll just take
that to mean mac80211-based drivers really since that's what we can
actually control.

> Maybe I can be a part in enhancing the driver in the future.
> 
> But first, I have a few questions to you:
> 
> How does the compact-wireless driver handle the case, when a connection of a STA to an AP gets lost?

Right now, the lowest-common-denominator is that the driver sends a
disconnection event to userspace, and userspace handles reconnection as
it sees fit.  Some drivers may attempt to reconnect to the AP
periodically until told not to.

I personally think the driver/stack should try a few reconnections to
the AP (without sending the SIOCSIWAP disconnect event) and only if
those all fail, send the disconnect event.  But if the reconnection was
successful, send the SCIOCSIWAP event for the AP even if it matches the
old AP's BSSID just so userspace knows that something happened.
wpa_supplicany may need to know this to rekey the connection or
something.

But really, the connection loss could be for any number of reasons, like
the AP is out of resources, out of range, missed a few beacons because
somebody turned a microwave on, etc.  A few reconnection attempts might
help out some of these but at some point you just have to pick a new AP
to associate with.

> Is there a solution for "fast handovers" between two APs?

Do you mean two BSSs in the same ESS?  In any case, roaming between to
BSSes of the same SSID is currently highly driver dependent and it's
pretty much assumed that drivers can choose which BSS to associate to
within the same ESS

Roaming between two APs _not_ in the same ESS is currently left to
userspace.

> Are there any activities to implement something like a "background scanning" in STA Mode?

Some drivers already do this (ipw for example), but I don't think
background scanning is really implemented in mac80211 at this time.
mac80211 certainly will handle beacons and probe responses _on the same
channel_, but I don't believe there is any sort of multi-channel
background scanning going on, nor should there really be unless it can
be made _very_ fast.  You don't want the driver doing a multi-channel
background scan while you're using VOIP.

> A background scanning will allow a STA to observe the neighbourhood for new APs.

Right.

> There are a few drivers that provide this functionality today.
> The intention is to reduce Handover latency of a mobile STA, when it switches from one AP to an other AP.

Again, within the same ESS?

> What do you think:
> Is it interessting for you, to work jointly on these challenges?

Personally I think anything we can do to make intra-ESS handover faster
is a good thing.  wpa_supplicant in userspace is obviously required here
for WPA roaming and it can handle things like preauth and other bits of
fast reauth defined in the WPA specs.  Since that's where things are
going, it's going to need coordination between both the driver and the
supplicant to get right.

Dan

