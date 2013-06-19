Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:35340 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756965Ab3FSP60 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 11:58:26 -0400
Message-ID: <51C1D518.1060103@candelatech.com> (sfid-20130619_175830_031275_EDFC3D1E)
Date: Wed, 19 Jun 2013 08:58:16 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 1/2] cfg80211: require passing BSS struct back to cfg80211_assoc_timeout
References: <1371650017-14293-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1371650017-14293-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/19/2013 06:53 AM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Doing so will allow us to hold the BSS (not just ref it) over the
> association process, thus ensuring that it doesn't time out and
> gets invisible to the user (e.g. in 'iw wlan0 link'.)
>
> This also fixes a leak in mac80211 where it doesn't always release
> the BSS struct properly in all cases where calling this function.
> This leak was reported by Ben Greear.

I have not yet tested this, but I read it closely and
it appears to fix the same problem I tried to fix in
the 2/6 "Fix bss leak." patch.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

