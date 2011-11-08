Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60645 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab1KHS46 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 13:56:58 -0500
Message-ID: <4EB97B70.1010909@candelatech.com> (sfid-20111108_195702_100468_A11C1AE7)
Date: Tue, 08 Nov 2011 10:56:48 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211/cfg80211: report monitor channel in wireless
 extensions
References: <1320778327.24797.36.camel@jlt3.sipsolutions.net>
In-Reply-To: <1320778327.24797.36.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/08/2011 10:52 AM, Johannes Berg wrote:
> From: Johannes Berg<johannes.berg@intel.com>
>
> Just add API to get the channel&  report it. Trivial really.
>
> Signed-off-by: Johannes Berg<johannes.berg@intel.com>
> ---
> I'm not sure why this is so hard that the aircrack people
> couldn't figure out what to do ...
>
>   include/net/cfg80211.h     |    5 +++++
>   net/mac80211/cfg.c         |    8 ++++++++
>   net/wireless/wext-compat.c |   12 ++++++++++++
>   3 files changed, 25 insertions(+)
>
> --- a/include/net/cfg80211.h	2011-11-08 19:37:45.000000000 +0100
> +++ b/include/net/cfg80211.h	2011-11-08 19:49:33.000000000 +0100
> @@ -1342,6 +1342,9 @@ struct cfg80211_gtk_rekey_data {
>    *	doesn't verify much. Note, however, that the passed netdev may be
>    *	%NULL as well if the user requested changing the channel for the
>    *	device itself, or for a monitor interface.
> + * @get_channel: Get the current operating channel, should return %NULL if
> + *	there's no signal defined operating channel if for example the

Do you mean "no single defined" ?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

