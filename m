Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46117 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab1EFQ3Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 12:29:16 -0400
Message-ID: <4DC421D8.3050403@candelatech.com> (sfid-20110506_182919_778631_E61F875B)
Date: Fri, 06 May 2011 09:29:12 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Bisected:  ath9k: fix powersave frame filtering/buffering in
 AP mode broke STA association.
References: <4DC30C42.6070402@candelatech.com> <4DC3109F.6080601@openwrt.org> <4DC3135C.4040601@candelatech.com> <4DC31A0B.4040409@candelatech.com> <4DC31C91.1030303@openwrt.org> <4DC33DE2.1070508@candelatech.com> <4DC34465.6090108@openwrt.org>
In-Reply-To: <4DC34465.6090108@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/05/2011 05:44 PM, Felix Fietkau wrote:

> This should fix the second issue:
>
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -1722,6 +1722,10 @@ static int ath9k_sta_add(struct ieee8021
>   	struct ath_node *an = (struct ath_node *) sta->drv_priv;
>   	struct ieee80211_key_conf ps_key = { };
>
> +	if (vif->opmode != NL80211_IFTYPE_AP&&
> +	    vif->opmode != NL80211_IFTYPE_AP_VLAN)
> +		return 0;
> +
>   	ath_node_attach(sc, sta);
>   	an->ps_key = ath_key_config(common, vif, sta,&ps_key);

This doesn't compile..appears there is no vif->opmode member?

Also, if you are trying to compare the hardware opmode, I'm not
sure that would be correct since you can be in AP mode and still
have stations.  Maybe I'm just confused though...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

