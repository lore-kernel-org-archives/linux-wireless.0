Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([83.151.30.3]:54854 "EHLO m25s01.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab3KDNgx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Nov 2013 08:36:53 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Luciano Coelho <luciano.coelho@intel.com>
Subject: Re: [RFC] mac80211: don't transmit beacon with CSA count 0
Date: Mon, 4 Nov 2013 14:36:51 +0100
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
References: <1383569955-13236-1-git-send-email-luciano.coelho@intel.com>
In-Reply-To: <1383569955-13236-1-git-send-email-luciano.coelho@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201311041436.51673.sw@simonwunderlich.de> (sfid-20131104_143657_328515_976A692D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Luca,

> A beacon should never have a Channel Switch Announcement information
> element with a count of 0, because a count of 1 means switch just
> before the next beacon.  So, if a count of 0 was valid in a beacon, it
> would have been transmitted in the next channel already, which is
> useless.  A CSA count equal to zero is only meaningful in action
> frames or probe_responses.
> 
> Fix the ieee80211_csa_is_complete() and ieee80211_update_csa()
> functions accordingly.
> 
> Cc: Simon Wunderlich <sw@simonwunderlich.de>
> Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
> ---
> 
> Hi Simon (et al),
> 
> I identified this issue while playing around with CSA.  I noticed that
> we are sending a CSA beaon with count == 0, which should not happen.
> The last beacon visible in the current channel (ie. before the switch)
> contains a CSA IE with count == 1.
> 
> I wanted to check with you if my proposed change would have any
> side-effects, especially with the ath9k driver, which is the only user
> of this code in the mainline at the moment.
> 
> The potential danger here is if you don't check
> ieee80211_csa_is_complete() before you send the first CSA beacon out.
> With the previous code, there would always be a beacon with CSA (count
> == 0), but now, if the count starts with 1, there won't be any.  If
> you don't check, my patch will probably introduce a WARN when the
> ath9k driver tries to get the beacon without checking for CSA
> completion..
> 
> Any other comments or a sanity check would also be appreciated.

Thanks for checking back - I've read the part in the spec again [1], and 
appearently you are right.

With your proposed change, shouldn't we also change the behaviour if the 
userspace requests a channel switch with count = 0? I guess we should 
immediately change the channel then without waiting for beacons? I don't see 
the point in changing the beacons if we don't send them, after all. Currently, 
ath9k calls the csa_finish() after checking whether beacon sending was complete 
... so this would have to be changed.

Cheers,
    Simon


[1] IEEE 802.11-2012, 8.4.2.21 
For nonmesh STAs, the Channel Switch Count field either is set to the number of 
TBTTs until the STA sending the Channel Switch Announcement element switches 
to the new channel or is set to 0. A value of 1 indicates that the switch 
occurs immediately before the next TBTT. A value of 0 indicates that the  
switch occurs at any time after the frame containing the element is 
transmitted.
