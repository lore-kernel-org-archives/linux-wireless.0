Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59009 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab1EIQqi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 12:46:38 -0400
Message-ID: <4DC81A61.9080101@candelatech.com> (sfid-20110509_184641_702205_F225443A)
Date: Mon, 09 May 2011 09:46:25 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: restrict AP beacon intervals
References: <1304959275.12202.4.camel@jlt3.sipsolutions.net>
In-Reply-To: <1304959275.12202.4.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/09/2011 09:41 AM, Johannes Berg wrote:
> From: Johannes Berg<johannes.berg@intel.com>
>
> Multiple virtual AP interfaces can currently try
> to use different beacon intervals, but that just
> leads to problems since it won't actually be done
> that way by drivers. Return an error in this case
> to make sure it won't be done wrong.

I think there is no problem with having different beacon
intervals, as long as they are all a multiple of
the smallest interval and the driver does things properly.

I'm not sure ath9k or ath5k currently supports this properly,
but there was a patch floating around for a while that did
this for ath9k I think...

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

