Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55322 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab2LMVXX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 16:23:23 -0500
Message-ID: <50CA4745.5020904@candelatech.com> (sfid-20121213_222326_613779_8CE452B8)
Date: Thu, 13 Dec 2012 13:23:17 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [RFT 3/3] cfg80211: move world roaming check for beacon hints
References: <1355430534-7881-1-git-send-email-mcgrof@do-not-panic.com> <1355430534-7881-4-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1355430534-7881-4-git-send-email-mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/13/2012 12:28 PM, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
>
> We should not add new beacon hints even if the wiphy

Maybe 'even' shouldn't be there?

I'll add this series to our kernels for testing...

Thanks,
Ben

> is not world roaming. Without this we were always adding
> a beacon hint if not world roaming for every non world
> roaming wiphy interface.
>
> Reported-by: Ben Greear <greearb@candelatech.com>
> Reported-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
> ---
>   net/wireless/reg.c |    5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index f649b5e..bdc42d9 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -1076,6 +1076,9 @@ static void handle_reg_beacon(struct wiphy *wiphy,
>
>   	chan->beacon_found = true;
>
> +	if (!reg_is_world_roaming(wiphy))
> +		return;
> +
>   	if (wiphy->flags & WIPHY_FLAG_DISABLE_BEACON_HINTS)
>   		return;
>
> @@ -1149,8 +1152,6 @@ static void reg_process_beacons(struct wiphy *wiphy)
>   	 */
>   	if (!last_request)
>   		return;
> -	if (!reg_is_world_roaming(wiphy))
> -		return;
>   	wiphy_update_beacon_reg(wiphy);
>   }
>
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

