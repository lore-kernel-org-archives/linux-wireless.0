Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48418 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090AbcCOOKd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2016 10:10:33 -0400
Message-ID: <1458051029.2871.14.camel@sipsolutions.net> (sfid-20160315_151039_044855_E50082E1)
Subject: Re: [PATCH-v2] mac80211:  Let VHT work on 2.4Ghz
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Tue, 15 Mar 2016 15:10:29 +0100
In-Reply-To: <1457633336-27898-1-git-send-email-greearb@candelatech.com>
References: <1457633336-27898-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-03-10 at 10:08 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> ath10k supports VHT on 2.4Ghz band.

I still don't think this is the right thing to do.

Most implementations seem to use the BRCM vendor IE to advertise "VHT"
features on 2.4 GHz, since the spec requires 5 GHz for the real ones.

The combination of ath10k with mac80211 seems to be broken in that
regard right now, since mac80211 didn't expect drivers to set the
capabilities for 2.4 GHz band.

I guess we can get away with using the regular capabilities towards
userspace, but as far as the IEs are concerned we should probably use
the BRCM ones.

johannes
