Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:58181 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbbI3INn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 04:13:43 -0400
Subject: Re: Can we ignore frames with invalid BSSID in IBSS mode?
To: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
References: <5605D228.7050609@candelatech.com>
From: Nicolas Cavallari <Nicolas.Cavallari@green-communications.fr>
Message-ID: <560B99AA.5060401@green-communications.fr> (sfid-20150930_101349_746217_ED2DB93B)
Date: Wed, 30 Sep 2015 10:13:30 +0200
MIME-Version: 1.0
In-Reply-To: <5605D228.7050609@candelatech.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26/09/2015 01:00, Ben Greear wrote:
> It seems that ath10k ar988X hardware has a bug where the BSSID
> for IBSS AMSDU frames is all zeros.  The 'main' 636 ath10k firmware
> does not seem to use AMSDUs for IBSS, and when I enable it in my CT
> firmware, then I see the breakage.  So, I suspect it is not
> just a simple software/firmware bug.
> 
> If I simply ignore the bssid_match check in ieee80211_accept_frame,
> then it seems everything runs fine.
> 
> So, I'm curious if anyone knows what sorts of bad things could happen
> if the bssid_match check is ignored?  Maybe bcast/mcast frames could
> be accepted when they shouldn't be in certain cases?

Given that all it takes for an IBSS station to be added as a neighbor
is to see a frame from an unknown station with the same BSSID
(ieee80211_ibss_rx_no_sta(), just 10 lines below), your ath10k chip
will consider all stations for neighboring IBSS to be part of this BSS.

If RSN is used, or any other protocol/program that watches the list of
neighbors, then your station will try to communicate with them.  Good
(those who don't ignore bssid checks) neighbors will normally drop the
frames. But if you deploy several machines ignoring the bssid check,
then they cannot run two concurrent IBSS networks.

Also, if there is a limit on how much stations the ath10k hardware can
handle, then that limit have a higher chance of being reached.
