Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:36298 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935521AbcIFTHU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Sep 2016 15:07:20 -0400
Subject: Re: [PATCH] cfg80211: cap 20MHz VHT bitrate at MCS 8
To: Thomas Pedersen <twp@qca.qualcomm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <1473188417-13987-1-git-send-email-twp@qca.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <2769a14e-964d-4ec2-9f04-ddd332434b78@candelatech.com> (sfid-20160906_210841_485984_ED0E7865)
Date: Tue, 6 Sep 2016 12:07:18 -0700
MIME-Version: 1.0
In-Reply-To: <1473188417-13987-1-git-send-email-twp@qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/06/2016 12:00 PM, Thomas Pedersen wrote:
> Some drivers (ath10k) report MCS 9 @ 20MHz, which
> technically isn't allowed. To get more meaningful value
> than 0 out of this however, just cap the bitrate for 20MHz
> to MCS 8.

If it is actually reporting MCS9, why lie about it?  Report it up
the stack as a proper value instead of hiding the issue?

Thanks,
Ben


>
> Signed-off-by: Thomas Pedersen <twp@qca.qualcomm.com>
> ---
>  net/wireless/util.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/net/wireless/util.c b/net/wireless/util.c
> index 0675f51..5fb0249 100644
> --- a/net/wireless/util.c
> +++ b/net/wireless/util.c
> @@ -1157,7 +1157,9 @@ static u32 cfg80211_calculate_bitrate_vht(struct rate_info *rate)
>  		   58500000,
>  		   65000000,
>  		   78000000,
> -		   0,
> +		   /* some drivers report MCS 9 for 20MHz anyway. Clip to MCS 8
> +		    * bitrate as it's closer than 0 */
> +		   78000000,
>  		},
>  		{  13500000,
>  		   27000000,
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
