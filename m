Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42723 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab1KQRti (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 12:49:38 -0500
Received: from [192.168.100.111] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id pAHHncxm013676
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 17 Nov 2011 09:49:38 -0800
Message-ID: <4EC54932.4090007@candelatech.com> (sfid-20111117_184942_279324_ABBF5D35)
Date: Thu, 17 Nov 2011 09:49:38 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
CC: linux-wireless@vger.kernel.org
Subject: Re: [wireless-next PATCH 5/5] wifi-debugfs: Fix AMSDU rate printout.
References: <1319778680-11405-1-git-send-email-greearb@candelatech.com> <1319778680-11405-5-git-send-email-greearb@candelatech.com>
In-Reply-To: <1319778680-11405-5-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/27/2011 10:11 PM, greearb@candelatech.com wrote:
> From: Ben Greear<greearb@candelatech.com>
>
> It was flipped.  See section 7.3.2.56 of the 802.11n
> spec for details.

This patch is stand-alone, even though it was originally
part of a series I posted.  Do I need to re-post as 1/1
(it's not yet in wireless-testing tree).

Thanks,
Ben

>
> Signed-off-by: Ben Greear<greearb@candelatech.com>
> ---
> :100644 100644 1ceec86... 4310431... M	net/mac80211/debugfs_sta.c
>   net/mac80211/debugfs_sta.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
> index 1ceec86..4310431 100644
> --- a/net/mac80211/debugfs_sta.c
> +++ b/net/mac80211/debugfs_sta.c
> @@ -274,9 +274,9 @@ static ssize_t sta_ht_capa_read(struct file *file, char __user *userbuf,
>
>   		PRINT_HT_CAP((htc->cap&  BIT(10)), "HT Delayed Block Ack");
>
> -		PRINT_HT_CAP((htc->cap&  BIT(11)), "Max AMSDU length: "
> -			     "3839 bytes");
>   		PRINT_HT_CAP(!(htc->cap&  BIT(11)), "Max AMSDU length: "
> +			     "3839 bytes");
> +		PRINT_HT_CAP((htc->cap&  BIT(11)), "Max AMSDU length: "
>   			     "7935 bytes");
>
>   		/*


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

