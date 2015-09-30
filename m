Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48153 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753746AbbI3GrA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 02:47:00 -0400
Message-ID: <1443595615.1859.2.camel@sipsolutions.net> (sfid-20150930_084704_436063_29E59D80)
Subject: Re: Can we ignore frames with invalid BSSID in IBSS mode?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
Date: Wed, 30 Sep 2015 08:46:55 +0200
In-Reply-To: <5605D228.7050609@candelatech.com> (sfid-20150926_010105_789618_F93D668E)
References: <5605D228.7050609@candelatech.com>
	 (sfid-20150926_010105_789618_F93D668E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-09-25 at 16:00 -0700, Ben Greear wrote:
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
> 

You could end up accepting multicast frames from a different,
overlapping, BSS? Seems like a bad idea.

johannes
