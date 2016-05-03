Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:60271 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756497AbcECVeE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 17:34:04 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.nyi.internal (Postfix) with ESMTP id 2876420D04
	for <linux-wireless@vger.kernel.org>; Tue,  3 May 2016 17:34:03 -0400 (EDT)
Date: Tue, 3 May 2016 14:34:01 -0700
From: Greg Kroah-Hartman <greg@kroah.com>
To: Kangjie Lu <kangjielu@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, davem@davemloft.net,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, Kangjie Lu <kjlu@gatech.edu>
Subject: Re: [PATCH] fix infoleak in wireless
Message-ID: <20160503213401.GB23469@kroah.com> (sfid-20160503_233430_002279_8F3C4453)
References: <1462308013-6032-1-git-send-email-kjlu@gatech.edu>
 <1462308044.10444.19.camel@sipsolutions.net>
 <CABEk9YxqyBxnqOseJ3-d-aKxnREZBFt1z89nOjHf=DvNQy_hTw@mail.gmail.com>
 <20160503210052.GA23109@kroah.com>
 <CABEk9YwiqpP+Ahxax3AC7tbPcmpUQnrB-Nwsb4rixhVjcL4Crw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CABEk9YwiqpP+Ahxax3AC7tbPcmpUQnrB-Nwsb4rixhVjcL4Crw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 03, 2016 at 05:11:07PM -0400, Kangjie Lu wrote:
> Opps, I did not notice the patch is not attached.
> 
> From 34a82a734388d07eb10f91770f86938e38f7575a Mon Sep 17 00:00:00 2001
> From: Kangjie Lu <kjlu@gatech.edu>
> Date: Tue, 3 May 2016 14:15:18 -0400
> Subject: [PATCH] fix infoleak in wireless
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> The 6-bytes array “mac_addr” is not initialized in the dump_station
> implementations of “drivers/staging/wilc1000/wilc_wfi_cfgoperations.c”
> and “drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c”, so all 6
> bytes may be leaked.
> 
> Signed-off-by: Kangjie Lu <kjlu@gatech.edu>
> ---
>  net/wireless/nl80211.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 056a730..2e92d14 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -3905,6 +3905,7 @@ static int nl80211_dump_station(struct sk_buff *skb,
>  
>   while (1) {
>   memset(&sinfo, 0, sizeof(sinfo));
> + eth_zero_addr(mac_addr);
>   err = rdev_dump_station(rdev, wdev->netdev, sta_idx,
>   mac_addr, &sinfo);
>   if (err == -ENOENT)

Patch is corrupted :(

Why not fix up the staging drivers, they are the real problem here,
which is what I think the networking maintainers were telling you to do.

thanks,

greg k-h
