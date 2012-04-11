Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36607 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756753Ab2DKSBk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 14:01:40 -0400
Message-ID: <4F85C6FF.1050004@candelatech.com> (sfid-20120411_200145_359099_85E8FC90)
Date: Wed, 11 Apr 2012 11:01:35 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: greearb@candelatech.com
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 05/10] mac80211: Add more ethtools stats: survey, rates,
 etc
References: <1334166738-28243-1-git-send-email-greearb@candelatech.com> <1334166738-28243-6-git-send-email-greearb@candelatech.com>
In-Reply-To: <1334166738-28243-6-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/11/2012 10:52 AM, greearb@candelatech.com wrote:
> From: Ben Greear<greearb@candelatech.com>
>
> The signal and noise are forced to be positive since ethtool
> deals in unsigned 64-bit values and this number should be human
> readable.  This gives easy access to some of the data formerly
> exposed in the deprecated /proc/net/wireless file.

> +	if (WARN_ON(i != STA_STATS_LEN)) {
> +		rcu_read_unlock();
> +		return;
> +	}
> +
> +	drv_get_et_stats(sdata, stats,&(data[STA_STATS_LEN]));
> +}
> +

Ahh crap, I missed an rcu_read_unlock here...will fix this
and whatever else folks suggest and repost..but don't apply
this patch as is!

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

