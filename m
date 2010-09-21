Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42279 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab0IUQZD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 12:25:03 -0400
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id o8LGP1TW025011
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 21 Sep 2010 09:25:01 -0700
Message-ID: <4C98DC5D.2000108@candelatech.com>
Date: Tue, 21 Sep 2010 09:25:01 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
CC: linux-wireless@vger.kernel.org
Subject: Re: [mac80211] mac80211:  Support multiple VIFS per AP in debugfs.
References: <1285071310-11440-1-git-send-email-greearb@candelatech.com>
In-Reply-To: <1285071310-11440-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/21/2010 05:15 AM, greearb@gmail.com wrote:
> From: Ben Greear<greearb@candelatech.com>
>
> MAC address of AP isn't unique..need to add the device
> name as well.
>
> Signed-off-by: Ben Greear<greearb@candelatech.com>
> ---
> :100644 100644 76839d4... e802fce... M	net/mac80211/debugfs_sta.c
>   net/mac80211/debugfs_sta.c |    5 +++--
>   1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
> index 76839d4..e802fce 100644
> --- a/net/mac80211/debugfs_sta.c
> +++ b/net/mac80211/debugfs_sta.c
> @@ -301,14 +301,15 @@ STA_OPS(ht_capa);
>   void ieee80211_sta_debugfs_add(struct sta_info *sta)
>   {
>   	struct dentry *stations_dir = sta->local->debugfs.stations;
> -	u8 mac[3*ETH_ALEN];
> +	u8 mac[3*ETH_ALEN + IFNAMSIZ + 2];
>
>   	sta->debugfs.add_has_run = true;
>
>   	if (!stations_dir)
>   		return;
>
> -	snprintf(mac, sizeof(mac), "%pM", sta->sta.addr);
> +	snprintf(mac, sizeof(mac), "%pM-%s",
> +		 sta->sta.addr, sta->sdata->name);
>
>   	/*
>   	 * This might fail due to a race condition:

I got to thinking:  Is there any reason to put the sta.addr in there?

Maybe just use sta->sdata->name?  Seems it might be easier for
scripts to deal with?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

