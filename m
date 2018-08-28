Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:51552 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727094AbeH1NtF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 09:49:05 -0400
Message-ID: <1535450281.5895.34.camel@sipsolutions.net> (sfid-20180828_115815_595163_8686DF9E)
Subject: Re: [PATCH] mac80211: WFA Multi-AP backhaul STA Rx requirement
From: Johannes Berg <johannes@sipsolutions.net>
To: Sathishkumar Muruganandam <murugana@codeaurora.org>,
        linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>
Date: Tue, 28 Aug 2018 11:58:01 +0200
In-Reply-To: <1534423635-28222-1-git-send-email-murugana@codeaurora.org> (sfid-20180816_144745_205490_C47B9321)
References: <1534423635-28222-1-git-send-email-murugana@codeaurora.org>
         (sfid-20180816_144745_205490_C47B9321)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hmm. The subject/patch title isn't very clear - does it *implement* this
requirement? Or do something else with it? Please clarify.

On Thu, 2018-08-16 at 18:17 +0530, Sathishkumar Muruganandam wrote:
> The current mac80211 WDS (4-address mode) can be used to cover most of the 
> Multi-AP requirements for Data frames per the WFA Multi-AP Specification v1.0.

Be more clear here please - I think you don't mean WDS
(NL80211_IF_TYPE_WDS) but the - currently for all I know Linux-specific
- 4-addr mode of AP/client interfaces?

> When configuring AP/STA interfaces in 4-address mode, they are able to function 
> as fronthaul AP/backhaul STA of Multi-AP device complying below 
> Tx, Rx requirements except one STA Rx requirement.
> 
> Multi-AP specification section 14.1 describes the following requirements:
> 
> Transmitter requirements
> ------------------------
> 1. Fronthaul AP
>         i) When DA!=RA of backhaul STA, must use 4-address format
>         ii) When DA==RA of backhaul STA, shall use either 3-address
>             or 4-address format with RA updated with STA MAC
> 
>             (mac80211 support 4-address format via AP/VLAN interface)
> 
> 2. Backhaul STA
>         i) When SA!=TA of backhaul STA, must use 4-address format
>         ii) When SA==TA of backhaul STA, shall use either 3-address
>             or 4-address format with RA updated with AP MAC
> 
>             (mac80211 support 4-address format via use_4addr)
> 
> Receiver requirements
> ---------------------
> 1. Fronthaul AP
>         i) When SA!=TA of backhaul STA, must support receiving 4-address
>            format frames
>         ii) When SA==TA of backhaul STA, must support receiving both
>             3-address and 4-address format frames
> 
>             (mac80211 support both 3-addr & 4-addr via AP/VLAN interface)
> 
> 2. Backhaul STA
>         i) When DA!=RA of backhaul STA, must support receiving 4-address
>            format frames
>         ii) When DA==RA of backhaul STA,  must support receiving both
>             3-address and 4-address format frames
> 
>             (mac80211 support only receiving 4-address format via
>              use_4addr)
> 
> This patch addresses the above Rx requirement (ii) for backhaul STA.
> 
> The current design doesn't accept 3-address frames when configured in 4-address
> mode (use_4addr). Hence add a check to allow 3-address frames when DA==RA of
> backhaul STA (adhering to Table 9-26 of IEEE Std 802.11™-2016).
> 
> This case was tested with a bridged station interface when associated with
> a non-mac80211 based vendor AP implementation using 3-address frames for WDS.
> 
> STA was able to support the Multi-AP Rx requirement when DA==RA. No issues,
> no loops seen when tested with mac80211 based AP as well.
> 
> Verified and confirmed all other Tx and Rx requirements of AP and STA for 
> Multi-AP respectively. They all work using the current mac80211-WDS design.

Ok.

> Signed-off-by: Sathishkumar Muruganandam <murugana@codeaurora.org>
> ---
>  net/mac80211/rx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index a16ba568e2a3..686e5586e1f4 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -2313,7 +2313,7 @@ __ieee80211_data_to_8023(struct ieee80211_rx_data *rx, bool *port_control)
>  
>  		if (!sdata->u.mgd.use_4addr)
>  			return -1;
> -		else
> +		else if (!ether_addr_equal(hdr->addr1, sdata->vif.addr))
>  			check_port_control = true;

I guess I have no objection to this. Felix?

johannes
