Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378AbYB0RjU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2008 12:39:20 -0500
Subject: Re: Roaming issues.
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Lars Ericsson <Lars_Ericsson@telia.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <1204129706.6309.19.camel@johannes.berg>
References: <004501c87946$e5f1f490$0b3ca8c0@gotws1589>
	 <1204129706.6309.19.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 12:36:46 -0500
Message-Id: <1204133806.11761.12.camel@localhost.localdomain> (sfid-20080227_173924_086277_AD317281)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-02-27 at 17:28 +0100, Johannes Berg wrote:
> Hi Lars,
> 
> > AP deauthentication.
> > =====================
> > When any of the ieee80211_rx_mgmt_deauth() or ieee80211_rx_mgmt_disassoc()
> > are executed, the mac layer takes two actions.
> > 1) Tells wpa_supplicant what had happened.
> > 2) Start reestabliching the connaction again.
> > 
> > The later action will stop or significantly delay the decisions/action taken
> > by wpa_supplicant as a result of action 1. Normally the supplicant will
> > start an AP scan. 
> > But the mac layer is busy with reestablishing the link and will not start
> > any scan action.
> 
> Does associating actually block scanning?

If it doesn't, it really should.  There's been a number of problems over
the years with scan requests screwing up association because the card is
on a different channel and misses the association/auth exchanges.  To
ensure that association/authentication is as robust as possible, the
driver should refuse scans while association is ongoing.

This would be a problem for drivers like ipw2200 that always try to
associate with _something_ (see below for rants on that) even though
they haven't been told to.  In that case ipw2200 would have to know that
it's autoassociating and let the scan through.

> > My patches simply put the mac layer in IEEE80211_DISABLED state and wait for
> > the supplicant to decide.
> 
> That would break supplicant-less operation which we can't do.

Yeah; roaming is an area that's somewhat underdefined right now.  Wasn't
there previous discussion of a knob to tell the driver that userspace
was going to handle roaming?  Could be wrong, but the driver doesn't
always have all the details for roaming and there are times when
userspace knows better.  Could default to "driver" for roaming and then
the supplicant could set it to "off" when it takes over.

Which brings up the other issue of auto-association by drivers, which is
usually the wrong thing.  Yeah, it makes 1337 kernel hackers in the
woods happier because the card will be up automatically and associated
with their single open AP, but it's pretty much a bad idea anywhere else
(ipw2200 associate=1 for example).  The driver should only be
associating when it's told to do so, it shouldn't be going out and
finding APs on it's own ever.

> > The ieee80211_rx_h_sta_process() and  ieee80211_associated() are involved in
> > monitors for dead AP connection. A last_rx value is set to indicate a
> > working connection.
> > 
> > The porblem is the following lines.
> > 	if (!is_multicast_ether_addr(hdr->addr1) ||
> > 	    rx->sdata->vif.type == IEEE80211_IF_TYPE_STA) {
> > 
> > Any package that arrives to an STA will update the last_rx value and
> > prohibit a link lost action.
> > 
> > I have noticed in my system that this function receives the following type
> > of frames:
> > 1) Broad cast frames from my BSS (beacons).
> > 2) Data frames addressed to me ;)
> > 3) Data frames from other STA addressed to other MAC addresses but using the
> > same BSS.
> > 
> > It is the case 3 that creates the problem. Another STA, closer to my BSS
> > will update my last_rx value even I do not receive the BSS.
> 
> I'm pretty sure case 3 can't create a problem there since rx->sta
> wouldn't be set to the AP. Can you please print out "rx->sta->addr"
> after the !sta check in ieee80211_rx_h_sta_process and send me the log
> indicating that we can actually get into there with sta != our own AP?
> If we can that's a bug elsewhere but I doubt it.
> 
> > Timeout handling
> > =================
> > When any of the ieee80211_authenticate() or ieee80211_associate() function
> > are executed. 
> > The mac silently set its state to IEEE80211_DISABLED and waits for the
> > wpa_supplicant to timeout its current action.
> > 
> > I think it would be a good idea to signal to the supplicant that the
> > operation has timeout, and no further action will be taken.
> > To speed up the timeout response I had squeezed the supplicant timeout.
> 
> How do you signal that? Make a wext event with the BSSID all-zeroes or
> something? Sounds ok.

Yeah, a zero-BSSID event would mean "disconnected" or "association
failed" and the supplicant would take over at that point.

Dan


